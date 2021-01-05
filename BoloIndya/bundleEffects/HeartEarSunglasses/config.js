
function Effect() {
	var self = this;

	this.init = function() {
		Api.meshfxMsg("spawn", 1, 0, "!glfx_FACE");
		Api.meshfxMsg("spawn", 0, 0, "HeartEarSunglasses.bsm2");
		Api.playSound("25music_3.ogg", true, 1);
		Api.playVideo("frx",true,1);
		Api.playVideo("backgroundSeparation", true, 1);
		Api.showRecordButton();
	};

	this.restart = function() {
		Api.meshfxReset();
		self.init();
	};

	this.faceActions = [];
	this.noFaceActions = [];

	this.videoRecordStartActions = [];
	this.videoRecordFinishActions = [];
	this.videoRecordDiscardActions = [this.restart];
}

configure(new Effect());
