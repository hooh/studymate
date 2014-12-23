package com.studyMate.world.screens.ui
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.EncryptTool;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.UpdateFilesVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
		
	public class QueueDownMediator extends Mediator
	{
		
		public static const NAME:String = "QueueDownMediator";
		public static const TEST_PATH:String = "TEST_VIDEO";
		private const LOADING_COMPLETE:String = NAME +"LoadingComplete";
		
		private var queue:Array=[];//下载队列
		private var testArr:Array = [];//测试需要排除的文件
		
		public function QueueDownMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			queue.length = 0;
			if(Global.isLoading){
				sendNotification(CoreConst.CANCEL_DOWNLOAD);				
			}
			sendNotification(CoreConst.MANUAL_LOADING,false);//可见进度
			sendNotification(CoreConst.LOADING_CLOSE_PROCESS);
			queue = null;
			testArr.length=0;
			testArr = null;
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case LOADING_COMPLETE:
					var obj:Object = queue.shift();
					var resDownVO:UpdateListItemVO = obj.updateListItemVO;
					var file:File =Global.document.resolvePath(Global.localPath+resDownVO.path);					
					if(file.exists){
						var newName:String = EncryptTool.encyptRC4(file.name);
						var destination:File = Global.document.resolvePath(file.parent.nativePath+"/"+newName);	
						file.moveTo(destination, true);
					}			
					sendNotification(WorldConst.CURRENT_DOWN_COMPLETE,obj.sp);					
					downloadNextItem();
					break;
				case TEST_PATH:
					testArr = notification.getBody() as Array;					
					break;
			}
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [LOADING_COMPLETE,TEST_PATH];
		}
		
		
		public function addDownQueue(queueDownVO:UpdateListItemVO,sp:Object):void{
			var obj:Object = new Object();
			obj.updateListItemVO = queueDownVO;
			obj.sp = sp;
			if(queueDownVO) queue.push(obj);
			downloadNextItem();
		}
		
		public function removeOf(sp:Object):void{
			for(var i:int=0;i<queue.length;i++){
				if(queue[i].sp  == sp){
					queue[i]=null;
					queue.splice(i,1);
					//downloadNextItem();
					break;
				}
			}			
		}
								
		public function downloadNextItem():void{
			if(!Global.isLoading && queue.length>0){
				//MyUtils.checkFolderSize(testArr);
				downSource();
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE
			}
		}
		
		private function downSource():void{		
			//var currentDown:queueDownPath = queue[0];
			//var _itemVideo:UpdateListItemVO = new UpdateListItemVO(currentDown.downId,currentDown.path,"BOOK",currentDown.version);
			var value:Number = File.documentsDirectory.spaceAvailable/1024/1024/1024;//磁盘剩余大小
			if(value<0.2){//如果剩余磁盘空间＜2G
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\n您的空间已不足200M，为了保证系统的正常运行，已自动停止下载。"));
				return;
			}
			var _itemVideo:UpdateListItemVO = queue[0].updateListItemVO;
			if(_itemVideo==null) return;
			var _vec:Vector.<UpdateListItemVO> = new Vector.<UpdateListItemVO>;
			_vec.push(_itemVideo);
			sendNotification(CoreConst.UPDATE_FILES,new UpdateFilesVO(_vec,LOADING_COMPLETE,null,true));	
			sendNotification(CoreConst.MANUAL_LOADING,true);	
			
			sendNotification(WorldConst.CURRENT_DOWN_RESINFOSP,queue[0].sp);
		}
	}
}