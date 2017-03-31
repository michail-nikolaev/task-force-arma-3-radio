#include "stdafx.h"
#include "SharedMemoryTransfer.h"
#include <thread>
using namespace SharedMemoryHandlerInternal;

bool SharedMemoryHandlerInternal::SharedMemoryData::canAddAsyncRequest() const {
	return nextFreeAsyncMessage + 1 < SHAREDMEM_ASYNCMSG_COUNT;
}

void SharedMemoryHandlerInternal::SharedMemoryData::addAsyncRequest(const std::string& req) {
	setLastGameTick();
	if (req.length() > SHAREDMEM_MAX_STRINGSIZE) {
		MessageBoxA(0, (req + std::to_string(req.length())).c_str(), "TFAR SHAMEM Too big request", 0);
		return; //#TODO Could try to open and use a NamedPipe instead as backup
	}
	SharedMemString* asyncBase = reinterpret_cast<SharedMemString*>(reinterpret_cast<char*>(this) + 128 + sizeof(SharedMemString) * 2);
	if (nextFreeAsyncMessage > SHAREDMEM_ASYNCMSG_COUNT) {
		return;
		//Queue is full
	}
	auto position = nextFreeAsyncMessage++;

	asyncBase[position] = req;
}

void SharedMemoryHandlerInternal::SharedMemoryData::setSyncRequest(const std::string& req) {
	setLastGameTick();
	if (req.length() > SHAREDMEM_MAX_STRINGSIZE) {
		MessageBoxA(0, (req + std::to_string(req.length())).c_str(), "TFAR SHAMEM Too big Srequest", 0);
		__debugbreak();//Request bigger than max allowed size
		return;
	}
	SharedMemString* syncReq = reinterpret_cast<SharedMemString*>(reinterpret_cast<char*>(this) + 128);
	*syncReq = req;
}

bool SharedMemoryHandlerInternal::SharedMemoryData::getSyncResponse(std::string& response) {
	setLastGameTick();
	SharedMemString* syncResp = reinterpret_cast<SharedMemString*>(reinterpret_cast<char*>(this) + 128 + sizeof(SharedMemString));
	return syncResp->assignToAndClear(response);
}

bool SharedMemoryHandlerInternal::SharedMemoryData::hasAsyncRequest() const {
	return nextFreeAsyncMessage > 0;
}

bool SharedMemoryHandlerInternal::SharedMemoryData::hasSyncRequest() const {
	const SharedMemString* syncResp = reinterpret_cast<const SharedMemString*>(reinterpret_cast<const char*>(this) + 128);
	return syncResp->length > 0;
}

std::string GetLastErrorString() {
	LPSTR messageBuffer = nullptr;
	size_t size = FormatMessageA(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
		NULL, GetLastError(), MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPSTR) &messageBuffer, 0, NULL);
	std::string message(messageBuffer, size);

	//Free the buffer.
	LocalFree(messageBuffer);
	return message;
}

SharedMemoryHandler::SharedMemoryHandler() {
	createMemMap();
}

SharedMemoryHandler::~SharedMemoryHandler() {  
	shutdown();
	if (pMapView) UnmapViewOfFile(pMapView);
	if (hMapFile) CloseHandle(hMapFile);
	if (hEventRequest) CloseHandle(hEventRequest);
	if (hMutex) CloseHandle(hMutex);
}

bool SharedMemoryHandler::canDoAsyncRequest() const {
	MutexLock lock(hMutex);
	if (!lock.isLocked())
		return false;
	SharedMemoryData* pData = static_cast<SharedMemoryData*>(pMapView);
	return pData->canAddAsyncRequest();
}

bool SharedMemoryHandler::doSyncRequest(const std::string& request, std::string& answer) {
	if (!isReady()) return false;
	MutexLock lock(hMutex);
	if (!lock.isLocked())
		return false;
	SharedMemoryData* pData = static_cast<SharedMemoryData*>(pMapView);
	pData->setSyncRequest(request);
	lock.unlock();
	SetEvent(hEventRequest);
	auto waited = SignalObjectAndWait(hEventRequest, hEventResponse, PIPE_TIMEOUT, FALSE);
	ResetEvent(hEventResponse);
	if (waited != WAIT_OBJECT_0) {
		return false;
	}
	//lock.lock();//No need to lock again. see SharedMemoryHandler::doSyncAndAsyncRequest
	//if (!lock.isLocked())
	//	return false;
	return pData->getSyncResponse(answer);
}

bool SharedMemoryHandler::doAsyncRequest(const std::string& request) {
	if (!isReady()) return false;
	MutexLock lock(hMutex);
	if (!lock.isLocked())
		return false;
	SharedMemoryData* pData = static_cast<SharedMemoryData*>(pMapView);
	pData->addAsyncRequest(request);
	return true;
}

bool SharedMemoryHandler::doSyncAndAsyncRequest(const std::string& syncRequest, std::string& answer, const std::string& asyncRequest) {
	if (!isReady()) return false;
	MutexLock lock(hMutex);
	if (!lock.isLocked())
		return false;
	SharedMemoryData* pData = static_cast<SharedMemoryData*>(pMapView);
	pData->addAsyncRequest(asyncRequest);
	pData->setSyncRequest(syncRequest);
	lock.unlock();
	SetEvent(hEventRequest);
	auto waited = SignalObjectAndWait(hEventRequest, hEventResponse, PIPE_TIMEOUT, FALSE);
	ResetEvent(hEventResponse);
	if (waited != WAIT_OBJECT_0) {
		return false;
	}
    //lock.lock();//No need to lock again. There won't be anyone else who could write a sync response. gameTime update racecondition is possible but who if we mix up some microseconds
    //if (!lock.isLocked())
    //	return false;
	return pData->getSyncResponse(answer);
}

bool SharedMemoryHandler::isConnected() {
	if (!isReady()) return false;
	MutexLock lock(hMutex);
	if (!lock.isLocked())
		return false;
	SharedMemoryData* pData = static_cast<SharedMemoryData*>(pMapView);
	pData->setLastGameTick();
	auto lastPluginTick = pData->getLastPluginTick();
	lock.unlock();
	return std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now() - lastPluginTick).count() < PIPE_TIMEOUT;
}

bool SharedMemoryHandler::needsConfigRefresh() {
	if (!isReady()) return false;
	SharedMemoryData* pData = static_cast<SharedMemoryData*>(pMapView);
	return pData->needConfigRefresh();
}

bool SharedMemoryHandler::createMemRegion() {
	if (!hEventRequest) {
		hEventRequest = OpenEvent(
			SYNCHRONIZE | EVENT_MODIFY_STATE,
			FALSE,
			L"Local\\TFARSHAMEM_EVTREQ"
		);
		if (!hEventRequest) {
			if (GetLastError() != ERROR_FILE_NOT_FOUND)
				errorMessage = "TFAR ERR OpenEvt REQ " + GetLastErrorString();
			return false;
		}
	}
	if (!hEventResponse) {
		hEventResponse = OpenEvent(
			SYNCHRONIZE | EVENT_MODIFY_STATE,
			FALSE,
			L"Local\\TFARSHAMEM_EVTRESP"
		);
		if (!hEventResponse) {
			if (GetLastError() != ERROR_FILE_NOT_FOUND)
				errorMessage = "TFAR ERR OpenEvt RESP " + GetLastErrorString();
			return false;
		}
	}
	if (!hMutex) {
		hMutex = OpenMutex(
			SYNCHRONIZE,
			FALSE,
			L"Local\\TFARSHAMEM_MTX"
		);
		if (!hMutex) {
			if (GetLastError() != ERROR_FILE_NOT_FOUND)
				errorMessage = "TFAR ERR OpenMtx " + GetLastErrorString();
			return false;
		}
	}

	if (hMapFile)
		CloseHandle(hMapFile);
	hMapFile = OpenFileMapping(
		FILE_MAP_WRITE,    // read/write access
		FALSE,                  // do not inherit the name
		L"Local\\TFARSHAMEM");             // name of mapping object
	if (!hMapFile) {
		if (GetLastError() != ERROR_FILE_NOT_FOUND)
			errorMessage = "TFAR ERR OpenFMap " + GetLastErrorString();
		return false;
	}
	return true;
}

bool SharedMemoryHandler::createMemMap() {
	if (!hMapFile) {
		if (!createMemRegion())
			return false;
	}
	if (pMapView)
		CloseHandle(pMapView);

	pMapView = MapViewOfFile(hMapFile,   // handle to map object
		FILE_MAP_WRITE, // read/write permission
		0,
		0,
		SHAREDMEM_BUFSIZE);
	if (!pMapView) {
		if (GetLastError() != ERROR_FILE_NOT_FOUND)
			errorMessage = "TFAR ERR MapFile " + GetLastErrorString();
		if (hMapFile) {
			CloseHandle(hMapFile);
			hMapFile = nullptr;
		}
		return false;
	}

	return true;
}

bool SharedMemoryHandler::isReady() {
	if (!pMapView) {
		if (!createMemMap())
			return false;
	}
	return true;
}

void SharedMemoryHandler::shutdown() const {
	if (pMapView) {
		SharedMemoryData* pData = static_cast<SharedMemoryData*>(pMapView);
		pData->onShutdown();
	}
}

SharedMemoryTransfer::SharedMemoryTransfer() {}


SharedMemoryTransfer::~SharedMemoryTransfer() {}

void SharedMemoryTransfer::transactMessage(char* output, int outputSize, const char* input) {
	std::string answer;
	std::string inp(input);
	if (!handler.isReady()) {
		if (handler.errorMessage.empty())
			strncpy_s(output, outputSize, "Not connected to TeamSpeak", _TRUNCATE);
		else
			strncpy_s(output, outputSize, handler.errorMessage.c_str(), min(handler.errorMessage.length(), outputSize - 1));
		handler.errorMessage = "";
		return;
	}

	if (!handler.isConnected()) {
		printf("not connected\n");
		strncpy_s(output, outputSize, "Not connected to TeamSpeak", _TRUNCATE);
		return;
	}

	if (inp.back() == '~') {
		handler.doAsyncRequest(inp);
		if (inp.front() == 'D' && handler.needsConfigRefresh())//DFRAME
			answer = "NEEDCFG";
		else if (inp.front() == 'M')//MISSIONEND
			handler.shutdown();
		else
			answer = "OK";
	} else {
		handler.doSyncRequest(inp, answer);
	}

	strncpy_s(output, outputSize, answer.c_str(), min(answer.length(), outputSize - 1));
}
