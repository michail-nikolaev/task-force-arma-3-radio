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
    class Land_Communication_F {
        class ADDON {
            clientInit = QUOTE(call DFUNC(initRadioTower));
        };
    };
};

class Extended_Delete_EventHandlers {
    class Land_Communication_F {
        class ADDON {
            clientInit = QUOTE(call DFUNC(deleteRadioTower));
        };
    };
};

#include "CfgVehicles.hpp"
