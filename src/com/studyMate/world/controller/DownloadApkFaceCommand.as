package com.studyMate.world.controller
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.LocalFilesLoadCommandVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.world.component.AndroidGame.AndroidGameVO;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class DownloadApkFaceCommand extends SimpleCommand implements ICommand
	{
		public function DownloadApkFaceCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var list:Vector.<AndroidGameVO> = notification.getBody()[0] as Vector.<AndroidGameVO>;
			var completeNotice:String = notification.getBody()[1] as String;
			
			
			var _vec:Vector.<UpdateListItemVO> = new Vector.<UpdateListItemVO>;
			var _item:UpdateListItemVO;
			for(var i:int=0;i<list.length;i++){
				_item = new UpdateListItemVO(list[i].faceId,"game/"+list[i].faceName,"BOOK","");
				_item.hasLoaded = true;
				_vec.push(_item);
			}
			sendNotification(CoreConst.LOCAL_FILES_LOAD,new LocalFilesLoadCommandVO(_vec,completeNotice));
			
			
			
		}
		
	}
}