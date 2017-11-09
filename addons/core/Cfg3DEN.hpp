class ctrlMenuStrip;
class display3DEN {
    class Controls {
        class MenuStrip: ctrlMenuStrip {
            class Items {
                class Attributes {
                    items[] += {"TFAR_Preferences"};
                };
                class TFAR_Preferences {
                    text = "TFAR Preferences";
                    action = "edit3DENMissionAttributes 'TFAR_Preferences';";
                    picture = QPATHTOF(task_force_arrowhead_logo.paa);
                };
            };
        };
    };
};
class Cfg3DEN {
    class Mission {
        class TFAR_Preferences {
            displayName = "TFAR Preferences";
            class AttributeCategories {
                class TFAR_Teamspeak_Channel {
                    displayName = "Teamspeak Channel";
                    collapsed = 0;
                    class Attributes {
                        class TFAR_Teamspeak_Channel_Name {
                            displayName = "Name:";
                            tooltip = "Define the forced Teamspeak Channel Name";
                            property = "TFAR_Teamspeak_Channel_Name";
                            control = "Edit";
                            expression = QUOTE(_this setVariable [ARR_3('%s',_value,true)];);
                            validate = "none";
                            typeName = "STRING";
                            defaultValue = "''";
                        };
                        class TFAR_Teamspeak_Channel_Password {
                            displayName = "Password:";
                            tooltip = "Define the forced Teamspeak Channel Password";
                            property = "TFAR_Teamspeak_Channel_Password";
                            control = "Edit";
                            expression = QUOTE(_this setVariable [ARR_3('%s',_value,true)];);
                            validate = "none";
                            typeName = "STRING";
                            defaultValue = "''";
                        };
                    };
                };
            };
        };
    };
    class Object {
        class AttributeCategories {
            class TFAR_attributes {
                displayName = "TFAR Options";
                collapsed = 1;
                class Attributes {
                    class TFAR_freq_sr {
                        displayName = "Default SR Freq";
                        tooltip = "define the default SR Freq for this unit";
                        property = "TFAR_freq_sr";
                        control = "EditArray";
                        typeName = "STRING";
                        expression = QUOTE(_value=[ARR_5(str _value,TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput); if !(_value isEqualTo []) then {_this setVariable [ARR_3('%s',_value,true)];});
                        defaultValue = "''";
                        unique = 0;
                    };
                    class TFAR_freq_lr {
                        displayName = "Default LR Freq";
                        tooltip = "define the default LR Freq for this unit";
                        property = "TFAR_freq_lr";
                        control = "EditArray";
                        typeName = "STRING";
                        expression = QUOTE(_value=[ARR_5(str _value,TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput); if !(_value isEqualTo []) then {_this setVariable [ARR_3('%s',_value,true)];});
                        defaultValue = "''";
                        unique = 0;
                    };
                    class TFAR_CuratorCamEars {
                        property = "TFAR_CuratorCamEars";
                        control = "Checkbox";
                        displayName = "Hear Camera when in Curator interface";
                        tooltip = "Hear voice from Curator Camera when in Curator interface";
                        expression = QUOTE(if (_value) then {_this setVariable [ARR_3('%s',_value,true)]};);
                        typeName = "BOOL";
                        condition = "objectBrain";
                        defaultValue = "false";
                    };
                };
            };
        };
    };
    class Group {
        class AttributeCategories {
            class TFAR_attributes {
                displayName = "TFAR Options";
                collapsed = 1;
                class Attributes {
                    class TFAR_freq_sr {
                        displayName = "Default SR Freq";
                        tooltip = "define the default SR Freq for this group";
                        property = "TFAR_freq_sr";
                        expression = QUOTE(_value=[ARR_5(str _value,TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput); if !(_value isEqualTo []) then {_this setVariable [ARR_3('%s',_value,true)];});
                        control = "EditArray";
                        typeName = "STRING";
                        defaultValue = "''";
                        unique = 0;
                    };
                    class TFAR_freq_lr {
                        displayName = "Default LR Freq";
                        tooltip = "define the default LR Freq for this group";
                        property = "TFAR_freq_lr";
                        expression = QUOTE(_value=[ARR_5(str _value,TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput); if !(_value isEqualTo []) then {_this setVariable [ARR_3('%s',_value,true)];});
                        control = "EditArray";
                        typeName = "STRING";
                        defaultValue = "''";
                        unique = 0;
                    };
                };
            };
        };
    };
};
