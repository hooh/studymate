package com.studyMate.world.screens.component
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.ui.QueueDownMediator;
	import com.studyMate.world.screens.ui.SendDelayMediator;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;

	/**
	 * 资源列表基类
	 * 
	 * 把下载、通信、刷新进度等简化出来
	 * 
	 * @author wangtu
	 * 
	 */	
	public class BaseResTableMediator extends ScreenBaseMediator
	{
		protected var process:int;
		protected var total:Number;
		
		protected var sendDelayMediator:SendDelayMediator;
		protected var queueDownMediator:QueueDownMediator;
		
		private var loadTime:Timer;
		
		public function BaseResTableMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}		
		override public function onRemove():void
		{
			facade.removeMediator(SendDelayMediator.NAME);
			facade.removeMediator(QueueDownMediator.NAME);
			if(loadTime){
				loadTime.stop();
				loadTime.removeEventListener(TimerEvent.TIMER, timerHandler);
				loadTime = null;
			}
			super.onRemove();
		}
		override public function onRegister():void
		{
			sendDelayMediator = new SendDelayMediator();
			queueDownMediator = new QueueDownMediator();
			facade.registerMediator(sendDelayMediator);			
			facade.registerMediator(queueDownMediator);
			
			this.backHandle = quitHandler;
		}
		
		protected function quitHandler():void{//先停止消息后，再退出						
//			sendDelayMediator.execute(sendNotification,[WorldConst.POP_SCREEN]);
			sendNotification(WorldConst.POP_SCREEN);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case CoreConst.LOADING_PROCESS:
					process =notification.getBody() as int;
					if(loadTime==null){
						loadTime = new Timer(2000);
						loadTime.start();
						loadTime.addEventListener(TimerEvent.TIMER, timerHandler);
					}				
					break;
				case CoreConst.LOADING_TOTAL:
					var num:Number = notification.getBody() as Number;
					if(num) total = num;
					break;
				case WorldConst.CURRENT_DOWN_COMPLETE:///下载完成
					if(loadTime){
						loadTime.stop();
						loadTime.removeEventListener(TimerEvent.TIMER, timerHandler);
						loadTime = null;
					}
					break;
					
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.LOADING_PROCESS,CoreConst.LOADING_TOTAL,WorldConst.CURRENT_DOWN_COMPLETE];
		}							
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		private function timerHandler(e:TimerEvent):void{
			if(total){
				updateLoadingHandler();
			}
		}
		// 该函数为降低刷新List频率,由子类继承下改变状态
		protected function updateLoadingHandler():void
		{
			
		}
	
	}
}