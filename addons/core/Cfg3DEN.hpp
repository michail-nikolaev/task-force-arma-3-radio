/*
class ctrlMenuStrip;
class display3DEN {
    class Controls {
        class MenuStrip: ctrlMenuStrip {
            class Items {
                class Attributes {
                    items[] += {"TFAR_Preferences"};
                };
                class TFAR_Preferences {
                    text = ECSTRING(core,3DEN_Menu);
                    action = "edit3DENMissionAttributes 'TFAR_Preferences';";
                    picture = QPATHTOF(task_force_arrowhead_logo.paa);
                };
            };
        };
    };
};
*/
class Cfg3DEN {
    /*
    class Mission {
        class TFAR_Preferences {
            displayName = ECSTRING(core,3DEN_Menu);
            class AttributeCategories {
                
            };
        };
    };
    */
    class Object {
        class AttributeCategories {
            class TFAR_attributes {
                displayName = ECSTRING(core,3DEN_Properties);
                collapsed = 1;
                class Attributes {
                    class TFAR_freq_sr {
                        displayName = ECSTRING(settings,DefaultRadioFrequencies_SR);
                        tooltip = ECSTRING(settings,DefaultRadioFrequencies_SR_desc);
                        property = "TFAR_freq_sr";
                        control = "EditArray";
                        expression = QUOTE(if !(_value isEqualTo []) then {_value=[ARR_5(str _value,TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput);_this setVariable [ARR_3('%s',_value,true)];});
                        defaultValue = "[]";
                        unique = 0;
                        condition = "objectControllable + logicModule";
                    };
                    class TFAR_freq_lr {
                        displayName = ECSTRING(settings,DefaultRadioFrequencies_LR);
                        tooltip = ECSTRING(settings,DefaultRadioFrequencies_LR_desc);
                        property = "TFAR_freq_lr";
                        control = "EditArray";
                        expression = QUOTE(if !(_value isEqualTo []) then {_value=[ARR_5(str _value,TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput);_this setVariable [ARR_3('%s',_value,true)];});
                        defaultValue = "[]";
                        unique = 0;
                        condition = "objectControllable + logicModule";
                    };
                    class TFAR_CuratorCamEars {
                        property = "TFAR_CuratorCamEars";
                        control = "Checkbox";
                        displayName = CSTRING(Att_CuratorCamEars);
                        tooltip = CSTRING(Att_CuratorCamEars_tooltip);
                        expression = QUOTE(if (_value) then {_this setVariable [ARR_3('%s',_value,true)]};);
                        typeName = "BOOL";
                        condition = "objectBrain";
                        defaultValue = "false";
                    };
                    };
                    class TFAR_defaultIntercomSlot {
                        property = "TFAR_defaultIntercomSlot";
                        control = "EditShort";
                        displayName = "Default Intercom Channel";
                        tooltip = "Default Intercom Channel when entering vehicle. Overwrites global setting. (-1 means Intercom disabled by default, -2 means this setting is ignored)";
                        expression = QUOTE(diag_log [ARR_2('defaultIntercomSlot', _value)]; if (_value != -2) then {_this setVariable [ARR_2('TFAR_defaultIntercomSlot',_value)]};);
                        typeName = "NUMBER";
                        validate = "number";
                        condition = "objectVehicle";
                        defaultValue = "-2";
                    };
                };
            };
        };
    };
    class Group {
        class AttributeCategories {
            class TFAR_attributes {
                displayName = ECSTRING(core,3DEN_Properties);
                collapsed = 1;
                class Attributes {
                    class TFAR_freq_sr {
                        displayName = ECSTRING(settings,DefaultRadioFrequencies_SR);
                        tooltip = ECSTRING(settings,DefaultRadioFrequencies_SR_desc);
                        property = "TFAR_freq_sr";
                        expression = QUOTE(if !(_value isEqualTo []) then {_value=[ARR_5(str _value,TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput);_this setVariable [ARR_3('%s',_value,true)];});
                        control = "EditArray";
                        defaultValue = "[]";
                        unique = 0;
                    };
                    class TFAR_freq_lr {
                        displayName = ECSTRING(settings,DefaultRadioFrequencies_LR);
                        tooltip = ECSTRING(settings,DefaultRadioFrequencies_LR_desc);
                        property = "TFAR_freq_lr";
                        expression = QUOTE(if !(_value isEqualTo []) then {_value=[ARR_5(str _value,TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput);_this setVariable [ARR_3('%s',_value,true)];});
                        control = "EditArray";
                        defaultValue = "[]";
                        unique = 0;
                    };
                };
            };
        };
    };
};
