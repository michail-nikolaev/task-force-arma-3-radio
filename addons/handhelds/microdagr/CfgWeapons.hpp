class ItemWatch;
class TFAR_microdagr: ItemWatch {
    author = "Raspu, Nkey";
    displayName = "MicroDAGR Radio Programmer";//#Stringtable
    descriptionShort = "Provides ability to program rifleman radios in the field";//#Stringtable
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    picture = QPATHTOF(microdagr\ui\microdagr_icon.paa);
    model = QPATHTOF(microdagr\data\tfr_microdagr);
};
HIDDEN_CLASS(tf_microdagr : TFAR_microdagr); //#Deprecated dummy class for backwards compat
