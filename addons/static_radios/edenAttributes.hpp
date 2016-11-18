editorCategory = "TFAR";
class Attributes {//#TODO move Attributes into base class for all Radio Vehicles
// Attribute class, can be anything
    class staticRadioFrequency {
        //--- Mandatory properties
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
        //--- Mandatory properties
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
        //--- Mandatory properties
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
};
