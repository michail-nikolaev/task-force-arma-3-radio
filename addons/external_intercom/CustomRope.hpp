class CfgVehicles {
    class Rope;
    class RopeSmallWire : Rope {
        maxRelLenght = 1.1;
        maxExtraLenght = 0;
        springFactor = 1; // higher == less stretchy rope
        segmentType = "RopeSegmentSmallWire";
        torqueFactor = 0.5;
        dampingFactor[] = {1.0,2.5,1.0};
        model = QPATHTOF(data\TFAR_wire.p3d);
    };
};

class CfgNonAIVehicles {
    class RopeSegmentSmallWire {
        scope = 2;
        displayName = "";
        simulation = "ropesegment";
        autocenter = 0;
        animated = 0;
        model = QPATHTOF(data\TFAR_wire.p3d);
    };
};
