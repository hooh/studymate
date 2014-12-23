package com.mylib.framework.controller
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	
	import flash.desktop.NativeApplication;
	
	import feathers.controls.Alert;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class LoginFailUICommand extends SimpleCommand
	{
		private static var passwordErrAlert:Boolean;
		public function LoginFailUICommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy:ISwitchScreenProxy = facade.retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			if(proxy){
				if(!passwordErrAlert&&(proxy.gpuStack.lastTwoScreen()||proxy.cpuStack.lastTwoScreen())){
					passwordErrAlert = true;
					Alert.show( "密码被别人修改了，请重启应用", '温馨提示', new ListCollection(
						[
							{ label: "退出应用",triggered:function exit():void{Global.isUserExit = true;NativeApplication.nativeApplication.exit();} }
						]));
				}else{
					sendNotification(CoreConst.LOADING,false);
				}
			}
		}
		
	}
}