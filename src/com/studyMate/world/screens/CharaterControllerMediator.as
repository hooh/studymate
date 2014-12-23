package com.studyMate.world.screens
{
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.studyMate.world.screens.ui.CharaterInterativeObject;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class CharaterControllerMediator extends Mediator
	{
		
		public static const NAME:String = "CharaterControllerMediator";
		public static const UPDATE_CHARATER_CONTROLHOLDER:String = "UpdateCharaterControlHolder";

		private var controller:IslanderControllerMediator;
		
		private var point:Point;
		
		private var range:Rectangle;


		
		private var targetObj:CharaterInterativeObject;
		private var preMoveTime:int;
		private var mark:DisplayObject;
		
		private var startPoint:Point;
		
		private var bgToucher:Quad;
		private var triggerMark:Boolean;
		
		private var rigClickZone:int; //右边最远行走空间，用户扩大点击范围

		public function CharaterControllerMediator(viewComponent:Object,range:Rectangle)
		{
			super(NAME, viewComponent);
			this.range = range;
			bgToucher = new Quad(range.width+640,range.height+130);
			bgToucher.alpha = 0;
		}
		override public function onRegister():void
		{
			point = new Point();
			
			preMoveTime = 0;
			startPoint = new Point();
			
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.ADD_CHARATER_CONTROL:
				{
					
					controller = notification.getBody() as IslanderControllerMediator;
					controller.charater.view.addEventListener(TouchEvent.TOUCH,charaterHandle);
					
					bgToucher.addEventListener(TouchEvent.TOUCH,triggeredHandle);
					bgToucher.x = range.x;
					bgToucher.y = range.y-30;
					view.addChild(bgToucher);
					
					rigClickZone = range.width - (Math.abs(range.x));
					break;
				}
				case WorldConst.UPDATE_PLAYER_MARK:{
					mark = notification.getBody() as DisplayObject;
					break;
				}
				case UPDATE_CHARATER_CONTROLHOLDER:
					var ran:Rectangle = notification.getBody() as Rectangle;
					bgToucher.x = ran.x;
					bgToucher.y = ran.y-30;
					bgToucher.width = ran.width+640;
					bgToucher.height = ran.height+130;
					
					rigClickZone = ran.width - (Math.abs(ran.x));
					break;
			}
			
		}
		override public function listNotificationInterests():Array
		{
			return [WorldConst.ADD_CHARATER_CONTROL,WorldConst.UPDATE_PLAYER_MARK,UPDATE_CHARATER_CONTROLHOLDER];
		}
		private var preTime:Number=0;
		private function triggeredHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(view);
			if(touch){
				
				if(touch.phase ==TouchPhase.BEGAN){
					if(preTime == 0){
						preTime = new Date().getTime();
						controller.charater.velocity = 3.5;
					}else{
						var nowTime:Number = new Date().getTime();
						//快速点击，人物加速
						if( nowTime-preTime < 200)	controller.charater.velocity += 0.5;
						else	controller.charater.velocity = 3.5;
						preTime = nowTime;
					}
					
					
					triggerMark = true;
					touch.getLocation(view,startPoint);
				}else if(touch.phase==TouchPhase.MOVED){
					touch.getLocation(view,point);
					
					if(point.x>startPoint.x+10||point.x<startPoint.x-10||point.y>startPoint.y+10||point.y<startPoint.y-10){
						triggerMark = false;
					}
					
				}else if(touch.phase==TouchPhase.ENDED){
					if(triggerMark && !isNaN(point.x) && !isNaN(point.y)){
						triggerMark = false;
						sendNotification(WorldConst.STOP_PLAYER_TALKING);
						touch.getLocation(view,point);
						if(controller.charater)
							controller.charater.idle();
						
						var goX:Number;
						var goY:Number;
						
						if(point.x > rigClickZone)	goX = rigClickZone;
						else	goX = point.x;
						
						
						if(point.y < range.y)	goY = range.y;
						else if(point.y > range.y+range.height)	goY = range.y+range.height;
						else	goY = point.y;
						
						
						controller.go(goX,goY);
					}
				}
			}
		}
		
		private var curentY:Number;
		private function charaterHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				
				if(touch.phase ==TouchPhase.BEGAN){
					curentY = touch.globalY;
					
				}else if(touch.phase==TouchPhase.ENDED){
					if((touch.globalY - curentY) >= 50){
						if(controller.charater)
							(controller.charater as IHuman).sit();
						
					}else if((touch.globalY - curentY) <= -50){
						if(controller.charater)
							controller.charater.idle();
					}
				}
			}
		}


		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function onRemove():void
		{
			bgToucher.removeEventListeners();
			bgToucher.removeFromParent(true);
			bgToucher.removeEventListener(TouchEvent.TOUCH,triggeredHandle);
			
			if(controller && controller.charater)
				controller.charater.view.removeEventListener(TouchEvent.TOUCH,charaterHandle);
		}
	}
}