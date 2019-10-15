class Extended_PreStart_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
        disableModuload = true;
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
        disableModuload = true;
    };
};

class Extended_DisplayLoad_EventHandlers { //From commy2
    class RscDisplayArsenal {
        //Actually gets called after units backpack was already replaced
        TFAR_ArsenalOpened = "'PreOpen' call TFAR_fnc_onArsenal";
    };
    class RscDisplayCurator {
        TFAR_CuratorInterfaceOpened = "[_this select 0, 'Open'] call TFAR_fnc_onCuratorInterface";
    };
    class RscDisplayEGSpectator {
        //Can enable CBA keybinds with _display call (uiNamespace getVariable "cba_events_fnc_initDisplayCurator") see TFAR_fnc_sendFrequencyInfo note about spectator
        TFAR_RscDisplayEGSpectator = "[player, true] call TFAR_fnc_forceSpectator;";
    };
};

class Extended_DisplayUnload_EventHandlers {
    class RscDisplayMission {
        TFAR_MissionEnded = "call TFAR_fnc_onMissionEnd";
    };
    class RscDisplayCurator {
        TFAR_CuratorInterfaceOpened = "[_this select 0, 'Close'] call TFAR_fnc_onCuratorInterface";
    };
    class RscDisplayEGSpectator {
        TFAR_RscDisplayEGSpectator = "[player, false] call TFAR_fnc_forceSpectator;";
    };
};

class RscListBox;
class RscDisplayArsenal {
    class Controls {
        class ListBackpack : RscListBox {
            onLoad = "'PrePreOpen' call TFAR_fnc_onArsenal"; //Called before PreOpen.
        };
    };
};
