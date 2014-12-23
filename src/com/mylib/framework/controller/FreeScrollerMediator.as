package com.mylib.framework.controller
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.vo.TransformVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class FreeScrollerMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "FreeScrollerMediator";
		
		private var stageWidth:int;
		private var stageHeight:int;
		public var centerX:Number;
		public var centerY:Number;
		public var targetX:int;
		public var targetY:int;
		
		private var dragging:Boolean;
		
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		private var downTime:int;
		private var offsetX:Number=0;
		private var offsetY:Number = 0;
		
		private var edge:Rectangle;
		
		private var currentPoint:Point;
		private var halfWidth:int;
		private var halfHeight:int;
		
		private var ocurrentX:Number;
		private var ocurrentY:Number;
		//控制拖动方向
		private var dir:int=1;
		
		private var beginMark:Boolean;
		
		private var vo:TransformVO;
		
		public var radioXL:Number=0.5;
		public var radioXR:Number=0.5;
		public var radioYU:Number=0.5;
		public var radioYD:Number=0.5;
		public var speed:Number;
		
		private var prepareVO:SwitchScreenVO;
		public var updateNotice:String = WorldConst.UPDATE_CAMERA;
		
		public static const GO:String = "go";
		public var goNotice:String;
		
		public function FreeScrollerMediator(mediatorName:String=null,viewComponent:Object=null)
		{
			var mname:String = mediatorName;
			mname?updateNotice=mediatorName+updateNotice:mname = NAME;
			goNotice = mediatorName+GO;
			
			super(mname, viewComponent);
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
			stageWidth = WorldConst.stageWidth;
			stageHeight = WorldConst.stageHeight;
			
//			halfWidth = centerX = stageWidth>>1;
//			halfHeight = centerY = stageHeight>>1;
			
			targetX = centerX =0;
			targetY = centerY =0;
			
			speed = 1;
			
			
			if(view.stage)
			view.stage.addEventListener(TouchEvent.TOUCH,onTransform);
			runEnterFrames = true;
			
		}
		
		protected function onTransform(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			if(touch){
				
				
				
				if (touch.phase == TouchPhase.BEGAN)
				{
					if(vo.mask&&!vo.mask.contains(touch.globalX,touch.globalY)){
						beginMark = false;
						return;
					}
					mouseDownX =  touch.globalX;
					mouseDownY = touch.globalY;
					downTime = getTimer();
					ocurrentX = currentPoint.x;
					ocurrentY = currentPoint.y;
					offsetX = 0;
					offsetY = 0;
					beginMark = true;
				}else if(touch.phase == TouchPhase.MOVED){
					
					if(!beginMark){
						return;
					}
					
					offsetX = ( touch.globalX - mouseDownX)*dir;
					offsetY = ( touch.globalY - mouseDownY)*dir;
					
					
					if(!dragging&&((offsetX>20||offsetX<-20)||(offsetY>20||offsetY<-20))){
						dragging = true;
					}
					
				}
				else if (touch.phase == TouchPhase.ENDED){
					dragging = false;
					
					if(!beginMark){
						return;
					}
					
					var t:int = getTimer() - downTime;
					speed = Math.sqrt(offsetX*offsetX+offsetY*offsetY)/t;
					
					targetX=ocurrentX+offsetX;
					targetY=ocurrentY+offsetY;
					
					if(targetX<centerX-edge.width){
						targetX=centerX-edge.width;
					}else if(targetX>centerX-edge.x){
						targetX=centerX-edge.x;
					}
					
					if(targetY<centerY+edge.y){
						targetY=centerY+edge.y;
					}else if(targetY>centerY+edge.height){
						targetY=centerY+edge.height;
					}
					
					
					
					
				}
			}
			
			
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			switch(name)
			{
				case WorldConst.HIDE_SETTING_SCREEN :
					prepareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
					break;
				case WorldConst.CHANGE_HSCROLL_DIRECTION:
				{
					
					dir = notification.getBody() as int;
					
					
					
					break;
				}
				case WorldConst.SET_ROLL_SCREEN : 
					var enable:Boolean = notification.getBody() as Boolean;
					if(enable){
						view.stage.addEventListener(TouchEvent.TOUCH,onTransform);
						targetX = currentPoint.x;
						targetY = currentPoint.y;
						runEnterFrames = true;
						
					}else{
						view.stage.removeEventListener(TouchEvent.TOUCH,onTransform);
						runEnterFrames = false;
						beginMark = false;
					}
					break;
				case goNotice:{
					
					targetX = (notification.getBody() as Point).x;
					targetY = (notification.getBody() as Point).y;
					
					
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
			return [WorldConst.CHANGE_HSCROLL_DIRECTION,WorldConst.SET_ROLL_SCREEN, WorldConst.HIDE_SETTING_SCREEN,goNotice];
		}
		
		
		override public function advanceTime(time:Number):void
		{
			var radio:Number;
			if(dragging){
				radio = 1;
//				trace(currentPoint);
				if(offsetX<0&&currentPoint.x<centerX+edge.width){
					radio = radioXL;
				}else if(offsetX>0&&currentPoint.x>centerX-edge.x){
					radio = radioXR;
				}
				targetX = ocurrentX+radio*offsetX;
				
				
				radio = 1;
				if(offsetY<0&&currentPoint.y<centerY+edge.y){
					radio = radioYU;
				}else if(offsetY>0&&currentPoint.y>centerY+edge.height){
					radio = radioYD;
				}
				targetY = ocurrentY+radio*offsetY;
				
				
			}
			var stepX:Number = (targetX-currentPoint.x)*0.1;
			var stepY:Number = (targetY-currentPoint.y)*0.1;
			
			if(stepX<0.05&&stepX>-0.05&&stepY<0.05&&stepY>-0.05){
				return;
			}
			speed*=0.9;
			
			
			currentPoint.x +=stepX;
			currentPoint.y +=stepY;
			
//			point.setTo(int(centerX-currentX),int(centerY-currentY));
			
			sendNotification(updateNotice,currentPoint);
			
			
		}
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			edge = (vo.data as TransformVO).range;
			currentPoint = (vo.data as TransformVO).location;
			this.vo = vo.data as TransformVO;
			prepareVO = vo;
			
			if(this.vo.radio){
				radioXL = this.vo.radio.radioXL;
				radioXR = this.vo.radio.radioXR;
				radioYU = this.vo.radio.radioYU;
				radioYD = this.vo.radio.radioYD;
			}
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
	}
}