/*
    MochiAds.com ActionScript 3 code, version 1.5

    Flash movies should be published for Flash 9 or later.

    Copyright (C) 2006-2007 Mochi Media, Inc. All rights reserved.
*/

package {
    import flash.system.Security;
    import flash.display.MovieClip;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.LocalConnection;
    import flash.utils.getTimer;
    
    public class MochiAd {

        public static function getVersion():String {
            return "1.5";
        }

        public static function doOnEnterFrame(mc:MovieClip):void {
            var f:Function = function (ev:Object):void {
                if ('onEnterFrame' in mc && mc.onEnterFrame) {
                    mc.onEnterFrame();
                } else {
                    mc.removeEventListener(Event.ENTER_FRAME, f);
                }
                
            }
            mc.addEventListener(Event.ENTER_FRAME, f);
        }
                
        public static function createEmptyMovieClip(parent:Object, name:String, depth:Number):MovieClip {
            var mc:MovieClip = new MovieClip();
            if (false && depth) {
                parent.addChildAt(mc, depth);
            } else {
                parent.addChild(mc);
            }
            parent[name] = mc;
            mc["_name"] = name;
            return mc;
        }
        
        public static function showPreloaderAd(options:Object):void {
            /*
                This function will stop the clip, load the MochiAd in a
                centered position on the clip, and then resume the clip
                after a timeout or when this movie is loaded, whichever
                comes first.

                options:
                    An object with keys and values to pass to the server.
                    These options will be passed to MochiAd.load, but the
                    following options are unique to showPreloaderAd.

                    clip is a MovieClip reference to place the ad in.
                    clip must be dynamic.

                    ad_timeout is the number of milliseconds to wait
                    for the ad to start loading (default: 2000).

                    color is the color of the preloader bar
                    as a number (default: 0xFF8A00)

                    background is the inside color of the preloader
                    bar as a number (default: 0xFFFFC9)

                    outline is the outline color of the preloader
                    bar as a number (default: 0xD58B3C)

                    fadeout_time is the number of milliseconds to
                    fade out the ad upon completion (default: 250).

                    ad_started is the function to call when the ad
                    has started (may not get called if network down)
                    (default: function ():void { this.clip.stop() }).

                    ad_finished is the function to call when the ad
                    has finished or could not load
                    (default: function ():void { this.clip.play() }).
            */
            var DEFAULTS:Object = {
                ad_timeout: 3000,
                fadeout_time: 250,
                regpt: "o",
                method: "showPreloaderAd",
                color: 0xFF8A00,
                background: 0xFFFFC9,
                outline: 0xD58B3C,
                ad_started: function ():void { this.clip.stop(); },
                ad_finished: function ():void { this.clip.play(); }
            };

            options = MochiAd._parseOptions(options, DEFAULTS);

            var clip:Object = options.clip;
            var ad_msec:Number = 11000;
            var ad_timeout:Number = options.ad_timeout;
            delete options.ad_timeout;
            var fadeout_time:Number = options.fadeout_time;
            delete options.fadeout_time;

            if (!MochiAd.load(options)) {
                options.ad_finished();
                return;
            }

            options.ad_started();

            var mc:MovieClip = clip._mochiad;
            mc["onUnload"] = function ():void {
                options.ad_finished();
            }
            

            /* Center the clip */
            
            var wh:Array = MochiAd._getRes(options, clip);
            
            var w:Number = wh[0];
            var h:Number = wh[1];
            mc.x = w * 0.5;
            mc.y = h * 0.5;
        
            var chk:MovieClip = createEmptyMovieClip(mc, "_mochiad_wait", 3);
            chk.x = w * -0.5;
            chk.y = h * -0.5;

            var bar:MovieClip = createEmptyMovieClip(chk, "_mochiad_bar", 4);
            bar.x = 10;
            bar.y = h - 20;

            var bar_color:Number = options.color;
            delete options.color;
            var bar_background:Number = options.background;
            delete options.background;
            var bar_outline:Number = options.outline;
            delete options.outline;

            var backing_mc:MovieClip = createEmptyMovieClip(bar, "_outline", 1);
            var backing:Object = backing_mc.graphics;

            backing.beginFill(bar_background);
            backing.moveTo(0, 0);
            backing.lineTo(w - 20, 0);
            backing.lineTo(w - 20, 10);
            backing.lineTo(0, 10);
            backing.lineTo(0, 0);
            backing.endFill();
            
            var inside_mc:MovieClip = createEmptyMovieClip(bar, "_inside", 2);
            var inside:Object = inside_mc.graphics;
            inside.beginFill(bar_color);
            inside.moveTo(0, 0);
            inside.lineTo(w - 20, 0);
            inside.lineTo(w - 20, 10);
            inside.lineTo(0, 10);
            inside.lineTo(0, 0);
            inside.endFill();
            inside_mc.scaleX = 0;

            var outline_mc:MovieClip = createEmptyMovieClip(bar, "_outline", 3);
            var outline:Object = outline_mc.graphics;
            outline.lineStyle(0, bar_outline, 100);
            outline.moveTo(0, 0);
            outline.lineTo(w - 20, 0);
            outline.lineTo(w - 20, 10);
            outline.lineTo(0, 10);
            outline.lineTo(0, 0);

            chk.ad_msec = ad_msec;
            chk.ad_timeout = ad_timeout;
            chk.started = getTimer();
            chk.showing = false;
            chk.last_pcnt = 0.0;
            chk.fadeout_time = fadeout_time;

            chk.fadeFunction = function ():void {
                var p:Number = 100 * (1 - 
                    ((getTimer() - this.fadeout_start) / this.fadeout_time));
                
                if (p > 0) {
                    this.parent.alpha = p * 0.01;
                } else {
                    var _clip:MovieClip = this.parent.parent;
                    MochiAd.unload(_clip);
                    delete this["onEnterFrame"];
                }
            };

            mc.unloadAd = function ():void {
                MochiAd.unload(clip);
            }

            mc.adjustProgress = function (msec:Number):void {
                var _chk:Object = mc._mochiad_wait;
                _chk.server_control = true;
                _chk.started = getTimer();
                _chk.ad_msec = msec;
            };

            chk["onEnterFrame"] = function ():void {
                var _clip:Object = this.parent.parent.root;
				if (!_clip) {
					delete this["onEnterFrame"];
					return;
				}
                var ad_clip:Object = this.parent._mochiad_ctr;
                var elapsed:Number = getTimer() - this.started;
                var finished:Boolean = false;
                var clip_total:Number = _clip.loaderInfo.bytesTotal;
                var clip_loaded:Number = _clip.loaderInfo.bytesLoaded;
                var clip_pcnt:Number = (100.0 * clip_loaded) / clip_total;
                var ad_pcnt:Number = (100.0 * elapsed) / chk.ad_msec;
                var _inside:Object = this._mochiad_bar._inside;
                var pcnt:Number = Math.min(100.0, Math.min((clip_pcnt || 0.0), ad_pcnt));
                pcnt = Math.max(this.last_pcnt, pcnt);
                this.last_pcnt = pcnt;
                _inside.scaleX = pcnt * 0.01;
            
                if (!chk.showing) {
                    var total:Number = ad_clip.loaderInfo.bytesTotal;
                    if (total > 0 || typeof(total) == "undefined") {
                        chk.showing = true;
                        chk.started = getTimer();
                    } else if (elapsed > chk.ad_timeout) {
                        finished = true;
                    }
                }
                if (elapsed > chk.ad_msec || this.parent._mochiad_ctr_failed) {
                    finished = true;
                }
                if (clip_total > 0 && clip_loaded >= clip_total && finished) {
                    if (this.server_control) {
                        delete this.onEnterFrame;
                    } else {
                        this.fadeout_start = getTimer();
                        this.onEnterFrame = chk.fadeFunction;
                    }
                }
            };
            doOnEnterFrame(chk);
        }
    
        public static function showTimedAd(options:Object):void {
            /*
                This function will stop the clip, load the MochiAd in a
                centered position on the clip, and then resume the clip
                after a timeout.

                options:
                    An object with keys and values to pass to the server.
                    These options will be passed to MochiAd.load, but the
                    following options are unique to showTimedAd.

                    clip is a MovieClip reference to place the ad in.

                    ad_timeout is the number of milliseconds to wait
                    for the ad to start loading (default: 2000).

                    fadeout_time is the number of milliseconds to
                    fade out the ad upon completion (default: 250).
            */
            var DEFAULTS:Object = {
                ad_timeout: 2000,
                fadeout_time: 250,
                regpt: "o",
                method: "showTimedAd",
                ad_started: function ():void { this.clip.stop(); },
                ad_finished: function ():void { this.clip.play(); }
            };
            options = MochiAd._parseOptions(options, DEFAULTS);

            var clip:Object = options.clip;
            var ad_msec:Number = 11000;
            var ad_timeout:Number = options.ad_timeout;
            delete options.ad_timeout;
            var fadeout_time:Number = options.fadeout_time;
            delete options.fadeout_time;

            if (!MochiAd.load(options)) {
                options.ad_finished();
                return;
            }

            options.ad_started();
        
            var mc:MovieClip = clip._mochiad;
            mc["onUnload"] = function ():void {
                options.ad_finished();
            }


            /* Center the clip */
            var wh:Array = MochiAd._getRes(options, clip);
            var w:Number = wh[0];
            var h:Number = wh[1];
            mc.x = w * 0.5;
            mc.y = h * 0.5;
        
            var chk:MovieClip = createEmptyMovieClip(mc, "_mochiad_wait", 3);
            chk.ad_msec = ad_msec;
            chk.ad_timeout = ad_timeout;
            chk.started = getTimer();
            chk.showing = false;
            chk.fadeout_time = fadeout_time;
            chk.fadeFunction = function ():void {
                var p:Number = 100 * (1 - 
                    ((getTimer() - this.fadeout_start) / this.fadeout_time));
                if (p > 0) {
                    this.parent.alpha = p * 0.01;
                } else {
                    var _clip:MovieClip = this.parent.parent;
                    MochiAd.unload(_clip);
                    delete this["onEnterFrame"];
                }
            };

            mc.unloadAd = function ():void {
                MochiAd.unload(clip);
            }
            
            mc.adjustProgress = function (msec:Number):void {
                var _chk:Object = mc._mochiad_wait;
                _chk.server_control = true;
                _chk.started = getTimer();
                _chk.ad_msec = msec - 250;
            };

            chk["onEnterFrame"] = function ():void {
                var ad_clip:Object = this.parent._mochiad_ctr;
                var elapsed:Number = getTimer() - this.started;
                var finished:Boolean = false;
                if (!chk.showing) {
                    var total:Number = ad_clip.loaderInfo.bytesTotal;
                    if (total > 0 || typeof(total) == "undefined") {
                        chk.showing = true;
                        chk.started = getTimer();
                    } else if (elapsed > chk.ad_timeout) {
                        finished = true;
                    }
                }
                if (elapsed > chk.ad_msec || this.parent._mochiad_ctr_failed) {
                    finished = true;
                }
                if (finished) {
                    if (this.server_control) {
                        delete this.onEnterFrame;
                    } else {
                        this.fadeout_start = getTimer();
                        this.onEnterFrame = this.fadeFunction;
                    }
                }
            };
            doOnEnterFrame(chk);


        }

        public static function _allowDomains(server:String):String {
            var hostname:String = server.split("/")[2].split(":")[0];
            flash.system.Security.allowDomain("*");
            flash.system.Security.allowDomain(hostname);
            flash.system.Security.allowInsecureDomain("*");
            flash.system.Security.allowInsecureDomain(hostname);
            return hostname;
        }
        
        public static function _loadCommunicator(options:Object):MovieClip {
            var DEFAULTS:Object = {
                com_server: "http://x.mochiads.com/com/1/",
                method: "loadCommunicator",
                depth: 10337,
                id: "_UNKNOWN_"
            };
            options = MochiAd._parseOptions(options, DEFAULTS);
            options.swfv = 9;
            options.mav = MochiAd.getVersion();

            var clip:Object = options.clip;
            var clipname:String = '_mochiad_com_' + options.id;

            if (!MochiAd._isNetworkAvailable()) {
                return null;
            }

            if (clip[clipname]) {
                return clip[clipname];
            }

            var server:String = options.com_server + options.id;
            MochiAd._allowDomains(server);
            delete options.id;
            delete options.com_server;

            var depth:Number = options.depth;
            delete options.depth;
            var mc:MovieClip = createEmptyMovieClip(clip, clipname, depth);
            var lv:URLVariables = new URLVariables();
            for (var k:String in options) {
                lv[k] = options[k];
            }

            var lc:LocalConnection = new LocalConnection();
            lc.client = mc;
            var name:String = [
                "", Math.floor((new Date()).getTime()), Math.floor(Math.random() * 999999)
            ].join("_");
            lc.allowDomain("*", "localhost");
            lc.allowInsecureDomain("*", "localhost");
            lc.connect(name);
            mc.name = name;
            mc.lc = lc;
            lv.lc = name;
            mc._id = 0;
            mc._queue = [];
            mc.rpcResult = function (cb:Object):void {
                cb = parseInt(cb.toString());
                var cblst:Array = mc._callbacks[cb];
                if (typeof(cblst) == 'undefined') {
                    return;
                }
                delete mc._callbacks[cb];
                var args:Array = [];
                for (var i:Number = 2; i < cblst.length; i++) {
                    args.push(cblst[i]);
                }
                for (i = 1; i < arguments.length; i++) {
                    args.push(arguments[i]);
                }
                var method:Object = cblst[1];
                var obj:Object = cblst[0];
                if (obj && typeof(method) == 'string') {
                    method = obj[method];
                }
                if (typeof(method) == 'function') {
                    method.apply(obj, args);
                }
            }
            mc._didConnect = function (endpoint:String):void {
                mc._endpoint = endpoint;
                var q:Array = mc._queue;
                delete mc._queue;
                var ds:Function = mc.doSend;
                for (var i:Number = 0; i < q.length; i++) {
                    var item:Array = q[i];
                    ds.apply(this, item);
                }
            }
            mc.doSend = function (args:Array, cbobj:Object, cbfn:Object):void {
                if (mc._endpoint == null) {
                    var qargs:Array = [];
                    for (var i:Number = 0; i < arguments.length; i++) {
                        qargs.push(arguments[i]);
                    }
                    mc._queue.push(qargs);
                    return;
                }
                mc._id += 1;
                var id:Number = mc._id;
                mc._callbacks[id] = [cbobj, cbfn || cbobj];
                var slc:LocalConnection = new LocalConnection();
                slc.send(mc._endpoint, 'rpc', id, args);
            }
            mc._callbacks = {};
            mc._callbacks[0] = [mc, '_didConnect'];

            lv.st = getTimer();
            var req:URLRequest = new URLRequest(server + ".swf");
            req.contentType = "application/x-www-form-urlencoded";
            req.method = URLRequestMethod.POST;
            req.data = lv;
            var loader:Loader = new Loader();
            loader.load(req);
            mc.addChild(loader);
            mc._mochiad_com = loader;

            return mc;

        }

        public static function fetchHighScores(options:Object, callbackObj:Object, callbackMethod:Object=null):Boolean {
            /*
                Fetch the high scores from MochiAds. Returns false if a connection
                to MochiAds can not be established due to the security sandbox.

                options:
                    An object with keys and and values to pass to the
                    server.

                    clip is a MovieClip reference to place the (invisible)
                    communicator in.

                    id should be the unique identifier for this MochiAd.

                callback(scores):

                    scores is an array of at most 50 high scores, highest score
                    first, with a millisecond epoch timestamp (for the Date
                    constructor).  [[name, score, timestamp], ...]
            */
            var lc:MovieClip = MochiAd._loadCommunicator({clip: options.clip, id: options.id});
            if (!lc) {
                return false;
            }
            lc.doSend(['fetchHighScores', options], callbackObj, callbackMethod);
            return true;
        }


        public static function sendHighScore(options:Object, callbackObj:Object, callbackMethod:Object=null):Boolean {
            /*
                Send a high score to MochiAds. Returns false if a connection
                to MochiAds can not be established due to the security sandbox.

                options:
                    An object with keys and and values to pass to the
                    server.

                    clip is a MovieClip reference to place the (invisible)
                    communicator in.

                    id should be the unique identifier for this MochiAd.

                    name is the name to be associated with the high score, e.g.
                    "Player Name"

                    score is the value of the high score, e.g. 100000.

                callback(scores, index):

                    scores is an array of at most 50 high scores, highest score
                    first, with a millisecond epoch timestamp (for the Date
                    constructor).  [[name, score, timestamp], ...]

                    index is the array index of the submitted high score in
                    scores, or -1 if the submitted score did not rank top 50.
            */
            var lc:MovieClip = MochiAd._loadCommunicator({clip: options.clip, id: options.id});
            if (!lc) {
                return false;
            }
            lc.doSend(['sendHighScore', options], callbackObj, callbackMethod);
            return true;
        }        

        public static function load(options:Object):MovieClip {
            /*
                Load a MochiAd into the given MovieClip
            
                options:
                    An object with keys and values to pass to the server.

                    clip is a MovieClip reference to place the ad in.

                    id should be the unique identifier for this MochiAd.

                    server is the base URL to the MochiAd server.

                    res is the resolution of the container clip or movie
                    as a string, e.g. "500x500"

                    no_page disables page detection.
            */
            var DEFAULTS:Object = {
                server: "http://x.mochiads.com/srv/1/",
                method: "load",
                depth: 10333,
                id: "_UNKNOWN_"
            };
            options = MochiAd._parseOptions(options, DEFAULTS);
            // This isn't accessible yet for some reason:
            // options.clip.loaderInfo.swfVersion;
            options.swfv = 9;
            options.mav = MochiAd.getVersion();

            var clip:Object = options.clip;

            if (!MochiAd._isNetworkAvailable()) {
                return null;
            }
        
            if (clip._mochiad_loaded) {
                return null;
            }

            var depth:Number = options.depth;
            delete options.depth;
            var mc:MovieClip = createEmptyMovieClip(clip, "_mochiad", depth);
        
            var wh:Array = MochiAd._getRes(options, clip);
            options.res = wh[0] + "x" + wh[1];

            options.server += options.id;
            delete options.id;

            clip._mochiad_loaded = true;

            var lv:URLVariables = new URLVariables();
            for (var k:String in options) {
                var v:Object = options[k];
                if (!(v is Function)) {
                    lv[k] = v;
                }
            }
            if (clip.loaderInfo.loaderURL.indexOf("http") != 0) {
                options.no_page = true;
            }

            var server:String = lv.server;
            delete lv.server;
            var hostname:String = _allowDomains(server);

            mc["onEnterFrame"] =  function ():void {
                if (!this._mochiad_ctr) {
                    delete this["onEnterFrame"];
                    MochiAd.unload(this.parent);
                };
            };
            doOnEnterFrame(mc);

            var lc:LocalConnection = new LocalConnection();
            lc.client = mc;
            var name:String = [
                "", Math.floor((new Date()).getTime()), Math.floor(Math.random() * 999999)
            ].join("_");
            lc.allowDomain("*", "localhost");
            lc.allowInsecureDomain("*", "localhost");
            lc.connect(name);
            mc.lc = lc;
            lv.lc = name;
            
            lv.st = getTimer();
            var loader:Loader = new Loader();
            
            var f:Function = function (ev:Object):void {
                mc._mochiad_ctr_failed = true;
            }
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, f);
            
            var req:URLRequest = new URLRequest(server + ".swf");
            req.contentType = "application/x-www-form-urlencoded";
            req.method = URLRequestMethod.POST;
            req.data = lv;
            loader.load(req);
            mc.addChild(loader);
            mc._mochiad_ctr = loader;
            
        
            return mc;
        }

        public static function unload(clip:Object):Boolean {
            /*
                Unload a MochiAd from the given MovieClip
            
                    clip:
                        a MovieClip reference (e.g. this.stage)
            */
            if (clip.clip && clip.clip._mochiad) {
                clip = clip.clip;
            }
            if (!clip._mochiad) {
                return false;
            }
            if (clip._mochiad.onUnload) {
                clip._mochiad.onUnload();
            }
            clip.removeChild(clip._mochiad);
            delete clip._mochiad_loaded;
            delete clip._mochiad;
            return true;
        }

        public static function _isNetworkAvailable():Boolean {
            return Security.sandboxType != "localWithFile";
        }
    
        public static function _getRes(options:Object, clip:Object):Array {
            var b:Object = clip.getBounds(clip.root);
            var w:Number = 0;
            var h:Number = 0;
            if (typeof(options.res) != "undefined") {
                var xy:Array = options.res.split("x");
                w = parseFloat(xy[0]);
                h = parseFloat(xy[1]);
            } else {
                w = b.xMax - b.xMin;
                h = b.yMax - b.yMin;
            }
            if (w == 0 || h == 0) {
                w = clip.stage.stageWidth;
                h = clip.stage.stageHeight;
            }


            return [w, h];
        }

        public static function _parseOptions(options:Object, defaults:Object):Object {
            var optcopy:Object = {};
            var k:String;
            for (k in defaults) {
                optcopy[k] = defaults[k];
            }
            if (options) {
                for (k in options) {
                    optcopy[k] = options[k];
                }
            }
            options = optcopy.clip.loaderInfo.parameters.mochiad_options;
            if (options) {
                var pairs:Array = options.split("&");
                for (var i:Number = 0; i < pairs.length; i++) {
                    var kv:Array = pairs[i].split("=");
                    optcopy[unescape(kv[0])] = unescape(kv[1]);
                }
            }
            return optcopy;
        }

    }
}
