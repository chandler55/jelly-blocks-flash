
package
{
	import com.senocular.utils.KeyObject;
	import com.hexagonstar.util.debug.Debug;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.display.BlendMode;
	import flash.events.MouseEvent;
	import de.polygonal.ds.*;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Graphics;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.display.Loader;
	import com.jxl.util.LoaderQueue;
	import flash.net.URLRequest;
	import com.jxl.battlefield.model.MDArray;
	import com.jxl.battlefield.view.CharacterSprite;
	import com.jxl.diesel.view.core.BitmapSprite;
	import com.jxl.battlefield.view.DefaultTileMap;
	import com.jxl.battlefield.view.SpriteMap;
	import com.jxl.battlefield.view.WalkableMap;
	import com.jxl.diesel.view.core.BitmapSpriteDisplayObject;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import Image;
	import flash.display.BitmapDataChannel;
	import flash.utils.ByteArray;
	import flash.media.Sound;
	import flash.text.Font;
	import flash.text.*;
	import flash.filters.*;
	import mx.core.SoundAsset;
	import flash.geom.Matrix;
	import zeuslabs.particles.*;
	import flash.net.*;
	//[Frame(factoryClass="Preloader")]
	[SWF( backgroundColor='0x121212', frameRate='35', width='320', height='240')]
	
	public dynamic class stickyblocks extends Sprite
	{

		private var glow:GlowFilter;
		[Embed(source="Leaves.swf",symbol="greenleaf")]
		public static var GreenLeaf:Class;
		[Embed(source="Leaves.swf",symbol="brownleaf")]
		public static var BrownLeaf:Class;
		private var clone:BitmapData;
		private var system:ParticleSystem;
		private var swap_counter:int = 0;
		// constants
		private const TITLESCREEN:int = 0;
		private const LEVELSELECT:int = 1;
		private const GAME:int = 2;
		private const INSTRUCTIONS:int = 3;
		private const CREDITS:int = 4;
		private const TRANSITION:int = 5;
		private var transitionOverride:Boolean = false;
		private var fps:FPS;
		private var realTimer:Timer;
		private var moves:int = 0;
		private var showTimerExpiredScreen:int = 0;
		var gameplayBackgroundBitmap:Bitmap;
		var gameplayBackgroundSprite:BitmapSprite;
		[Embed(source="art/click.mp3")]
		public var c_click:Class;
		[Embed(source="art/click2.mp3")]
		public var c_click2:Class;
		[Embed(source="art/winner.mp3")]
		public var c_winner:Class;
		[Embed(source="levels.dat", mimeType="application/octet-stream")]
		public var b_map:Class;
		[Embed(source="art/controls.png")]
		public var c_controls:Class;
		[Embed(source="art/cube.png")]
		public var c_cube:Class;
		[Embed(source="art/smallcube.png")]
		public var c_smallcube:Class;
		[Embed(source="art/blocks.png")]
		public var c_blocks:Class;
		[Embed(source="art/blocks2.png")]
		public var c_blocks2:Class;
		//[Embed(source="art/gameplay.png")]
		//public var c_gameplayBackground:Class;
		[Embed(source="art/grass2.png")]
		public var c_levelselectBackground:Class;
		//[Embed(source="art/titlescreen.png")]
		//public var c_titlescreen:Class;
		//[Embed(source="art/levels1.png")]
		//public var c_levels1:Class;
		//[Embed(source="art/levels2.png")]
		//public var c_levels2:Class;
		//[Embed(source="art/levels3.png")]
		//public var c_levels3:Class;
		//[Embed(source="art/levels4.png")]
		//public var c_levels4:Class;
		[Embed(source="art/leftarrow.png")]
		public var c_leftarrow:Class;
		[Embed(source="art/leftarrowdown.png")]
		public var c_leftarrowdown:Class;
		//[Embed(source="art/credits.png")]
		//public var c_credits:Class;
		//[Embed(source="art/creditsdown.png")]
		//public var c_creditsdown:Class;
		//[Embed(source="art/quit.png")]
		//public var c_quit:Class;
		//[Embed(source="art/quitdown.png")]
		//public var c_quitdown:Class;
		[Embed(source="art/rightarrow.png")]
		public var c_rightarrow:Class;
		[Embed(source="art/rightarrowdown.png")]
		public var c_rightarrowdown:Class;
		[Embed(source="art/backtotitlescreendown.png")]
		public var c_backtotitlescreendown:Class;
		[Embed(source="art/backtotitlescreen.png")]
		public var c_backtotitlescreen:Class;
		[Embed(source="art/nextlevel.png")]
		public var c_nextlevel:Class;
		[Embed(source="art/nextleveldown.png")]
		public var c_nextleveldown:Class;
		[Embed(source="art/start.png")]
		public var c_start:Class;
		[Embed(source="art/startdown.png")]
		public var c_startdown:Class;
		//[Embed(source="art/instructions.png")]
		//public var c_instructions:Class;
		[Embed(source="art/startgame.png")]
		public var c_startgame:Class;
		[Embed(source="art/startgamedown.png")]
		public var c_startgamedown:Class;
		[Embed(source="art/undo.png")]
		public var c_undo:Class;
		[Embed(source="art/undodown.png")]
		public var c_undodown:Class;
		[Embed(source="art/reset.png")]
		public var c_reset:Class;
		[Embed(source="art/resetdown.png")]
		public var c_resetdown:Class;
		[Embed(source="art/binstructions.png")]
		public var c_binstructions:Class;
		[Embed(source="art/binstructionsdown.png")]
		public var c_binstructionsdown:Class;
		[Embed(source="art/control1.png")]
		public var c_control1:Class;
		[Embed(source="art/control2.png")]
		public var c_control2:Class;
		[Embed(source="art/font.ttf", fontName="Cooper")]		
		public var font:String;
		[Embed(source="art/casper.ttf", fontName="Casper")]
		public var font2:String;
		[Embed(source="art/arrowkeys.png")]
		public var c_arrowkeys:Class;
		[Embed(source="art/arrow.png")]
		public var c_arrow:Class;
		public var key:KeyObject = new KeyObject(stage);
		private var font_format2:TextFormat;
		private var ff:TextFormat;
		private var txt2:TextField;
		private var t_thanksforplaying:TextField;
		private var t_jellyblocks:TextField;
		private var congratsArray:Array;
		private var transitionCounter:int = 0;
		private var t_instructions:TextField;
		private var f_font2:Font;
		private var t_goal:TextField;
		private var t_control:TextField;
		private var t_creditsText:TextField;
		private var t_same:TextField;
		private var font_format:TextFormat;
		private var txt:TextField;
		private var t_progress:TextField;
		private var t_credits:TextField;
		private var t_levelselect:TextField;
		private var clickSound:Sound;
		private var winnerSound:Sound;
		private var click2Sound:Sound;
		private var f_font:Font;
		private var t_solvedpuzzle:TextField;
		private var t_level:TextField;
		private var t_level2:TextField;
		private var t_jellyblockscom:TextField;
		private var mySo:SharedObject;
		
		private var b_backtotitlescreen:MyButton;
		private var b_leftarrow:MyButton;
		private var b_rightarrow:MyButton;
		private var b_start:MyButton;
		private var b_undoButton:MyButton;
		private var b_resetButton:MyButton;
		private var b_startgame:MyButton;
		private var b_instructions:MyButton;
//		private var b_quit:MyButton; 
		private var b_nextlevel:MyButton;
		//private var b_credits:MyButton;
		private var i_control1:Image;
		private var i_control2:Image;
		// images
		private var i_controls:Image;
		private var i_blocks:Image;
		private var i_blocks2:Image;
		private var i_gameplaybackground:Image;
		//private var i_titlescreen:Image;
		private var i_levelselectbackground:Image;
		private var i_levels1:Image
		private var i_levels2:Image
		private var i_levels3:Image
		private var i_levels4:Image
		private var i_cube:Image;
		private var i_arrowkeys:Image;
		private var i_smallcube:Image;
		private var i_arrow:Image;
		private var levelPreview:int = 0;
		private var mouseDown: Boolean;
		var bsdo:BitmapSpriteDisplayObject;
		private var timer:int = 0;
		private var t_timerText:TextField;
		private var t_timerExpired:TextField;
		private var completePuzzleSequence:int = 0;
		private var gamestate:int; 
		private var congratsMovement:Array;
		//mouse
		private var mousex:int;
		private var mousey:int;
		private var clone2:BitmapSpriteDisplayObject;
		// levels
		private var levels:Array3;
		private var undoBackup:Array3;
		private var currentLevel:int = 0;
		private var levelselectedx:int = 0;
		private var levelselectedy:int = 0;
		
		//what does this do?  keep track of level data
		private var leveltagged:Array2;
		private var level:Array2;
		private var transitionlevel:Array2;
		
		private var completedLevels:Array;
		
		//input keys
		private var keyF1Pressed:Boolean = false;
		private var keyF1Toggle:Boolean = false;
		private var keyF2Pressed:Boolean = false;
		private var keyF2Toggle:Boolean = false;
		private var keyF3Pressed:Boolean = false;
		private var keyF3Toggle:Boolean = false;
		private var keyF4Pressed:Boolean = false;
		private var keyF4Toggle:Boolean = false;
		
		private var keyUpPressed:Boolean = false;
		private var keyUpToggle:Boolean = false;
		private var keyDownPressed:Boolean = false;
		private var keyDownToggle:Boolean = false;
		private var keyRightPressed:Boolean = false;
		private var keyRightToggle:Boolean = false;
		private var keyLeftPressed:Boolean = false;
		private var keyLeftToggle:Boolean = false;
		private var keyRPressed:Boolean = false;
		private var keyRToggle:Boolean = false;
		private var keyUPressed:Boolean = false;
		private var keyUToggle:Boolean = false;
		private var keyEnterPressed:Boolean = false;
		private var keyEnterToggle:Boolean = false;
		private var mousePressed:Boolean = false;
		private var mouseToggle:Boolean = false;
		private var keyCounter:int = 0;
		private var beforeState:int;
		private var afterState:int;
		
		// filters
		private	var bevel:BevelFilter = new BevelFilter(4, 45, 0x99CCFF, 1, 0x003399, 1, 10, 10, 2, 3);
		//private var colorfilter:ColorMatrixFilter = new ColorMatrixFilter(new Matrix(
		// is puzzle completed
		private var completePuzzle:Boolean = false;
		private var timerExpired:Boolean = false;
		private const WIDTH: int = 640;
		private const HEIGHT: int = 480;
		
		private const ORIGIN: Point = new Point();
		
		//-- APPEARANCE
		private const EXPLOSION_BLUR_STRENGTH: int = 2;
		private const EXPLOSION_BLUR_QUALITY: int = 1;
		
		private var blur: BlurFilter;
		
		private var buffer: BitmapData;
		private var output: BitmapData;                                                                                                                                                                                                                                                                                   
		private var temp:BitmapData;
		private var explosions: Array;
		private var fireColors: Array;
		private var whichColor:int = 0;
		private var keysDown:Array = new Array();
		
		function addKey(e:KeyboardEvent):void {
		    keysDown[e.keyCode] = true;
		}
		function removeKey(e:KeyboardEvent):void {
		    keysDown[e.keyCode] = false;
		}
		// here's how you'd implement it:
		var t:Timer = new Timer(25);
		
		function tick(e:TimerEvent):void {
		    // old way- if (Key.isDown(Key.RIGHT)) {
		    if (keysDown[Keyboard.RIGHT]) {
		        trace("right key is down!");
		    }
		    // etc.
		}
		public function CreditsRender(bsdo:BitmapSpriteDisplayObject) {
			b_backtotitlescreen.Show();
			bsdo.bitmapData.copyPixels(i_levelselectbackground.bitmap.bitmapData, new Rectangle(0,0,320,240),new Point(0,0),null,null,null);
			t_credits.visible = true;
			t_creditsText.visible = true;
			
		}
		public function Credits() {
			CreditsRender(bsdo);
			
			if (b_backtotitlescreen.isClicked()) {
				b_backtotitlescreen.Hide();
				t_credits.visible = false;
				gamestate = TITLESCREEN;
				t_creditsText.visible = false;
				return;
			}
		}
		public function InstructionsRender(bsdo:BitmapSpriteDisplayObject) {
			bsdo.bitmapData.copyPixels(i_levelselectbackground.bitmap.bitmapData, new Rectangle(0,0,320,240),new Point(0,0),null,null,null);
			bsdo.bitmapData.copyPixels(i_arrowkeys.getBitmap().bitmapData,new Rectangle(0,0,110,74),new Point(200,120),null,new Point(0,0),1);
			bsdo.bitmapData.copyPixels(i_arrow.getBitmap().bitmapData,new Rectangle(0,0,40,18),new Point(131,57),null,new Point(0,0),1);
			bsdo.bitmapData.copyPixels(i_arrow.getBitmap().bitmapData,new Rectangle(0,0,40,18),new Point(131,192),null,new Point(0,0),1);
			
			if (swap_counter <= 40) {
				bsdo.bitmapData.copyPixels(i_control1.bitmap.bitmapData, new Rectangle(0,0,49,49),new Point(140,115),null,null,null);
				bsdo.bitmapData.colorTransform(new Rectangle(200,138,18,18),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));					
			}
			else {
				bsdo.bitmapData.copyPixels(i_control2.bitmap.bitmapData, new Rectangle(0,0,49,49),new Point(140,115),null,null,null);
				bsdo.bitmapData.colorTransform(new Rectangle(200+36,138,18,18),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));		
			}
				
			if (swap_counter == 80)
				swap_counter = 0;
			swap_counter++;
			
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(108,36,12,12),new Point(85,53),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(36,36,12,12),new Point(85+12,53),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(72,36,12,12),new Point(85+12+12,53),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(36,36,12,12),new Point(85,53+12),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(72,36,12,12),new Point(85+12,53+12),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(108,36,12,12),new Point(85+24,53+12),null,new Point(0,0),0);
			
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(84,48,24,12),new Point(190,50),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(120,36,12,12),new Point(190+12,50+12),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(120+12,36,12,12),new Point(190+12,50+12+12),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(48,36,12,12),new Point(190+12+12,50),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(48+12,36,12,12),new Point(190+12+12,50+12),null,new Point(0,0),0);
			
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(72,36,12,12),new Point(88,185),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(72,36,12,12),new Point(112,185),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(84,48,24,12),new Point(190,185),null,new Point(0,0),0);						
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(108,36,12,12),new Point(190,185+18),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(36,36,12,12),new Point(190+12,185+18),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(108,36,12,12),new Point(87,185+17),null,new Point(0,0),0);
			bsdo.bitmapData.copyPixels(i_blocks.getBitmap().bitmapData,new Rectangle(36,36,12,12),new Point(87+25,185+17),null,new Point(0,0),0);
			b_backtotitlescreen.Show();
			
			t_control.visible = true;
			t_goal.visible = true;
			t_same.visible = true;
			t_instructions.visible = true;
			
		}
		public function Instructions() {
			InstructionsRender(bsdo);
			//// input ////
			Input(); 
			if (b_backtotitlescreen.isClicked() || keyF1Toggle) {
				gamestate = TITLESCREEN;
				t_control.visible = false;
				t_goal.visible = false;
				t_same.visible = false;
				t_instructions.visible = false;
				b_backtotitlescreen.Hide();
			}
		
			/// game code ///
		}
		
		public function TitlescreenRender(bsdo:BitmapSpriteDisplayObject) {
			t_jellyblockscom.visible = true;
			b_instructions.Show();
			b_startgame.Show();
			//b_credits.Show();
			txt.visible = true;
			bsdo.bitmapData.copyPixels(i_levelselectbackground.bitmap.bitmapData, new Rectangle(0,0,320,240),new Point(0,0),null,null,null);		
			bsdo.bitmapData.copyPixels(i_cube.bitmap.bitmapData, new Rectangle(0,0,92,95),new Point(132,108),null,null,true);
			
		}
		public function Titlescreen() {
			
			//// input ////
			Input(); 
			
			//goto instructions
			if (b_instructions.isClicked() || keyF4Toggle) {
				gamestate = INSTRUCTIONS;
				b_instructions.Hide();
				b_startgame.Hide();
				txt.visible = false;
				b_instructions.Hide();
				b_startgame.Hide();
				//b_credits.Hide();
				return;
			}
			//goto levelselect (MODIFIED: GOTO GAME)
			if (b_startgame.isClicked() || keyF2Toggle) {
				// load first level
				for (var i:int = 0; i < 18; i++) {
					for (var j:int = 0; j < 18; j++) {
						level.set(i,j,levels.get(0,i,j));
					}
				}
				i_levelselectbackground.move(0,0);
				currentLevel = 0;
				gamestate = GAME;
				txt.visible = false;
				b_instructions.Hide();
				b_startgame.Hide();
				//b_credits.Hide();
				timer = 120;
				showTimerExpiredScreen = 3;
				timerExpired = false;
				return;
			}
			if (mouseToggle && this.mouseX > t_jellyblockscom.x && this.mouseY > t_jellyblockscom.y && 
			this.mouseX < t_jellyblockscom.x + 146 && this.mouseY < t_jellyblockscom.y + 13) 
				callLink();
			
			/// game code ///
			TitlescreenRender(bsdo);
		}
		public function LevelSelectRender(bsdo:BitmapSpriteDisplayObject) {
			t_level.text = "Level " + new int(25*levelPreview + levelselectedx + 5*levelselectedy + 1);
			t_level.filters = [glow];
			t_level.visible = true;
			t_progress.visible = true;
			t_levelselect.visible = true;
			b_backtotitlescreen.Show();
			b_start.Show();
			bsdo.bitmapData.copyPixels(i_levelselectbackground.bitmap.bitmapData,new Rectangle(0,0,320,240),new Point(0,0),null,null,null);
			
			if (mouseToggle && mouseX > 192 && mouseX < 192 + 256 && mouseY > 112 && mouseY < 112 + 256) {
				var xselect:int = (mouseX - 192) / 51;
				var yselect:int = (mouseY - 112) / 51;
				levelselectedx = xselect;
				levelselectedy = yselect;
			}
			bsdo.bitmapData.fillRect(new Rectangle(190 + levelselectedx*52,110 + levelselectedy*52,52,52),0xffff0000);
			switch (levelPreview) {
				case 0:
				bsdo.bitmapData.copyPixels(i_levels1.bitmap.bitmapData,new Rectangle(0,0,258,258),new Point(191,111),null,null,true);
				break;
				case 1:
				bsdo.bitmapData.copyPixels(i_levels2.bitmap.bitmapData,new Rectangle(0,0,258,258),new Point(191,111),null,null,true);
				break;
				case 2:
				bsdo.bitmapData.copyPixels(i_levels3.bitmap.bitmapData,new Rectangle(0,0,258,258),new Point(191,111),null,null,true);
				break;
				case 3:
				bsdo.bitmapData.copyPixels(i_levels4.bitmap.bitmapData,new Rectangle(0,0,258,258),new Point(191,111),null,null,true);
				break;
				
			}
			for (var i:int = 0; i < 5; i++) {
				for (var j:int = 0; j < 5; j++) {
					//var whatLevel = 
					if (!completedLevels[i + j*5 + 25*levelPreview]) 
						bsdo.bitmapData.colorTransform(new Rectangle(192 + i*52,112 + j*52,48,48),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));		
				
				}
			}
			
		}
		public function LevelSelect() {
			
			Input();
			
			LevelSelectRender(bsdo);
			
			if (b_start.isClicked()) {
				t_progress.visible = false;
				completePuzzle = false;
				timerExpired = false;
				if (!completedLevels[levelselectedx + levelselectedy * 5 + levelPreview*25])
					return;
				// reset undo
				completePuzzleSequence = 0;
				moves = 0;
				t_levelselect.visible = false;
				gamestate = GAME;
				i_levelselectbackground.move(-900,-900);
				b_start.Hide();
				b_leftarrow.Hide();
				b_rightarrow.Hide();
				b_backtotitlescreen.Hide();
				currentLevel = 25*levelPreview + levelselectedx + 5*levelselectedy;
				// load first level
				for (var i:int = 0; i < 18; i++) {
					for (var j:int = 0; j < 18; j++) {
						level.set(i,j,levels.get(0,i,j));
					}
				}
				return;
			}
			if (b_backtotitlescreen.isClicked()) {
				t_progress.visible = false;
				t_levelselect.visible = false;
				gamestate = TITLESCREEN;
				//i_titlescreen.move(0,0);
				i_levelselectbackground.move(-900,-900);
				b_start.Hide();
				b_leftarrow.Hide();
				b_rightarrow.Hide();
				b_backtotitlescreen.Hide();
				system.visible = false;
				return;
			}
			if (b_leftarrow.isClicked()) {
				levelPreview--;
			}
			if (b_rightarrow.isClicked()) {
				levelPreview++;
			}

			if (levelPreview == 0) {
				b_leftarrow.Hide();
			} else {
				b_leftarrow.Show();
			}
			if (levelPreview == 3) {
				b_rightarrow.Hide();
			} else {
				b_rightarrow.Show();
			}

			
		}
	    public function Input() {
	    	//Debug.trace(keyCounter);
	    	
	    	if (keyCounter > 15) {
	    		keyCounter = 0;
	    		keyUpPressed = keyDownPressed = keyLeftPressed = keyRightPressed = false;
	    	}
	    	
	    	keyEnterToggle = false;
	    	if (keysDown[Keyboard.ENTER]) {
	    		if (!keyEnterPressed)
					keyEnterToggle = keyEnterPressed = true;
			} else 
				keyEnterPressed = false;
			
			
	    	keyUToggle = false;
	    	if (keysDown[85]) {
	    		if (!keyUPressed)
					keyUToggle = keyUPressed = true;
			} else 
				keyUPressed = false;
			keyF1Toggle = false;
	    	if (keysDown[112]) {
	    		if (!keyF1Pressed)
					keyF1Toggle = keyF1Pressed = true;
			} else 
				keyF1Pressed = false;
			keyF2Toggle = false;
	    	if (keysDown[113]) {
	    		if (!keyF2Pressed)
					keyF2Toggle = keyF2Pressed = true;
			} else 
				keyF2Pressed = false;
			keyF3Toggle = false;
	    	if (keysDown[114]) {
	    		if (!keyF3Pressed)
					keyF3Toggle = keyF3Pressed = true;
			} else 
				keyF3Pressed = false;
			keyF4Toggle = false;
	    	if (keysDown[115]) {
	    		if (!keyF4Pressed)
					keyF4Toggle = keyF4Pressed = true;
			} else 
				keyF4Pressed = false;
			keyRToggle = false;
	    	if (keysDown[82]) {
	    		if (!keyRPressed)
					keyRToggle = keyRPressed = true;
			} else 
				keyRPressed = false;
				
	    	keyUpToggle = false;
	    	if (keysDown[Keyboard.UP]) {
	    		keyCounter++;
	    		if (!keyUpPressed) {
					keyUpToggle = keyUpPressed = true;
	    		}
			} else {
				keyUpPressed = false;
			}
			if (key.isDown(Keyboard.UP) ||  key.isDown(Keyboard.DOWN) || key.isDown(Keyboard.LEFT) || key.isDown(Keyboard.RIGHT)) {
				
			} else {
				keyCounter = 0;
			}
				
			keyDownToggle = false;
	    	if (key.isDown(Keyboard.DOWN)) {
	    		keyCounter++;
	    		if (!keyDownPressed)
					keyDownToggle = keyDownPressed = true;
			} else {
				keyDownPressed = false;
			}
			keyLeftToggle = false;
	    	if (key.isDown(Keyboard.LEFT)) {
	    		keyCounter++;
	    		if (!keyLeftPressed) {
					keyLeftToggle = keyLeftPressed = true;
					}
			} else {
				keyLeftPressed = false;
			}
			keyRightToggle = false;
	    	if (key.isDown(Keyboard.RIGHT)) {
	    		keyCounter++;
	    		if (!keyRightPressed)
					keyRightToggle = keyRightPressed = true;
			} else {
				keyRightPressed = false;
			}
			
			mouseToggle = false;
	    	if (mouseDown) {
	    		if (!mousePressed)
					mouseToggle = mousePressed = true;
			} else 
				mousePressed = false;
	    }
	    public function GameplayRender(bsdo:BitmapSpriteDisplayObject) {
	    	t_level2.text = "Level " + new int(currentLevel + 1);
	    	t_level2.filters = [glow];
	    	t_level2.visible = true;
	    	t_timerText.visible = true;
	    	if (timer <= 0) {
	    		t_timerText.text = "";
	    		timerExpired = true;
	    		
	    		//gamestate = TITLESCREEN;
	    		//return;
	    	}
	    	else  {
		    	if (timer %60 <= 9) { 
		    		t_timerText.text = "Timer\n" + Math.floor((timer / 60 )).toString() + ":0" + (timer % 60 ).toString();
		    	} else {
		    		t_timerText.text = "Timer\n" + Math.floor((timer / 60 )).toString() + ":" + (timer % 60 ).toString();
		    	}
	    	}
	    	
	    	
	    	if (timerExpired) {
	    		t_timerExpired.visible = true;
	    	}
	    	
	    	//t_jellyblocks.visible = true;
			//b_quit.Show();
			b_undoButton.Show();
	    	b_resetButton.Show();
			bsdo.bitmapData.copyPixels(i_levelselectbackground.bitmap.bitmapData,new Rectangle(0,0,320,240),new Point(0,0),null,null,null);
			bsdo.bitmapData.fillRect(new Rectangle(0,0,199,199),0);
		
			var square:BitmapData = new BitmapData(12,12,false,0);
			for (var i:int = 1; i < 17 ; i++) 
				for (var j:int = 1; j < 17 ; j++)  {
				var rect:Rectangle = new Rectangle();
				var color:int = level.get(i,j);
				var lcolor:int = level.get(i-1,j);
				var rcolor:int = level.get(i+1,j);
				var bcolor:int = level.get(i,j+1);
				var tcolor:int = level.get(i,j-1);
				rect = getColorToRect(color,lcolor != color,rcolor != color,bcolor != color,tcolor != color);
				
				
				if (color != 0)
					bsdo.bitmapData.copyPixels(i_blocks2.getBitmap().bitmapData,rect,new Point(i*15-15,j*15-15),null,new Point(0,0),0);
				else if ((i + j) % 2== 0)
					bsdo.bitmapData.copyPixels(i_blocks2.getBitmap().bitmapData,new Rectangle(15,75,15,15),new Point(i*15-15,j*15-15),null,new Point(0,0),0);
				else
					bsdo.bitmapData.copyPixels(i_blocks2.getBitmap().bitmapData,new Rectangle(30,75,15,15),new Point(i*15-15,j*15-15),null,new Point(0,0),0);
					
			}
		bsdo.bitmapData.copyPixels(i_controls.bitmap.bitmapData, new Rectangle(0,0,155,236),new Point(468,207),null,null,false);
			
			/// game code ///
			
			if (completePuzzle) {
				t_timerText.text = "";
				// finished game
				if (currentLevel == 99) {
					t_thanksforplaying.visible = true;
					
				}
				
				bsdo.bitmapData.colorTransform(bsdo.bitmapData.rect,new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));
				t_jellyblocks.visible = false;
				t_level2.visible = false;
				
				if (currentLevel != 99)
					b_nextlevel.Show();
					
				b_undoButton.Hide();
				b_resetButton.Hide();
				t_solvedpuzzle.visible = true;
				system.visible = true;
				//bsdo.bitmapData.fillRect(new Rectangle(190 + levelselectedx*52,110 + levelselectedy*52,52,52),0xff00ffff);	
				
				for (var i:int = 0; i < 18;i++) {
					congratsArray[i].visible = true;
					if (congratsArray[i].y == 63)
						congratsMovement[i] = true;
					if (congratsArray[i].y == 37)
						congratsMovement[i] = false;
					if (!congratsMovement[i])
						congratsArray[i].y+=1;
					else
						congratsArray[i].y-=1;
				}
					
				if (keyF4Toggle || b_nextlevel.isClicked() || (keyEnterToggle && currentLevel != 99)) {
					transitionOverride = true;
					completePuzzleSequence = 0;
					completePuzzle = false;
					timerExpired = false;
					showTimerExpiredScreen = 3;
					// reset undo
					b_nextlevel.Hide();
					system.visible = false;
					for (var i:int = 0; i < 18;i++)
						congratsArray[i].visible = false;
					t_solvedpuzzle.visible = false;
					moves = 0;
					currentLevel++;
					timer = 120;
					// load level
					for (var i:int = 0; i < 18; i++) {
						for (var j:int = 0; j < 18; j++) {
							level.set(i,j,levels.get(currentLevel,i,j));
						}
					}
					return;
				}
			}
			if (completePuzzleSequence == 0)
				checkCompleted();
			if (completePuzzleSequence > 0 && completePuzzleSequence < 25) {
				var fade:Number  = 1 - 0.7 * (completePuzzleSequence / 25);
				bsdo.bitmapData.colorTransform(bsdo.bitmapData.rect,new ColorTransform(fade,fade,fade,1,0,0,0,0));
				completePuzzleSequence++;
				t_solvedpuzzle.visible = true;
				t_solvedpuzzle.x = 87 * (completePuzzleSequence/25)*1.0;
				
			}
			if (completePuzzleSequence == 25) {
				completePuzzleSequence= 26;
				if (currentLevel != 99) {
					completedLevels[currentLevel+1] = true;
					mySo.data.completed = completedLevels;
					mySo.flush();
				}
				completePuzzle = true;
			}
	    }
	    public function TimerExpired() {
	    	
	    }
		public function Gameplay() {

	
		/// render /// 
			GameplayRender(bsdo);
			//// input ////
			if (showTimerExpiredScreen > 0 && timerExpired) 
				return;
			if (showTimerExpiredScreen == 0 && timerExpired)
				gamestate = TITLESCREEN;
				
			Input();
			if (!completePuzzle) {
				if (keyUpToggle) {
					backupBoard();
					MoveUp();
					clickSound.play();
						bsdo.bitmapData.colorTransform(new Rectangle(513+ 36,289-36,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					
				}
				if (keyRightToggle) {
					backupBoard();
					MoveRight();
					clickSound.play();	
						bsdo.bitmapData.colorTransform(new Rectangle(513+ 36+ 36,289,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					
				}
				if (keyDownToggle) {
					backupBoard();
					MoveDown();
					clickSound.play();
						bsdo.bitmapData.colorTransform(new Rectangle(513+ 36,289,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					
				}
				if (keyLeftToggle) {
					backupBoard();
					MoveLeft();
					clickSound.play();
							bsdo.bitmapData.colorTransform(new Rectangle(513,289,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					
				}
				if (keyRToggle || b_resetButton.isClicked() || keyF4Toggle) {
					ResetBoard();
						bsdo.bitmapData.colorTransform(new Rectangle(534,395,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					
				}
				if (keyUToggle || b_undoButton.isClicked() || keyF3Toggle) {
					restoreBoard();
							bsdo.bitmapData.colorTransform(new Rectangle(534,350,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					
				}
				if (mouseToggle) {
					if (this.mouseX > 534 && this.mouseY > 350 && this.mouseX < 534 + 36 && this.mouseY < 350 + 36) {
						restoreBoard();
						bsdo.bitmapData.colorTransform(new Rectangle(534,350,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					}
					if (this.mouseX > 534 && this.mouseY > 395 && this.mouseX < 534 + 36 && this.mouseY < 395 + 36) {
						ResetBoard();
						bsdo.bitmapData.colorTransform(new Rectangle(534,395,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					}
					if (this.mouseX > 513 && this.mouseY > 289 && this.mouseX < 513 + 36 && this.mouseY < 289 + 36) {
						backupBoard();
						MoveLeft();
						clickSound.play();
						bsdo.bitmapData.colorTransform(new Rectangle(513,289,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					}
					if (this.mouseX > 513+ 36 && this.mouseY > 289 && this.mouseX < 513 + 36+ 36 && this.mouseY < 289 + 36) {
						backupBoard();
						MoveDown();
						clickSound.play();
						bsdo.bitmapData.colorTransform(new Rectangle(513+ 36,289,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					}
					if (this.mouseX > 513+ 36+ 36 && this.mouseY > 289 && this.mouseX < 513 + 36+ 36+ 36 && this.mouseY < 289 + 36) {
						backupBoard();
						MoveRight();
						clickSound.play();
						bsdo.bitmapData.colorTransform(new Rectangle(513+ 36+ 36,289,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					}
					if (this.mouseX > 513+ 36 && this.mouseY > 289-36 && this.mouseX < 513 + 36+ 36 && this.mouseY < 289 + 36-36) {
						backupBoard();
						MoveUp();
						clickSound.play();
						bsdo.bitmapData.colorTransform(new Rectangle(513+ 36,289-36,37,37),new ColorTransform(0.3,0.3,0.3,1,0,0,0,0));	
					}
				}
			}
			/*if (b_quit.isClicked() && (completePuzzleSequence == 0 || completePuzzleSequence == 25 || completePuzzleSequence == 26)) {
				completePuzzleSequence = 0;
				gamestate = LEVELSELECT;
				system.visible = false;
				b_quit.Hide();
				b_nextlevel.Hide();
				t_jellyblocks.visible = false;
				for (var i:int = 0; i < 18;i++)
						congratsArray[i].visible = false;
				t_solvedpuzzle.visible = false;
				t_thanksforplaying.visible = false;
				return;
			}*/
			
			
					
		}
		public function getColorToRect(color:int, lcolor:Boolean, rcolor:Boolean, bcolor:Boolean, tcolor:Boolean):Rectangle {
			var src:Rectangle = new Rectangle();
			// what block color
			switch (color) {
				case 0:
					src.left = 0;
					src.top = 0;
					break;
				case 1:
					src.left =0;
					src.top = 0;
					break;
				case 2:
					src.left = 45*2;
					src.top = 0;
					break;
				case 3:
					src.left = 67.5*2;
					src.top = 0;
					break;
				case 4:
					src.left = 22.5*2;
					src.top = 0;
					break;
			}
			
			// what block type (left right up down etc)
			if (lcolor && tcolor && rcolor && bcolor) {
				src.top += 18*2*1.25;
			}
			else if (lcolor && tcolor && rcolor) {
				src.left += 6*2*1.25;
				src.top += 18*2*1.25;
			}
			else if (lcolor && bcolor && rcolor) {
				src.left += 12*2*1.25;
				src.top += 18*2*1.25;
			}
			else if (bcolor && tcolor && rcolor) {
				src.left += 12*2*1.25;
				src.top += 24*2*1.25;
			}
			else if (lcolor && tcolor && bcolor) {
				src.left += 6*2*1.25;
				src.top += 24*2*1.25;
			}
			else if (lcolor && tcolor) {
			}
			else if (tcolor && rcolor) {
				src.left += 12*2*1.25;
			}
			else if (bcolor && rcolor) {
				src.left += 12*2*1.25;
				src.top += 12*2*1.25;
			}
			else if (lcolor && bcolor) {
				src.top += 12*2*1.25;
			}
			else if (tcolor && bcolor) {
				src.top += 24*2*1.25;
			}
			else if (lcolor && rcolor) {
				src.top += 30*2*1.25;
			}
			else if (lcolor) {
				src.top += 6*2*1.25;
			}
			else if (tcolor) {
				src.left += 6*2*1.25;
			}
			else if (bcolor) {
				src.left += 6*2*1.25;
				src.top += 12*2*1.25;
			}
			else if (rcolor) {
				src.left += 12*2*1.25;
				src.top += 6*2*1.25;
			}
			else {
				src.left += 6*2*1.25;
				src.top += 6*2*1.25;
			}
		
			src.right = 6*2*1.25 + src.left; 
			src.bottom = 6*2*1.25 + src.top;
			src.height = 12*1.25;
			src.width = 12*1.25;
			
			return src;
		}
		public function backupBoard():void {
			for (var i:int = 0; i < 18; i++)
				for (var j:int = 0; j < 18; j++) {
					undoBackup.set(moves,i,j,level.get(i,j));
				}
			moves++;
		}
		public function restoreBoard():void {
			if (moves == 0)
				return;
			moves--;
			for (var i:int = 0; i < 18; i++)
				for (var j:int = 0; j < 18; j++) {
					level.set(i,j,undoBackup.get(moves,i,j));
				}
			
		}
		public function stickyblocks()
		{	
			super();
            // This initializes if the preloader is turned off.
            if (stage != null) {
                init(false);
            }
  		}
  		
  		public function timerHandler(event:TimerEvent):void {
  			if (!completePuzzle)
           	 	timer -= 1;
           	if (timerExpired)
	           	showTimerExpiredScreen -= 1;
        }
        
  		public function init(did_load:Boolean) {
  			this.addEventListener(KeyboardEvent.KEY_DOWN, addKey, false, 0, true);
			this.addEventListener(KeyboardEvent.KEY_UP, removeKey, false, 0, true);
			t.addEventListener(TimerEvent.TIMER, tick, false, 0, true);
			
	 		realTimer = new Timer(1000,0);
			
			realTimer.addEventListener("timer",timerHandler);
			realTimer.start();
			clone2 = new BitmapSpriteDisplayObject(new BitmapData(320, 240, true, 0x00ffffff));
			mySo = SharedObject.getLocal("jellyblocks");
			//mySo = SharedObject.getLocal("jellyblocks", "/game_files/0000/");
			if (mySo.data.completed == null) {
				completedLevels = new Array();
				for (var i:int = 0; i < 100; i++) {
					completedLevels[i] = new Boolean();
					completedLevels[i] = false;
				}
				completedLevels[0] = true;
			} else {
				completedLevels = mySo.data.completed;
			}
			
			moves = 0;
			undoBackup = new Array3(100,18,18);
			system = new ParticleSystem();
			system.spawnRate = 1 / 5;
			system.particleClass = SkinnedParticle;
			system.addEventListener(ParticleEvent.INITIALIZE_PARTICLE, initializeLeaf);
			system.addEventListener(ParticleEvent.UPDATE_PARTICLE, updateLeaf);
			system.start();
			
			buffer = new BitmapData( WIDTH, HEIGHT, true, 0 );
			output = new BitmapData( WIDTH, HEIGHT, true, 0 );
			temp = new BitmapData(WIDTH, HEIGHT, true,0);
	//		explosionSound = Sound( new ExplosionSoundAsset() );
			blur = new BlurFilter( EXPLOSION_BLUR_STRENGTH, EXPLOSION_BLUR_STRENGTH, EXPLOSION_BLUR_QUALITY );	
			
			explosions = new Array();
			clickSound = new c_click() as Sound;
			winnerSound = new c_winner() as Sound;
			click2Sound = new c_click2() as Sound;
			gamestate = TITLESCREEN;
			transitionlevel = new Array2(18,18);
			level = new Array2(18,18);
			leveltagged = new Array2(18,18);
			levels = new Array3(100,18,18);
			
			// load temp level
			for (var i:int = 0; i < 18; i++) {
				for (var j:int = 0; j < 18; j++) {
						transitionlevel.set(i,j,0);
						level.set(j,i,0);
						if (i == 0 || i == 17 || j == 17 || j ==0)
							leveltagged.set(j,i,1);
						else
							leveltagged.set(j,i,0);
					}
			}
			resetTags();
			
			// load all the levels
			var pickyourself:ByteArray = new b_map() as ByteArray;
			for (var z:int = 0; z < 100; z++)
				for (var i:int = 0; i < 18; i++)
					for (var j:int = 0; j < 18 ; j++) {
							levels.set(z,i,j,pickyourself.readByte()-48);
					}
						
			// load one level
			for (var i:int = 0; i < 18; i++) {
				for (var j:int = 0; j < 18; j++) {
					level.set(i,j,levels.get(8,i,j));
				}
			}
			Debug.disable();
			//Debug.fpsStart(stage);
			//Debug.trace("[%TME%]hi");
			//trace("hi");
			stage.frameRate = 60;

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			tabEnabled = true;
			
			var defaultBitmapData:BitmapData = new BitmapData(640, 480, true, 0x00ffffff);
			bsdo = new BitmapSpriteDisplayObject(defaultBitmapData);
			
			addChild(bsdo);

			//i_gameplaybackground = new Image(c_gameplayBackground,bsdo);
			//i_gameplaybackground.move(0,0);
			i_levelselectbackground = new Image(c_levelselectBackground,bsdo);
			i_levelselectbackground.move(-900,-900);
			i_arrow = new Image(c_arrow, bsdo);
			//i_titlescreen = new Image(c_titlescreen, bsdo);
			i_controls = new Image(c_controls, bsdo);
			i_blocks = new Image(c_blocks, bsdo);
			i_blocks2 = new Image(c_blocks2,bsdo);
			//i_levels1 = new Image(c_levels1, bsdo);
			//i_levels2 = new Image(c_levels2, bsdo);
			//i_levels3 = new Image(c_levels3, bsdo);
			//i_levels4 = new Image(c_levels4, bsdo);
			i_control1 = new Image(c_control1, bsdo);
			i_control2 = new Image(c_control2, bsdo);
			i_arrowkeys = new Image(c_arrowkeys, bsdo);
			i_cube = new Image(c_cube,bsdo);
			i_smallcube = new Image(c_smallcube, bsdo);
			stage.focus = this;
			stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			
			// Buttons
		//	b_credits= new MyButton(new Rectangle(554,453,73,20),c_creditsdown,c_credits,bsdo);
			//b_credits.addListeners(stage);
			//b_credits.Hide();
			b_leftarrow = new MyButton(new Rectangle(71,167,73,133),c_leftarrowdown,c_leftarrow,bsdo);
			b_leftarrow.addListeners(stage);
			b_leftarrow.Hide();
			b_rightarrow = new MyButton(new Rectangle(511,167,73,133),c_rightarrowdown,c_rightarrow,bsdo);
			b_rightarrow.addListeners(stage);
			b_rightarrow.Hide();
			b_backtotitlescreen = new MyButton(new Rectangle(9,118,91,20), c_backtotitlescreendown,c_backtotitlescreen,bsdo);
			b_backtotitlescreen.addListeners(stage);
			b_backtotitlescreen.Hide();		
			b_undoButton = new MyButton(new Rectangle(248,135,57,20),c_undodown,c_undo,bsdo);
			b_undoButton.addListeners(stage);
			b_undoButton.Hide();
			b_resetButton = new MyButton(new Rectangle(248,175,57,20), c_resetdown,c_reset, bsdo);
			b_resetButton.addListeners(stage);
			b_resetButton.Hide();
			b_start = new MyButton(new Rectangle(469,432,110,30),c_startdown,c_start,bsdo);
			b_start.addListeners(stage);
			b_start.Hide();
			//b_quit = new MyButton(new Rectangle(544,7,90,30),c_quitdown,c_quit,bsdo);
			//b_quit.addListeners(stage);
			//b_quit.Hide();
			b_instructions = new MyButton(new Rectangle(26,183,106,20),c_binstructionsdown,c_binstructions,bsdo);
			b_instructions.addListeners(stage);
			b_instructions.Hide();
			b_startgame = new MyButton(new Rectangle(200,183,92,20),c_startgamedown,c_startgame,bsdo);
			b_startgame.addListeners(stage);
			b_startgame.Hide();
			b_nextlevel = new MyButton(new Rectangle(240,186,81,20),c_nextleveldown,c_nextlevel,bsdo);
			b_nextlevel.addListeners(stage);
			b_nextlevel.Hide();
			// Apply the glow filter to the cross shape.
			glow = new GlowFilter();
			glow.color = 0xffffff;
			glow.alpha = 1;
			glow.blurX = 2;
			glow.blurY = 2;
			glow.quality = BitmapFilterQuality.MEDIUM;
			
			// font
			font_format = new TextFormat();
			font_format.font = "Cooper";
			font_format.size = 36;
			
			txt = new TextField();
			txt.embedFonts = true;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.defaultTextFormat = this.font_format;
			txt.text = "Jelly Blocks";
			txt.filters = [glow];
			txt.x = 35;
			txt.y = 47;
			txt.mouseEnabled = false;
			addChild(txt);
			
		    // font2
			font_format2 = new TextFormat();
			font_format2.font = "Casper";
			font_format2.size = 36;
			
			glow.color = 0xffffff;
			glow.blurX = 4;
			glow.blurY = 4;
			var congratsString:String = "CONGRATULATIONS!";
			
			txt2 = new TextField();
			
			congratsArray = new Array();
			congratsMovement = new Array();
			for (var i:int = 0; i < 18; i++) {
				congratsArray[i] = new TextField();
				congratsArray[i].embedFonts = true;
				congratsArray[i].autoSize = TextFieldAutoSize.LEFT;
				congratsArray[i].defaultTextFormat = this.font_format2;
				congratsArray[i].filters = [glow];
				congratsArray[i].x = 15 + i*18;
				congratsArray[i].y = 37 + i*2;
				congratsArray[i].mouseEnabled = false;
				congratsMovement[i] = new Boolean(true);
				congratsArray[i].text = congratsString.charAt(i);
				addChild(congratsArray[i]);
				congratsArray[i].visible = false;
			}
			
			font_format.size = 11;
			glow.blurX = 2;
			glow.blurY = 2;
			t_levelselect = new TextField();
			t_levelselect.embedFonts = true;
			t_levelselect.autoSize = TextFieldAutoSize.LEFT;
			t_levelselect.defaultTextFormat = this.font_format;
			t_levelselect.text = "Level Select";
			t_levelselect.filters = [glow];
			t_levelselect.x = 246;
			t_levelselect.y = 22;
			t_levelselect.mouseEnabled = false;
			t_instructions = new TextField();
			t_instructions.embedFonts = true;
			t_instructions.autoSize = TextFieldAutoSize.LEFT;
			t_instructions.defaultTextFormat = this.font_format;
			t_instructions.text = "Instructions";
			t_instructions.filters = [glow];
			t_instructions.x = 123;
			t_instructions.y = 11;
			t_instructions.mouseEnabled = false;
			addChild(t_instructions);
			t_credits = new TextField();
			t_credits.embedFonts = true;
			t_credits.autoSize = TextFieldAutoSize.LEFT;
			t_credits.defaultTextFormat = this.font_format;
			t_credits.text = "Credits";
			t_credits.filters = [glow];
			t_credits.x = 266;
			t_credits.y = 22;
			t_credits.mouseEnabled = false;
			t_credits.visible = false;
			addChild(t_credits);
			font_format.size = 30;
			glow.blurX = 3;
			glow.blurY = 3;
			t_jellyblocks = new TextField();
			t_jellyblocks.embedFonts = true;
			t_jellyblocks.autoSize = TextFieldAutoSize.LEFT;
			t_jellyblocks.defaultTextFormat = this.font_format;
			t_jellyblocks.text = "JELLY BLOCKS";
			t_jellyblocks.filters = [glow];
			t_jellyblocks.x = 197;
			t_jellyblocks.y = 10;
			t_jellyblocks.mouseEnabled = false;
			glow.blurX = 4;
			glow.blurY = 4;
			font_format.size = 9;
			t_solvedpuzzle = new TextField();
			t_solvedpuzzle.embedFonts = true;
			t_solvedpuzzle.autoSize = TextFieldAutoSize.LEFT;
			t_solvedpuzzle.defaultTextFormat = this.font_format;
			t_solvedpuzzle.text = "YOU SOLVED THE PUZZLE!";
			t_solvedpuzzle.filters = [glow];
			t_solvedpuzzle.x = 87;
			t_solvedpuzzle.y = 95;
			t_solvedpuzzle.mouseEnabled = false;
			
			t_solvedpuzzle.visible = false;
			font_format.size = 13;
			t_thanksforplaying = new TextField();
			t_thanksforplaying.embedFonts = true;
			t_thanksforplaying.autoSize = TextFieldAutoSize.LEFT;
			t_thanksforplaying.defaultTextFormat = this.font_format;
			t_thanksforplaying.text = "THANKS FOR PLAYING!";
			t_thanksforplaying.filters = [glow];
			t_thanksforplaying.x = 75;
			t_thanksforplaying.y = 110;
			t_thanksforplaying.mouseEnabled = false;
			t_thanksforplaying.visible = false;
			t_timerExpired = new TextField();
			t_timerExpired.embedFonts = true;
			t_timerExpired.autoSize = TextFieldAutoSize.LEFT;
			t_timerExpired.defaultTextFormat = this.font_format;
			t_timerExpired.text = "Time Expired!";
			t_timerExpired.filters = [glow];
			t_timerExpired.x = 75;
			t_timerExpired.y = 110;
			t_timerExpired.mouseEnabled = false;
			t_timerExpired.visible = false;
			
			font_format.size = 16;
			glow.blurX = 3;
			glow.blurY = 3;
			t_progress = new TextField();
			t_progress.embedFonts = true;
			t_progress.autoSize = TextFieldAutoSize.LEFT;
			t_progress.defaultTextFormat = this.font_format;
			t_progress.text = "progress is automatically saved";
			t_progress.filters = [glow];
			t_progress.x = 185;
			t_progress.y = 380;
			t_progress.mouseEnabled = false;
			t_progress.visible = false;
			font_format.size = 10;
			
			t_goal = new TextField();
			t_goal.embedFonts = true;
			t_goal.autoSize = TextFieldAutoSize.LEFT;
			t_goal.defaultTextFormat = this.font_format;
			t_goal.text = "GOAL: To connect all the same colored blocks together";
			t_goal.filters = [glow];
			t_goal.x = 14;
			t_goal.y = 32;
			t_goal.mouseEnabled = false;
			
			t_control = new TextField();
			t_control.embedFonts = true;
			t_control.autoSize = TextFieldAutoSize.LEFT;
			t_control.defaultTextFormat = this.font_format;
			t_control.text = "You control all blocks simultaneously";
			t_control.filters = [glow];
			t_control.x = 63;
			t_control.y = 95;
			t_control.mouseEnabled = false;
			
			t_same = new TextField();
			t_same.embedFonts = true;
			t_same.autoSize = TextFieldAutoSize.LEFT;
			t_same.defaultTextFormat = this.font_format;
			t_same.text = "Same colored blocks stick";
			t_same.filters = [glow];
			t_same.x = 92;
			t_same.y = 170;
			t_same.mouseEnabled = false;
			t_same.visible = false;
			t_creditsText = new TextField();
			t_creditsText.embedFonts = true;
			t_creditsText.autoSize = TextFieldAutoSize.LEFT;
			t_creditsText.defaultTextFormat = this.font_format;
			t_creditsText.text = "Programmer/Artist - Michael Le\n\n\n\nThanks to the Flash Community\n\n";
			t_creditsText.filters = [glow];
			t_creditsText.x = 125;
			t_creditsText.y = 100;
			t_same.mouseEnabled = false;
			t_creditsText.visible = false;
			t_control.visible = false;
			t_goal.visible = false;
			t_instructions.visible = false;
			t_creditsText.visible = false;
			t_level = new TextField();
			t_level.embedFonts = true;
			t_level.autoSize = TextFieldAutoSize.LEFT;
			t_level.defaultTextFormat = this.font_format;
			t_level.text = "Level 23";
			t_level.filters = [glow];
			t_level.x = 266;
			t_level.y = 72;
			font_format.size = 15;
			t_level2 = new TextField();
			t_level2.embedFonts = true;
			t_level2.autoSize = TextFieldAutoSize.LEFT;
			t_level2.defaultTextFormat = this.font_format;
			t_level2.text = "Level 23";
			t_level2.filters = [glow];
			t_level2.x = 243;
			t_level2.y = 20;
			t_level.visible = false;
			t_level2.visible = false;
			t_level2.mouseEnabled = false;
			t_timerText = new TextField();
			//t_timerText.embedFonts = true;
			 ff = new TextFormat();
			ff.align = "center";
			ff.bold = true;
			ff.size = 15;
			t_timerText.defaultTextFormat = this.ff;
			t_timerText.autoSize = TextFieldAutoSize.LEFT;
			 
			t_timerText.x = 251;
			t_timerText.y = 50;
			t_timerText.text = "Timer\n1:12";

			t_timerText.visible = false;
			t_level.mouseEnabled = false;
			font_format.size = 12;
			font_format.url = "http://www.jellyblocks.com";
			t_jellyblockscom = new TextField();
			t_jellyblockscom.embedFonts = true;
			t_jellyblockscom.autoSize = TextFieldAutoSize.LEFT;
			t_jellyblockscom.defaultTextFormat = this.font_format;
			t_jellyblockscom.text = "www.jellyblocks.com";
			t_jellyblockscom.filters = [glow];
			t_jellyblockscom.x = 400;
			t_jellyblockscom.y = 459;
			t_jellyblockscom.mouseEnabled = false;
			t_jellyblockscom.selectable = false;
			t_jellyblockscom.visible = true;
			
			//t_jellyblockscom.addEventListener(MouseEvent.CLICK, callLink);
			addChild(t_creditsText);
			addChild(t_level);
			addChild(t_level2);
			addChild(t_goal);
			addChild(t_control);
			addChild(t_same);
		//	addChild(t_jellyblockscom);
			addChild(t_progress);
			t_progress.visible = false;
			addChild(t_thanksforplaying);
			addChild(t_solvedpuzzle);
			addChild(t_jellyblocks);
			addChild(t_levelselect);
			addChild(t_timerText);
			addChild(t_timerExpired);
			t_levelselect.visible = false;
			
			t_jellyblocks.visible = false;
			
			//addChild( new FPS() );
			addChild( new Bitmap( output ) );
			Key.initialize(stage);
			//Debug.timerStop();
			
			//stage.addEventListener( MouseEvent.MOUSE_DOWN, createExplosion );
			//stage.addEventListener( Event.ENTER_FRAME, renderExplosions );
			addChild(system);
			system.visible = false;
			
		}
		public function callLink():void {
		  var url:String = "http://www.jellyblocks.com";
		  var request:URLRequest = new URLRequest(url);
		  try {
		    navigateToURL(request, '_blank');
		  } catch (e:Error) {
		    trace("Error occurred!");
		  }
		}
		private function createExplosion( event: Event ): void
		{
			whichColor++;
			if (whichColor == 3)
				whichColor = 0;
				
			var explosion: Explosion = new Explosion( mouseX, mouseY, whichColor );
			explosions.push( explosion );
			//explosionSound.play();
		}
		public function Transition():void {
			
			if (transitionCounter == 0) {
				click2Sound.play();
				switch (afterState) {
					case TITLESCREEN:
						TitlescreenRender(clone2);
						break;
					case GAME:
						GameplayRender(clone2);
						break;
					case LEVELSELECT:
						LevelSelectRender(clone2);
						break;
					case CREDITS:
						CreditsRender(clone2);
						break;
					case INSTRUCTIONS:
						InstructionsRender(clone2);
						break;
					
				}
			}
			transitionCounter++;
			if (transitionCounter > 20) {
				transitionCounter = 0;
				gamestate = afterState;
				return;
			}
			b_backtotitlescreen.Hide();
			b_leftarrow.Hide();
			b_rightarrow.Hide();
			b_start.Hide();
			b_startgame.Hide();
			b_instructions.Hide();
			//b_quit.Hide(); 
			b_nextlevel.Hide();
			b_undoButton.Hide();
			b_resetButton.Hide();
		//	b_credits.Hide();
			for (var i:int = this.numChildren-1; i >= 0; i--) {
				this.getChildAt(i).visible = false;
			}
			this.getChildAt(0).visible = true;
			
			stage.invalidate();
			bsdo.bitmapData.fillRect(bsdo.bitmapData.rect,0);
			bsdo.bitmapData.copyPixels(clone,clone.rect,new Point(-1*transitionCounter*16,0),null,null,null);
			bsdo.bitmapData.copyPixels(clone2.bitmapData,clone2.bitmapData.rect,new Point(-1*transitionCounter*16+320,0),null,null,null);
			
		}
		private function onEnterFrame(event:Event):void
		{
			stage.focus = this;
			//Debug.timerReset();
			//Debug.timerStart();
			
			switch (gamestate) {
				case TITLESCREEN:
					Titlescreen();
					if (gamestate != TITLESCREEN) {
						beforeState = TITLESCREEN;
						afterState = gamestate;
						gamestate = TRANSITION;
						clone = bsdo.bitmapData.clone();
					}
					break;
				case LEVELSELECT:
					LevelSelect();
					if (gamestate != LEVELSELECT) {
						beforeState= LEVELSELECT;
						afterState = gamestate;
						gamestate = TRANSITION;
						clone = bsdo.bitmapData.clone();
					}
					break;
				case GAME:
					Gameplay();
					if (gamestate != GAME || transitionOverride) {
						transitionOverride= false;
						beforeState = GAME;
						afterState = gamestate;
						gamestate = TRANSITION;
						clone = bsdo.bitmapData.clone();
					}
					break;
				case INSTRUCTIONS:
					Instructions();
					if (gamestate != INSTRUCTIONS) {
						beforeState = INSTRUCTIONS;
						afterState = gamestate;
						gamestate = TRANSITION;
						clone = bsdo.bitmapData.clone();
					}
					break;
				case CREDITS:
					Credits();
					if (gamestate != CREDITS) {
						beforeState= CREDITS;
						afterState = gamestate;
						gamestate = TRANSITION;
						clone = bsdo.bitmapData.clone();
					}
					break;
				case TRANSITION:
					Transition();
					break;
					
			}
			//Debug.trace(mouseDown);		
			//i_gameplaybackground.move(Math.random()*640,0);
			//Debug.timerMilliSeconds();
		}
		
		private function onMouseDown( event: MouseEvent ): void
		{
			mousex = event.stageX;
			mousey = event.stageY;
			mouseDown = true;
		}
		private function onStageMouseUp( event: MouseEvent ): void
		{
			mousex = event.stageX;
			mousey = event.stageY;
			//stage.removeEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			mouseDown = false;
		}
		private function onMouseMove(event:MouseEvent) :void {
			
		}
		function changeColorUp(color:int, x:int, y:int):void {
						
			leveltagged.set(x,y,1);
		
			if (level.get(x+1,y) == color && leveltagged.get(x+1,y) != 1) {
				changeColorUp(color, x+1, y);
			}
			if (level.get(x-1,y) == color && leveltagged.get(x-1,y) != 1) {
				changeColorUp(color, x-1, y);
			}
			if (level.get(x,y-1) == color && leveltagged.get(x,y-1) != 1) {
				changeColorUp(color, x, y-1);
			}
			if ((level.get(x,y+1) == 4 || level.get(x,y+1) == 2 || level.get(x,y+1) == 3) && leveltagged.get(x,y+1) != 1) {
				changeColorUp(level.get(x,y+1), x, y+1);
			}
		}
		
		function changeColorRight(color:int,  x:int,  y:int):void {
			leveltagged.set(x,y,1);
			
		
			if (level.get(x,y+1) == color && leveltagged.get(x,y+1) != 1) {
				changeColorRight(color, x, y+1);
			}
			if (level.get(x,y-1) == color && leveltagged.get(x,y-1) != 1) {
				changeColorRight(color, x, y-1);
			}
			if (level.get(x+1,y) == color && leveltagged.get(x+1,y) != 1) {
				changeColorRight(color, x+1, y);
			}
			if ((level.get(x-1,y) == 4 || level.get(x-1,y) == 2 || level.get(x-1,y) == 3) && leveltagged.get(x-1,y) != 1) {
				changeColorRight(level.get(x-1,y), x-1, y);
			}
		}
		function changeColorDown(color:int,  x:int,  y:int):void {
		
			leveltagged.set(x,y,1);
		
			if (level.get(x,y+1) == color && leveltagged.get(x,y+1) != 1) {
				changeColorDown(color, x, y+1);
			}
			if (level.get(x+1,y) == color && leveltagged.get(x+1,y) != 1) {
				changeColorDown(color, x+1, y);
			}
			if (level.get(x-1,y) == color && leveltagged.get(x-1,y) != 1) {
				changeColorDown(color, x-1, y);
			}
			if ((level.get(x,y-1) == 4 || level.get(x,y-1) == 2 || level.get(x,y-1) == 3) && leveltagged.get(x,y-1) != 1) {
				changeColorDown(level.get(x,y-1), x, y-1);
			}
		}
		
		function changeColorLeft(color:int,  x:int,  y:int):void {
		
			leveltagged.set(x,y,1);
		
			if (level.get(x-1,y) == color && leveltagged.get(x-1,y) != 1) {
				changeColorLeft(color, x-1, y);
			}
			if (level.get(x,y+1) == color && leveltagged.get(x,y+1) != 1) {
				changeColorLeft(color, x, y+1);
			}
			if (level.get(x,y-1) == color && leveltagged.get(x,y-1) != 1) {
				changeColorLeft(color, x, y-1);
			}
			if ((level.get(x+1,y) == 4 || level.get(x+1,y) == 2 || level.get(x+1,y) == 3) && leveltagged.get(x+1,y) != 1) {
				changeColorLeft(level.get(x+1,y), x+1, y);
			}
		}
		function tagAround(color:int,  i:int,  j:int):void {
			leveltagged.set(i,j,1);
		
			if (level.get(i-1,j) == color && leveltagged.get(i-1,j) == 0) {
				tagAround(color,i-1,j);
			}
			if (level.get(i+1,j) == color && leveltagged.get(i+1,j) == 0) {
				tagAround(color,i+1,j);
			}
			if (level.get(i,j-1) == color && leveltagged.get(i,j-1) == 0) {
				tagAround(color,i,j-1);
			}
			if (level.get(i,j+1) == color && leveltagged.get(i,j+1) == 0) {
				tagAround(color,i,j+1);
			}
		}
		function resetTags():void {
			for (var i:int = 1; i < 17; i++) {
				for (var j:int = 1; j < 17; j++) {
					leveltagged.set(i,j,0);
				}
			}
		}
		function MoveRight():void {
			resetTags();
			for (var i:int = 2; i < 18; i++) {
				for (var j:int = 1; j < 17; j++) {
					if (level.get(i,j) == 1) {
						if ((level.get(i-1,j) == 4 || level.get(i-1,j) == 2 || level.get(i-1,j) == 3) && leveltagged.get(i-1,j) != 1)
							changeColorRight(level.get(i-1,j), i-1, j);
					}
				}
			}

			for (var i:int = 15; i > 0; i--) {
					for (var j:int = 16; j > 0; j--) {
						for (var z:int = 2; z < 5; z++)
							if (level.get(i,j) == z && level.get(i+1,j) == 0 && leveltagged.get(i,j) != 1) {
								level.set(i,j,0);
								level.set(i+1,j,z);
							}
					}
				} 
		}
		function MoveDown():void {
			resetTags();
			for (var i:int = 1; i < 18; i++) {
				for (var j:int = 2; j < 18; j++) {
					if (level.get(i,j) == 1) {
						if ((level.get(i,j-1) == 4 || level.get(i,j-1) == 2 || level.get(i,j-1) == 3) && leveltagged.get(i,j-1) != 1)
							changeColorDown(level.get(i,j-1), i, j-1);
					}
				}
			}

			for (var i:int = 16; i > 0; i--) {
				for (var j:int = 15; j > 0; j--) {
					for (var z:int = 2; z < 5; z++)
					if (level.get(i,j) == z && level.get(i,j+1) == 0 && leveltagged.get(i,j) != 1) {
						level.set(i,j,0);
						level.set(i,j+1,z);
					}
				}
			}
		}
		function MoveLeft():void {
			resetTags();
			for (var i:int = 0; i < 17; i++) {
				for (var j:int = 1; j < 17; j++) {
					if (level.get(i,j) == 1) {
						if ((level.get(i+1,j) == 4 || level.get(i+1,j) == 2 || level.get(i+1,j) == 3) && leveltagged.get(i+1,j) != 1)
							changeColorLeft(level.get(i+1,j), i+1, j);
					}
				}
			}
			for (var i:int = 1; i < 18; i++) {
				for (var j:int = 1; j < 17; j++) {
					for (var z:int = 2; z < 5; z++)
						if (level.get(i,j) == z && level.get(i-1,j) == 0 && leveltagged.get(i,j) != 1) {
							level.set(i,j,0);
							level.set(i-1,j,z);
						}
				}
			}
		}
		

		function MoveUp():void {
			
			resetTags();
			for (var j:int = 0; j < 16; j++) {
				for (var i:int = 1; i < 17; i++) {
					if (level.get(i,j) == 1) {
						if ((level.get(i,j+1) == 4 || level.get(i,j+1) == 2 || level.get(i,j+1) == 3) && leveltagged.get(i,j+1) != 1)
							changeColorUp(level.get(i,j+1), i, j+1);
					}
				}
			}
			
			for (var j:int = 2; j < 17; j++) {
				for (var i:int = 1; i < 17; i++) {
					for (var z:int = 2; z < 5; z++)
						if (level.get(i,j) == z && level.get(i,j-1) == 0 && leveltagged.get(i,j) != 1)  {
							level.set(i,j,0);
							level.set(i,j-1,z);
						}
					}
				}
			//moveup = 1;
		}
		
		public function ResetBoard():void {
			moves = 0;
			// load level
				for (var i:int = 0; i < 18; i++) {
					for (var j:int = 0; j < 18; j++) {
						level.set(i,j,levels.get(currentLevel,i,j));
					}
				}
		} 
		public function checkCompleted():void {
			resetTags();
			completePuzzleSequence = 1;
			for (var z:int = 2; z <= 4; z++ ){
				for (var i:int = 1; i <= 16; i++) {
					for (var j:int = 1; j <= 16; j++) {
						if (level.get(i,j) == z) {
							tagAround(z,i,j);
							j = 30;
							i = 30;
						}
					}
				}
				for (var i:int = 1; i <= 16; i++) {
					for (var j:int = 1; j <= 16; j++) {
						if (level.get(i,j) == z && leveltagged.get(i,j) == 0) {
							completePuzzleSequence = 0;
							
							resetTags();
							return;
						}
					}
				}
			}
			//playfireworks = true;
			resetTags();
			winnerSound.play();
		}
		//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 *  Initializes a single leaf particle.
		 */
		private function initializeLeaf(event:ParticleEvent):void
		{
			var particle:SkinnedParticle = event.particle as SkinnedParticle;
			if(!particle.skin)
			{
				if(Math.random() >= 0.4)
				{
					particle.skin = new GreenLeaf();
				}
				else
				{
					particle.skin = new BrownLeaf();
				}
			}
			particle.checkDestroyConditionFunction = canDestroyParticle;
			particle.size = 10 + Math.random() * 25;
			
			//start above the top vertically and randomly horizontally
			var width:Number = this.stage.stageWidth;
			particle.position = new Point(Math.random() * 3 * width - width, -particle.size);
			
			//alpha depends on size
			particle.alpha = 0.1 + particle.size / 40;
			
			particle.velocity = new Point(0, 2 * (particle.size / 35) + this.stage.stageHeight / 250);
		}
		
		/**
		 *  Updates a single leaf particle.
		 */
		private function updateLeaf(event:ParticleEvent):void
		{
			var particle:SkinnedParticle = event.particle as SkinnedParticle;
			
			var wind:Number = 10 * (this.mouseX - this.stage.stageWidth / 2) / (this.stage.stageWidth / 2);
			particle.rotation += 0;
			
			particle.velocity = new Point(0, particle.velocity.y);
		}
		
		/**
		 *  Instead of being based on time, the particle will be destroyed
		 *  when it reaches the bottom of the Flash window.
		 */
		private function canDestroyParticle(particle:SkinnedParticle):Boolean
		{
			return particle.y > this.stage.stageHeight;
		}
		
		/**
		 *  @private
		 *  The particle system should appear at 0,0
		 */
		private function stageResizeHandler(event:Event):void
		{
			this.system.x = 0;
			this.system.y = 0;
		}
	
	
	}
	
}


