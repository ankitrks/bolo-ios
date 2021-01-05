// Root
// Joint_1	-> Root
// Joint_2	-> Joint_1
// glasses
// Joint_3	-> Joint_2
// Joint_4	-> Joint_3
function Effect() {
    var self = this;
    this.play = function() {
        now = (new Date()).getTime();
        if (now > self.time) {
            Api.hideHint();
            self.faceActions = [];
        }
        if(isMouthOpen(world.landmarks,world.latents)) {
            Api.hideHint();
            self.faceActions = [];
        };
    };

    this.init = function() {
        Api.meshfxMsg("spawn", 2, 0, "!glfx_FACE");

        Api.meshfxMsg("spawn", 0, 0, "TrollGrandson.bsm2");
        // Api.meshfxMsg("animOnce", 0, 0, "CINEMA_4D_Main");

        Api.meshfxMsg("spawn", 1, 0, "Trollson_morphing.bsm2");
        // Api.meshfxMsg("animOnce", 1, 0, "CINEMA_4D_Main");

        Api.meshfxMsg("dynImass", 0, 0, "Root");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_1");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_2");
        Api.meshfxMsg("dynImass", 0, 0, "glasses");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_3");
        Api.meshfxMsg("dynImass", 0, 0, "Joint_4");
        //Api.meshfxMsg("dynGravity", 0, 0, "0 -100 0");

        if(Api.getPlatform() == "ios"){
            Api.showHint("Voice changer");
        };
        self.time = (new Date()).getTime() + 3000;
        self.faceActions = [self.play];
        Api.playSound("music.ogg",true,1);

        Api.showRecordButton();
    };

    this.restart = function() {
        Api.meshfxReset();
        self.init();
    };
    this.stopSound = function () {
        if(Api.getPlatform() == "ios") {
            Api.hideHint();
            Api.stopSound("music.ogg");                  
        };
    };

    this.faceActions = [];
    this.noFaceActions = [];

    this.videoRecordStartActions = [self.stopSound];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [this.restart];
}

configure(new Effect());