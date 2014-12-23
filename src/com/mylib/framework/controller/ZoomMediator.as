package com.mylib.framework.controller
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.vo.TransformVO;
	import com.mylib.framework.controller.vo.ZoomResultVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.gestouch.core.GestureState;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.ZoomGesture;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	
	public class ZoomMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ZoomMediator";
		private var  zoom:ZoomGesture;
		private var offsetScale:Number;
		private var targetScale:Number;
		private var ocurrentScale:Number;
		
		private var result:ZoomResultVO;
		
		private var currentPoint:Point;
		private var ox:int;
		private var oy:int;
		
		private var halfWidth:int;
		private var halfHeight:int;
		private var edge:Rectangle;
		private var vo:TransformVO;
		private var prepareVO:SwitchScreenVO;
		
		
		public function ZoomMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			
			currentPoint = (vo.data as TransformVO).location;
			
			edge = (vo.data as TransformVO).range;
			
			this.vo = vo.data as TransformVO;
			
			prepareVO = vo;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
			
			
		}
		
		override public function onRemove():void
		{
			zoom.dispose();
		}
		
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRegister():void
		{
			result = new ZoomResultVO(0,new Point);
			zoom = new ZoomGesture(view.stage);
			
			zoom.addEventListener(GestureEvent.GESTURE_BEGAN, onZoomPress);
			zoom.addEventListener(GestureEvent.GESTURE_STATE_CHANGE, onZoomPress);
			zoom.addEventListener(GestureEvent.GESTURE_ENDED, onZoomPress);
			
			targetScale = ocurrentScale  = vo.scale = 1;
			offsetScale = 0;
			
			
			halfWidth  = WorldConst.stageWidth>>1;
			halfHeight = WorldConst.stageHeight>>1;
			
//			runEnterFrames = true;
		}
		
		override public function listNotificationInterests():Array
		{
			return[WorldConst.HIDE_SETTING_SCREEN]
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.HIDE_SETTING_SCREEN:
					prepareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
					break;
			}
		}
		
		protected function onZoomPress(event:GestureEvent):void
		{
			var gesture:ZoomGesture = event.target as ZoomGesture;
			
			if(event.newState==GestureState.BEGAN){
				sendNotification(WorldConst.SET_ROLL_SCREEN,false);
				ocurrentScale = vo.scale;
				offsetScale = 0;
				ox = currentPoint.x;
				oy = currentPoint.y;
				
				
				
			}else if(event.newState==GestureState.CHANGED){
				var t:Number=0;
				if(gesture.scaleX>=1&&gesture.scaleY>=1){
					gesture.scaleX>gesture.scaleY?t = gesture.scaleX: t = gesture.scaleY;
				}else if(gesture.scaleX<=1&&gesture.scaleY<=1){
					gesture.scaleX<gesture.scaleY?t = gesture.scaleX: t = gesture.scaleY;
				}
				
				offsetScale+=t-1;
				
				vo.scale = offsetScale+ocurrentScale;
				
				result.location=gesture.location;
				
				
				if(vo.scale>vo.maxScale){
					vo.scale = vo.maxScale;
				}else if(vo.scale<vo.minScale){
					vo.scale = vo.minScale;
				}
				
				result.scale = vo.scale;
				
				
				var edgeWidth:int = WorldConst.stageWidth*(vo.scale-1)>>1;
				var edgeHeight:int = WorldConst.stageHeight*(vo.scale-1)>>1;
				edge.setTo(-edgeWidth,-edgeHeight,2*edgeWidth,2*edgeHeight);
				
				
				
				currentPoint.setTo(0,0);
				
				sendNotification(WorldConst.UPDATE_SCALE,result);
				
				
				
			}else if(event.newState==GestureState.ENDED){
				resetScroll();
			}
		}		
		
		
		private function updateLocation(_x:int,_y:int):void{
			
		}
		
		private function resetScroll():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function advanceTime(time:Number):void
		{
			
			if(targetScale>2){
				targetScale=2;
			}else if(targetScale<1){
				targetScale = 1;
			}
			
			
			var step:Number = (targetScale-vo.scale)*0.05;
			
			if(step<0.001&&step>-0.001){
				return;
			}
			
			vo.scale +=step;
			
			result.scale = vo.scale;
			
			
			sendNotification(WorldConst.UPDATE_SCALE,result);
			
			
			
		}
		
		
		
	}
}