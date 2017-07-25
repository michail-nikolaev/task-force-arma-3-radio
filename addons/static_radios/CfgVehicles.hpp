
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
            text="$STR_subject_name:";
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
            text="$STR_TFAR_Zeus_moduleStaticRadio_FreqTitle";
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
            text="$STR_TFAR_Zeus_moduleStaticRadio_ChannelTitle";
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
            text="$STR_TFAR_Zeus_moduleStaticRadio_SpeakerTitle";
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
            text="$STR_TFAR_Zeus_moduleStaticRadio_VolumeTitle";
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
    class TFAR_Module_staticRadio: Module_F {
        author = "TFAR";
        //category = "TFAR";
        category = "TFAR";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        scope = 1;
        scopeCurator = 2;


        curatorCanAttach = 1;
        displayName = "$STR_TFAR_Zeus_moduleStaticRadio_DisplayName";
        //function = "TFAR_static_radios_fnc_moduleStaticRadio";
        icon = "";//#TODO
curatorInfoType="RscDisplayAttributesModuleTFARStaticRadio";







    };



};
