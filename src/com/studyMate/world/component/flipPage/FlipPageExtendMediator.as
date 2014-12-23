package com.studyMate.world.component.flipPage
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.FlipPageData;
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.screens.FlipPageMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	
	/**
	 * 继承关系 实现初始化到指定的页数
	 * 2014-7-22上午9:46:14
	 * Author wt
	 *
	 */	
	
	public class FlipPageExtendMediator extends FlipPageMediator
	{
		public function FlipPageExtendMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			data = vo.data.FlipPageData as FlipPageData;
			total = data.pages.length;
			index = vo.data.index as int;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override protected function initialization():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ChapterSeleterExtendMediator,{totalPage:total,curChapterIdx:index},SwitchScreenType.SHOW,view,0,0,-1)]);
			updatePosition();
//			camera.moveTo(0,0,1,0,true);
			if(index==0){//第一页
				if(total > 0){
					displayPage(data.pages[0]);
					currentHolder.addChild(data.pages[0].view);
				}
				if(total>1){
					displayPage(data.pages[1]);
					nextHolder.addChild(data.pages[1].view);
				}
			}else if(index == total-1){//最后一页
					displayPage(data.pages[total-1]);
					currentHolder.addChild(data.pages[total-1].view);
					displayPage(data.pages[total-2]);
					preHolder.addChild(data.pages[total-2].view);
			}else{
				displayPage(data.pages[index]);
				currentHolder.addChild(data.pages[index].view);
				displayPage(data.pages[index-1]);
				preHolder.addChild(data.pages[index-1].view);
				displayPage(data.pages[index+1]);
				nextHolder.addChild(data.pages[index+1].view);
			}
			temp = data.pages[index];
//			(data.pages[index] as IFlipPageRendererExtends).startLoad();
			TweenLite.killDelayedCallsTo(startLoad);
			TweenLite.delayedCall(0.5,startLoad);
		}
		
//		override public function handleNotification(notification:INotification):void
//		{
//			switch(notification.getName()){
//				case LazyLoad.QUEUE_LOAD_COMPLETE:
//					if(temp)
//						(temp as IFlipPageRendererExtends).clearLoad();
//					sendNotification(WorldConst.SET_ROLL_SCREEN,true);
//					return;
//				/*case LazyLoad.QUEUE_LOAD_START:
//					
//					return;*/
//			}
//			super.handleNotification(notification);
//		}
//		
//		override public function listNotificationInterests():Array
//		{
//			return super.listNotificationInterests().concat([LazyLoad.QUEUE_LOAD_COMPLETE]);
//		}
		
		private var temp:IFlipPageRenderer;
		override protected function roll():void
		{
//			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			if(temp){				
				(temp as IFlipPageRendererExtends).clearLoad();
			}
			super.roll();
			if(data.pages[index]){
				temp = data.pages[index];
			}
			
			TweenLite.killDelayedCallsTo(startLoad);
			TweenLite.delayedCall(0.6,startLoad);
			
		}
		
		private function startLoad():void
		{
			(data.pages[index] as IFlipPageRendererExtends).startLoad();	
			
		}
		
		override protected function rollBack():void
		{
//			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			if(temp){		
				(temp as IFlipPageRendererExtends).clearLoad();
			}
			super.rollBack();
			if(data.pages[index]){
				temp = data.pages[index];
			}
			
			TweenLite.killDelayedCallsTo(startLoad);
			TweenLite.delayedCall(0.6,startLoad);
		}
		
		override public function onRemove():void
		{
			TweenLite.killDelayedCallsTo(startLoad);
			super.onRemove();
		}
		

		
		
		
		
		
	}
}