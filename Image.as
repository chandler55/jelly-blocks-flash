package
{
	import com.jxl.diesel.view.core.BitmapSprite;
	import flash.display.Bitmap;
	import com.jxl.diesel.view.core.BitmapSpriteDisplayObject;
	import flash.events.MouseEvent;
	
	public class Image
	{
		var bitmap:Bitmap;
		var bitmapSprite:BitmapSprite;
		
		public function Image(what:Class, bsdo:BitmapSpriteDisplayObject) {
			bitmap = new what() as Bitmap;
			bitmapSprite = new BitmapSprite();
			bitmapSprite.setBitmap(bitmap);
			bsdo.addBitmapSprite(bitmapSprite);
			move(-900,-900);
			
		}
		public function getBS():BitmapSprite {
			return bitmapSprite;
		}
		public function getBitmap():Bitmap {
			return bitmap;
		}
		public function move(x:int, y:int):void {
			bitmapSprite.move(x,y,false);
		}
	}
}