#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {""};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "A3_Modules_F",
            "tfar_core"
        };
        Url = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};

class Extended_Init_EventHandlers {
    class TFAR_Land_Communication_F {
        class ADDON {
            clientInit = QUOTE([ARR_2(_this select 0,50000)] call DFUNC(initRadioTower));
        };
    };
};

class Extended_Delete_EventHandlers {
    class TFAR_Land_Communication_F {
        class ADDON {
            clientInit = QUOTE((_this param [ARR_2(0,_this)]) call DFUNC(deleteRadioTower));
        };
    };
};

#include "CfgVehicles.hpp"
