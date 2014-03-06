private ["_lr_cycle_direction", "_result"];
_lr_cycle_direction = _this select 0;
_result = false;

if ((call TFAR_fnc_haveLRRadio) and {alive player}) then
{
	private ["_radio", "_radio_list", "_active_radio", "_active_radio_index", "_new_radio_index", "_pos"];
	_radio = call TFAR_fnc_activeLrRadio;
	_radio_list = call TFAR_fnc_lrRadiosList;

	_active_radio_index = 0;
	_new_radio_index = 0;

	_pos = 0;
	{
		if (((_x select 0) == (_radio select 0)) or ((_x select 1) == (_radio select 1))) then
		{
			_active_radio_index = _pos;
		};
		_pos = _pos + 1;
	} forEach _radio_list;


	switch (_lr_cycle_direction) do
	{
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

	_new_radio = _radio_list select _new_radio_index;
	_new_radio call TFAR_fnc_setActiveLrRadio;

	[(call TFAR_fnc_activeLrRadio), true] call TFAR_fnc_ShowRadioInfo;

	_result = true;
};
_result