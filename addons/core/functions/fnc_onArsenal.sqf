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
tfar_log = {
systemChat _this;
diag_log _this;
};
_eventType call tfar_log;
switch _eventType do {
    case "PreOpen": {
        "PreOpen" call tfar_log;
        //Check if current backpack is a TFAR Radio
        _class = ConfigFile >> "CfgVehicles" >> (backpack player);
        if (isClass _class AND {isNumber (_class >> "tf_hasLRradio")}) then {
            //Save all variables from backpack into array
            _backpackVariables = [];
            {
                ("save"+_x+"to"+(str (unitBackpack player) getVariable _x)) call tfar_log;
                _backpackVariables pushBack [_x,(unitBackpack player) getVariable _x];
                true;
            } count (allVariables unitBackpack player);
            TFAR_ArsenalBackpackVariables = [backpack player,_backpackVariables];
        } else {
        "Non TFAR backpack" call tfar_log;
        };
    };
    case "PostOpen": {

    };
    case "PostClose": {
        "PostClose" call tfar_log;
        //Check if current backpack is a TFAR Radio
        _class = ConfigFile >> "CfgVehicles" >> (backpack player);
        (str _class) call tfar_log;
        if (isClass _class AND {isNumber (_class >> "tf_hasLRradio")}) then {
            if (isNil "TFAR_BackpackVariables") exitwith {"TFAR_BackpackVariables is Nil." call tfar_log;};
            if ((TFAR_BackpackVariables select 0) == backpack player) then {
                {
                ("restore"+(_x select 0)+"to"+(str (_x select 1))) call tfar_log;
                    (unitBackpack player) setVariable [_x select 0,_x select 1];
                    true;
                } count (TFAR_BackpackVariables select 1);
            } else {
                "different backpack" call tfar_log;
            };
        } else {
        "Non TFAR backpack" call tfar_log;
        };
        TFAR_BackpackVariables = nil;
    };

};
