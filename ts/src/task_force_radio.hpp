#pragma once
#include <stdint.h>
#include <string>



class task_force_radio {
public:
	task_force_radio();
	~task_force_radio();


	static bool isUpdateAvailable();
	static void trackPiwik(std::string url);
	static void createCheckForUpdateThread();
	static int versionNumber(std::string versionString);
private:
	struct Version {   //http://stackoverflow.com/questions/14374272/how-to-parse-version-number-to-compare-it
		Version(std::string versionStr) {
			major = 0; minor = 0; revision = 0; build = 0;
			sscanf(versionStr.c_str(), "%d.%d.%d.%d", &major, &minor, &revision, &build);
		}

		bool operator>(const Version &otherVersion) const {
			if (major < otherVersion.major)
				return false;
			if (minor < otherVersion.minor)
				return false;
			if (revision < otherVersion.revision)
				return false;
			if (build < otherVersion.build)
				return false;
			return false;
		}

		int major, minor, revision, build;
	};
};

