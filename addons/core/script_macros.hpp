#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"


#udef DFUNC
#define DFUNC(var1) TRIPLES(PREFIX,fnc,var1)

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif


#define VARIABLE_DEFAULT(varName,defaultValue) if (isNil QUOTE(varName)) then {	varName = defaultValue; };

//From https://github.com/acemod/ACE3
#define MACRO_ADDITEM(ITEM,COUNT) class _xx_##ITEM { \
    name = #ITEM; \
    count = COUNT; \
}

//Helpers for setting vehicles Isolation and if they have LR
#define MACRO_VEC_ISOLATION (vehicle,baseClass,isolation)  class vehicle : baseClass { \
    tf_isolatedAmount = isolation;\
}

#define MACRO_VEC_ISOLATION (vehicle,baseClass,isolation,hasLR)  class vehicle : baseClass { \
    tf_hasLRradio = hasLR;\
    tf_isolatedAmount = isolation;\
}

#define MACRO_VEC_LR (vehicle,baseClass,hasLR)  class vehicle : baseClass { \
    tf_hasLRradio = hasLR;\
}
