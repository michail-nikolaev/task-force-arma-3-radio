if (call TFAR_fnc_haveLRRadio) then {
	[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, _this] call TFAR_fnc_setLrFrequency;
};