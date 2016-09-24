#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = "TFAR - Core";
        units[] = {
            "tfar_ModuleTaskForceRadioEnforceUsage",
            "tfar_ModuleTaskForceRadio",
            "tfar_ModuleTaskForceRadioFrequencies"
        };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cba_main",
            "cba_ui",
            "cba_xeh"
        };
        author = QUOTE(AUTHORS);
    };
};

class CfgMods {
    class PREFIX {
        dir = "@task_force_radio";
        name = "Task Force Arrowhead Radio";
        picture = "A3\Ui_f\data\Logos\arma3_expansion_alpha_ca";
        hidePicture = "true";
        hideName = "true";
        actionName = "Website";
        description = "War is not only about moving, waiting and engaging targets. It is also about communication. Task Force Arrowhead Radio provides a way to dramatically increase gameplay realism and atmosphere by seamless integration with TeamSpeak.";
    };
};

#include "RadioDialogControls.hpp"
#include "RscTitles.hpp"
#include "RadioDialogControls.hpp"
#include "CfgSounds.hpp"
#include "CfgFontFamilies.hpp"
#include "CfgVehicles.hpp"
