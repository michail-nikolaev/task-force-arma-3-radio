class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};

class Extended_InitPost_EventHandlers {
    class TFAR_Land_Communication_F {
        class ADDON {
            clientInit = QUOTE([ARR_2(_this select 0,50000)] call FUNC(initRadioTower));
        };
    };
};

class Extended_Delete_EventHandlers {
    class TFAR_Land_Communication_F {
        class ADDON {
            clientInit = QUOTE((_this param [ARR_2(0,_this)]) call FUNC(deleteRadioTower));
        };
    };
};
