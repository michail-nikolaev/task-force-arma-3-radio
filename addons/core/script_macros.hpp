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
#define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)

#define VARIABLE_DEFAULT(varName,defaultValue) if (isNil QUOTE(varName)) then {	varName = defaultValue; };

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

//config scopes
#define PRIVATE 0 //unusable - only for inheritance
#define HIDDEN 1 //Hidden in Editor/Curator/Arsenal
#define PUBLIC 2 //usable and visible
#define ALL_SCOPES_HIDDEN scope = 1;scopeCurator = 1;scopeArsenal = 1;
#define HIDDEN_CLASS(name) class name {scope = 1;scopeCurator = 1;scopeArsenal = 1;}
