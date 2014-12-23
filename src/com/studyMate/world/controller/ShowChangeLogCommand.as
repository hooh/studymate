package com.studyMate.world.controller
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.ShowChangeLogMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	
	public class ShowChangeLogCommand extends SimpleCommand implements ICommand
	{
		public function ShowChangeLogCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void {
			try {
				var holder:Sprite = notification.getBody() as Sprite;
			} catch(error:Error) {
				return;
			}
			if(needShowChangeLog()){
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowChangeLogMediator, null, SwitchScreenType.SHOW, holder, 310, 77)]);
			}
		}
		
		private function needShowChangeLog():Boolean{
			var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var currentVer:String = config.getValue("CurrentChangeLog");
			try{
				var changeLogFile:File = Global.document.resolvePath(Global.localPath+"changeLog.txt");
				var stream:FileStream = new FileStream();
				stream.open(changeLogFile, FileMode.READ);
				var changeLogString:String = stream.readMultiByte(stream.bytesAvailable, "GBK");
				stream.close();
				var enterCodeIndex:int = changeLogString.indexOf("\n");
				var changeVer:String = changeLogString.slice(0,enterCodeIndex);
				if(currentVer == changeVer){
					return false;
				}else{
					config.updateValue("CurrentChangeLog", changeVer);
					return true;
				}
			} 
			catch(error:Error) 
			{
			}
			return false;
		}
		
	}
}