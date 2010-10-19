package
{
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import com.jxl.diesel.view.core.BitmapSpriteDisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.Stage;
	public class MyButton
	{
		private var downImage:Image;
		private var upImage:Image;
		private var isDown:Boolean;
		private var rect:Rectangle;
		private var clicked:Boolean;
		private var show:Boolean;
		private var bsdoRef:BitmapSpriteDisplayObject;
		
		public function Show() {
			show = true;
		}
		public function Hide() {
			show = false;
			
		}
		public function MyButton(rectangle:Rectangle, dImage:Class, uImage:Class, bsdo:BitmapSpriteDisplayObject) {
			
			bsdoRef = bsdo;
			rect = rectangle;
			isDown = false;
			downImage = new Image(dImage,bsdo);
			upImage = new Image(uImage, bsdo);
			downImage.move(-900,-900);
			upImage.move(-900,-900);
			clicked = false;
			show = false;
		}
		public function onMouseDown( event: MouseEvent ): void {
			if (rect.contains(event.stageX,event.stageY))
				isDown = true;
			else
				isDown = false;
		}
		public function onMouseUp( event: MouseEvent ): void {
			isDown = false;
		}
		public function onMouseMove(event:MouseEvent):void {
			if (!rect.contains(event.stageX,event.stageY))
				isDown = false;	
			
		}
		public function onEnterFrame(event:Event):void {
			if (!show)
				return;
			if (isDown)
				bsdoRef.bitmapData.copyPixels(downImage.bitmap.bitmapData,new Rectangle(0,0,rect.width,rect.height),new Point(rect.x, rect.y),null,null,true);
			else
				bsdoRef.bitmapData.copyPixels(upImage.bitmap.bitmapData,new Rectangle(0,0,rect.width,rect.height),new Point(rect.x, rect.y),null,null,true);
		}
		public function onMouseClick(event:MouseEvent):void {
			if (!show)
				return;
			if (rect.contains(event.stageX,event.stageY))
				clicked = true;
			else
				clicked = false;
		}
		public function isClicked():Boolean {
			if (clicked) {
				clicked = false
				return true;
			} else
				return false;
		}
		public function addListeners(stage:Stage):void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.CLICK,onMouseClick);
			stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
		}
	}
}