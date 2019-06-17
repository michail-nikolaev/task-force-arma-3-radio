IFDEF _X64

option casemap :none

_TEXT    SEGMENT

    EXTERN ts3plugin_onPluginCommandEventOld:       PROC;
    EXTERN ts3plugin_onPluginCommandEventNew:       PROC;
    EXTERN new_onPluginCommandEvent:                BYTE;

    PUBLIC ts3plugin_onPluginCommandEvent
    ts3plugin_onPluginCommandEvent PROC EXPORT

        CMP new_onPluginCommandEvent, 00
        jne _newFunc;
        jmp ts3plugin_onPluginCommandEventOld;
_newFunc:
    jmp ts3plugin_onPluginCommandEventNew;

    

    ts3plugin_onPluginCommandEvent ENDP

ELSE
.686
option casemap :none

_TEXT    SEGMENT

    EXTERN _ts3plugin_onPluginCommandEventOld:       PROC;
    EXTERN _ts3plugin_onPluginCommandEventNew:       PROC;
    EXTERN _new_onPluginCommandEvent:                BYTE;

    PUBLIC ts3plugin_onPluginCommandEvent
    ts3plugin_onPluginCommandEvent PROC FAR EXPORT

        CMP _new_onPluginCommandEvent, 00
        jne _newFunc;
        jmp _ts3plugin_onPluginCommandEventOld;
_newFunc:
    jmp _ts3plugin_onPluginCommandEventNew;

    ts3plugin_onPluginCommandEvent ENDP

ENDIF



_TEXT    ENDS
END
