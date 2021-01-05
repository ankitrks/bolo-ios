var MOUTH_COEFFICENT = 2.0;

function mouthOpenAmount(landmarks, latents) {
    var latentsOffset = 0;
    var indicator = 0.0;
    if (latents[latentsOffset + 0] > 0 && latents[latentsOffset + 2] > 0) {
        indicator = Math.min(0.14 * latents[latentsOffset + 0] * latents[latentsOffset + 2], 1);
    }
    return indicator;
}

function Effect() {
    var self = this;

    this.play = function () {
        var mouth = mouthOpenAmount(world.landmarks, world.latents);
        if (mouth > 0.5) {
            Api.hideHint();
        }
        Api.meshfxMsg("shaderVec4", 1, 0, String(mouth * MOUTH_COEFFICENT + 1.0));
    };

    this.init = function () {
        Api.meshfxMsg("spawn", 2, 0, "!glfx_FACE");

        Api.meshfxMsg("spawn", 0, 0, "face.bsm2");
        // Api.meshfxMsg("animOnce", 0, 0, "static");

        Api.meshfxMsg("spawn", 1, 0, "mount.bsm2");
        // Api.meshfxMsg("animOnce", 1, 0, "static");
        Api.showHint("Open Mouth");


        self.faceActions = [self.play];
        // Api.showHint("Open mouth");
        // Api.playVideo("frx",true,1);
        // Api.playSound("sfx.aac",false,1);
        Api.showRecordButton();
    };

    this.faceActions = [];
    this.noFaceActions = [];

    this.videoRecordStartActions = [];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [];
}

configure(new Effect());