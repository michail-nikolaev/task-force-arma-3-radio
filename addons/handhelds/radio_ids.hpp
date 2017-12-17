#define TF_RADIO_ID_full(baseClass,displayNameBase,index) class DOUBLES(baseClass,index) : baseClass \
    { \
        displayName = 'displayNameBase index'; \
        scope = 1; \
        scopeCurator = 1; \
        tf_prototype = 0; \
        tf_radio = 1; \
        ace_arsenal_uniqueBase = 'baseClass'; \
    };


#define TF_RADIO_IDS_1(baseClass,displayNameBase,index,one) class DOUBLES(baseClass,index) : DOUBLES(baseClass,one) \
{ \
    displayName = 'displayNameBase index'; \
};

#define CREATE_INDEX(VAR1,VAR2) VAR1##VAR2

#define TF_RADIO_IDS_10(baseClass,displayNameBase,index10) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,CREATE_INDEX(index10,0),1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,CREATE_INDEX(index10,1),1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,CREATE_INDEX(index10,2),1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,CREATE_INDEX(index10,3),1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,CREATE_INDEX(index10,4),1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,CREATE_INDEX(index10,5),1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,CREATE_INDEX(index10,6),1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,CREATE_INDEX(index10,7),1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,CREATE_INDEX(index10,8),1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,CREATE_INDEX(index10,9),1)

#define TF_RADIO_IDS_100(baseClass,displayNameBase,index100) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,CREATE_INDEX(index100,0)) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,CREATE_INDEX(index100,1)) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,CREATE_INDEX(index100,2)) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,CREATE_INDEX(index100,3)) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,CREATE_INDEX(index100,4)) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,CREATE_INDEX(index100,5)) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,CREATE_INDEX(index100,6)) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,CREATE_INDEX(index100,7)) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,CREATE_INDEX(index100,8)) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,CREATE_INDEX(index100,9))


#define TF_RADIO_IDS_999(baseClass,displayNameBase) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,2,1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,3,1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,4,1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,5,1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,6,1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,7,1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,8,1) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,9,1) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,1) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,2) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,3) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,4) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,5) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,6) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,7) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,8) \
    TF_RADIO_IDS_10(baseClass,displayNameBase,9) \
    TF_RADIO_IDS_100(baseClass,displayNameBase,1) \
    TF_RADIO_IDS_100(baseClass,displayNameBase,2) \
    TF_RADIO_IDS_100(baseClass,displayNameBase,3) \
    TF_RADIO_IDS_100(baseClass,displayNameBase,4) \
    TF_RADIO_IDS_100(baseClass,displayNameBase,5) \
    TF_RADIO_IDS_100(baseClass,displayNameBase,6) \
    TF_RADIO_IDS_100(baseClass,displayNameBase,7) \
    TF_RADIO_IDS_100(baseClass,displayNameBase,8) \
    TF_RADIO_IDS_100(baseClass,displayNameBase,9) \
    TF_RADIO_IDS_1(baseClass,displayNameBase,1000,1)

#define TF_RADIO_IDS(baseClass,displayNameBase) \
    TF_RADIO_ID_full(baseClass,displayNameBase,1) \
    TF_RADIO_IDS_999(baseClass,displayNameBase)
