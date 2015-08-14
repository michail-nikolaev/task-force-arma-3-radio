/*
 	Name: TFAR_fnc_processLRCycleKeys
 	
 	Author(s):
		

 	Description:
		Allows rotating through the list of LR radios with keys.
	
	Parameters:
		0: STRING - Direction to cycle : VALUES (next, prev)
 	
 	Returns:
		BOOLEAN - If the event was handled or not.
 	
 	Example:
		Handled via CBA's onKey eventhandler.
*/
private ["_lr_cycle_direction", "_result"];
_lr_cycle_direction = _this select 0;
_result = false;

<<<<<<< HEAD
if ((call TFAR_fnc_haveLRRadio) and {alive TFAR_currentUnit}) then {
	private ["_radio", "_radio_list", "_active_radio_index", "_new_radio_index"];
	_radio = call TFAR_fnc_activeLrRadio;
	_radio_list = TFAR_currentUnit call TFAR_fnc_lrRadiosList;
=======
if ((call TFAR_fnc_haveLRRadio) and {alive player}) then
{
	private ["_radio", "_radio_list", "_active_radio_index", "_new_radio_index"];
	_radio = call TFAR_fnc_activeLrRadio;
	_radio_list = call TFAR_fnc_lrRadiosList;
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086

	_active_radio_index = 0;
	_new_radio_index = 0;

	{
<<<<<<< HEAD
		if (((_x select 0) == (_radio select 0)) or {(_x select 1) == (_radio select 1)}) exitWith{
=======
		if (((_x select 0) == (_radio select 0)) or {(_x select 1) == (_radio select 1)}) exitWith
		{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
			_active_radio_index = _forEachIndex;
		};
	} forEach _radio_list;


<<<<<<< HEAD
	switch (_lr_cycle_direction) do{
=======
	switch (_lr_cycle_direction) do
	{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
		case "next":
			{
				_new_radio_index = (_active_radio_index + 1) mod (count _radio_list);
			};
	    case "prev":
	    {
	    	if (_active_radio_index != 0) then {
	    		_new_radio_index = (_active_radio_index - 1);
	    	} else {
	    		_new_radio_index = (count _radio_list) - 1;
	    	};
	    };
	};

	(_radio_list select _new_radio_index) call TFAR_fnc_setActiveLrRadio;

	[(call TFAR_fnc_activeLrRadio), true] call TFAR_fnc_ShowRadioInfo;

	_result = true;
};
_result