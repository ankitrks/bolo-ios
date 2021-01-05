var settings = {
    "effectName": "LiquidSunglasses2"
};

var analytic = {
    "taps": 0.0
};

function sendAnalyticsData() {
	var _analytic;
	
       _analytic = {
           "Effect Action": "Tap",
           "Action Count": analytic.taps
       };

	Api.print("sended analytic: " + JSON.stringify(_analytic));
	Api.effectEvent("analytic", _analytic);
}


function onStop() {
	try {
		sendAnalyticsData();
	} catch (err) {
		Api.print(err);
	}
}

function onFinish() {
	try {
		sendAnalyticsData();
	} catch (err) {
		Api.print(err);
	}
}
function Effect() {
    var self = this;

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
    
    this.init = function() {
        Api.meshfxMsg("spawn", 3, 0, "!glfx_FACE");
        Api.meshfxMsg("spawn", 4, 0, "BeautyFaceSP_Optimased.bsm2");
        Api.meshfxMsg("spawn", 5, 0, "glasses.bsm2");
        Api.meshfxMsg("spawn", 0, 0, "tri1.bsm2");
        Api.meshfxMsg("spawn", 1, 0, "tri1.bsm2");
        
		var resolution;
		
		if (Api.getPlatform().toLowerCase != 'macos') {
			resolution = Api.visibleAreaWidth();
		} else {
			resolution = 960;
		}

		Api.meshfxMsg( "tex", 0, 0, texturesToChange[0].from);
		Api.meshfxMsg( "tex", 1, 0, texturesToChange[0].to);
		Api.meshfxMsg( "shaderVec4", 0, 0, "1.0 0.0 0.0 0.0");
		Api.meshfxMsg( "shaderVec4", 0, 1, "0.0 0.0 0.0 0.0");

		Api.showHint('Tap');
		self.faceActions.push(self.hideHint);

        Api.playVideo("frx",true ,1);
        // timeout(this, 14000, function() {
        //     Api.playVideoRange("frx", 7,  14, true, 1);
        // });
        Api.playSound("music.ogg", true, 1);
        Api.playVideo("foreground",true,1);
        Api.showRecordButton();
    };

    this.restart = function() {
        Api.meshfxReset();
        Api.stopVideo("frx");
        Api.stopSound("music.ogg");
        self.init();
    };

    this.faceActions = [];
    this.noFaceActions = [];

    this.videoRecordStartActions = [];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [this.restart];
}


var blueOpacity = 1.0;
var pinkOpacity = 0.0;

var effect = new Effect();

var isBlue = true;
var isChanged = false;

var texturesToChange = [
	{from: "lut_1.png", to: "lut_2.png"}
];

var counter = -1;


function onTouchesBegan(params) {
	analytic.taps++;

	Api.hideHint();
	if (!isChanged) {
		counter = counter + 1 >= texturesToChange.length ? 0 : counter + 1;
		effect.faceActions.push(changeLut());
	}
}

function changeLut() {
	var maxOpacity = 1, minOpacity = 0;

	var deltaList = [16, 16, 16, 16, 16];
  	var lastTime = new Date().getTime();

	isChanged = true;
	return function() {
		var now = new Date().getTime();
		var deltaTime = now - lastTime;
		lastTime = now;
		
		deltaList.shift();
		deltaList.push(deltaTime);

		var delta = average(deltaList);

		maxOpacity -= 1 * delta / 500;
		minOpacity += 1 * delta / 500;

		if (isBlue) {
			Api.meshfxMsg( "shaderVec4", 0, 0, maxOpacity + " 0.0 0.0 0.0");
			Api.meshfxMsg( "shaderVec4", 0, 1, minOpacity + "0.0 0.0 0.0");
		} else {
			Api.meshfxMsg( "shaderVec4", 0, 1, maxOpacity + " 0.0 0.0 0.0");
			Api.meshfxMsg( "shaderVec4", 0, 0, minOpacity + "0.0 0.0 0.0");
		}

		if (maxOpacity <= 0 || minOpacity >= 1) {
			maxOpacity = 0;
			minOpacity = 1;

			isBlue = !isBlue;

			var index = effect.faceActions.indexOf(effect.changeLut);
            effect.faceActions.splice(index, 1);

			isChanged = false;
		}
	};
}


function average(arr) {
	return arr.reduce(function(last, curr) {
		return curr + last;
	}) / arr.length;
}


function timeout(effcet, delay, callback) {
    var timer = new Date().getTime();
    effcet.faceActions.push(callbackTrigger);
    function callbackTrigger() {
        var now = new Date().getTime();
        
        if (now >= timer + delay) {
            callback(effect);
            var index = effcet.faceActions.indexOf(callbackTrigger);
            effcet.faceActions.splice(index, 1);
        }
    }
}
var effect  = new Effect;
configure(effect);