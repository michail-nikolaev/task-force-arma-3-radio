// COMPONENT should be defined in the script_component.hpp and included BEFORE this hpp

#define MAINPREFIX z
#define PREFIX tfar

#include "script_version.hpp"

#define VERSION MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD
#define VERSION_CONFIG version = QUOTE(VERSION); versionStr = QUOTE(VERSION); versionAr[] = {VERSION_AR}
#define TFAR_ADDON_VERSION QUOTE(VERSION)
#define SERVER_API_VERSION 1

// MINIMAL required version for the Mod. Components can specify others..
#define REQUIRED_VERSION 2.14
#define REQUIRED_CBA_VERSION {3,0,0}
