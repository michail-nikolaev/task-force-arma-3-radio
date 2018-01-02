#include "script_component.hpp"

/*
 * Name: TFAR_fnc_getTransmittingDistanceMultiplicator
 *
 * Author: NKey
 * Return multiplicator for sending distance of radio.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call TFAR_fnc_getTransmittingDistanceMultiplicator;
 *
 * Public: Yes
 */

TFAR_currentUnit getVariable ["tf_sendingDistanceMultiplicator", 1.0];
