#pragma once

/*
Shared Mem layout
offset 0: SharedMemoryData
offset 128: Synchronous Request [512b]
offset 640: Synchronous Answer [512b]
offset 1152: Asynchronous Messages array of SharedMemString[500]
*/

#define SHAREDMEM_ASYNCMSG_COUNT 300
#define SHAREDMEM_MAX_STRINGSIZE sizeof(SharedMemString) -4
#define SHAREDMEM_BUFSIZE 128+sizeof(SharedMemString)+sizeof(SharedMemString)+(sizeof(SharedMemString) * SHAREDMEM_ASYNCMSG_COUNT) //Header+SyncReq+SyncAnsw+AsyncMessages
#include <chrono>

namespace SharedMemoryHandlerInternal {
	struct SharedMemString {
		uint32_t length{ 0 };
		char data[2044]{ 0 };
		SharedMemString& operator=(const std::string& other) {
			length = static_cast<uint32_t>(other.length());
			if (length == 0 || length > SHAREDMEM_MAX_STRINGSIZE) {
				length = 0;
				return *this;
			}
			memcpy(data, other.c_str(), length);
			return *this;
		}
		bool assignTo(std::string& other) const {
			if (length == 0 || length > SHAREDMEM_MAX_STRINGSIZE)
				return false;
			other.resize(length);
			other.assign(data, length);
			return true;
		}
		bool assignToAndClear(std::string& other) {
			if (length == 0 || length > SHAREDMEM_MAX_STRINGSIZE)
				return false;
			other.resize(length);
			other.assign(data, length);
			length = 0;
			return true;
		}
	};
	class SharedMemoryData {
	public:
		explicit SharedMemoryData(uint32_t _size) :sharedMemSize(_size) {}
		bool canAddAsyncRequest() const;
		void addAsyncRequest(const std::string& req);
		void setSyncRequest(const std::string& req);
		bool getSyncResponse(std::string& response);
		bool hasAsyncRequest() const;
		bool hasSyncRequest() const;
		std::chrono::system_clock::time_point getLastGameTick() const { return lastGameTick; }
		void setLastGameTick() { lastGameTick = std::chrono::system_clock::now(); }
		std::chrono::system_clock::time_point getLastPluginTick() const { return lastPluginTick; }
		void onShutdown() {
			lastGameTick = std::chrono::system_clock::time_point(0us); 
			nextFreeAsyncMessage = 0;
		}
		bool needConfigRefresh() const { return configNeedsRefresh; }
	private:
		uint32_t sharedMemSize{ 0 };
		volatile uint16_t nextFreeAsyncMessage{ 0 };
		std::chrono::system_clock::time_point lastGameTick;
		std::chrono::system_clock::time_point lastPluginTick;
		volatile bool configNeedsRefresh;  //no mutex
	};
	static_assert(sizeof(SharedMemoryData) < 128, "SharedMemoryData is bigger than space allocated to it in SHAMEM");
	class MutexLock {
		HANDLE hMutex;
		bool m_isLocked = false;
	public:
		explicit MutexLock(HANDLE _mutex) : hMutex(_mutex) { lock(); }
		~MutexLock() {
			unlock();
		}
		bool isLocked() const { return m_isLocked; }
		void unlock() {
			if (!m_isLocked) return;
			ReleaseMutex(hMutex);
			m_isLocked = false;
		}
		void lock() {
			if (m_isLocked) return;
			DWORD dwWaitResult = WaitForSingleObject(
				hMutex,    // handle to mutex
				500);  // no time-out interval
			if (dwWaitResult == WAIT_OBJECT_0) {
				m_isLocked = true;
				return;
			}
			m_isLocked = false;
		};
	};
}

class SharedMemoryHandler {
public:
	SharedMemoryHandler();
	~SharedMemoryHandler();
	bool canDoAsyncRequest() const;
	bool doSyncRequest(const std::string& request, std::string& answer);
	bool doAsyncRequest(const std::string& request);
	bool doSyncAndAsyncRequest(const std::string& syncRequest, std::string& answer, const std::string& asyncRequest);
	bool isConnected();
	bool needsConfigRefresh();
	bool isReady();
	void shutdown() const;
	std::string errorMessage;
private:
	bool createMemRegion();
	bool createMemMap();
	HANDLE hMapFile = nullptr;
	HANDLE hEventRequest = nullptr;
	HANDLE hEventResponse = nullptr;
	HANDLE hMutex = nullptr;
	HANDLE pMapView = nullptr;
};

class SharedMemoryTransfer {
public:
	SharedMemoryTransfer();
	~SharedMemoryTransfer();
	static void open() {};
	static void close() {};
	void transactMessage(char *output, int outputSize, const char *input);
private:
	SharedMemoryHandler handler;
};

