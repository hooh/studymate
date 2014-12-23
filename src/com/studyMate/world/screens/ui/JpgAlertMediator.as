package com.studyMate.world.screens.ui
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SwitchScreenProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.UserPerDataMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GesturePhase;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	
	/**
	 * note
	 * 2014-12-11下午4:44:45
	 * Author wt
	 *
	 */	
	
	public class JpgAlertMediator extends ScreenBaseMediator
	{
		private var loader:Loader;
		private var holder:Sprite;
		private var vo:SwitchScreenVO;
		private var parentScreen:ScreenBaseMediator;
		
		public function JpgAlertMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super("JpgAlertMediator", viewComponent);
		}
		
		override public function onRemove():void
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

			var switchProxy:SwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as SwitchScreenProxy;
			switchProxy.currentGpuScreen = parentScreen;
			sendNotification(UserPerDataMediator.JPGALERT_CLOSE);
			TweenLite.killTweensOf(holder);
			Global.stage.removeEventListener(MouseEvent.DOUBLE_CLICK,DoubleClickHandler);
			Global.stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom);//屏幕放大
			super.onRemove();
		}
		
		override public function onRegister():void
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;	
			holder = new Sprite();
			view.addChild(holder);
			
			loader = new Loader();	
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,LoaderComHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(new URLRequest(vo.data as String));
			holder.addChild(loader);	
			
			var switchProxy:SwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as SwitchScreenProxy;
			parentScreen = switchProxy.currentGpuScreen;
			switchProxy.currentGpuScreen = this;
			
			view.addEventListener(MouseEvent.MOUSE_UP,stopDragging);
			
			backHandle = keybackHandle;
		}
		private function keybackHandle():void{	
			vo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[vo]);							
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			sendNotification(CoreConst.TOAST,new ToastVO("图片文件不存在！"));
			keybackHandle();
		}
		
		protected function LoaderComHandler(event:Event):void
		{
			loader.width = Global.stageWidth;
			loader.height = Global.stageHeight;		
			
			Global.stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom);//屏幕放大
		}
		
		
		//屏幕放大功能
		private var scaleNum:Number = 1;
		private var p:Point;
		private var olderScaleX:Number;
		private var olderX:Number;
		private var olderY:Number;
		private var isZoomed:Boolean = false;

		protected function onZoom(e:TransformGestureEvent):void{
			scaleNum = (e.scaleY+e.scaleX)/2;	
			//scaleNum = e.scaleY;
			if(e.phase==GesturePhase.BEGIN){
				p = new Point( e.stageX, e.stageY );
				isZoomed = true;
				olderScaleX = holder.scaleX;
				olderX = holder.x;
				olderY = holder.y;
				view.stopDrag();
				Global.stage.removeEventListener(MouseEvent.DOUBLE_CLICK,DoubleClickHandler);
				
			}else if(e.phase==GesturePhase.UPDATE){
				if(holder.scaleX*scaleNum>5){
					holder.scaleX = 5;
					holder.scaleY=5;
				}else{
					holder.scaleX = holder.scaleY *= scaleNum;
					holder.x = p.x- (p.x - olderX)*holder.scaleX/olderScaleX;
					holder.y = p.y- (p.y - olderY)*holder.scaleX/olderScaleX;
				}
				
			}else if(e.phase==GesturePhase.END){
				if(holder.scaleX<=1.2){
					if(holder.scaleX!=1){
						TweenLite.to(holder,0.5,{scaleX:1,scaleY:1,x:0,y:0});
					}
					view.stopDrag();
					isZoomed = false;
				}else{
					view.addEventListener(MouseEvent.MOUSE_DOWN,startDragging);//屏幕拖动
				}
			}		　　			
		}
		protected function startDragging(e:MouseEvent):void{
			if(isZoomed){
				var a:Number = holder.scaleX*Global.stageWidth -Global.stageWidth;
				var b:Number = holder.scaleY*Global.stageHeight - Global.stageHeight;
				var rect:Rectangle = new Rectangle(-a,-b,a,b);
				holder.startDrag(false,rect);				
				Global.stage.addEventListener(MouseEvent.DOUBLE_CLICK,DoubleClickHandler);
			}
		}		
		protected function stopDragging(event:MouseEvent):void{
			if(isZoomed){
				holder.stopDrag();
			}
		}
		private function DoubleClickHandler(e:MouseEvent):void{
			Global.stage.removeEventListener(MouseEvent.DOUBLE_CLICK,DoubleClickHandler);
			view.stopDrag();
			holder.scaleX = 1;
			holder.scaleY = 1;
			isZoomed = false;
			holder.x = 0;
			holder.y = 0;
		}
		
		public function get view():Sprite{
			return viewComponent as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{			
			this.vo = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
			
		}
	}
}