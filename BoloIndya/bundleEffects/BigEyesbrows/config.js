var isTexChanged = false;

var settings = {
    effectName: "BigEyesbrows"
};

var spendTime = 0;

var analytic = {
    spendTimeSec: 0,
    taps: 0
};

function sendAnalyticsData() {
    var _analytic;
    analytic.spendTimeSec = Math.round(spendTime / 1000);
    _analytic = {
        'Event Name': 'Effects Stats',
        'Effect Name': settings.effectName,
        'Effect Action': 'Tap', // or 'Swipe'
        'Action Count': String(analytic.taps),
        'Spend Time': String(analytic.spendTimeSec)
    };
    Api.print('sended analytic: ' + JSON.stringify(_analytic));
    Api.effectEvent('analytic', _analytic);
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

function onTouchesBegan(touches) {
    analytic.taps++;
    if (!isTexChanged){
        isTexChanged = true;
        Api.meshfxMsg("tex", 3, 0, "Brows2_BaseColor.png");
        Api.meshfxMsg("tex", 2, 0, "Brows2_BaseColor.png");
    } else {
        isTexChanged = false;
        Api.meshfxMsg("tex", 3, 0, "Brows_BaseColor.png");
        Api.meshfxMsg("tex", 2, 0, "Brows_BaseColor.png");
    }
}

function Effect() {
    var self = this;


    this.init = function() {
        Api.meshfxMsg("spawn", 4, 0, "!glfx_FACE");
        Api.meshfxMsg("spawn", 5, 0, "plane.bsm2");

        Api.meshfxMsg("spawn", 0, 0, "BigEyesbrows.bsm2");

        Api.meshfxMsg("spawn", 2, 0, "Brows.bsm2");
        Api.meshfxMsg("tex", 2, 0, "Brows_BaseColor.png");

        Api.meshfxMsg("spawn", 3, 0, "Brows2.bsm2");
        Api.meshfxMsg("tex", 3, 0, "Brows_BaseColor.png");

        Api.meshfxMsg("dynGravity", 2, 0, "-100 200 0");
        Api.meshfxMsg("dynDamping", 2, 90);
        Api.meshfxMsg("dynImass", 2,  0, "CATRigHub001");

        Api.meshfxMsg("dynImass", 2,  0, "Left100");
        Api.meshfxMsg("dynImass", 2,  7, "Left101");
        Api.meshfxMsg("dynImass", 2,  10, "Left102");
        Api.meshfxMsg("dynImass", 2,  10, "Left103");


        Api.meshfxMsg("dynGravity", 3, 0, "100 200 0");
        Api.meshfxMsg("dynDamping", 3, 90);
        Api.meshfxMsg("dynImass", 3,  0, "CATRigHub002");

        Api.meshfxMsg("dynImass", 3,  0, "Left104");
        Api.meshfxMsg("dynImass", 3,  7, "Left105");
        Api.meshfxMsg("dynImass", 3,  10, "Left106");
        Api.meshfxMsg("dynImass", 3,  10, "Left107");

        Api.playVideo("frx", true, 1);

        timeOut(3000, function(){Api.meshfxMsg("del", 5);});

        Api.showRecordButton();
    };

    this.restart = function() {
        Api.meshfxReset();
        self.init();
    };

    this.delVideo = function() {
        Api.meshfxMsg("del", 5);
    };

    this.timeUpdate = function () { 
        if (self.lastTime === undefined) self.lastTime = (new Date()).getTime();
    
        var now = (new Date()).getTime();
        self.delta = now - self.lastTime;
        if (self.delta < 3000) { // dont count spend time if application is minimized
            spendTime += self.delta;
        }
        self.lastTime = now;
    };
    
    this.faceActions = [this.timeUpdate];
    this.noFaceActions = [this.timeUpdate];

    this.videoRecordStartActions = [this.delVideo];
    this.videoRecordFinishActions = [this.delVideo];
    this.videoRecordDiscardActions = [this.restart];
}

configure(new Effect());

function onTakePhoto() {
    Api.meshfxMsg("del", 5);
}

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