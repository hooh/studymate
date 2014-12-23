package com.mylib.game.drawing
{
	import com.mylib.framework.CoreConst;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Graphics;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.graphics.Graphic;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class DrawingColorPicker extends Sprite implements IMediator
	{
		private static const NAME:String = "DrawingColorPicker";
		public static const SELECT_COLOR:String = "selectColor";
		private var multitonKey:String;
		private var colors:Array = [0xf42b35,0xffa200,0xfed500,0xa8be11,0x2db52f,0x00aab4,
		0x325bc5,0xfad0de,0x946d9a,0x885e38,0x8e959b,0x000000
		];
		
		private const ICON_W:int = 40;
		
		private const ICON_GAP:int = 20;
		
		private var graphics:Graphics;
		
		private var hots:Vector.<Rectangle>;
		private var helperPoint:Point;
		
		private var selectMarker:Sprite;
		private var selectMarkerGraphics:Graphics;
		
		public var selectedColor:uint;
		
		
		
		public function DrawingColorPicker()
		{
			super();
			
			hots = new Vector.<Rectangle>;
			helperPoint = new Point;
			
			graphics = new Graphics(this);
			for (var i:int = 0; i < colors.length; i++) 
			{
				
				graphics.beginFill(colors[i]);
				
				var rec:Rectangle = new Rectangle((i%6)*(ICON_W+ICON_GAP),Math.floor(i/6)*(ICON_W+ICON_GAP),ICON_W,ICON_W);
				
				
				graphics.drawRect(rec.x,rec.y,rec.width,rec.height);
				
				hots.push(rec);
				
			}
			
			selectMarker = new Sprite;
			addChild(selectMarker);
			selectMarkerGraphics = new Graphics(selectMarker);
			selectMarkerGraphics.lineStyle(2,0xffffff);
			selectMarkerGraphics.drawRect(2,2,ICON_W-4,ICON_W-4);
			selectMarkerGraphics.endFill();
			
			
			addEventListener(TouchEvent.TOUCH,touchHandle);
			
			selectIdx(colors.length-1);
		}
		
		private function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this,TouchPhase.ENDED);
			
			if(touch){
				touch.getLocation(this,helperPoint);
				
				for (var i:int = 0; i < hots.length; i++) 
				{
					if(hots[i].containsPoint(helperPoint)){
						break;
					}
				}
				
				if(i<colors.length){
					selectIdx(i);
				}
			}
			
			
			
			
		}		
		
		private function selectIdx(idx:int):void{
			selectedColor = colors[idx];
			selectMarker.x = hots[idx].x;
			selectMarker.y = hots[idx].y;
			
			sendNotification(SELECT_COLOR,selectedColor);
		}
		
		
		public function getMediatorName():String
		{
			return NAME;
		}
		
		public function getViewComponent():Object
		{
			return this;
		}
		
		public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function onRegister():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function onRemove():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function setViewComponent(viewComponent:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function initializeNotifier(key:String):void
		{
			multitonKey = key;
		}
		
		public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(notificationName,body,type);
		}
		
	}
}