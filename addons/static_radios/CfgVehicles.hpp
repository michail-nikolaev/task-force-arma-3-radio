
class RscCombo;
class RscText;
class RscEdit;
class RscPicture;
class RscTree;
class RscControlsGroupNoScrollbars;
class RscCheckBox;
class RscSlider;
//26118 == TFAR
class ctrlXSliderH;

class RscAttributeTFARStaticRadioThingy: RscControlsGroupNoScrollbars {
    idc=2611800;
    x="7 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
    y="5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
    w="26 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
    h="16 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";

    class controls {
        /*class RadioTitle: RscText {
            idc=20611801;
            text="Radios:";
            x="0 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            y="0 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            w="10 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            colorBackground[]={0,0,0,0.5};
        };
        class RadioList: RscCombo {
            idc=20611802;
            x="10 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            y="0 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            w="16 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
        };*/
        class FreqTitle: RscText {
            idc=2611803;
            text=CSTRING(moduleStaticRadio_FreqTitle);
            x="0 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            y="1.1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            w="6 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            colorBackground[]={0,0,0,0.5};
        };
        class FreqEdit: RscEdit {
            idc=2611804;
            x="6 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            y="1.1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            w="20 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            colorBackground[]={1,1,1,0.1};
        };
        class ChannelTitle: RscText {
            idc=2611805;
            text=CSTRING(moduleStaticRadio_ChannelTitle);
            x="0 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            y="2.2 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            w="26 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            colorBackground[]={0,0,0,0.5};
        };
        class ChannelEdit: RscEdit {
            style=16;
            idc=2611806;
            x="10 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            y="2.2 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            w="16 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            colorBackground[]={1,1,1,0.1};
        };
        class SpeakerTitle: RscText {
            idc=2611807;
            text=CSTRING(moduleStaticRadio_SpeakerTitle);
            x="0 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            y="3.3 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            w="26 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            colorBackground[]={0,0,0,0.5};
        };
        class SpeakerCheckbox: RscCheckBox {
            idc=2611808;
            text="#(argb,8,8,3)color(0,0,0,0)";
            x="10 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            y="3.3 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            w="1 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
        };

        class VolumeTitle: RscText {
            idc=2611809;
            text=CSTRING(moduleStaticRadio_VolumeTitle);
            x="0 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            y="4.4 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            w="26 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            colorBackground[]={0,0,0,0.5};
        };
        class VolumeSlider: ctrlXSliderH {
            idc=2611810;
            x="10 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            y="4.4 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            w="11 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
        };
        class VolumeEdit: RscEdit {
            style=16;
            idc=2611811;
            x="(10+12) * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            y="4.4 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            w="4 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
            colorBackground[]={1,1,1,0.1};
        };
    };
};





class ButtonOK;
class ButtonCancel;
class Background;
class Title;
class Content;
class controls;
class RscDisplayAttributes;
class RscAttributeOwners;
class RscAttributeDiaryRecord;
class RscDisplayAttributesModuleTFARStaticRadio: RscDisplayAttributes {
    //scriptName="RscDisplayAttributesModuleTFARStaticRadio";
    //scriptPath="CuratorDisplays";
    onLoad="[""onLoad"",_this,""RscDisplayAttributesModuleTFARStaticRadio""] call TFAR_static_radios_fnc_zeusAttributes";
    onUnload="[""onUnload"",_this,""RscDisplayAttributesModuleTFARStaticRadio""] call TFAR_static_radios_fnc_zeusAttributes";
    class Controls: Controls {
        class Background: Background {};
        class Title: Title {};
        class Content: Content {
            class Controls: controls {
                class StaticRadioSettings: RscAttributeTFARStaticRadioThingy {};
            };
        };
        class ButtonOK: ButtonOK {
            onLoad = "_this call TFAR_static_radios_fnc_moduleStaticRadio";
        };
        class ButtonCancel: ButtonCancel {
        };
    };
};

class CfgVehicles {
    class Module_F;
    class Items_base_F;
    class TFAR_Module_staticRadio: Module_F {
        author = ECSTRING(core,AUTHORS);
        category = ECSTRING(core,CATEGORY);
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        scope = 1;
        scopeCurator = 2;

        curatorCanAttach = 1;
        displayName = CSTRING(moduleStaticRadio_DisplayName);
        //function = "TFAR_static_radios_fnc_moduleStaticRadio";
        icon = "";//#TODO
        curatorInfoType="RscDisplayAttributesModuleTFARStaticRadio";
    };

    class TFAR_Static_Radio_Base : Items_base_F {
        tf_hasLRradio = 0;
        tf_encryptionCode = "";
        tf_range = 20000;
        tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
        tf_hasLRradio = 1;
        tf_subtype = "digital_lr";
        scope = 0;
        scopeCurator = 0;
        class ACE_Actions {
            class ACE_MainActions {
                class TFAR_Radio {
                    displayName = ECSTRING(CORE,RADIOS);
                    distance = 2;
                    condition = "_player call TFAR_fnc_hasRadio";
                    exceptions[] = {};
                    statement = "";
                    icon = QPATHTOF(ui\ACE_Interaction_Radio_Icon.paa);
                    insertChildren = QUOTE(_this call EFUNC(core,getRadiosChildren));
                };
            };
        };
    };
    class TFAR_Static_Radio_NATO : TFAR_Static_Radio_Base {
        scope = 2;
        scopeCurator = 2;

        author = "Bohemia Interactive";
        mapSize = 0.17;
        editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_SurvivalRadio_F.jpg";
        _generalMacro = "Land_SurvivalRadio_F";
        displayName = "Portable Long-range Radio (NATO)";
        model = "\A3\Structures_F\Items\Electronics\SurvivalRadio_F.p3d";
        icon = "iconObject_4x1";
        editorCategory = ECSTRING(core,CATEGORY);
        cost = 1000;

        tf_range = 40000;
        tf_encryptionCode = "tf_west_radio_code";
        tf_dialog = "rt1523g_radio_dialog";
        tf_subtype = "digital_lr";
    };
};
