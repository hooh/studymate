package com.studyMate.world.component.flipPage
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.ChapterSeleterMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.Event;
	
	
	/**
	 * note
	 * 2014-7-22上午10:47:56
	 * Author wt
	 *
	 */	
	
	public class ChapterSeleterExtendMediator extends ChapterSeleterMediator
	{
		public function ChapterSeleterExtendMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		private var curChapterIdxTemp:uint;
		override public function prepare(vo:SwitchScreenVO):void
		{
			totalPage = vo.data.totalPage as int;
			curChapterIdxTemp = vo.data.curChapterIdx as uint;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override protected function createChapters():void{
			super.createChapters();
			curChapterIdx = curChapterIdxTemp;
		}
		
		override protected function addToStageHandle(event:starling.events.Event):void
		{
			super.addToStageHandle(event);
			curChapter.x = centerX;
			
			sendNotification(WorldConst.UPDATE_CAMERA,int(curChapterIdx*centerX*2));

		}
		
		
	}
}