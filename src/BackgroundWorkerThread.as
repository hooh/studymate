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
	import com.studyMate.model.vo.SoundVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.UpdateListVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	
	import flash.concurrent.Mutex;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class BackgroundWorkerThread extends Sprite  implements IMediator
	{
		public static const NAME:String = "BackgroundWorker";
		private var multitonKey:String;
		private var facade:BackgroundFacade;
		private var socket:SocketProxy;
		
		private var commandChannel:MessageChannel;
		private var resultChannel:MessageChannel;
		private var loadingChannel:MessageChannel;
		
		private var shareMem:ByteArray;
		
		private var cache:ByteArray;
		private var uiMem:ByteArray;
		private var memLock:Mutex;
		
		
		public function BackgroundWorkerThread()
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
			registerClassAlias("com.studyMate.model.vo.SoundVO",SoundVO);
			facade = BackgroundFacade.getInstance();
			if(!CONFIG::ARM){
				LOGGER_FACTORY.setup = new SimpleTargetSetup( new TraceTarget("[Background]   {time} {logLevel} - {shortName}{atPerson} - {message}") );
			}
			addEventListener(Event.ADDED,initHandle);
			
		}
		
		protected function initHandle(event:Event):void{
			facade.registerMediator(this);
			
		}
		
		private function initialize():void{
			Global.mainThread = Worker.current.getSharedProperty("mainThread") as Worker;
			resultChannel = Global.mainThread.getSharedProperty("resultChannel") as MessageChannel;
			commandChannel = Global.mainThread.getSharedProperty("incomingCommandChannel") as MessageChannel;
			commandChannel.addEventListener(Event.CHANNEL_MESSAGE, handleCommandMessage);
			
			loadingChannel = Global.mainThread.getSharedProperty("loadingChannel") as MessageChannel;
			
			memLock = Global.mainThread.getSharedProperty(ShareConst.MEM_LOCK);
			
			shareMem = new ByteArray;
			shareMem.shareable = true;
			
			cache = new ByteArray;
			
			Global.mainThread.setSharedProperty(ShareConst.REC_DATA,shareMem);
			uiMem = Global.mainThread.getSharedProperty(ShareConst.UI_MEM);
			
		}
		
		private function handleCommandMessage(event:Event):void
		{
			while(commandChannel.messageAvailable){
				getLogger(BackgroundWorkerThread).debug("rec command");
				var arr:Array = commandChannel.receive();
				getLogger(BackgroundWorkerThread).debug(arr[0]);
				sendNotification(arr[0],arr[1],arr[2]);
			}
			
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
					var backData:Array = [];
					backData.length = socket.CmdOutCnt;
					var bgSendArr:Array = [notification.getName(),[socket.CmdOStr,notification.getBody()]];
					var doCache:Boolean=false;
					for (var i:int = 0; i < backData.length; i++) 
					{
						backData[i] = socket.CmdOStr[i];
					}
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
						loadingChannel.send([notification.getName(),notification.getBody()]);
					}
					
					break;
				case CoreConst.DEACTIVATE:
//					TweenMax.pauseAll();
					Global.activate = false;
					sendNotification(CoreConst.FLOW_RECORD,new RecordVO("DEACTIVATE","",0));
					break;
				case CoreConst.ACTIVATE:
//					TweenMax.resumeAll();
					Global.activate = true;
					sendNotification(CoreConst.FLOW_RECORD,new RecordVO("ACTIVATE","",0));
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
			initialize();
			facade.startup();
			socket = facade.retrieveProxy(SocketProxy.NAME) as SocketProxy;
			
			this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,errorHandle);
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
			cache.position = cache.length;
			cache.writeObject(data);
			getLogger(BackgroundWorkerThread).debug("cache"+cache.length);
			if(_cache){
				
				
			}else{
				
				getLogger(BackgroundWorkerThread).debug("start send result "+data[0],t);
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("start send result",data[0],0));
				shareMem.position = shareMem.length;
				shareMem.writeBytes(cache);
				
				cache.clear();
				
				var t:uint = getTimer();
				//				resultChannel.send(t);
				getLogger(BackgroundWorkerThread).debug("end send result "+data[0],t);
				sendNotification(CoreConst.FLOW_RECORD,new RecordVO("end send result",data[0],0));
				
				memLock.lock();
				if(!uiMem.length){
					uiMem.position = 0;
				}
				uiMem.writeBytes(shareMem);
				shareMem.clear();
				memLock.unlock();
				
			}
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