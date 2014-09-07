/*
 	Name: TFAR_fnc_useCameraToWorld
 	
 	Author(s):
		L-H

 	Description:
		Uses positionCameraToWorld instead of the default means of calculating the unit's position for radio use.
	
	Parameters:
		0: OBJECT - unit
		1: BOOLEAN - Whether to use it or default.
 	
 	Returns:
		Nothing
 	
 	Example:
		[player, true] call TFAR_fnc_useCameraToWorld;
*/
if (_this select 1) exitWith {
	(_this select 0) setVariable ["TF_fnc_position", {
		_position = [0,0,0,0];
		if (_this select 0 == player) then {
			_position = positionCameraToWorld [0,0,0];
			_forward = (positionCameraToWorld [0,0,1]) vectorDiff _position;
			_position set [3, (((_forward select 0) atan2 (_forward select 1)) + 360) % 360];
		}else{
			_position = _this call TFAR_fnc_defaultPositionCoordinates;
		};
		_position
	}];
};

(_this select 0) setVariable ["TF_fnc_position", nil];