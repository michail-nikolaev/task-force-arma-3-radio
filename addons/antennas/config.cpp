#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {"TFAR_Land_Communication_F"};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "A3_Modules_F",
            "tfar_core"
        };
        Url = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
    };
};

#include "CfgEventhandlers.hpp"
#include "CfgVehicles.hpp"
