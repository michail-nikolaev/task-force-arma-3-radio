#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"

#include "\z\tfar\addons\core\defines.hpp"

//From https://github.com/acemod/ACE3


#ifdef DFUNC
    #undef DFUNC
#endif
#define DFUNC(var1) TRIPLES(PREFIX,fnc,var1)

#define DISABLE_COMPILE_CACHE 1

#ifdef PREP
    #undef PREP
#endif

#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QUOTE(DFUNC(fncName))] call CBA_fnc_compileFunction
#define PREP_SUB(subfolder,fncName) [QPATHTOF(functions\subfolder\DOUBLES(fnc,fncName).sqf), QUOTE(DFUNC(fncName))] call CBA_fnc_compileFunction

#define VARIABLE_DEFAULT(varName,defaultValue) if (isNil QUOTE(varName)) then {varName = defaultValue;}

//From https://github.com/acemod/ACE3
#define MACRO_ADDWEAPON(WEAPON,COUNT) class _xx_##WEAPON { \
    weapon = #WEAPON; \
    count = COUNT; \
}

#define MACRO_ADDITEM(ITEM,COUNT) class _xx_##ITEM { \
    name = #ITEM; \
    count = COUNT; \
}

#define MACRO_ADDMAGAZINE(MAGAZINE,COUNT) class _xx_##MAGAZINE { \
    magazine = #MAGAZINE; \
    count = COUNT; \
}

#define MACRO_ADDBACKPACK(BACKPACK,COUNT) class _xx_##BACKPACK { \
    backpack = #BACKPACK; \
    count = COUNT; \
}

//Helpers for setting vehicles Isolation and if they have LR
#define MACRO_VEC_ISOLATION(vehicle,baseClass,isolation) class vehicle : baseClass { \
    tf_isolatedAmount = isolation; \
}

#define MACRO_VEC_LR(vehicle,baseClass,hasLR) class vehicle : baseClass { \
    tf_hasLRradio = hasLR; \
}

#define MACRO_VEC_ISOLATION_LR(vehicle,baseClass,isolation,hasLR) class vehicle : baseClass { \
    tf_hasLRradio = hasLR; \
    tf_isolatedAmount = isolation; \
}

#define MACRO_VEC_ISOLATION_LR_Intercom(veeeeehicle,baseClass,isolation,hasLR,intercom) class veeeeehicle : baseClass { \
    tf_hasLRradio = hasLR; \
    tf_isolatedAmount = isolation; \
        class ACE_SelfActions : ACE_SelfActions { \
            class TFAR_IntercomChannel { \
                displayName = "$STR_TFAR_Intercom_ACESelfAction_Name"; \
                condition = QUOTE(true); \
                statement = ""; \
                icon = ""; \
                class TFAR_IntercomChannel_1 { \
                    displayName = "$STR_TFAR_Intercom_ACESelfAction_Channel1"; \
                    condition = QUOTE(true); \
                    statement = "(vehicle ACE_Player) setVariable [format ['TFAR_IntercomSlot_%1',(netID ACE_Player)],0,true];"; \
                }; \
                class TFAR_IntercomChannel_2 { \
                    displayName = "$STR_TFAR_Intercom_ACESelfAction_Channel2"; \
                    condition = QUOTE(true); \
                    statement = "(vehicle ACE_Player) setVariable [format ['TFAR_IntercomSlot_%1',(netID ACE_Player)],1,true];"; \
                }; \
            }; \
        }; \
    TFAR_hasIntercom = intercom; \
}

//config scopes
#define PRIVATE 0 //unusable - only for inheritance
#define HIDDEN 1 //Hidden in Editor/Curator/Arsenal
#define PUBLIC 2 //usable and visible
#define ALL_SCOPES_HIDDEN scope = 1;scopeCurator = 1;scopeArsenal = 1;
#define HIDDEN_CLASS(name) class name {scope = 1;scopeCurator = 1;scopeArsenal = 1;}



//Mutex
#define MUTEX_INIT(name) name = false
#define MUTEX_LOCK(name) waitUntil {if (!name) exitWith {name = true; true};false;}
#define MUTEX_UNLOCK(name) name = false


#define DEPRECATE_VARIABLE(OLD_VARIABLE,NEW_VARIABLE) \
    if (!isNil QUOTE(OLD_VARIABLE)) then { \
        WARNING('Deprecated variable used: OLD_VARIABLE (new: NEW_VARIABLE) in ADDON'); \
        NEW_VARIABLE = OLD_VARIABLE; \
    }






#ifdef DEBUG_PROFCONTEXT

#define PROFCONTEXT_NORTN(x) {isNil{call x}}
#define PROFCONTEXT_NORTN_NAMED(n,x) {n;isNil{call x}}
#define PROFCONTEXT_RTN(x) {private _rtn = 0; isNil{_rtn = _this call x}; _rtn}

#else

#define PROFCONTEXT_NORTN(x) x
#define PROFCONTEXT_NORTN_NAMED(n,x) x
#define PROFCONTEXT_RTN(x) x

#endif


#ifdef DEBUG_PROFTRAP

#define PROFCONTEXT_LOGTRAP(VAR,FUNC) if (missionNamespace getVariable [#VAR,false]) exitWith {VAR = false;diag_captureFrame 1;[PROFCONTEXT_NORTN(FUNC), []] call CBA_fnc_execNextFrame;}

#else

#define PROFCONTEXT_LOGTRAP(VAR,FUNC)

#endif
