package com.studyMate.world.component.AndroidGame
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class GameDownloadMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "GameDownloadMediator";
		public static const START_DOWNLOAD:String = NAME + "StartDownload";
		
		
		private var gamevo:AndroidGameVO;
		private var myIconSp:MyGameIconStateSp;
		
		public function GameDownloadMediator(viewComponent:Object=null)
		{
			
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			
			
			
		}
		
		//下载
		private function downloadHandle():void{
			trace("游戏："+myIconSp.name+" 开始下载："+gamevo.apkName);
			
			var _item:UpdateListItemVO = new UpdateListItemVO("","game/"+gamevo.apkName,"BOOK","");
			_item.hasLoaded = true;
			
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.REMOTE_FILE_LOAD,new RemoteFileLoadVO(_item.wfname,Global.localPath+_item.wfname,
				CoreConst.GAME_DOWNLOAD_COMPLETE,_item,_item));
		}
		private var total:int;
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case START_DOWNLOAD:
					var downItem:MyGameItem = notification.getBody() as MyGameItem;
					gamevo = downItem.gameVo;
					myIconSp = downItem.myIconSp;
					
					
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.MANUAL_LOADING,true);
					
					downloadHandle();
					
					
					break;
				case CoreConst.LOADING_TOTAL:
					var _total:int = notification.getBody() as int;
					total = _total;
					if(myIconSp)
						myIconSp.setProBar(_total);
					
					
					break;
				case CoreConst.LOADING_PROCESS:
					var _process:int = notification.getBody() as int;
					if(myIconSp)
						myIconSp.setProBar(-1,_process);
//					trace("游戏："+myIconSp.name+" 下载:"+(_process/total*100));
					break;
				case CoreConst.GAME_DOWNLOAD_COMPLETE:
					
					sendNotification(CoreConst.LOADING,false);
					
					//更新item状态
					if(myIconSp && myIconSp.parent){
						if(myIconSp.parent.parent)
							(myIconSp.parent.parent as MyGameItem).updateItemState("install");
					}
					
					myIconSp.removeFromParent(true);
					
					myIconSp = null;
					break;
					
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [START_DOWNLOAD,CoreConst.LOADING_TOTAL,CoreConst.LOADING_PROCESS,CoreConst.GAME_DOWNLOAD_COMPLETE];
		}
		
		
		
		override public function onRemove():void
		{
			super.onRemove();
			myIconSp = null;
			gamevo = null;
			if(Global.isLoading){
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.CANCEL_DOWNLOAD);	//中断下载
			}
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.MANUAL_LOADING,false);
		}
		
		
		
		
		
	}
}