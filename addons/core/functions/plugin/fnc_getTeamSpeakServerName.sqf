#include "script_component.hpp"

/*
 * Name: TFAR_COMPONENT_fnc_getTeamSpeakServerName
 *
 * Author: NKey
 * Returns TeamSpeak server name.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * name of the server <STRING>
 *
 * Example:
 * call TFAR_COMPONENT_fnc_getTeamSpeakServerName;
 *
 * Public: Yes
 */
*/

"task_force_radio_pipe" callExtension "TS_INFO	SERVER"
