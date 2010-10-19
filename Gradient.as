package
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	public class Gradient
	{
		static private const IDENTITY: Matrix = new Matrix();
		
		static public function getArray( colors: Array, alphas: Array, ratio: Array ): Array
		{
			var a: Array = new Array();
			var s: Shape = new Shape();
			var m: Matrix = new Matrix();
			var o: BitmapData = new BitmapData( 256, 1, true, 0 );
			var g: Graphics = s.graphics;
			
			m.createGradientBox( 256, 256, 0, 0, 0 );
			
			g.clear();
			g.beginGradientFill( 'linear', colors, alphas, ratio, m );
			g.drawRect( 0, 0, 256, 256 );
			g.endFill();
			
			o.draw( s, IDENTITY );
			
			var c: uint;
			
			for( var i: int = 0 ; i < 256 ; i++ )
			{
				a.push( c = o.getPixel32( i, 0 ) );
			}
			
			return a;
		}
	}
}