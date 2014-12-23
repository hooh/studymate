package  com.studyMate.world.component.MydragMethod
{
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * 使用说明
	 * @author wangtu
	 *  var LeftUIDrag:MyDragFunc = new MyDragFunc(LeftUI);
	 LeftUIDrag.addEventListener(MyDragEvent.START_EFFECT,leftStartEffectHandler);
	 LeftUIDrag.addEventListener(MyDragEvent.END_EFFECT,leftEndEffectHandler);
	 * 
	 */	
	
	public class MyDragFunc extends  EventDispatcher  {
		private var _target:DisplayObject;
		private var _delay:Number;
		
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		private var draging:Boolean;
		
		/**
		 * @param target 需要注册的组件
		 * @param delay 特效延迟的时长
		 */		
		public function MyDragFunc(target:DisplayObject,delay:Number=0.6) {
			_target = target;
			_delay = delay;
			
			_target.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownClick);//注册按下,默认冒泡,可以被拦截
			_target.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
		}
		
		/**
		 *  第一步MouseDown
		 */		
		private function mouseDownClick(e:MouseEvent):void{
			TweenLite.delayedCall(_delay,onComp,[e]);
//			mouseDownX = _target.mouseX;
//			mouseDownY = _target.mouseY
			mouseDownX = e.stageX;
			mouseDownY = e.stageY;
			_target.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);//注册滑动
			_target.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpClick,true);//注册松手,捕获，使其优先处理结束特效
			if(_target is SimpleButton){
				e.stopPropagation();
			}
		}
		
		/**
		 *  第二步 分支 1 MmouseMove
		 */		
		private function mouseMoveHandler(e:MouseEvent):void{
//			if(Math.abs(_target.mouseX-mouseDownX)>10 || Math.abs(_target.mouseY-mouseDownY)>10  ){
			if(Math.abs(e.stageX-mouseDownX)>10 || Math.abs(e.stageY-mouseDownY)>10  ){
				TweenLite.killTweensOf(onComp);
				_target.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);//移除滑动
			}
		}
		
		/**
		 * 派发事件，开始特效
		 */		
		private function onComp(e:MouseEvent):void{
			//trace("派发拖动");
			draging = true;
			_target.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);//移除滑动
			
			dispatchEvent(new MyDragEvent(MyDragEvent.START_EFFECT,e.localX,e.localY));
			if(!hasEventListener(MyDragEvent.START_EFFECT))
				throw new Error("请注册开始拖动侦听:MyDragEvent.START_EFFECT");
		}
		
		/**
		 * 第三步 MouseUp
		 */		
		private function mouseUpClick(e:MouseEvent):void{	
			TweenLite.killTweensOf(onComp);
			_target.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpClick,true); //移除松手
			if(_target.hasEventListener(MouseEvent.MOUSE_MOVE)){
				_target.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);//注册滑动
			}
			if(draging){
				//trace("停止派发");
				dispatchEvent(new MyDragEvent(MyDragEvent.END_EFFECT));
				draging =false;
			}
			
			if(!hasEventListener(MyDragEvent.END_EFFECT))
				throw new Error("请注册结束侦听:MyDragEvent.END_EFFECT");
		}
		
		private function removeFromStageHandler(e:Event):void{
			_target.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			_target.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownClick);//移除按下
			if(_target.stage.hasEventListener(MouseEvent.MOUSE_UP))
				_target.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpClick,true);//注册松手
			TweenLite.killTweensOf(onComp);
			_target=null;
		}

		public function get target():DisplayObject
		{
			return _target;
		}

		
	}
}
