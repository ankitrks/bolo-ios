
function Effect() {
	var self = this;

	this.init = function() {
		Api.meshfxMsg("spawn", 3, 0, "!glfx_FACE");
		Api.meshfxMsg("spawn", 1, 0, "BeautyFaceSP_Optimased.bsm2");
		Api.meshfxMsg("spawn", 2, 0, "GlassDiamond.bsm2");
		Api.meshfxMsg("spawn", 0, 0, "Kaleidoscope_5.bsm2");
		Api.meshfxMsg("animLoop", 0, 0, "CINEMA_4D_Main");
		Api.playVideo("foreground",true,1);

		// Api.playVideo("frx",true,1);
		Api.playSound("music.ogg", true, 1);
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
