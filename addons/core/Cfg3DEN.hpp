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
class Cfg3DEN {
    class Mission {
        class TFAR_Preferences {
            displayName = ECSTRING(core,3DEN_Menu);
            class AttributeCategories {
                class TFAR_Teamspeak_Channel {
                    displayName = ECSTRING(core,TeamspeakChannel);
                    collapsed = 0;
                    class Attributes {
                        class TFAR_Teamspeak_Channel_Name {
                            displayName = ECSTRING(settings,TeamspeakChannel_name);
                            tooltip = ECSTRING(settings,TeamspeakChannel_name_desc);
                            property = "TFAR_Teamspeak_Channel_Name";
                            control = "Edit";
                            expression = QUOTE(_this setVariable [ARR_3('%s',_value,true)];);
                            validate = "none";
                            typeName = "STRING";
                            defaultValue = "''";
                        };
                        class TFAR_Teamspeak_Channel_Password {
                            displayName = ECSTRING(settings,TeamspeakChannel_password);
                            tooltip = ECSTRING(settings,TeamspeakChannel_password_desc);
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
                displayName = ECSTRING(core,3DEN_Properties);
                collapsed = 1;
                class Attributes {
                    class TFAR_freq_sr {
                        displayName = ECSTRING(core,DefaultRadioFrequencies_SR);
                        tooltip = ECSTRING(core,DefaultRadioFrequencies_SR_desc);
                        property = "TFAR_freq_sr";
                        control = "EditArray";
                        expression = QUOTE(if !(_value isEqualTo []) then {_value=[ARR_5(str _value,TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput);_this setVariable [ARR_3('%s',_value,true)];});
                        defaultValue = "[]";
                        unique = 0;
                        condition = "objectControllable + logicModule";
                    };
                    class TFAR_freq_lr {
                        displayName = ECSTRING(core,DefaultRadioFrequencies_LR);
                        tooltip = ECSTRING(core,DefaultRadioFrequencies_LR_desc);
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
                        displayName = ECSTRING(core,DefaultRadioFrequencies_SR);
                        tooltip = ECSTRING(core,DefaultRadioFrequencies_SR_desc);
                        property = "TFAR_freq_sr";
                        expression = QUOTE(if !(_value isEqualTo []) then {_value=[ARR_5(str _value,TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput);_this setVariable [ARR_3('%s',_value,true)];});
                        control = "EditArray";
                        defaultValue = "[]";
                        unique = 0;
                    };
                    class TFAR_freq_lr {
                        displayName = ECSTRING(core,DefaultRadioFrequencies_LR);
                        tooltip = ECSTRING(core,DefaultRadioFrequencies_LR_desc);
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
