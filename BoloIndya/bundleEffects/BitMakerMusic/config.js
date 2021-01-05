var settings = {
  effectName: "BitMakerMusicA"
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

var state = false;
var isDone = false;

function Effect() {
    var self = this;
    this.meshes = [];
    var index = 0;
    this.queue = [];


    this.init = function () {
        Api.playVideoRange('frx', 0, 0.1, false, 1);
        Api.stopVideo('frx');
        Api.meshfxMsg("spawn", 11, 0, "!glfx_FACE");
        Api.meshfxMsg("spawn", 10, 0, "headphone.bsm2");
        // Api.meshfxMsg("spawn", 8, 0, "BeautyFaceSP_Optimased.bsm2");
        Api.meshfxMsg("spawn", 14, 0, "Cut.bsm2");
        Api.meshfxMsg("spawn", 1, 0, "tri.bsm2");
        Api.meshfxMsg("spawn", 13, 0, "plane.bsm2");

        timeOut(3000, function () {
            Api.meshfxMsg("del", 13);
            if (!self.state){
                Api.stopVideo("frx");
            }
        })

        // // Api.playSound('1.ogg', false, 1);
        var sprite1 = new Sprite(0, 0, 0, 'quad.bsm2', 'btn_blue_normal.png', 'btn_blue_over.png', '1.ogg', 0.01, 0.37, true);
        sprite1.scale(0.5, 0.255);
        sprite1.transform(-0.5, 0.74);
        var sprite2 = new Sprite(0, 0, 7, 'quad.bsm2', 'btn_green_normal.png', 'btn_green_over.png', '2.ogg', 0.37, 0.87, true);
        sprite2.scale(0.5, 0.255);
        sprite2.transform(-0.5, 0.23);
        var sprite3 = new Sprite(0, 0, 2, 'quad.bsm2', 'btn_orange_normal.png', 'btn_orange_over.png', '3.ogg', 0.87, 2.5, false);
        sprite3.scale(0.5, 0.255);
        sprite3.transform(-0.5, -0.28);
        var sprite4 = new Sprite(0, 0, 3, 'quad.bsm2', 'btn_pink_normal.png', 'btn_pink_over.png', '4.ogg', 2.5, 4.1, false);
        sprite4.scale(0.5, 0.255);
        sprite4.transform(0.5, 0.74);
        var sprite5 = new Sprite(0, 0, 4, 'quad.bsm2', 'btn_red_normal.png', 'btn_red_over.png', '5.ogg', 4.1, 5.42, false);
        sprite5.scale(0.5, 0.255);
        sprite5.transform(0.5, 0.23);
        var sprite6 = new Sprite(0, 0, 5, 'quad.bsm2', 'btn_yellow_normal.png', 'btn_yellow_over.png', '6.ogg', 5.42, 7.1, false);
        sprite6.scale(0.5, 0.255);
        sprite6.transform(0.5, -0.28);
        var sprite7 = new Sprite(0, 0, 6, 'quad3.bsm2', 'Black.png');
        sprite7.transform(0, 0, 1, 1, 0);

        this.buttons = [sprite1, sprite2, sprite3, sprite4, sprite5, sprite6];
        Api.playVideo('frx', true, 1);
        // Api.playSound("music.ogg", true, 1);
        Api.showRecordButton();
    };

    this.spawnVideo = function (){
        if(state && !isDone){
            var sprite8 = new Sprite(0, 0, 8, 'quad2.bsm2');
            sprite8.scale(1, 0.4);
            sprite8.transform(0, -0.6);
            isDone = true;
        }
    }

    this.timeUpdate = function () { 
        if (self.lastTime === undefined) self.lastTime = (new Date()).getTime();

        var now = (new Date()).getTime();
        self.delta = now - self.lastTime;
        if (self.delta < 3000) { // dont count spend time if application is minimized
            spendTime += self.delta;
        }
        self.lastTime = now;
    };

    this.restart = function () {
        Api.meshfxReset();
        self.init();
    };

    this.faceActions = [this.spawnVideo, this.timeUpdate];
    this.noFaceActions = [this.spawnVideo, this.timeUpdate];

    this.videoRecordStartActions = [];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [this.restart];
}


function Sprite(x, y, meshId, meshName, texNameNormal, texNameOver, soundName, start, stop, isDrum) {
    var self = this;

    this.x = x;
    this.y = y;
    this.width = 1;
    this.heigth = 1;
    this.angle = 0;
    this.isHold = false;

    this.id = meshId;
    this.meshName = meshName;
    this.isTriggered = false;
    this.isDrum = isDrum;

    if (soundName) {
        this.soundName = soundName;
    }

    if (texNameNormal) {
        this.textureNormal = texNameNormal;
    }

    if (texNameOver) {
        this.textureOver = texNameOver;
    }

    if (start) {
        this.start = start;
    }

    if (stop) {
        this.stop = stop;
    }

    if (start && stop) {
        this.delay = Math.abs(stop - start) * 1000;
    }

    this.transformIds = {
        translate: this.id,
        scale: this.id + 48,
        rotate: this.id + 48 * 2,
    };


    this.transform = function (trX, trY, scX, scY, rotateDeg) {
        this.translate(trX || 0.0, trY || 0.0);
        this.scale(scX || 1.0, scY || 1.0);
        this.rotate(rotateDeg || 0.0);
    };


    this.translate = function (x, y) {
        this.x = x;
        this.y = y;
        var str = _createString(this.x, this.y);
        Api.meshfxMsg('shaderVec4', 0, this.transformIds.translate, str);
    };


    this.scale = function (scaleX, scaleY) {
        this.width *= scaleX;
        this.heigth *= scaleY;
        var str = _createString(this.width, this.heigth);
        Api.meshfxMsg('shaderVec4', 0, this.transformIds.scale, str);
    };


    this.rotate = function (deg) {
        this.angle += deg;
        var radians = (Math.PI * this.angle) / 180;
        var sin = Math.sin(radians);
        var cos = Math.cos(radians);
        var str = _createString(cos, sin);

        Api.meshfxMsg('shaderVec4', 0, this.transformIds.rotate, str);
    };


    this.overTrigger = function () {
        if (this.soundName) {
            this.isHold = true;
            Api.playSound(this.soundName, false, 1);
            Api.stopVideo('frx');
            Api.playVideoRange('frx', this.start, this.stop, false, 1);
        }
    };

    this.outTrigger = function () {
        if (this.soundName) {
            if (!this.isDrum) {
                Api.stopSound(this.soundName);
            }
            this.isHold = false;
            Api.stopVideo('frx');
            this.updateTexture(this.textureNormal);
        }
    };


    this.updateTexture = function (textureName) {
        Api.meshfxMsg('tex', this.id, 0, textureName);
    };


    function _createString(val1, val2) {
        return String(val1) + ' ' + String(val2) + ' 0.0 1.0';
    }


    this.destruct = function () {
        Api.meshfxMsg('del', this.id);
    };

    Api.meshfxMsg('spawn', this.id, 0, this.meshName);
    if (this.textureNormal) {
        Api.meshfxMsg('tex', this.id, 0, this.textureNormal);
    }

    this.transform();
};


function Controller(effect) {
    var self = this;
    this.effect = effect;

    this.UI = {
        findButtonByTouchCoords: function (x, y, arrayOfButtons) {
            for (var i = 0; i < arrayOfButtons.length; i++) {
                var button = arrayOfButtons[i];

                var leftBottomVertex = {
                    x: button.x - button.width,
                    y: button.y - button.heigth
                };

                var leftTopVertex = {
                    x: button.x - button.width,
                    y: button.y + button.heigth
                };

                var RightBottomVertex = {
                    x: button.x + button.width,
                    y: button.y - button.heigth
                };

                if (
                    x >= leftBottomVertex.x && x <= RightBottomVertex.x &&
                    y >= leftBottomVertex.y && y <= leftTopVertex.y
                ) {
                    return button;
                }
            }
        },

        screenTap: function (touchX, touchY, arrayOfButtons, searchFunc) {
            var x = touchX;
            var y = touchY;

            self.drawViewCorrection.coeffUpdate();

            var viewAspect = self.drawViewCorrection.viewAspect;
            var drawAspect = self.drawViewCorrection.drawAspect;
            var coeff = self.drawViewCorrection.coeff;
            var button;
            if (viewAspect < drawAspect) {
                button = searchFunc(x * coeff, y, arrayOfButtons);
            } else if (viewAspect > drawAspect) {
                button = searchFunc(x, y * coeff, arrayOfButtons);
            } else {
                button = searchFunc(x, y, arrayOfButtons);
            }

            return button;
        },

        fillScreenColumnByButtons: function (
            offsetX, offsetY, step, spriteCount,
            scaleX, scaleY, rotateAngle,
            meshName, texName, lastMeshId
        ) {

            if (!self.effect.buttons) {
                self.effect.buttons = [];
            }

            var index = lastMeshId;
            var currX = 0 + offsetX;
            var currY = 0 + offsetY;

            for (var i = 0; i < spriteCount; i++) {
                var sprite = new Sprite(0, 0, index, meshName, texName);
                sprite.transform(currX, currY, scaleX, scaleY, rotateAngle);
                self.effect.buttons.push(sprite);
                currY -= step;
                index++;
            }
        }
    };

    this.drawViewCorrection = {
        drawSize: {},
        drawScaled: {},
        viewSize: {},
        drawAspect: 1,
        coeff: 1,

        coeffUpdate: function () {
            if (Api.getPlatform() == 'macOS') {
                this.drawSize.x = 720;
                this.drawSize.y = 1280;

                this.viewSize.x = 720;
                this.viewSize.y = 1280;
            } else {
                this.drawSize.x = Api.drawingAreaWidth();
                this.drawSize.y = Api.drawingAreaHeight();

                this.viewSize.x = Api.visibleAreaWidth();
                this.viewSize.y = Api.visibleAreaHeight();
            }

            this.drawAspect = this.drawSize.x / this.drawSize.y;
            this.viewAspect = this.viewSize.x / this.viewSize.y;

            if (this.viewAspect < this.drawAspect) {
                this.coeff = this.viewAspect / this.drawAspect;
            } else if (this.viewAspect > this.drawAspect) {
                this.coeff = this.drawAspect / this.viewAspect;
            } else {
                this.coeff = 1;
            }
        }
    };
}

if (!Array.prototype.find) {
    Array.prototype.find = function (predicate) {
        if (this == null) {
            throw new TypeError('Array.prototype.find called on null or undefined');
        }
        if (typeof predicate !== 'function') {
            throw new TypeError('predicate must be a function');
        }
        var list = Object(this);
        var length = list.length >>> 0;
        var thisArg = arguments[1];
        var value;

        for (var i = 0; i < length; i++) {
            value = list[i];
            if (predicate.call(thisArg, value, i, list)) {
                return value;
            }
        }
        return undefined;
    };
}

var effect = new Effect();
var controller = new Controller(effect);

// var currButton;

var activeButtons = [];

function onTouchesBegan(touches) {
    analytic.taps++;
    state = true;
    Api.playVideo("frx", 1 , true);
    Api.meshfxMsg("del", 13);
    Api.print("onTouchesBegan: " + JSON.stringify(touches, null, 4));
    spawnTouches(touches);
}

function spawnTouches(touches) {
    for (var i = 0; i < touches.length; i++) {
        var x = touches[i].x;
        var y = touches[i].y;

        var searchFunc = controller.UI.findButtonByTouchCoords;
        var currButton = controller.UI.screenTap(x, y, effect.buttons, searchFunc);

        if (currButton && !currButton.isHold) {
            currButton.touchId = touches[i].id;
            activeButtons.push(currButton);
            currButton.overFunction = hold(currButton);
            effect.noFaceActions.push(currButton.overFunction);
            effect.faceActions.push(currButton.overFunction);
        }
    }
}

function onTouchesMoved(touches, a) {
    // Api.print("IHJADHIOSADLJGASHLJDGAJLGDGJLADLGJAD");
}

function onTouchesEnded(touches) {
    Api.print("onTouchesEnded: " + JSON.stringify(touches, null, 4));
    removeTouches(touches);
}

function removeTouches(touches) {
    for (var i = 0; i < touches.length; i++) {
        var currButton = activeButtons.find(findFunction(i));
        if (currButton) {
            // Api.print(JSON.stringify(currButton));
            var btnIndex = activeButtons.indexOf(currButton);
            var overFunctionIndexes = [
                effect.faceActions.indexOf(currButton.overFunction),
                effect.noFaceActions.indexOf(currButton.overFunction)
            ];
            effect.faceActions.splice(overFunctionIndexes[0], 1);
            effect.noFaceActions.splice(overFunctionIndexes[1], 1);
            activeButtons.splice(btnIndex, 1);
            currButton.outTrigger();
            currButton.updateTexture(currButton.textureNormal);
        }
    }

    function findFunction(i) {
        return function (button) {
            return button.touchId === touches[i].id;
        };
    }
}


function onTouchesCancelled(touches) {
    removeTouches(touches);
}

function hold(button) {
    var timer = new Date().getTime();
    var delay = button.delay;
    Api.print(delay);
    button.overTrigger();
    button.updateTexture(button.textureOver);
    return function () {
        var now = new Date().getTime();
        if (now >= timer + delay) {
            button.overTrigger();
            timer = now;
        }
    };
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

configure(effect);