#define COMPONENT static_radios
#include "\z\tfar\addons\core\script_mod.hpp"

#ifdef DEBUG_ENABLED_CORE
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_CORE
    #define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#endif

#include "\z\tfar\addons\core\script_macros.hpp"

#undef DFUNC
#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)//Core only used PREFIX instead to keep bwc on function names
#ifdef PREP
    #undef PREP
#endif

#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QUOTE(DFUNC(fncName))] call CBA_fnc_compileFunction

#define CBA_SETTINGS_GUARD(fncName) if !(TFAR_core_SettingsInitialized) exitWith {["CBA_settingsInitialized", {\
diag_log ["delayed",#fncName];\
                                        _thisArgs call fncName; [_thisType, _thisId] call CBA_fnc_removeEventHandler\
                                    }, _this] call CBA_fnc_addEventHandlerArgs;}


