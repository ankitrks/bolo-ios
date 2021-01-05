var drawSize = {};
var drawScaled = {};
var viewSize = {};
var aspect;
var drawAspect;
var coef;
var gIndex = 0;

function Effect() {

    var timer = new Date().getTime();
    var delay = 3000;

    this.hideHint = function() {
        var now = new Date().getTime();

        if (now >= timer + delay) {
                Api.hideHint();
                var index = self.faceActions.indexOf(self.hideHint);
                self.faceActions.splice(index, 1);
        }
    };

	this.init = function () {
		Api.meshfxMsg("spawn", 9, 0, "!glfx_FACE");
		Api.meshfxMsg("spawn", 1, 0, "tri2.bsm2");
		Api.meshfxMsg("spawn", 2, 0, "tri3.bsm2");
		Api.meshfxMsg("spawn", 3, 0, "Rayban_glasses.bsm2");
		Api.meshfxMsg("spawn", 4, 0, "Rayban_2_glasses.bsm2");
		Api.meshfxMsg("spawn", 7, 0, "cut_2.bsm2");
		Api.meshfxMsg("spawn", 8, 0, "cut_1.bsm2");
		Api.showHint('Swipe to right/left');
		//self.faceActions.push(self.hideHint);
		
		Api.meshfxMsg( "shaderVec4", 0, 0, "0.5 0.0 0.0 0.0");
		Api.playSound("music.ogg", true, 1);
	};

	this.restart = function () {};

	this.faceActions = [];
	this.noFaceActions = [];

	this.videoRecordStartActions = [];
	this.videoRecordFinishActions = [];
	this.videoRecordDiscardActions = [];
}
function coeffUpdate() {
	if (Api.getPlatform() == "macOS") {
			drawSize.x = 720;
			drawSize.y = 1280;

			viewSize.x = 720;
			viewSize.y = 1280;
	} else {
			drawSize.x = Api.drawingAreaWidth();
			drawSize.y = Api.drawingAreaHeight();

			viewSize.x = Api.visibleAreaWidth();
			viewSize.y = Api.visibleAreaHeight();
	}
	drawAspect = drawSize.x / drawSize.y;
	viewAspect = viewSize.x / viewSize.y;

	if (viewAspect < drawAspect) {
			coef = viewAspect / drawAspect;
	} else if (viewAspect > drawAspect) {
			coef = drawAspect / viewAspect;
	} else {
			coef = 1;
	}
}


function onTouchesBegan(touches) {
	coeffUpdate();

	var x = touches[0].x;

	if (viewAspect < drawAspect) {
		x *= coef;
	} 

	x *= 0.5;
	x += 0.5;

	Api.hideHint();
	Api.meshfxMsg( "shaderVec4", 0, 0, x + " 0.0 0.0 0.0");
}

function onTouchesMoved(touches) {
	coeffUpdate();
	
	var x = touches[0].x;

	if (viewAspect < drawAspect) {
		x *= coef;
	} 

	x *= 0.5;
	x += 0.5;

	Api.meshfxMsg( "shaderVec4", 0, 0, x + " 0.0 0.0 0.0");
}

configure(new Effect());