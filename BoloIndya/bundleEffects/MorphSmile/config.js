
function Effect() {
	var self = this;

	this.init = function() {
		Api.meshfxMsg("spawn", 0, 0, "!glfx_FACE");
		Api.showRecordButton();
	};

	this.faceActions = [];
	this.noFaceActions = [];

	this.videoRecordStartActions = [];
	this.videoRecordFinishActions = [];
	this.videoRecordDiscardActions = [];
}

configure(new Effect());
