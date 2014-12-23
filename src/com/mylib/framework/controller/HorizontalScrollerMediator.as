package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class HorizontalScrollerMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "HorizontalScrollerMediator";
		
		private var stageWidth:int;
		public var targetX:int;
		
		private var dragging:Boolean;
		
		private var mouseDownX:Number;
		private var downTime:int;
		private var offsetX:Number=0;
		
		public var leftEdge:int;
		public var rightEdge:int;
		
		public var currentX:Number;
		
		private var halfWidth:int;
		
		public var ocurrentX:Number;
		//控制拖动方向
		private var dir:int=1;
		
		private var hotY:int;
		
		
		public function HorizontalScrollerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			if(view.stage.hasEventListener(TouchEvent.TOUCH))
				view.stage.removeEventListener(TouchEvent.TOUCH,onTransform);
			view.dispose();
		}
		
		override public function onRegister():void
		{
			init();
		}
		
		private function init():void{
			stageWidth = Global.stageWidth;
			
			halfWidth  = stageWidth>>1;
			targetX = 0;
			currentX = 0;
			
			view.stage.addEventListener(TouchEvent.TOUCH,onTransform);
			runEnterFrames = true;
			
		}
		
		protected function onTransform(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(hotY>0&&touch.globalY>hotY){
				return;
			}
			
			if (touch.phase == TouchPhase.BEGAN)
			{
				mouseDownX =  touch.globalX;
				downTime = getTimer();
				ocurrentX = currentX;
				offsetX = 0;
			}else if(touch.phase == TouchPhase.MOVED){
				offsetX = ( touch.globalX - mouseDownX)*dir;
				
				if(!dragging&&(offsetX>20||offsetX<-20)){
					dragging = true;
				}
				
				
			}
			else if (touch.phase == TouchPhase.ENDED){
				dragging = false;
				
				if(Math.abs(offsetX)<10){
					return;
				}
				
				var t:int = getTimer() - downTime;
				var speed:Number = offsetX/t;
				targetX=ocurrentX+offsetX+speed*50;
				
				if(targetX<-rightEdge){
					targetX=-rightEdge;
				}else if(targetX>-leftEdge){
					targetX=-leftEdge;
				}
				
				
				
				
			}
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			switch(name)
			{
				case WorldConst.CHANGE_HSCROLL_DIRECTION:
				{
					
					dir = notification.getBody() as int;
					
					
					
					break;
				}
				case WorldConst.SET_ROLL_SCREEN : 
					var enable:Boolean = notification.getBody() as Boolean;
					if(enable){
						view.stage.addEventListener(TouchEvent.TOUCH,onTransform);
					}else{
						view.stage.removeEventListener(TouchEvent.TOUCH,onTransform);
					}
					break;
				case WorldConst.SET_HSCROLL_RL:{
					rightEdge = (notification.getBody() as Array)[0];
					leftEdge = (notification.getBody() as Array)[1];
					
					break;
				}
				case WorldConst.SET_ROLL_TARGETX:{
					targetX = notification.getBody() as int;
					
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.CHANGE_HSCROLL_DIRECTION,WorldConst.SET_ROLL_SCREEN,WorldConst.SET_ROLL_TARGETX,WorldConst.SET_HSCROLL_RL];
		}
		
		
		override public function advanceTime(time:Number):void
		{
			var radio:Number;
			if(dragging){
				radio = 1;
				if(offsetX<0&&currentX<-rightEdge){
					radio=0.5;
				}else if(offsetX>0&&currentX>-leftEdge){
					radio=0.5;
				}
				targetX = ocurrentX+radio*offsetX;
				
			}
			var step:Number = (targetX-currentX)*0.1;
			
			if(step<0.001&&step>-0.001){
				return;
			}
			
			currentX +=step;
			sendNotification(WorldConst.UPDATE_CAMERA,int(currentX));
			
			
		}
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			rightEdge = vo.data[0] as int;
			leftEdge = vo.data[1] as int;
			
			if((vo.data as Array).length>2){
				hotY = vo.data[2];
			}
			
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
	}
}