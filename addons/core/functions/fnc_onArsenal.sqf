/*
    Name: TFAR_fnc_onArsenal

    Author(s):
    Dedmen

    Description:
    Eventhandler for Opening/Closing of Arsenal.
    Currently handles workaround for https://feedback.bistudio.com/T120517

    Parameters:
    0: STRING - Type of Event

    Returns:
    Nothing

    Example:
    "PreOpen" call TFAR_fnc_onArsenal;
*/
private ["_backpackVariables","_class"];
params ["_eventType"];
switch _eventType do {
    case "PrePreOpen": {
        //Check if current backpack is a TFAR Radio
        private _class = ConfigFile >> "CfgVehicles" >> (backpack player);
        if (isClass _class AND {isNumber (_class >> "tf_hasLRradio")}) then {
            //Save all variables from backpack into array
            private _backpackVariables = [];
            {
                _backpackVariables pushBack [_x,(unitBackpack player) getVariable _x];
                true;
            } count (allVariables unitBackpack player);
            TFAR_ArsenalBackpackVariables = [backpack player,_backpackVariables];
        };//else non tfar backpack
    };
    case "PostOpen": {

    };
    case "PostClose": {
        //Check if current backpack is a TFAR Radio
        private _class = ConfigFile >> "CfgVehicles" >> (backpack player);
        if (isClass _class AND {isNumber (_class >> "tf_hasLRradio")}) then {
            if (isNil "TFAR_ArsenalBackpackVariables") exitwith {};
            if ((TFAR_ArsenalBackpackVariables select 0) == backpack player) then {
                {
                    (unitBackpack player) setVariable [_x select 0,_x select 1,true]; //TFAR_fnc_setLrSettings is using publicVar so we do here
                    true;
                } count (TFAR_ArsenalBackpackVariables select 1);
            };//else player changed his backpack
        };//else non tfar backpack
        TFAR_ArsenalBackpackVariables = nil;
    };
};
