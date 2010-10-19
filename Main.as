package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.Timer;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import com.hexagonstar.util.debug.Debug;
	
	[SWF( backgroundColor='0x10101a', frameRate='44', width='384', height='384')]

	public class Main extends Sprite
	{
		private const WIDTH: int = 384;
		private const HEIGHT: int = 384;
		
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
		
	//	[Embed(source='bin/explosion.mp3')]
	//	private var ExplosionSoundAsset: Class;
	//	private var explosionSound: Sound;
	
		public function Main()
		{
			Debug.trace("hi");
			init();
			Debug.fpsStart(stage);
		}
		
		private function init(): void
		{
			buffer = new BitmapData( WIDTH, HEIGHT, false, 0 );
			output = new BitmapData( WIDTH, HEIGHT, false, 0 );
			temp = new BitmapData(WIDTH, HEIGHT, true,0);
	//		explosionSound = Sound( new ExplosionSoundAsset() );
			
			blur = new BlurFilter( EXPLOSION_BLUR_STRENGTH, EXPLOSION_BLUR_STRENGTH, EXPLOSION_BLUR_QUALITY );
			
			addChild( new Bitmap( output ) );
			
			explosions = new Array();
			stage.addEventListener( MouseEvent.MOUSE_DOWN, MouseDown );
			stage.addEventListener( MouseEvent.MOUSE_DOWN, createExplosion );
			stage.addEventListener( Event.ENTER_FRAME, render );
		}
		private function MouseDown(event:MouseEvent) {
			

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
		private function createExplosion( event: Event ): void
		{
			whichColor++;
			if (whichColor == 3)
				whichColor = 0;
				
			var explosion: Explosion = new Explosion( mouseX, mouseY, whichColor );
			explosions.push( explosion );
			//explosionSound.play();
		}
		private function render( event: Event ): void
		{
			buffer.fillRect(buffer.rect,0);
			
			var explosion: Explosion;
			var i: int = explosions.length;
			
			while( --i > -1 )
			{	
				temp.fillRect(temp.rect,0);
				explosion = explosions[i];
				explosion.render( temp );
				if (explosion.isDead()) {
					explosions.splice(0,1);
				}
			//	Debug.trace(explosions.length);
				switch (explosion.getColor()) {
					case 0:
						fireColors = Gradient.getArray
						(
							[ 0, 0, 0x333333, 0xff0000, 0xffff00, 0xffffff ],
							[ 0, 0, 1, 1, 1, 1 ],
							[ 0, 0x22, 0x44, 0x55, 0x88, 0xff ]
						);
						break;
					case 1:
						fireColors = Gradient.getArray
						(
							[ 0, 0, 0x333333, 0x0000ff, 0x5555ff, 0xffffff ],
							[ 0, 0, 1, 1, 1, 1 ],
							[ 0, 0x22, 0x44, 0x55, 0x88, 0xff ]
						);
						break;
					case 2:
						fireColors = Gradient.getArray
						(
							[ 0, 0, 0x333333, 0x00ff00, 0xffff00, 0xffffff ],
							[ 0, 0, 1, 1, 1, 1 ],
							[ 0, 0x22, 0x44, 0x55, 0x88, 0xff ]
						);
						break;
				}

				temp.applyFilter( temp, temp.rect, ORIGIN, blur );
				
				buffer.copyPixels(temp,temp.rect,ORIGIN,null,null,true);
				//buffer.paletteMap( buffer, temp.rect, ORIGIN, [], [], fireColors, [] );	
			}
			
			//buffer.applyFilter( buffer, buffer.rect, ORIGIN, blur );	
			buffer.paletteMap( buffer, buffer.rect, ORIGIN, [], [], fireColors, [] );
			
			output.copyPixels( buffer, buffer.rect, ORIGIN );
		}
	}
}
