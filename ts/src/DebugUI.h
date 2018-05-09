#pragma once
#include <thread>

class TextRenderer;
class DebugUI {
public:
	DebugUI();
	~DebugUI();

    void run();
    void stop();
private:
    void threadRun();

    std::unique_ptr<TextRenderer> textRenderer;
    std::thread* uiThread;
    bool shouldRun{ true };
};

