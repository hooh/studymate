package com.studyMate.world.screens.offPictureBook
{
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.BookFaceShow2ViewMediator;
	import com.studyMate.world.screens.CleanGpuMediator;
	import com.studyMate.world.screens.EBookNewView2Mediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	public class OffBookFaceShowMediator extends BookFaceShow2ViewMediator
	{
		public const NAME:String = 'OffBookFaceShowMediator';
		public function OffBookFaceShowMediator(viewCompoent:Object=null)
		{
			super(viewCompoent);
			super.mediatorName = NAME;
		}
		
		override public function handleNotification(notification:INotification):void{
			
		}
		override public function listNotificationInterests():Array{
			return [];
		}
		
		override protected function enterBookHandler(event:MouseEvent=null):void
		{
			if(item){					
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(OffEbookNewView2Mediator,item),new SwitchScreenVO(CleanGpuMediator)]);
			}
		}
		
		override protected function delHandler(event:MouseEvent):void
		{
			
		}
		
		override protected function panelShow():void
		{
			view.DownLoadFlagBtn.visible = false;
			view.delTxt.visible = false;
		}
		
		
	}
}