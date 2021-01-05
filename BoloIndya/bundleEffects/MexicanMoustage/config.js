// sombrero
// Root	-> sombrero
// Joint_2	-> Root
// Joint_1_2_2	-> Root
// Joint	-> Root
// Joint_5	-> Root
// Joint_6	-> Root
// Joint_7	-> Root
// Joint_8	-> Root
// Joint_9	-> Root
// Joint_10	-> Root
// Joint_11	-> Root
// Joint_12	-> Root
// Joint_13	-> Root
// Joint_14	-> Root
// Joint_30	-> Root
// Joint_29	-> Root
// Joint_28	-> Root
// Joint_27	-> Root
// Joint_26	-> Root
// Joint_25	-> Root
// Joint_24	-> Root
// Joint_23	-> Root
// Joint_22	-> Root
// Joint_21	-> Root
// Joint_20	-> Root
// Joint_19	-> Root
// Joint_18	-> Root
// Joint_17	-> Root
// Joint_16	-> Root
// Joint_15	-> Root
// Joint_4	-> Root
// Joint_1_5_2	-> Joint_4
// Joint_3	-> Root
// Joint_1_4_2	-> Joint_3
// Joint_1_3_2	-> Joint_2
// Joint_1_3	-> Joint_1_2_2
// Joint_1_2	-> Joint
// Joint_1_6_2	-> Joint_5
// Joint_1_7_2	-> Joint_6
// Joint_1_8_2	-> Joint_7
// Joint_1_9_2	-> Joint_8
// Joint_1_10_2	-> Joint_9
// Joint_1_11_2	-> Joint_10
// Joint_1_12_2	-> Joint_11
// Joint_1_13_2	-> Joint_12
// Joint_1_14_2	-> Joint_13
// Joint_1_15_2	-> Joint_14
// Joint_1_31_2	-> Joint_30
// Joint_1_30_2	-> Joint_29
// Joint_1_29_2	-> Joint_28
// Joint_1_28_2	-> Joint_27
// Joint_1_26_2	-> Joint_26
// Joint_1_27_2	-> Joint_25
// Joint_1_25_2	-> Joint_24
// Joint_1_24_2	-> Joint_23
// Joint_1_23_2	-> Joint_22
// Joint_1_22_2	-> Joint_21
// Joint_1_21_2	-> Joint_20
// Joint_1_20_2	-> Joint_19
// Joint_1_19_2	-> Joint_18
// Joint_1_18_2	-> Joint_17
// Joint_1_17_2	-> Joint_16
// Joint_1_16_2	-> Joint_15
// Joint_1_7	-> Joint_1_5_2
// Joint_1_6	-> Joint_1_4_2
// Joint_1_5	-> Joint_1_3_2
// Joint_1_4	-> Joint_1_3
// Joint_1	-> Joint_1_2
// Joint_1_8	-> Joint_1_6_2
// Joint_1_9	-> Joint_1_7_2
// Joint_1_10	-> Joint_1_8_2
// Joint_1_11	-> Joint_1_9_2
// Joint_1_12	-> Joint_1_10_2
// Joint_1_13	-> Joint_1_11_2
// Joint_1_14	-> Joint_1_12_2
// Joint_1_15	-> Joint_1_13_2
// Joint_1_16	-> Joint_1_14_2
// Joint_1_17	-> Joint_1_15_2
// Joint_1_33	-> Joint_1_31_2
// Joint_1_32	-> Joint_1_30_2
// Joint_1_31	-> Joint_1_29_2
// Joint_1_30	-> Joint_1_28_2
// Joint_1_29	-> Joint_1_26_2
// Joint_1_28	-> Joint_1_27_2
// Joint_1_27	-> Joint_1_25_2
// Joint_1_26	-> Joint_1_24_2
// Joint_1_25	-> Joint_1_23_2
// Joint_1_24	-> Joint_1_22_2
// Joint_1_23	-> Joint_1_21_2
// Joint_1_22	-> Joint_1_20_2
// Joint_1_21	-> Joint_1_19_2
// Joint_1_20	-> Joint_1_18_2
// Joint_1_19	-> Joint_1_17_2
// Joint_1_18	-> Joint_1_16_2


Api.meshfxMsg("dynImass", 0, 0, "Joint_1_16");
function Effect() {
    var self = this;

    this.update = function() {
        var now = (new Date()).getTime();
        if (now > self.t) {
            Api.meshfxMsg("animOnce", 1, 0, "Take 001");
            Api.stopSound("music.ogg");
            Api.playSound("music.ogg",false,1);
            self.t = now + 7100;
        }        
    };

    this.init = function() {
        Api.meshfxMsg("spawn", 4, 0, "cut.bsm2");
        Api.meshfxMsg("spawn", 3, 0, "!glfx_FACE");

        Api.meshfxMsg("spawn", 5, 0, "mexican.bsm2");
        Api.meshfxMsg("spawn", 0, 0, "spheres.bsm2");

        Api.meshfxMsg("spawn", 1, 0, "moustage.bsm2");

        Api.meshfxMsg("spawn", 2, 0, "morph.bsm2");

        Api.meshfxMsg("dynImass", 0, 0, "sombrero");
        Api.meshfxMsg("dynImass", 0, 0, "Root");
        Api.meshfxMsg("dynImass", 0, 0, "Joint");

        Api.meshfxMsg("dynImass", 0, 0, "Joint_2_2_2");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_5");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_6");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_7");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_8");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_9");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_10");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_11");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_12");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_13");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_14");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_30");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_29");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_28");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_27");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_26");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_25");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_24");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_23");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_22");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_21");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_20");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_19");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_18");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_17");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_16");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_15");

        Api.meshfxMsg("dynImass", 0, 0, "Joint");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_1_2_2");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_2");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_3");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_4");

        Api.meshfxMsg("dynSphere", 0, 0, "0 31 20 192");

		Api.meshfxMsg("dynGravity", 0, 0, "0 -1500 0");

        // Api.showHint("Open mouth");
        // Api.playVideo("frx",true,1);

        
        self.t = 0;
        this.faceActions = [self.update];

        Api.showRecordButton();
    };

    this.restart = function() {
        Api.meshfxReset();
        // Api.stopVideo("frx");
        Api.stopSound("music.ogg");
        self.init();
    };

    this.faceActions = [];
    this.noFaceActions = [];

    this.videoRecordStartActions = [];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [this.restart];
}

configure(new Effect());