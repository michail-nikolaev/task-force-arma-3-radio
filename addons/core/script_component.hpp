#define COMPONENT core

#include "\z\tfar\addons\core\script_mod.hpp"

#define DEBUG_PROFCONTEXT
// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define CBA_DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_CORE
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_CORE
    #define DEBUG_SETTINGS DEBUG_SETTINGS_CORE
#endif

#ifdef DEBUG_MODE_FULL
    #define DEBUG_PROFCONTEXT
    #define DEBUG_PROFTRAP
#endif


#include "\z\tfar\addons\core\script_macros.hpp"
