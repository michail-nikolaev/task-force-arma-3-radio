class CfgVehicles {
    class Land_Communication_F;

    class TFAR_Land_Communication_F : Land_Communication_F {
        scope = PUBLIC;
        scopeCurator = PUBLIC;
        author = ECSTRING(core,AUTHORS);
        category = ECSTRING(core,CATEGORY);
        editorCategory = ECSTRING(core,CATEGORY);
        displayName = CSTRING(TowerName);
    };
};
