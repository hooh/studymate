package
{
	import com.greensock.TweenMax;
	import com.mylib.framework.BackgroundFacade;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.ShareConst;
	import com.mylib.framework.model.tcp.SocketProxy;
	import com.studyMate.db.schema.Player;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.IFileVO;
	import com.studyMate.model.vo.LicenseVO;
	import com.studyMate.model.vo.LoginVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SaveTempFileVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.net.registerClassAlias;
	
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class BackgroundWorker extends Sprite  implements IMediator
	{
		public static const NAME:String = "BackgroundWorker";
		private var multitonKey:String;
		private var facade:BackgroundFacade;
		private var socket:SocketProxy;
		
		
		
		
		public function BackgroundWorker()
		{
			
			MyUtils.checkOS();
			registerClassAlias("com.studyMate.model.vo.LoginVO",LoginVO);
			registerClassAlias("com.studyMate.db.schema.Player",Player);
			registerClassAlias("com.studyMate.model.vo.DataResultVO",DataResultVO);
			registerClassAlias("com.studyMate.model.vo.RemoteFileLoadVO",RemoteFileLoadVO);
			registerClassAlias("com.studyMate.model.vo.IFileVO",IFileVO);
			registerClassAlias("com.studyMate.model.vo.UpdateListItemVO",UpdateListItemVO);
			registerClassAlias("com.studyMate.model.vo.LicenseVO",LicenseVO);
			registerClassAlias("com.studyMate.model.vo.ToastVO",ToastVO);
			registerClassAlias("com.studyMate.model.vo.UpLoadCommandVO",UpLoadCommandVO);
			registerClassAlias("com.studyMate.model.vo.SaveTempFileVO",SaveTempFileVO);
			registerClassAlias("com.studyMate.model.vo.UpdateListVO",UpdateListVO);
			
			facade = BackgroundFacade.getInstance();
			if(!CONFIG::ARM){
				LOGGER_FACTORY.setup = new SimpleTargetSetup( new TraceTarget("[Background]   {time} {logLevel} - {shortName}{atPerson} - {message}") );
			}
			addEventListener(Event.ADDED,initHandle);
			
		}
		
		protected function initHandle(event:Event):void{
			facade.registerMediator(this);
			
		}
		
		
		public function getMediatorName():String
		{
			return NAME;
		}
		
		public function getViewComponent():Object
		{
			return this;
		}
		
		public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.CONFIG_IP_PORT:{
					Global.setSharedProperty(ShareConst.IP,notification.getBody()[0]);
					Global.setSharedProperty(ShareConst.PORT,notification.getBody()[1]);
					Global.setSharedProperty(ShareConst.NETWORK_ID,notification.getBody()[2]);
					
					
					socket.host = notification.getBody()[0];
					socket.port = notification.getBody()[1];
					
					
					break;
				}
				case CoreConst.SEND_11:
				case CoreConst.SEND_1N:
					sendNotification(CoreConst.BG_SEND,notification.getBody());
					
				break;
				case CoreConst.LOGIN_SETTING_COMPLETE:
					socket.B0LoginComplete = true;
					sendResult([CoreConst.SET_OPERID,PackData.app.head.dwOperID],true);
					sendResult([CoreConst.UPDATE_PLAYER,Global.player],true);
					sendResult([notification.getName(),notification.getBody()]);
					break;
				case CoreConst.SET_APP_NAME:
					Global.appName = notification.getBody() as String;
					break;
				case CoreConst.BG_SEND_COMPLETE:
					
					var bgSendArr:Array = [notification.getName(),[socket.CmdOStr,notification.getBody()]];
					var doCache:Boolean=false;
					/*if(!(notification.getBody() as DataResultVO).isEnd){
						doCache = true;
					}*/
					sendResult(bgSendArr,doCache);
					
					break;
				case CoreConst.SOCKET_TIME_OUT:
				case CoreConst.SOCKET_CLOSED:
					sendResult([notification.getName(),notification.getBody()]);
					break;
				case CoreConst.CLOSE_SOCKET:
					socket.close(false);
					break;
				case CoreConst.LOADING_CLOSE_PROCESS:
				case CoreConst.LOADING_INIT_PROCESS:
				case CoreConst.LOADING_TOTAL_PROCESS_MSG:
					
					if(!Global.getSharedProperty(ShareConst.LOADING_DISABLE)){
//						loadingChannel.send([notification.getName(),notification.getBody()]);
						Facade.getInstance(CoreConst.CORE).sendNotification(notification.getName(),notification.getBody());
					}
					
					break;
				case CoreConst.DEACTIVATE:
//					TweenMax.pauseAll();
					Global.activate = false;
//					sendNotification(CoreConst.FLOW_RECORD,new RecordVO("DEACTIVATE","",0));
					break;
				case CoreConst.ACTIVATE:
//					TweenMax.resumeAll();
					Global.activate = true;
//					sendNotification(CoreConst.FLOW_RECORD,new RecordVO("ACTIVATE","",0));
					break;
				case CoreConst.RECEIVE_ERROR:{
					
					var msg:String = socket.CmdOStr[1];
					if(!msg){
						msg = socket.CmdOStr[0];
					}
					sendResult([notification.getName(),notification.getBody()]);
					break;
				}
				case CoreConst.CONTINUE_SEND_REQUEST:{
					socket.keepSend();
					break;
				}
				case CoreConst.BACKGROUND_OPER:{
					var arr:Array = notification.getBody() as Array;
					sendNotification(arr[0],arr[1],arr[2]);
					break;
				}
				default:
				{
					sendResult([notification.getName(),notification.getBody()]);
					break;
				}
			}
		}
		
		public function listNotificationInterests():Array
		{
			return [CoreConst.CONFIG_IP_PORT,CoreConst.SEND_11,CoreConst.SEND_1N,CoreConst.LOGIN_SETTING_COMPLETE,CoreConst.BG_SEND_COMPLETE,
				CoreConst.LOADING_CLOSE_PROCESS,CoreConst.LOADING_INIT_PROCESS,CoreConst.LOADING_MSG,
				CoreConst.SOCKET_TIME_OUT,CoreConst.TOAST,CoreConst.ERROR_REPORT,CoreConst.DOWNLOAD_STOPED,CoreConst.UPLOAD_SEGMENT_COMPLETE,CoreConst.UPLOAD_COMPLETE,CoreConst.SET_APP_NAME
				,CoreConst.FILE_DOWNLOADED,CoreConst.SOCKET_CLOSED,CoreConst.CHECK_UPDATE_FILES_COMPLETE,
				CoreConst.OPER_UPDATE_COMPLETE,CoreConst.RECEIVE_ERROR,CoreConst.NETWORK_DISABLE,
				CoreConst.LOADING_TOTAL_PROCESS_MSG,CoreConst.NETWORK_ERROR,CoreConst.CLOSE_SOCKET,CoreConst.RELOGIN_COMPLETE,CoreConst.CONTINUE_SEND_REQUEST,CoreConst.BACKGROUND_OPER,CoreConst.BG_RESEND
			];
		}
		
		public function onRegister():void
		{
			facade.startup();
			socket = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			
			
			sendResult([CoreConst.BG_WORKER_READY]);
			
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
			
			sendNotification(CoreConst.ERROR_REPORT,"2:"+message);
			
		}
		
		public function onRemove():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		private function sendResult(data:Array,_cache:Boolean=false):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(data[0],data[1],data[2]);
		}
		
		private function sendCache():void{
			
			
			
		}
		
		public function setViewComponent(viewComponent:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function initializeNotifier(key:String):void
		{
			multitonKey = key;
		}
		
		public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			if (facade != null) 
				facade.sendNotification( notificationName, body, type );
		}
		
	}
}