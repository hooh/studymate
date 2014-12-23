package com.mylib.framework.model
{
	import com.mylib.framework.BackgroundFacade;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.ShareConst;
	import com.studyMate.db.schema.Player;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	
	public class BackgroundWorkerMediator extends Mediator
	{
		public static const NAME:String = "BackgroundWorkerMediator";
		private var _sendVO:SendCommandVO;
		private var isReboot:Boolean;
		private var shareMem:ByteArray;
		private var processing:Boolean;
		private var cacheCommand:Array;
		private var nextSendVO:SendCommandVO;
		private var nextSendPara:Array;
		private var nextSendCnt:int;
		private var nextSendCmd:Array;
		private var quiting:Boolean;
		private var dataFilterMap:Dictionary;
		private var fileLoading:Boolean;
		private var quitParameter:*;
		private var backFacade:BackgroundFacade = BackgroundFacade.getInstance();
		private var background:BackgroundWorker;
		
		public function BackgroundWorkerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			cacheCommand = [];
		}
		
		public function get sendVO():SendCommandVO
		{
			return _sendVO;
		}

		public function set sendVO(value:SendCommandVO):void
		{
			if(value){
				Global.isBusy = true;
			}else{
				Global.isBusy = false;
			}
			_sendVO = value;
		}

		override public function handleNotification(notification:INotification):void
		{

			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleNotification"+notification.getName(),"BackgroundWorkerMediator",0));

			switch(notification.getName())
			{
				case CoreConst.SETUP_DATA_WORKER:
				{
					PackData.app = new PackData;
					PackData.app.CmdIStr = new Array(255);
					PackData.app.CmdOStr = new Array(255);
					background = new BackgroundWorker();
					backFacade.registerMediator(background);
					
					break;
				}
				case CoreConst.BACKGROUND_COMMAND:{
					
					sendCommand(notification.getBody() as Array);
					
					break;
				}
				case CoreConst.SEND_11:
				case CoreConst.SEND_1N:
					
					
					var tmpVO:SendCommandVO = notification.getBody() as SendCommandVO;
					if(tmpVO.type == SendCommandVO.SILENT){
						if(Global.isBeating||Global.isBusy){
							
							var dvo:DataResultVO = new DataResultVO();
							dvo.isEnd = true;
							dvo.isErr = true;
							dvo.para = tmpVO.para;
							dvo.type = "busy";
							sendNotification(tmpVO.receiveNotification,dvo);
							return;
						}
						Global.isBeating = true;
					}else if(tmpVO.type&SendCommandVO.QUEUE){
						sendNotification(CoreConst.SILENT_SEND,tmpVO);
						return;
					}
					
					
					if(!Global.isBeating&&sendVO){
						throw new Error("重复点击 "+sendVO.receiveNotification+" "+(notification.getBody() as SendCommandVO).receiveNotification);
					}
					
					if(nextSendVO&&tmpVO.type != SendCommandVO.SILENT){
						throw new Error("重复点击2 "+nextSendVO.receiveNotification+" "+(notification.getBody() as SendCommandVO).receiveNotification);
					}
					
					if(tmpVO.type == SendCommandVO.SILENT){
						sendNotification(CoreConst.SHOW_LOADING);
					}else{
						sendNotification(CoreConst.LOADING,true);
					}
					
					if(Global.isBeating&&tmpVO.type != SendCommandVO.SILENT){
						nextSendVO = tmpVO;
						nextSendPara = [];
						nextSendPara.length = PackData.app.CmdInCnt;
						for (var j:int = 0; j < PackData.app.CmdInCnt; j++) 
						{
							nextSendPara[j]=PackData.app.CmdIStr[j];
							nextSendCnt = PackData.app.CmdInCnt;
						}
						break;
					}else{
						sendVO = tmpVO;
					}
					
					
					var sendParameters:Array = [tmpVO.encode,tmpVO.byteIdx];
					sendParameters.length = PackData.app.CmdInCnt+2;
					for (var i:int = 2; i < sendParameters.length; i++) 
					{
						sendParameters[i] = PackData.app.CmdIStr[i-2];
					}
					
					var sendArr:Array = [notification.getName(),sendParameters];
					sendVO.sendParameters = sendArr;
					dataFilterMap = new Dictionary;
					sendCommand(sendArr);
					
					
				break;
				case CoreConst.BG_SEND_COMPLETE:
					var arr:Array = notification.getBody() as Array;
					var backData:Array = arr[0];
					
					PackData.app.CmdOStr = backData;
					PackData.app.CmdOutCnt = backData.length;
					
					if(!PackData.app.CmdOutCnt){
						PackData.app.CmdOStr[0] = null;
						PackData.app.CmdOStr[1] = null;
					}
					
					(arr[1] as DataResultVO).para = sendVO.para;
					
					
					
					var t:SendCommandVO =sendVO;
					
					if(t.type == SendCommandVO.SILENT){
						if((arr[1] as DataResultVO).isEnd){
							
							
							Global.isBeating = false;
							if(quiting){
								(arr[1] as DataResultVO).isCanceled = true;
							}
							sendVO = null;
							dispatchResultHandle(t.receiveNotification,arr[1]);
							sendNotification(CoreConst.HIDE_LOADING);
							sendNotification(CoreConst.SEND_QUEUE);
						}else{
							dispatchResultHandle(t.receiveNotification,arr[1]);
						}
					}else{
						if((arr[1] as DataResultVO).isEnd){
							sendVO = null;
							if(quiting){
								(arr[1] as DataResultVO).isCanceled = true;
							}
							sendNotification(CoreConst.LOADING,false);
						}
						dispatchResultHandle(t.receiveNotification,arr[1]);
					}
					
					
					if(quiting&&(arr[1] as DataResultVO).isEnd){
						quiting = false;
						sendNotification(CoreConst.SAFETY_QUIT,quitParameter);
						quitParameter = null;
					}
					if((arr[1] as DataResultVO).isBreak){
						sendCommand([CoreConst.CONTINUE_SEND_REQUEST,null]);
					}
					
					
				break;
				case CoreConst.SET_OPERID:
					PackData.app.head.dwOperID = notification.getBody() as uint;
					break;
				case CoreConst.UPDATE_PLAYER:
					Global.player = notification.getBody() as Player;
					break;
				case CoreConst.BG_WORKER_READY:{
					sendNotification(CoreConst.WORKER_RUNNING);
					sendCommand([CoreConst.SET_APP_NAME,Global.appName]);
					if(Global.hasLogin){
						sendNotification(CoreConst.CONFIG_IP_PORT,[Global.getSharedProperty(ShareConst.IP),Global.getSharedProperty(ShareConst.PORT),Global.getSharedProperty(ShareConst.NETWORK_ID)]);
						sendNotification(CoreConst.SOCKET_INIT,[true,"AB","n"]);
					}
					
					break;
				}
				case CoreConst.DOWNLOAD_STOPED:{
					NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
					sendNotification(CoreConst.LOADING,false);
					sendVO = null;
					fileLoading = false;
					if(quiting){
						requestQuit();
					}else{
						sendNotification(CoreConst.DOWNLOAD_CANCELED,quitParameter);
					}
					
					break;
				}
				case CoreConst.FILE_DOWNLOADED:{
					sendVO = null;
					fileLoading = false;
					sendNotification(CoreConst.CONTINUTE_FILE_DOWNLOADED,notification.getBody());
					break;
				}
				case CoreConst.SEND_QUEUE:{
					if(nextSendVO){
						var tmpSendVO:SendCommandVO = nextSendVO;
						nextSendVO = null;
						
						PackData.app.CmdInCnt = nextSendCnt;
						
						for (var k:int = 0; k < nextSendCnt; k++) 
						{
							PackData.app.CmdIStr[k] = nextSendPara[k];
						}
						
						
						sendNotification(CoreConst.SEND_11,tmpSendVO);
					}else if(nextSendCmd){
						sendVO = new SendCommandVO("downLoad");
						sendNotification(CoreConst.LOADING,true);
						fileLoading = true;
						var temnextSendCmd:Array = nextSendCmd.concat();
						nextSendCmd = null;
						sendCommand(temnextSendCmd);
					}
					break;
				}
				case CoreConst.REQUEST_QUIT:{
					quitParameter = notification.getBody();
					requestQuit();
					break;
				}
				case CoreConst.DETECT_DATA:{
					/*Global.stage.removeEventListener(Event.ENTER_FRAME,detectData);
					Starling.juggler.add(this);*/
					break;
				}
				case CoreConst.BG_RESEND:{
					sendVO.sendParameters = notification.getBody() as Array;
					
					sendNotification(CoreConst.BEGIN_SEND,sendVO);
					
					break;
				}
				
				default:
				{
					if(notification.getName()==CoreConst.SOCKET_INIT||notification.getName()==CoreConst.REQUEST_FILE_DATA){
						sendNotification(CoreConst.LOADING,true);
					}
					
					if(notification.getName()==CoreConst.REQUEST_FILE_DATA){
						
						if(Global.isBeating){
							nextSendCmd = [notification.getName(),notification.getBody(),notification.getType()];
							break;
						}
						
						if(sendVO){
//							throw new Error("重复点击 default"+sendVO.receiveNotification+" "+(notification.getBody() as RemoteFileLoadVO).completeNotice);
							Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("忽略重复点击下载",sendVO.receiveNotification+" "+(notification.getBody() as RemoteFileLoadVO).completeNotice,0));
							break;
						}
						sendVO = new SendCommandVO("downLoad");
						
						fileLoading = true;
						
					}
					
						sendCommand([notification.getName(),notification.getBody(),notification.getType()]);
					break;
				}
			}
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleNotification e","BackgroundWorkerMediator",0));

		}
		
		private function dispatchResultHandle(notification:String,result:DataResultVO):void{
			if(!sendVO||!sendVO.doFilter||!dataFilterMap[PackData.app.CmdOStr[0]]){
				dataFilterMap[PackData.app.CmdOStr[0]] = true;
				trace(notification);
				sendNotification(notification,result);
				PackData.app.CmdOStr[0] = null;
				PackData.app.CmdOutCnt = 0;
			}
		}
		
		
		
		private function sendCommand(data:Array):void{
			
			
			backFacade.sendNotification(CoreConst.BACKGROUND_OPER,data);
			
			
		}
		
		private function requestQuit():void{
			trace("requestQuit",Global.isBusy);
			if(!Global.isBusy){
				sendNotification(CoreConst.SAFETY_QUIT,quitParameter);
				quitParameter = null;
			}else if(fileLoading){
				quiting = true;
				sendNotification(CoreConst.CANCEL_DOWNLOAD);
			}else{
				quiting = true;
				sendNotification(CoreConst.STOP_REC);
			}
		}
		
		protected function ioErrorHandle(event:IOErrorEvent):void
		{
			
			sendNotification(CoreConst.ERROR_REPORT,"BackgroundWorker.swf miss!!!");
			
			
		}
		
		
			
		
		
		private function handleResultMessage(event:Event):void
		{
			
			getLogger(BackgroundWorkerMediator).debug("start process");
			processing = true;
			getLogger(BackgroundWorkerMediator).debug("rec ");
			processResult();
			
			processing = false;
			getLogger(BackgroundWorkerMediator).debug("end process");
			
			if(cacheCommand.length){
				sendCommand(cacheCommand.shift());
			}
			
			
		}
		
		private function processResult():void{
			
			while(shareMem.bytesAvailable){
				var resultArr:Array = shareMem.readObject() as Array;
				getLogger(BackgroundWorkerMediator).debug(resultArr[0]);
				sendNotification(resultArr[0],resultArr[1]);
			}
			
			
			
		}
		
		
		
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.SETUP_DATA_WORKER,CoreConst.BACKGROUND_COMMAND,CoreConst.SEND_11,CoreConst.SEND_1N,
				CoreConst.SOCKET_INIT,CoreConst.CONFIG_IP_PORT,CoreConst.BG_SEND_COMPLETE,CoreConst.SWITCH_NETWORK,
				CoreConst.SET_OPERID,CoreConst.REQUEST_FILE_DATA,CoreConst.CANCEL_DOWNLOAD,CoreConst.UPDATE_PLAYER,CoreConst.SEND_ERR
				,CoreConst.RESTART_BG_WORKER,CoreConst.BG_WORKER_READY,CoreConst.DOWNLOAD_STOPED,CoreConst.CHECK_UPDATE_FILES,
				CoreConst.OPER_UPDATE,CoreConst.FILE_DOWNLOADED,CoreConst.SEND_QUEUE,CoreConst.RELOGIN,CoreConst.STOP_REC,CoreConst.REQUEST_QUIT,CoreConst.KILL_BG_WORKER,CoreConst.CLOSE_SOCKET,
				CoreConst.DETECT_DATA,CoreConst.CONTINUE_SEND_REQUEST,CoreConst.SOUND_PLAY,CoreConst.SOUND_STOP,CoreConst.BG_RESEND
			];
		}
		
		
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			
			
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		
	}
}