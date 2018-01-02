#include "script_component.hpp"

/*
 * Name: TFAR_fnc_onArsenal
 *
 * Author: Dedmen
 * Eventhandler for Opening/Closing of Arsenal.
 * Currently handles workaround for https://feedback.bistudio.com/T120517
 *
 * Arguments:
 * 0: Type of Event <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * "PreOpen" call TFAR_fnc_onArsenal;
 *
 * Public: No
 */

params ["_eventType"];

switch _eventType do {
    case "PrePreOpen": {
        GVAR(currentlyInArsenal) = true;
        //Check if current backpack is a TFAR Radio
        private _class = configFile >> "CfgVehicles" >> (backpack player);
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
        private _class = configFile >> "CfgVehicles" >> (backpack player);
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
        GVAR(currentlyInArsenal) = false;
    };
};
