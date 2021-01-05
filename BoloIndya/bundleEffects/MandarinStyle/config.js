// head_cut
// mandarin
// drops
// joint7
// joint9	-> joint7
// joint10	-> joint9
// joint11	-> joint10
// joint12	-> joint11
// joint8	-> joint7
// joint15	-> joint8
// joint16	-> joint15
// joint17	-> joint16
// joint18	-> joint17
// joint13	-> joint12
// joint19	-> joint18
// joint14	-> joint13
function Effect() {
    var self = this;

    this.init = function() {
        Api.meshfxMsg("spawn", 2, 0, "!glfx_FACE");

        Api.meshfxMsg("spawn", 0, 0, "BeautyFaceSP.bsm2");
        // Api.meshfxMsg("animOnce", 0, 0, "static");

        Api.meshfxMsg("spawn", 1, 0, "MandarinStyle_ed4.3_physics.bsm2");
        // Api.meshfxMsg("animOnce", 1, 0, "static");

        Api.meshfxMsg("dynImass", 1, 0, "head_cut");
        Api.meshfxMsg("dynImass", 1, 0, "mandarin");
        Api.meshfxMsg("dynImass", 1, 0, "drops");
        
        Api.meshfxMsg("dynImass", 1, 0, "joint7");
        
        Api.meshfxMsg("dynImass", 1, 0, "joint9");
        Api.meshfxMsg("dynImass", 1, 1, "joint10");
        Api.meshfxMsg("dynImass", 1, 1, "joint11");
        Api.meshfxMsg("dynImass", 1, 10, "joint12");
        Api.meshfxMsg("dynImass", 1, 10, "joint13");
        Api.meshfxMsg("dynImass", 1, 10, "joint14");

        Api.meshfxMsg("dynImass", 1, 0, "joint8");
        Api.meshfxMsg("dynImass", 1, 1, "joint15");
        Api.meshfxMsg("dynImass", 1, 1, "joint16");
        Api.meshfxMsg("dynImass", 1, 10, "joint17");
        Api.meshfxMsg("dynImass", 1, 10, "joint18");
        Api.meshfxMsg("dynImass", 1, 10, "joint19");

		// Api.meshfxMsg("dynSphere", 1, 1, "0 -43 25 79");

        Api.meshfxMsg("dynDamping", 1, 95);
		Api.meshfxMsg("dynGravity", 1, 0, "0 -700 0");

        // Api.showHint("Open mouth");
        // Api.playVideo("frx",true,1);
        Api.playSound("music_L.ogg",true,1);
        Api.showRecordButton();
    };

    this.restart = function() {
        Api.meshfxReset();
        // Api.stopVideo("frx");
        // Api.stopSound("sfx.aac");
        self.init();
    };

    this.faceActions = [];
    this.noFaceActions = [];

    this.videoRecordStartActions = [];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [this.restart];
}

configure(new Effect());