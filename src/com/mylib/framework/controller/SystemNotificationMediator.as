package com.mylib.framework.controller
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.IPSpeedVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.IslandWelcomeMediator;
	import com.studyMate.world.screens.NetStateMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.TimerEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import feathers.controls.Alert;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.core.Starling;
	
	
	
	public final class SystemNotificationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ViewNavigatorMediator";
		
		private static const RETURN_LOGIN:String = NAME + "returnLogin";
		
		private var freeze:Boolean;
		private var config:IConfigProxy
		private var alert:Alert;
		
		
		public function SystemNotificationMediator()
		{
			super( NAME, viewComponent );
			
		}
		
		override public function listNotificationInterests():Array{
			return [
				
				CoreConst.SOCKET_TIME_OUT,
				CoreConst.NETWORK_DISABLE,
				CoreConst.BOOT_COMPLETE,
				WorldConst.CHECK_TO_RELOGIN,
				CoreConst.BEAT,
				RETURN_LOGIN
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			var name:String = notification.getName();
			
			switch(name)
			{
				case CoreConst.SOCKET_TIME_OUT:
				{
					getLogger(SystemNotificationMediator).info("time out");
					sendNotification(CoreConst.TOAST,new ToastVO("发送超时"));
					
					break;
				}
				case CoreConst.NETWORK_DISABLE:{
//					Global.isSwitching = false;
//					sendNotification(CoreConst.LOADING,false);
					//10次重连失败					
					sendNotification(CoreConst.FLOW_RECORD,new RecordVO("CoreConst.NETWORK_DISABLE","SystemNotificationMediator",0));

					alert = Alert.show( "网络连接出现问题！", '温馨提示', new ListCollection(
						[
							{ label: "重新连接",triggered:function relogin():void{sendNotification(CoreConst.RELOGIN);} },
							{ label: "退出程序",triggered:function exit():void{Global.isUserExit = true;NativeApplication.nativeApplication.exit();} }
						]));
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(NetStateMediator,true,SwitchScreenType.SHOW,AppLayoutUtils.gpuLayer,390,120)]);
					
//					sendNotification(WorldConst.SHOW_NETSTATE_CHECK);
					
					break;
				}
				case CoreConst.BOOT_COMPLETE:{
					Global.booted = true;
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"启动完成");
					getLogger(SystemNotificationMediator).info("app start");
					
					
					
					sendNotification(CoreConst.INIT_ROOT);
					
					break;
				}
				case WorldConst.CHECK_TO_RELOGIN:
					var _tmpvo:IPSpeedVO = notification.getBody() as IPSpeedVO;
					
					if(_tmpvo){
						sendNotification(CoreConst.FLOW_RECORD,new RecordVO("10 relogin fail, Choose Relogin","SystemNotificationMediator",0));
						
						sendNotification(CoreConst.CONFIG_IP_PORT,[_tmpvo.host, _tmpvo.port, _tmpvo.networkId]);
						sendNotification(CoreConst.RELOGIN);
						
					}
					
					
					break;
				case CoreConst.BEAT:
					//没限制，不需要判断
					if(!Global.timeLimitVo)
					{
						break;
					}
					
					//时间判断
					var nowdate:Date = Global.nowDate;
					var _nowdate:Date = new Date(null,null,null,nowdate.hours,nowdate.minutes);
					var normal:Boolean = (Global.timeLimitVo.sdate<=_nowdate && _nowdate<Global.timeLimitVo.edate);
					//在时间内
					if(normal){
						//还剩5分钟,并且未提醒
						var dif:int = (Global.timeLimitVo.edate.time - _nowdate.time)*0.001/60;
						if(dif <= 5 && !Global.timeLimitVo.hadl5Tip){
							
							sendNotification(CoreConst.TOAST,new ToastVO("离系统关闭还剩"+dif+"分钟哦~~",5));
							Global.timeLimitVo.hadl5Tip = true;
						}
						
						
					}else{
						//提示退出
						if(!Global.timeLimitVo.hadexitTip){
							sendNotification(WorldConst.ALERT_SHOW,new AlertVo("温馨提示：今天已经学了好久哦，休息休息吧~O(∩_∩)O~",false,RETURN_LOGIN));
							Global.timeLimitVo.hadexitTip = true;
						}
						
					}
					break;
				case RETURN_LOGIN:
					sendNotification(CoreConst.STOP_BEAT);
					sendNotification(WorldConst.CLEANUP_POPUP);
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IslandWelcomeMediator),new SwitchScreenVO(CleanCpuMediator)]);
					
					
					break;
				
				default:
				{
					break;
				}
			}
			
		}
		
		
		protected function onNetworkChange(event : Event) : void
		{
			
			getLogger(SystemNotificationMediator).info("network switch");
			sendNotification(CoreConst.SWITCH_NETWORK);
			
		}
		
		
		
		override public function onRegister():void{
			//viewNavigator.mouseChildren = viewNavigator.mouseEnabled = false
			sendNotification(CoreConst.STARTUP_STEP_BEGIN,"启动系统通知");
			config = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onNetworkChange);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, dehandleActivate, false);
			
			
			Global.root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,errorHandle);
			
			
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		//eduapp协议回调函数
		private function onInvoke(e:InvokeEvent):void {
			if(e.arguments.length>0){
				
				var splitArr:Array = (e.arguments[0] as String).split("//");
				
				if(splitArr.length>1){
					try
					{
						var uv:URLVariables =  new URLVariables(splitArr[1]);
						
						if(uv["operation"]){
//							sendNotification(SMMConst.JUMP,uv);
							
							
						}
						
					} 
					catch(error:Error) 
					{
						
					}
				}
			}
			
		}
		
		
		
		
		
		
		protected function errorHandle(event:UncaughtErrorEvent):void
		{
			
			
			var message:String; 
			if (event.error is Error) { 
				message = event.error.message; 
				message+="\n"+event.error.getStackTrace();
			} else if (event.error is ErrorEvent) { 
				message = event.error.text;
			} else { 
				message = event.error.toString(); 
			} 
			
			event.preventDefault();
			var f:File = File.documentsDirectory.resolvePath(Global.localPath+"err.log");
			
			var stream:FileStream = new FileStream();
			stream.open(f,FileMode.APPEND);
			var d:Date = new Date();
			stream.writeMultiByte("-----------------"+d.toString()+"-----------------",PackData.BUFF_ENCODE);
			stream.writeMultiByte("\r\n",PackData.BUFF_ENCODE);
			stream.writeMultiByte(message,PackData.BUFF_ENCODE);
			stream.writeMultiByte("\r\n",PackData.BUFF_ENCODE);
			stream.close();
			
			sendNotification(CoreConst.ERROR_REPORT,message);
		}
		
		private var deactive:Boolean;//做标记用
		private var timeOut:uint;
		protected function dehandleActivate(event:Event):void  //主界面不是系统
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("dehandleActivate","SystemNotification",0));
			if(Global.isUserExit){//用户主动退出的.杀掉程序或者 
				//NativeApplication.nativeApplication.exit.可以侦听到此事件。此为在线教育应用主动退出,非死机
				config.updateValueInUser("userKill",'appExit');
			}
			timeOut = setTimeout(deactivate,200);			
		}
		
		protected function handleActivate(event:Event):void  //回系统界面
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleActivate","SystemNotification",0));
			clearTimeout(timeOut);
			if(deactive){		//处理事件不准确的情况。闪现	
				deactive = false;
				activate();
			}
		}	
		
		private function activate():void{
			config.updateValueInUser("userKill",'false');
			
			endTimeExit();
			Global.stage.frameRate = 60;
			if(Starling.current){
				Starling.current.start();
			}
			TweenMax.resumeAll();			
			sendNotification(CoreConst.ACTIVATE);
		}
		private function deactivate():void{	
			deactive = true;
			//用户手动杀出程序，非死机
			config.updateValueInUser("userKill",'userClose');
			
			startTimeExit();
			//Global.stage.frameRate = 4;//不设置为0而是4帧频是为了保持socket继续通信,以用在后台下载等操作			
			TweenMax.pauseAll();
			if(Starling.current){
				Starling.current.stop(true);
			}
			sendNotification(CoreConst.DEACTIVATE);
			

		}
		
		/**
		 * 
		 ---------------计算后台退出时长，超出则关闭应用，达到省电效果-----------------*/
		private var myTime:Timer;		
		public function startTimeExit():void{
			myTime = new Timer(3600*1000,1);
			myTime.addEventListener(TimerEvent.TIMER,timeHandler);
			myTime.start();
		}
		
		protected function timeHandler(event:TimerEvent):void
		{
			if(!Global.isLoading && !Global._mp3IsRunning){
				config.updateValueInUser("userKill",'false');
				NativeApplication.nativeApplication.exit();
			}else{
				trace('重新计算');
				endTimeExit();
				startTimeExit();
			}
		}		
		
		public function endTimeExit():void{
			if(myTime){
				myTime.stop();
				myTime.removeEventListener(TimerEvent.TIMER,timeHandler);
				myTime = null;
			}
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			if(alert){
				if(PopUpManager.isPopUp(alert))
					PopUpManager.removePopUp(alert);
				alert.dispose();
			}
		}
		
		
		
	}
}