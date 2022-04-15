class ace_arsenal_stats {
    class statBase;
    class TFAR_ExternalIntercom_WirelessEnabled : statBase {
        scope = 2;
        displayName = "Wireless Intercom Enabled";
        priority = 1; // A higher value means the stat will be displayed higher on the page.
        stats[] = {"TFAR_ExternalIntercomWirelessCapable"};
        showBar = 0;
        showText = 1;
        textStatement = "params ['_stats','_config']; format ['%1',getNumber (_config >> _stats select 0) > 0 || {(configName _config) in TFAR_externalIntercomWirelessHeadgear}]";
        condition = "params ['','_config']; getNumber (_config >> 'TFAR_ExternalIntercomWirelessCapable') > 0 || {(configName _config) in TFAR_externalIntercomWirelessHeadgear}";
        tabs[] = {{6},{}}; // Arrays of tabs, left array is left tabs, right array is right tabs.
    };
};
