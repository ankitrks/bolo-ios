
function Effect() {
	var self = this;

	/*
	this.meshes = [
		{ file:"jaw.bsm2", anims:[
			{ a:"start", t:2500 },
		] },

	];
	*/

	this.waitEnd = function() {
		if( (new Date()).getTime() > self.waitTime ) {
			Api.meshfxMsg( "del", 0 );
			self.faceActions = [];
		}
	};

	this.init = function() {
		Api.showRecordButton();
		Api.meshfxMsg("spawn", 0, 0, "jaw.bsm2");
		Api.meshfxMsg("animOnce", 0, 0, "start");

		self.waitTime = (new Date()).getTime() + 2500;
	};

	this.onVideoStartAction = function() {
		Api.meshfxReset();
		self.init();
	};

	this.onVideoDiscardAction = function() {
		Api.meshfxReset();
	};

	this.faceActions = [this.waitEnd];
	this.noFaceActions = [];

	this.videoRecordStartActions = [this.onVideoStartAction];
	this.videoRecordFinishActions = [];
	this.videoRecordDiscardActions = [this.onVideoDiscardAction];
}

configure(new Effect());
