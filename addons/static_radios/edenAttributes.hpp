editorCategory = "TFAR";
class Attributes {//#TODO move Attributes into base class for all Radio Vehicles

    class staticRadioFrequency {
        displayName = "Frequencies"; // Name assigned to UI control class Title
        tooltip = "The static Frequencies for this radio"; // Tooltip assigned to UI control class Title
        property = "staticRadioFrequency"; // Unique config property name saved in SQM
        control = "Edit"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

        expression = QUOTE(if (isMultiplayer) then {[ARR_2(_this,call compile _value)] call TFAR_static_radios_fnc_setFrequencies});

        defaultValue = "str (_this call TFAR_static_radios_fnc_generateFrequencies)";

        validate = "none"; // Validate the value before saving. Can be "none", "expression", "condition", "number" or "variable"
        condition = "objectHasInventoryCargo"; // Condition for attribute to appear (see the table below)
        typeName = "STRING"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
    };
    class staticRadioChannel {
        displayName = "Channel"; // Name assigned to UI control class Title
        tooltip = "The current selected Channel for this radio"; // Tooltip assigned to UI control class Title
        property = "staticRadioChannel"; // Unique config property name saved in SQM
        control = "Edit"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

        expression = QUOTE(if (isMultiplayer) then {[ARR_2(_this,_value)] call TFAR_static_radios_fnc_setChannel});

        defaultValue = '1';

        validate = "none"; // Validate the value before saving. Can be "none", "expression", "condition", "number" or "variable"
        condition = "objectHasInventoryCargo"; // Condition for attribute to appear (see the table below)
        typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
    };
    class staticRadioSpeaker {
        displayName = "Speaker enabled"; // Name assigned to UI control class Title
        tooltip = ""; //#TODO write
        property = "staticRadioSpeaker"; // Unique config property name saved in SQM
        control = "Checkbox"; // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

        expression = QUOTE(if (isMultiplayer) then {[ARR_2(_this,_value)] call TFAR_static_radios_fnc_setSpeakers});

        defaultValue = "false";

        validate = "none"; // Validate the value before saving. Can be "none", "expression", "condition", "number" or "variable"
        condition = "objectHasInventoryCargo"; // Condition for attribute to appear (see the table below)
        typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
    };
    class staticRadioVolume {
        displayName = "Radio Volume"; // Name assigned to UI control class Title
        tooltip = "The normal max for this setting is 10. But for static Radios their volume can be amplified. Be careful using this on Radios that can be picked up by Players! A too high setting can cause performance problems on clients."; //#Stringtable
        property = "staticRadioVolume"; // Unique config property name saved in SQM
        control = "tfar_static_radios_volumeSlider"; //Thanks Baermitumlaut :3

        expression = QUOTE(if (isMultiplayer) then {[ARR_2(_this,_value)] call TFAR_static_radios_fnc_setVolume});

        defaultValue = 7;

        validate = "none"; // Validate the value before saving. Can be "none", "expression", "condition", "number" or "variable"
        condition = "objectHasInventoryCargo"; // Condition for attribute to appear (see the table below)
        typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
    };
};
