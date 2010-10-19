package {
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.utils.getDefinitionByName;

    // Must be dynamic!
    public dynamic class Preloader extends MovieClip {
        // Keep track to see if an ad loaded or not
        private var did_load:Boolean;

        // Change this class name to your main class
        public static var MAIN_CLASS:String = "stickyblocks";

        // Substitute these for what's in the MochiAd code
        public static var GAME_OPTIONS:Object = {id: "1fa7ef43e97f79f9", res:"640x480"};

        public function Preloader() {
            super();

            var opts:Object = {};
            for (var k:String in GAME_OPTIONS) {
                opts[k] = GAME_OPTIONS[k];
            }

            opts.ad_started = function ():void {
                did_load = true;
            }

            opts.ad_finished = function ():void {
                // don't directly reference the class, otherwise it will be
                // loaded before the preloader can begin
                var mainClass:Class = Class(getDefinitionByName(MAIN_CLASS));
                var app:Object = new mainClass();
                parent.addChild(app as DisplayObject);
                if (app.init) {
                    app.init(did_load);
                }
            }

            opts.clip = this;
            MochiAd.showPreloaderAd(opts);
        }


    }

}
