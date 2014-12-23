package com.studyMate.world.screens.offPictureBook
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.component.BookPicture;
	import com.studyMate.world.events.ShowFaceEvent;
	import com.studyMate.world.screens.ScrollShelfPicturebook2Mediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	public class offScrollShelfPicBookMediator extends ScrollShelfPicturebook2Mediator
	{
		public const NAME:String = 'offScrollShelfPicBookMediator';
		public function offScrollShelfPicBookMediator(viewComponent:Object=null)
		{
			super(viewComponent);
			super.mediatorName = NAME;
		}
		
	
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){	
				case CoreConst.CLOSE_FACE_SHOW://子目录对象通知其更新页面
					view.mouseEnabled = true;
					view.mouseChildren = true;
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [CoreConst.CLOSE_FACE_SHOW];
		}
		
		//侦听显示封面
		override protected function showFaceHandler(event:ShowFaceEvent):void{			
			view.mouseEnabled = false;
			view.mouseChildren = false;
			var bookbtn:BookPicture = (event.Item.bookContent as BookPicture);
			var data:Object = new Object();
			data.item = bookbtn;//单独一个
			data.bookArr = bookArr;//全部
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(OffBookFaceShowMediator,data,SwitchScreenType.SHOW,view.parent)]);
		}
	}
}