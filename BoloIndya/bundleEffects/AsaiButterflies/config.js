
function Effect() {
	var self = this;


	this.play = function() {
		var now = (new Date()).getTime();
		if(now > self.t) {
			Api.meshfxMsg("animOnce", 0, 0, "CINEMA_4D_Main");
			Api.meshfxMsg("animOnce", 1, 0, "CINEMA_4D_Main");
			Api.stopVideo("frx");
			Api.playVideo("frx",false,1);
			Api.stopVideo("background");
			Api.playVideo("background",false,1);
			self.t = now + 9000;
		}
	};

	this.init = function() {
		Api.meshfxMsg("spawn", 2, 0, "!glfx_FACE");

		Api.meshfxMsg("spawn", 0, 0, "but_1.bsm2");
		Api.meshfxMsg("spawn", 1, 0, "but_2.bsm2");
		
		self.faceActions = [self.play];
		Api.playSound("ButterflyBGM.ogg", true, 1);

		self.t = 0;


		Api.showRecordButton();
	};

	this.restart = function() {
		Api.meshfxReset();
		Api.stopVideo("frx");
		Api.stopVideo("background");
		Api.stopSound("ButterflyBGM.ogg");
		self.init();
	};

	this.faceActions = [];
	this.noFaceActions = [];

	this.videoRecordStartActions = [this.restart];
	this.videoRecordFinishActions = [];
	this.videoRecordDiscardActions = [this.restart];
}

configure(new Effect());
