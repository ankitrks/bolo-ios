// Point009
// Dummy001
// Point002	-> Point009
// Point013
// Point011
// Point008
// Point014
// Point012
// root_R_lock
// root_L_lock
// CATRigtail_L_1	-> root_L_lock
// CATRigtail_L_2	-> CATRigtail_L_1
// CATRigtail_L_3	-> CATRigtail_L_2
// CATRigtail_R_1	-> root_R_lock
// CATRigtail_R_2	-> CATRigtail_R_1
// CATRigtail_R_3	-> CATRigtail_R_2
// Point003	-> Point002
// Point006	-> Point013
// Point004	-> Point011
// Point001	-> Point008
// Point007	-> Point014
// Point005	-> Point012

var settings = {
	effectName: "1001NightsUpd"
};

var spendTime = 0;
var analytic = {
	spendTimeSec: 0
};

function sendAnalyticsData() {
	var _analytic;
	analytic.spendTimeSec = Math.round(spendTime / 1000);
	_analytic = {
		"Event Name": "Effects Stats",
		"Effect Name": settings.effectName,
        "Spend Time": String(analytic.spendTimeSec),
	};
	Api.print("sended analytic: " + JSON.stringify(_analytic));
	Api.effectEvent("analytic", _analytic);
}

function timeUpdate() {
    if (effect.lastTime === undefined) effect.lastTime = (new Date()).getTime();

    var now = (new Date()).getTime();
    effect.delta = now - effect.lastTime;
    if (effect.delta < 3000) { // dont count spend time if application is minimized
        spendTime += effect.delta;
    }
    effect.lastTime = now;
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

    this.init = function() {
        Api.meshfxMsg("spawn", 3, 0, "!glfx_FACE");
        Api.meshfxMsg("spawn", 0, 0, "BeautyFaceSP_Optimased.bsm2");
        Api.meshfxMsg("spawn", 1, 0, "mod.bsm2");
        Api.meshfxMsg("spawn", 2, 0, "mod_physics.bsm2");
        Api.playSound("1001Night_music_L_Channel.ogg", true, 1);
        Api.showRecordButton();

        Api.meshfxMsg("dynImass", 2, 10, "Point009");
        Api.meshfxMsg("dynImass", 2, 0, "Dummy001");
        Api.meshfxMsg("dynImass", 2, 10, "Point002");
        Api.meshfxMsg("dynImass", 2, 10, "Point013");
        Api.meshfxMsg("dynImass", 2, 10, "Point011");
        Api.meshfxMsg("dynImass", 2, 10, "Point008");
        Api.meshfxMsg("dynImass", 2, 10, "Point014");
        Api.meshfxMsg("dynImass", 2, 10, "Point012");
        Api.meshfxMsg("dynImass", 2, 10, "root_R_lock");
        Api.meshfxMsg("dynImass", 2, 10, "root_L_lock");
        Api.meshfxMsg("dynImass", 2, 10, "CATRigtail_L_1");
        Api.meshfxMsg("dynImass", 2, 10, "CATRigtail_L_2");
        Api.meshfxMsg("dynImass", 2, 10, "CATRigtail_R_1");
        Api.meshfxMsg("dynImass", 2, 10, "CATRigtail_R_2");
        Api.meshfxMsg("dynImass", 2, 10, "Point003");
        Api.meshfxMsg("dynImass", 2, 10, "Point006");
        Api.meshfxMsg("dynImass", 2, 10, "Point004");
        Api.meshfxMsg("dynImass", 2, 10, "Point001");
        Api.meshfxMsg("dynImass", 2, 10, "Point007");
        Api.meshfxMsg("dynImass", 2, 10, "Point005");    

        Api.meshfxMsg("dynGravity", 2, 0, "0 -700 0");
        Api.meshfxMsg("dynSphere", 2, 0, "0 20 -3 100");
        Api.meshfxMsg("dynSphere", 2, 1, "0 -60 -5 87");
    };

    this.restart = function() {
        Api.meshfxReset();
        Api.stopSound("1001Night_music_L_Channel.ogg");
        self.init();
    };

    this.faceActions = [timeUpdate];
    this.noFaceActions = [timeUpdate];

    this.videoRecordStartActions = [];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [this.restart];
}

var effect = new Effect();

configure(effect);