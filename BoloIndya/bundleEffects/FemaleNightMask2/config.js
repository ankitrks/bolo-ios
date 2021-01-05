// joint_E_L11
// joint_E_L12    -> joint_E_L11
// joint_E_L13    -> joint_E_L12
// joint_E_L21
// joint_E_L22    -> joint_E_L21
// joint_E_L23    -> joint_E_L22
// joint_E_L31
// joint_E_L32    -> joint_E_L31
// joint_E_L33    -> joint_E_L32
// joint_E_R11
// joint_E_R12    -> joint_E_R11
// joint_E_R13    -> joint_E_R12
// joint_E_R21
// joint_E_R22    -> joint_E_R21
// joint_E_R23    -> joint_E_R22
// joint_E_R31
// joint_E_R32    -> joint_E_R31
// joint_E_R33    -> joint_E_R32

function Effect() {
    var self = this;

    this.meshes = [
        { file: "Earrings.bsm2", anims: [
            { a: "Take 001", t: 5333 },
        ] },
        { file: "Mask.bsm2", anims: [
            { a: "Take 001", t: 5000 },
        ] },
        { file: "face.bsm2", anims: [
            { a: "CINEMA_4D_Main", t: 1000 },
        ] },
    ];

    this.play = function() {
        var now = (new Date()).getTime();
        for(var i = 0; i < self.meshes.length; i++) {
            if(now > self.meshes[i].endTime) {
                self.meshes[i].animIdx = (self.meshes[i].animIdx + 1)%self.meshes[i].anims.length;
                Api.meshfxMsg("animOnce", i, 0, self.meshes[i].anims[self.meshes[i].animIdx].a);
                self.meshes[i].endTime = now + self.meshes[i].anims[self.meshes[i].animIdx].t;
            }
        }

        // if(isMouthOpen(world.landmarks, world.latents)) {
        //  Api.hideHint();
        // }
    };

    this.init = function() {
        Api.meshfxMsg("spawn", 3, 0, "!glfx_FACE");

        Api.meshfxMsg("spawn", 0, 0, "Earrings.bsm2");
        // Api.meshfxMsg("animOnce", 0, 0, "Take 001");

        Api.meshfxMsg("dynImass", 0, 0, "joint_E_L11");
        Api.meshfxMsg("dynImass", 0, 6, "joint_E_L12");
        Api.meshfxMsg("dynImass", 0, 5, "joint_E_L13");
        Api.meshfxMsg("dynImass", 0, 0, "joint_E_L21");
        Api.meshfxMsg("dynImass", 0, 6, "joint_E_L22");
        Api.meshfxMsg("dynImass", 0, 4, "joint_E_L23");
        Api.meshfxMsg("dynImass", 0, 0, "joint_E_L31");
        Api.meshfxMsg("dynImass", 0, 6, "joint_E_L32");
        Api.meshfxMsg("dynImass", 0, 4, "joint_E_L33");
        Api.meshfxMsg("dynImass", 0, 0, "joint_E_R11");
        Api.meshfxMsg("dynImass", 0, 6, "joint_E_R12");
        Api.meshfxMsg("dynImass", 0, 5, "joint_E_R13");
        Api.meshfxMsg("dynImass", 0, 0, "joint_E_R21");
        Api.meshfxMsg("dynImass", 0, 6, "joint_E_R22");
        Api.meshfxMsg("dynImass", 0, 4, "joint_E_R23");
        Api.meshfxMsg("dynImass", 0, 0, "joint_E_R31");
        Api.meshfxMsg("dynImass", 0, 6, "joint_E_R32");
        Api.meshfxMsg("dynImass", 0, 3, "joint_E_R33");

        Api.meshfxMsg("dynGravity", 0, 0, "0 -1500 0");
        Api.meshfxMsg("dynSphere", 0, 0, "0 0 0 1");

        Api.meshfxMsg("spawn", 1, 0, "Mask.bsm2");
        // Api.meshfxMsg("animOnce", 1, 0, "Take 001");

        Api.meshfxMsg("spawn", 2, 0, "face.bsm2");
        // Api.meshfxMsg("animOnce", 2, 0, "CINEMA_4D_Main");
        Api.playVideo("foreground",true,1);
        
        self.faceActions = [self.play];
        // Enable background audio playback
        Api.playSound("music.ogg", true, 1);
        // Api.showHint("Open mouth");

        Api.showRecordButton();
    };

    this.restart = function() {
        Api.meshfxReset();
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