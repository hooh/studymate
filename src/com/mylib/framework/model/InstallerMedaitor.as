package com.mylib.framework.model
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.UpdateGlobal;
	import com.mylib.framework.controller.CheckUpdateFilesCommand;
	import com.mylib.framework.controller.OperUpdateCommand;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.module.ModuleConst;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class InstallerMedaitor extends Mediator
	{
		public static const NAME:String = "InstallerMedaitor";
		private var config:IConfigProxy;
		
		public function InstallerMedaitor(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			facade.registerCommand(CoreConst.CHECK_UPDATE_FILES,CheckUpdateFilesCommand);
			facade.registerCommand(CoreConst.OPER_UPDATE,OperUpdateCommand);
			
			config = facade.retrieveProxy(ModuleConst.CONFIGPROXY) as IConfigProxy;
			
			
			
			
			
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.INSTALL_UPDATE:
				{
					var spaceAvailable:Number = File.documentsDirectory.spaceAvailable/1024/1024/1024;
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"检查已下载更新  剩余空间:"+spaceAvailable.toFixed(2)+"g");
					var stream:FileStream = new FileStream;
					var f:File = Global.document.resolvePath(UpdateGlobal.UPDATE_FILE_PATH);
					
					try
					{
						UpdateGlobal.updateListMap = new Dictionary;
						if(f.exists){
							stream.open(f,FileMode.READ);
							UpdateGlobal.updateListVO = UpdateListVO(stream.readObject());
							stream.close();
							
							for (var i:int = 0; i < UpdateGlobal.updateListVO.list.length; i++) 
							{
								UpdateGlobal.updateListMap[UpdateGlobal.updateListVO.list[i].wfname] = UpdateGlobal.updateListVO.list[i];
							}
							
							if(config.getValue(UpdateGlobal.CONFIG_KEY)==UpdateGlobal.INSTALL){
								
								if(UpdateGlobal.updateListVO&&UpdateGlobal.updateListVO.list.length){
									sendNotification(CoreConst.CHECK_UPDATE_FILES,UpdateGlobal.updateListVO,"s");
								}
								
							}
						}
						
						
					} 
					catch(error:Error) 
					{
					}
					
					
					
					
					break;
				}
				case CoreConst.CHECK_UPDATE_FILES_COMPLETE:{
					var checkResult:UpdateListVO = notification.getBody() as UpdateListVO;
					var isComplete:Boolean;
					
					isComplete = checkResult.list.every(function(element:UpdateListItemVO, index:int, arr:Vector.<UpdateListItemVO>):Boolean{
						return element.isUpdate;
					}
					);
					
					if(isComplete){
						sendNotification(CoreConst.OPER_UPDATE,UpdateGlobal.updateListVO);
						config.updateValue(UpdateGlobal.CONFIG_KEY,UpdateGlobal.COMMIT);
						
					}
					
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.INSTALL_UPDATE,CoreConst.CHECK_UPDATE_FILES_COMPLETE];
		}
		
		
		override public function onRemove():void
		{
			facade.removeCommand(CoreConst.CHECK_UPDATE_FILES);
			facade.removeCommand(CoreConst.OPER_UPDATE);
			
		}
		
		
		
		
	}
}