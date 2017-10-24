editorCategory = "TFAR";
class Attributes {

    class staticRadioFrequency {
        displayName = "$STR_TFAR_Zeus_moduleStaticRadio_FreqTitle"; // Name assigned to UI control class Title
        tooltip = "$STR_TFAR_Zeus_moduleStaticRadio_ATT_Frequency_Tip"; // Tooltip assigned to UI control class Title
        property = "staticRadioFrequency"; // Unique config property name saved in SQM
        control = "Edit"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

        expression = QUOTE(if (isMultiplayer) then {[ARR_2(_this,call compile _value)] call TFAR_static_radios_fnc_setFrequencies});

        defaultValue = "str (_this call TFAR_static_radios_fnc_generateFrequencies)";

        validate = "none"; // Validate the value before saving. Can be "none", "expression", "condition", "number" or "variable"
        condition = "objectHasInventoryCargo"; // Condition for attribute to appear (see the table below)
        typeName = "STRING"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
    };
    class staticRadioChannel {
        displayName = "$STR_TFAR_Zeus_moduleStaticRadio_ChannelTitle";
        tooltip = "$STR_TFAR_Zeus_moduleStaticRadio_ATT_Channel_Tip";
        property = "staticRadioChannel";
        control = "Edit";

        expression = QUOTE(if (isMultiplayer) then {[ARR_2(_this,_value)] call TFAR_static_radios_fnc_setActiveChannel});

        defaultValue = '1';

        validate = "none";
        condition = "objectHasInventoryCargo";
        typeName = "NUMBER";
    };
    class staticRadioSpeaker {
        displayName = "$STR_TFAR_Zeus_moduleStaticRadio_ATT_SpeakerEnabled"; // Name assigned to UI control class Title
        tooltip = "$STR_TFAR_Zeus_moduleStaticRadio_ATT_SpeakerEnabled_Tip"; //#TODO Doesn't work on Static LR Radio backpacks yet (#1169).
        property = "staticRadioSpeaker";
        control = "Checkbox";

        expression = QUOTE(if (isMultiplayer) then {[ARR_2(_this,_value)] call TFAR_static_radios_fnc_setSpeakers});

        defaultValue = "false";

        validate = "none";
        condition = "objectHasInventoryCargo";
        typeName = "NUMBER";
    };
    class staticRadioVolume {
        displayName = "$STR_TFAR_Zeus_moduleStaticRadio_ATT_RadioVolume";
        tooltip = "$STR_TFAR_Zeus_moduleStaticRadio_ATT_RadioVolume_Tip";
        property = "staticRadioVolume";
        control = "tfar_static_radios_volumeSlider"; //Thanks Baermitumlaut :3

        expression = QUOTE(if (isMultiplayer) then {[ARR_2(_this,_value)] call TFAR_static_radios_fnc_setVolume});

        defaultValue = 7;

        validate = "none";
        condition = "objectHasInventoryCargo";
        typeName = "NUMBER";
    };
};
