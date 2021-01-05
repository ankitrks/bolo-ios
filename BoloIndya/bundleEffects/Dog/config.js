
function Effect() {
	var self = this;

	this.tonguePlay = function() {
		var now = (new Date()).getTime();
		if( now > self.tongueT && isMouthOpen(world.landmarks, world.latents) ) {
			Api.meshfxMsg("animOnce", 2, 0, "start");
			self.tongueT = now + 1800;
		}
	};

	this.init = function() {
		Api.meshfxMsg("spawn",    3, 0, "!glfx_FACE");
		Api.meshfxMsg("spawn",    2, 0, "tongue_red.bsm2");
		Api.meshfxMsg("spawn",    0, 0, "ear_red_anim.bsm2");
		Api.meshfxMsg("animOnce", 0, 0, "start");
		Api.meshfxMsg("spawn",    1, 0, "nose_red.bsm2");
		Api.meshfxMsg("animOnce", 1, 0, "start");

		timeOut(1433, function(){
			Api.meshfxMsg("spawn", 0, 0, "ear_red_no_anim.bsm2");
			var flex = 80;

			Api.meshfxMsg("dynImass", 0, 0, "BoneEar_left01");
			Api.meshfxMsg("dynImass", 0, 0, "BoneEar_left02");
		
			Api.meshfxMsg("dynConstraint", 0, flex, "BoneEar_left01 BoneEar_left03");
			Api.meshfxMsg("dynConstraint", 0, flex, "BoneEar_left02 BoneEar_left04");
			Api.meshfxMsg("dynConstraint", 0, flex, "BoneEar_left03 BoneEar_left05");
			Api.meshfxMsg("dynConstraint", 0, flex, "BoneEar_left04 BoneEar_left06");
			Api.meshfxMsg("dynConstraint", 0, flex, "BoneEar_left05 BoneEar_left07");

			Api.meshfxMsg("dynImass", 0, 0, "BoneEar_right01");
			Api.meshfxMsg("dynImass", 0, 0, "BoneEar_right02");
		
			Api.meshfxMsg("dynConstraint", 0, flex, "BoneEar_right01 BoneEar_right03");
			Api.meshfxMsg("dynConstraint", 0, flex, "BoneEar_right02 BoneEar_right04");
			Api.meshfxMsg("dynConstraint", 0, flex, "BoneEar_right03 BoneEar_right05");
			Api.meshfxMsg("dynConstraint", 0, flex, "BoneEar_right04 BoneEar_right06");
			Api.meshfxMsg("dynConstraint", 0, flex, "BoneEar_right05 BoneEar_right07");

			Api.meshfxMsg("dynSphere", 0, 0, "0 30 5 90");

			Api.meshfxMsg("dynGravity", 0, 0, "0 -1000 0");
			Api.meshfxMsg("dynDamping", 0, 96);

			timeOut(1100, function(){self.faceActions.push(self.tonguePlay);}); 
		});

		self.t = (new Date()).getTime();

		self.tongueT = 0;

		Api.showRecordButton();
	};

	this.onVideoStartAction = function() {
		Api.meshfxReset();
		self.init();
	};

	this.onVideoDiscardAction = function() {
		Api.meshfxReset();
		self.init();
	};

	this.faceActions = [];
	this.noFaceActions = [];

	this.videoRecordStartActions = [this.onVideoStartAction];
	this.videoRecordFinishActions = [];
	this.videoRecordDiscardActions = [this.onVideoDiscardAction];
}

configure(new Effect());

function timeOut(delay, callback) {
	var timer = new Date().getTime();

	effect.faceActions.push(removeAfterTimeOut);
	effect.noFaceActions.push(removeAfterTimeOut);

	function removeAfterTimeOut() {
		var now = new Date().getTime();

		if (now >= timer + delay) {
			var idx = effect.faceActions.indexOf(removeAfterTimeOut);
			effect.faceActions.splice(idx, 1);
			idx = effect.noFaceActions.indexOf(removeAfterTimeOut);
			effect.noFaceActions.splice(idx, 1);
			callback();
		}
	}
}