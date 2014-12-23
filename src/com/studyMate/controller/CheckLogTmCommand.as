package com.studyMate.controller
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SwitchScreenProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.IslandWelcomeMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.desktop.NativeApplication;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class CheckLogTmCommand extends SimpleCommand implements ICommand
	{
		public function CheckLogTmCommand()
		{
			super();
		}
		
		private function dateFormat(date:Date):String{
			var dYear:String = String(date.getFullYear());
			var dMouth:String = String((date.getMonth() + 1 < 10) ? "0" : "") + (date.getMonth() + 1);
			var dDate:String = String((date.getDate() < 10) ? "0" : "") + date.getDate();
			return dYear+dMouth+dDate;
		}
		
		override public function execute(notification:INotification):void{
			var today:Date = new Date(Global.nowDate.time);
			var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var loginDateStr:String = config.getValue("LastLoginTime");
			if(loginDateStr == ""){
				config.updateValue("LastLoginTime",dateFormat(today));
				return;
			}
			var year:int = parseInt(loginDateStr.substr(0,4));
			var month:int = parseInt(loginDateStr.substr(4,2));
			var day:int = parseInt(loginDateStr.substr(6,2));
			var loginDate:Date = new Date();
			loginDate.time = today.time;
			loginDate.setFullYear(year,month-1,day);
			var amongDay:int = (today.time - loginDate.time) / 1000 / 60 / 60 / 24;
			if(amongDay < 0){
				config.updateValue("LastLoginTime",dateFormat(today));
				return;
			}
			if(amongDay > 3){
				Global.isUserExit = true;
				NativeApplication.nativeApplication.exit();
				/*添加回到登录界面*/
				/*config.updateValue("LastLoginTime",dateFormat(today));
				var proxy:SwitchScreenProxy = facade.retrieveProxy(SwitchScreenProxy.NAME) as SwitchScreenProxy;
				if(proxy){
					if(!(proxy.currentGpuScreen is IslandWelcomeMediator)){
						proxy.gpuStack.length=0;
						proxy.cpuStack.length=0;
						sendNotification(WorldConst.CLEANUP_POPUP);
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IslandWelcomeMediator),new SwitchScreenVO(CleanCpuMediator)]);
					}
				}*/
				return;
			}
		}
		
	}
}