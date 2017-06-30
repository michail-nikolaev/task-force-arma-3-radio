#include "script_component.hpp"

/*
    Name: TFAR_fnc_getSrHalfDuplexOverride

    Author(s):
        MorpheusXAUT

    Description:
        Returns the passed SR radio's capabilities to use full-duplex mode although global half-duplex has been enabled.
        Function named after new naming scheme SR/LR instead of SW/LR on purpose, in consideration of https://github.com/michail-nikolaev/task-force-arma-3-radio/pull/1269/files#r125026122

    Parameters:
        0: STRING - Radio classname

    Returns:
        BOOLEAN - Half-duplex mode should be skipped for this SR radio

    Example:
        (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSrHalfDuplexOverride;
*/

params[["_radio","",[""]]];

(_radio call TFAR_fnc_getSwSettings) param [HALFDUPLEX_OVERRIDE_OFFSET,false]
