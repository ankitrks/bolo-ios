function Effect() {
    var self = this;


    this.init = function() {
        Api.meshfxMsg("spawn", 2, 0, "!glfx_FACE");
        Api.meshfxMsg("spawn", 0, 0, "face.bsm2");
        Api.meshfxMsg("spawn", 1, 0, "mesh.bsm2");

        var resolution = {};
	
		if (Api.getPlatform() === 'macOS') {
			resolution.x = 720;
			resolution.y = 1280;
		} else {
			resolution.x = Api.drawingAreaWidth();
			resolution.y = Api.drawingAreaHeight();
		}

		Api.print(JSON.stringify(resolution));
        Api.meshfxMsg("shaderVec4", 0, 0, resolution.x + " " + resolution.y + " 0.0 0.0");
        
        Api.playSound("music.ogg", true, 1);
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