#define COMPONENT intercom_phone
#include "\z\tfar\addons\core\script_mod.hpp"

#ifdef DEBUG_ENABLED_INTERCOM_PHONE
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_INTERCOM_PHONE
    #define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#endif

#include "\z\tfar\addons\core\script_macros.hpp"

#ifdef PREP
    #undef PREP
#endif

#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
