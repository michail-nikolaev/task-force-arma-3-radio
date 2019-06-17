#include "script_component.hpp"

player createDiarySubject ["radio", localize LSTRING(subject_name)];
player createDiaryRecord ["radio", [localize LSTRING(radio_diver), localize LSTRING(radio_diver_text)]];
player createDiaryRecord ["radio", [localize LSTRING(radio_control), localize LSTRING(radio_control_text)]];
player createDiaryRecord ["radio", [localize LSTRING(radio_intercept), localize LSTRING(radio_intercept_text)]];
player createDiaryRecord ["radio", [localize LSTRING(radio_vehicle), localize LSTRING(radio_vehicle_text)]];
