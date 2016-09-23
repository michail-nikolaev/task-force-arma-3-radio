/*
    Name: TFAR_fnc_currentUnit

    Author(s):
    Nkey

    Description:
    Return current player unit (player or remote controlled by Zeus).

    Parameters:
    Nothing

    Returns:
    OBJECT: current unit

    Example:
    call TFAR_fnc_currentUnit;
*/
private ["_unit"];
missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player]
