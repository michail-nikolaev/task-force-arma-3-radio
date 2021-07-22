class Cfg3DEN {
    class Attributes {
        class Default;
        class Title : Default {
            class Controls;
        };
        class Slider : Title {
            class Controls : Controls {
                class Title;
                class Value;
                class Edit;
            };
        };
        class TFAR_RangeSlider : Slider {
            onLoad = "      comment 'DO NOT COPY THIS CODE TO YOUR ATTRIBUTE CONFIG UNLESS YOU ARE CHANGING SOMETHING IN THE CODE!';        _ctrlGroup = _this select 0;        [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,''] call bis_fnc_initSliderValue;        ";
            attributeLoad = "        comment 'DO NOT COPY THIS CODE TO YOUR ATTRIBUTE CONFIG UNLESS YOU ARE CHANGING SOMETHING IN THE CODE!';        _ctrlGroup = _this;        [_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,'',_value] call bis_fnc_initSliderValue;    ";

            class Controls : Controls {
                class Title : Title {};
                class Value : Value {
                    sliderRange[] = {0,20};
                    sliderPosition = 0;
                    lineSize = 20;
                    sliderStep = 1;
                };
                class Edit : Edit {};
            };
        };
    };

    class Object {
        class AttributeCategories {
            class TFAR_attributes {
                displayName = ECSTRING(core,3DEN_Properties);
                collapsed = 1;
                class Attributes {
                    class TFAR_ExternalIntercomMaxRange_Phone {
                        property = "TFAR_ExternalIntercomMaxRange_Phone";
                        control = "TFAR_RangeSlider";
                        displayName = CSTRING(3DEN_ATTRIBUTE_MAX_RANGE_PHONE_HEADER);
                        tooltip = CSTRING(3DEN_ATTRIBUTE_MAX_RANGE_PHONE_DESC);
                        expression = QUOTE(if (_value > 0) then {_this setVariable [ARR_3('TFAR_externalIntercomMaxRange_Phone',_value,true)]};);
                        typeName = "NUMBER";
                        validate = "number";
                        condition = "objectVehicle";
                        defaultValue = "TFAR_externalIntercomMaxRange_Phone";
                    };
                    class TFAR_ExternalIntercomMaxRange_Wireless {
                        property = "TFAR_ExternalIntercomMaxRange_Wireless";
                        control = "TFAR_RangeSlider";
                        displayName = CSTRING(3DEN_ATTRIBUTE_MAX_RANGE_WIRELESS_HEADER);
                        tooltip = CSTRING(3DEN_ATTRIBUTE_MAX_RANGE_WIRELESS_DESC);
                        expression = QUOTE(if (_value > 0) then {_this setVariable [ARR_3('TFAR_externalIntercomMaxRange_Wireless',_value,true)]};);
                        typeName = "NUMBER";
                        validate = "number";
                        condition = "objectVehicle";
                        defaultValue = "TFAR_externalIntercomMaxRange_Wireless";
                    };
                };
            };
        };
    };
};
