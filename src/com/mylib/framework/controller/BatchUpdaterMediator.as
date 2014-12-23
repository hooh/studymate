package com.mylib.framework.controller
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.ShareConst;
	import com.mylib.framework.UpdateGlobal;
	import com.mylib.framework.model.DataBaseProxy;
	import com.mylib.framework.model.UpdateProxy;
	import com.mylib.framework.utils.DBTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Worker;
	import flash.utils.Dictionary;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class BatchUpdaterMediator extends Mediator
	{
		public static const NAME:String = "BatchUpdaterMediator";
		private var updateVO:UpdateListVO;
		private var localChecked:Boolean;
		private var reboot:Boolean;
		
		public function BatchUpdaterMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.RUN_UPDATE:
				{
					var updater:UpdateProxy = facade.retrieveProxy(UpdateProxy.NAME) as UpdateProxy;
					updater.updateMode = true;
					Global.setSharedProperty(ShareConst.DOWNLOAD_CMD,"USERWJ.DownHostFileNoSign(gdgz)");
					localChecked = false;
					sendNotification(CoreConst.GET_UPDATE_LIST,new UpdateListVO(CoreConst.REC_UPDATE_LIST,null,notification.getBody() as String));
					break;
				}
				case CoreConst.UPDATE_READY:					
					MyUtils.checkFolderSize();//检查磁盘空间
					UpdateGlobal.updateListVO = updateVO = notification.getBody() as UpdateListVO;
					
					sendNotification(CoreConst.LOADING_INIT_PROCESS);
					sendNotification(CoreConst.LOADING_MSG,"检查更新文件");
					sendNotification(CoreConst.LOADING,true);
					
					
					if(!localChecked&&updateVO.updateType!="u"){
						sendNotification(CoreConst.CHECK_UPDATE_FILES,updateVO,"l");
						return;
					}
					
					
					if(updateVO.updateType=="u"){
						if(!UpdateGlobal.updateListMap){
							UpdateGlobal.updateListMap = new Dictionary;
						}
						
						for (var i:int = 0; i < updateVO.list.length; i++) 
						{
							var localItem:UpdateListItemVO = UpdateGlobal.updateListMap[updateVO.list[i].wfname];
							if(localItem&&localItem.version==updateVO.list[i].version){
								updateVO.list[i].isUpdate = localItem.isUpdate;
							}
							UpdateGlobal.updateListMap[updateVO.list[i].wfname] = updateVO.list[i];
							
						}
					}
					
					
					
					var f:File = Global.document.resolvePath(UpdateGlobal.UPDATE_FILE_PATH);
					var stream:FileStream = new FileStream();
					stream.open(f,FileMode.WRITE);
					stream.writeObject(updateVO);
					stream.close();
					
					if(updateVO.list.length){
						var config:IConfigProxy = facade.retrieveProxy(ModuleConst.CONFIGPROXY) as IConfigProxy;
						config.updateValue(UpdateGlobal.CONFIG_KEY,UpdateGlobal.DOWNLOADING);
					}
					
					
					
					
					sendNotification(CoreConst.CHECK_UPDATE_FILES,updateVO,"s");
					
					break;
				case CoreConst.UPDATE_COMPLETE:{
					sendNotification(CoreConst.LOADING_INIT_PROCESS);
					sendNotification(CoreConst.LOADING_MSG,"检查更新文件");
					sendNotification(CoreConst.LOADING,true);
					sendNotification(CoreConst.CHECK_UPDATE_FILES,updateVO);
					
					
					break;
				}
				case CoreConst.CHECK_UPDATE_FILES_COMPLETE:{
					
					updateVO = notification.getBody() as UpdateListVO;
					if(!localChecked&&updateVO.updateType!="u"){
						localChecked = true;
						sendNotification(CoreConst.UPDATE_READY,updateVO);
						return;
					}
					
					sendNotification(CoreConst.LOADING,false);
					for (var j:int = 0; j < updateVO.list.length; j++) 
					{
						
						if(!updateVO.list[j].isUpdate&&!updateVO.list[j].hasLoaded&&!(updateVO.list[j].wfname==Global.appName&&Global.OS==OSType.ANDROID)){
							sendNotification(CoreConst.UPDATE_ASSETS,updateVO);
							return;
						}
						
						if(updateVO.list[j].wfname=="module/Main.swf"||updateVO.list[j].wfname=="module/StartprocessModule.swf"||updateVO.list[j].wfname=="module/AllLibs.swf"){
							reboot = true;
						}
						
						
						
						
					}
					
					
						
						
					if(!updateVO.list.length){
						sendNotification(CoreConst.COMMIT_UPDATE_COMPLETE);
					}else{
						Global.initialized = false;
						getLogger().debug("=============================================complete==========================================================");
						//提示有更新
						
						
						var cofigProxy:IConfigProxy = facade.retrieveProxy(ModuleConst.CONFIGPROXY) as IConfigProxy;
						cofigProxy.updateValue(UpdateGlobal.CONFIG_KEY,UpdateGlobal.INSTALL);
						
						DBTool.proxy.close();
						sendNotification(CoreConst.OPER_UPDATE,UpdateGlobal.updateListVO);
						
					}
						
					
					break;
				}
				case CoreConst.OPER_UPDATE_COMPLETE:{
					(facade.retrieveProxy(ModuleConst.CONFIGPROXY) as IConfigProxy).updateValue(UpdateGlobal.CONFIG_KEY,UpdateGlobal.COMMIT);
					
					
					if(!DBTool.proxy.sqlConnection.connected){
						DBTool.proxy.setUp();
					}
					sendNotification(CoreConst.INITIALIZE_ASSETS_CONFIG);
					DBTool.proxy.close();
					sendNotification(CoreConst.LOADING_CLOSE_PROCESS);
					sendNotification(CoreConst.LOADING,false);
					sendNotification(CoreConst.COMMIT_UPDATE,UpdateGlobal.updateListVO);
					
					
					break;
				}
				case CoreConst.COMMIT_UPDATE_COMPLETE:
					var commitVO:DataResultVO = notification.getBody() as DataResultVO;
					UpdateGlobal.updateListVO = null;
					UpdateGlobal.updateListMap = null;
					if(commitVO){
						sendNotification(CoreConst.REMOVE_UPDATE_FILE);
					}
					
					var updater1:UpdateProxy = facade.retrieveProxy(UpdateProxy.NAME) as UpdateProxy;
					updater1.updateMode = false;
					Global.setSharedProperty(ShareConst.DOWNLOAD_CMD,"USERWJ.DownHostFile(gdgz)");
					
					sendNotification(CoreConst.CHECK_APP_VERSION);
					sendNotification(CoreConst.LOADING_CLOSE_PROCESS);
					sendNotification(CoreConst.REMIND_UPDATE_COMPLETE,reboot);
					
					
					break;
				
				
				
				default:
				{
					break;
				}
			}
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.RUN_UPDATE,CoreConst.UPDATE_READY,CoreConst.UPDATE_COMPLETE,CoreConst.CHECK_UPDATE_FILES_COMPLETE,CoreConst.COMMIT_UPDATE_COMPLETE,CoreConst.OPER_UPDATE_COMPLETE];
		}
		
	}
}