function Effect() {
    var self = this;
    var timer = new Date().getTime();
    var delay = 3000;

    this.hide = function() {
        var now = new Date().getTime();
        if(now >= timer + delay) {
            Api.hideHint();
            this.faceActions = [];
        }
    };

    this.init = function() {
        Api.meshfxMsg("spawn", 2, 0, "!glfx_FACE");
        Api.meshfxMsg("spawn", 0, 0, "2Dglasses.bsm2");
        Api.meshfxMsg("spawn", 1, 0, "morph.bsm2");
        Api.playSound("music.ogg", true, 1);
        if (Api.getPlatform().toLowerCase() == 'ios') {
            Api.showHint("Voice Changer");
        };

        Api.showRecordButton();
    };

    this.restart = function() {
        Api.meshfxReset();
        Api.stopSound("music.ogg");
        self.init();
        Api.hideHint();
    };

    this.stopSound = function() {
        if (Api.getPlatform().toLowerCase() == 'ios') {
            Api.stopSound("music.ogg");
        } 
        Api.hideHint(); 
    };

    this.faceActions = [this.hide];
    this.noFaceActions = [];

    this.videoRecordStartActions = [this.stopSound];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [this.restart];
}

configure(new Effect());