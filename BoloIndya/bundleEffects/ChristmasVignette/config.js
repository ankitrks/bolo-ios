function Effect() {
	var self = this;
	var trigger = false;
	var isTriggerUsed = false;
	//var timer = Number.MAX_VALUE;
	var introLength = 3966; //5966

	this.play = function() {
		var now = (new Date()).getTime();

		if (!isTriggerUsed && now < self.timer && isSmile(world.landmarks, world.latents)) { 
			Api.playVideoRange("foreground", 2.1, 5 + 29./30., false, 1);
			isTriggerUsed = true;
			//timer = now + 5967;
			Api.hideHint();
			self.timer = (new Date()).getTime() + introLength;
		}

		if (now > self.timer) {
			Api.playVideoRange("foreground", 5 + 29./30., 7 + 29./30., true, 1);
			//timer = Number.MAX_VALUE;
		}
	};

	this.init = function() {
		self.timer = (new Date()).getTime() + introLength;
		Api.meshfxMsg("spawn", 1, 0, "!glfx_FACE");
		Api.showHint("Smile");
		Api.playVideoRange("foreground",0, 2.1, true,1);
		Api.playSound("ChristmasVignettes_Music.ogg",true,1);

		self.faceActions = [self.play];
		Api.showRecordButton();
	};

	this.restart = function() {
		Api.meshfxReset();
		Api.stopVideo("foreground");
		trigger = false;
		isTriggerUsed = false;
		self.init();
	};

	this.faceActions = [];
	this.noFaceActions = [];

	this.videoRecordStartActions = [this.restart];
	this.videoRecordFinishActions = [];
	this.videoRecordDiscardActions = [this.restart];
}

configure(new Effect());
