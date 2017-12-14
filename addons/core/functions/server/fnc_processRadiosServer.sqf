/*
    Name: TFAR_fnc_processRadiosServer

    Author(s):
        gandjustas

    Description:
        Handles (on server) getting switching radios, handles whether a manpack must be added to the player or not.

    Parameters:
        0: OBJECT - unit to replace radios

    Returns:
        Nothing

    Example:
       _unit call TFAR_fnc_processRadiosServer (with remoteExec from client)
*/
params ["_unit"];
 if (alive _unit) then {
    (_unit call TFAR_fnc_getDefaultRadioClasses) params ["_lrRadio", "_personalRadio", "_riflemanRadio"];
    private _defaultRadio = _riflemanRadio;
    

    //Handle backpack replacement for group leaders
    if (leader _unit == _unit) then {
        if (!TFAR_giveLongRangeRadioToGroupLeaders or {backpack _unit == "B_Parachute"} or {_unit call TFAR_fnc_isForcedCurator}) exitWith {};
        if ([(backpack _unit), "tf_hasLRradio", 0] call TFAR_fnc_getVehicleConfigProperty == 1) exitWith {};

        private _items = backpackItems _unit;
        private _backPack = unitBackpack _unit;
        _unit addBackpackGlobal _lrRadio;
        clearItemCargoGlobal _backPack;
        {
            if (_unit canAddItemToBackpack _x) then {
                _unit addItemToBackpack _x;
            }else{
                _backPack addItemCargoGlobal [_x, 1]
            };
            true;
        } forEach _items;	
    };

    //Radio programmator
    if (TFAR_giveMicroDagrToSoldier)  then {
        _unit linkItem "TFAR_microdagr";
    };

    //SR Radios
    if ((TF_give_personal_radio_to_regular_soldier) or {leader _unit == _unit} or {rankId _unit >= 2}) then {
        _defaultRadio = _personalRadio;
    };
    [_unit, _defaultRadio] call TFAR_fnc_replaceSwRadiosServer;
};
