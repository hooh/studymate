package com.studyMate.controller
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.TimeProxy;
	import com.mylib.framework.model.VideoConfigProxy;
	import com.mylib.framework.model.vo.VideoLogVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.globalization.DateTimeFormatter;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class GetInitializeDataMediator extends Mediator implements IMediator
	{
		private var dressList:HashMap = new HashMap();
		private var GOT_MONEY:String = "gotmoney";
		private const COST_GOLD_INFO:String = 'VIDEO_COST_GOLD_INFO';
		private const USER_KILL:String ='userKillSystem';
		private const UPDATE_DEFAULT_EQUIP:String = "update_default_equip";
		private const GET_CUST_DATA_EXT:String = "get_cust_data_ext";
		
		public function GetInitializeDataMediator(){
			super(ModuleConst.GET_INITIALIZE_DATA_MEDIATOR);
		}
		
		override public function onRegister():void{
			super.onRegister();
			facade.registerMediator(new PerCommandMediator());
			facade.registerMediator(new SubPackInfoMediator());
		}
		override public function onRemove():void{
			facade.removeMediator(PerCommandMediator.NAME);
			facade.removeMediator(SubPackInfoMediator.NAME);
			super.onRemove();
			dressList.clear();
		}
		
//		private function getGold():void{
//			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
//			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
//			PackData.app.CmdIStr[2] = "SYSTEM.SMONEY";
//			PackData.app.CmdInCnt =3;
//			sendNotification(CoreConst.SEND_11,new SendCommandVO(GOT_MONEY,null,"cn-gb",null,SendCommandVO.QUEUE));
//		}
		
		
		private function getStdInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_CUST_DATA_EXT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_CUST_DATA_EXT,null,'cn-gb',null,SendCommandVO.QUEUE));
		}
		private function upDefaultEquip( _dress:String ):void{
			Global.myDressList = _dress;
			
			PackData.app.CmdIStr[0] = CmdStr.UPDATE_CHARATER_EQUIPMENT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = _dress;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(UPDATE_DEFAULT_EQUIP,null,'cn-gb',null,SendCommandVO.QUEUE));
			
		}
		
		private function sendVideoLog():void{
			var videoLogVO:VideoLogVO = (facade.retrieveProxy(VideoConfigProxy.NAME) as VideoConfigProxy).getValueInUser();
			if(videoLogVO){
				if(Global.nowDate.time<Number(videoLogVO.endtime)){
					var startDate:Date = new Date();
					startDate.time = Number(videoLogVO.starttime);
					var endDate:Date = new Date();
					if(Global.nowDate.time-5*60*1000>startDate.time){						
						endDate.time = Global.nowDate.time-5*60*1000;
					}else{
						endDate.time = Global.nowDate.time;
					}
					
					PackData.app.CmdIStr[0] = CmdStr.SUBMIT_WATCH_VIDEO_INFO;
					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = videoLogVO.videoids;
					PackData.app.CmdIStr[3] = videoLogVO.times;
					PackData.app.CmdIStr[4] = videoLogVO.wtimes;
					var rtime:int = int((endDate.time-startDate.time)/1000/60);
					if(rtime<0) rtime = 0;
					PackData.app.CmdIStr[5] = rtime;
					PackData.app.CmdIStr[6] = videoLogVO.videoName;
					PackData.app.CmdIStr[7] = getTimeFormat(startDate);
					PackData.app.CmdIStr[8] = getTimeFormat(endDate); 
					PackData.app.CmdInCnt = 9;	
					sendNotification(CoreConst.SEND_11,new SendCommandVO(COST_GOLD_INFO,null,'cn-gb',null,SendCommandVO.QUEUE));
				}
			}
		}
		
		
		private function sendUserKill():void{			
			var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var value:String = (config.getValueInUser('userKill'));
			if(value=='userClose' || value=='appExit'){
				PackData.app.CmdIStr[0] = CmdStr.USER_KILL;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = Global.license.macid;
				PackData.app.CmdIStr[3] = value;
				PackData.app.CmdInCnt = 4;	
				sendNotification(CoreConst.SEND_11,new SendCommandVO(USER_KILL,null,'cn-gb',null,SendCommandVO.QUEUE | SendCommandVO.UNIQUE));
			}else{
				PackData.app.CmdIStr[0] = CmdStr.USER_KILL;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = Global.license.macid;
				PackData.app.CmdIStr[3] = 'maybeDie';
				PackData.app.CmdInCnt = 4;	
				sendNotification(CoreConst.SEND_11,new SendCommandVO(USER_KILL,null,'cn-gb',null,SendCommandVO.QUEUE | SendCommandVO.UNIQUE));
			}
		}
		
		private function getTimeFormat(value:Date):String{			
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");		
			dateFormatter.setDateTimePattern("yyyyMMdd-HHmmss");
			return dateFormatter.format(value);
		}
		
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case USER_KILL:
					var config:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
					config.updateValueInUser("userKill",'false');
					break;
				case CoreConst.START_GET_INITIALIZE_DATA:
					trace("start get initialize data");
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"初始化数据......");
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"获取系统时间");
					sendNotification(WorldConst.INIT_UI);
					sendNotification(CoreConst.GET_SER_TIME);
					sendNotification(WorldConst.RECORD_LOGIN_INFO);
					sendNotification(WorldConst.GET_PER_CONFIG);
					sendNotification(WorldConst.CHECK_PROMISE);
					/*getGold();*/
					sendVideoLog();
					
					sendUserKill();
					
					sendNotification(CoreConst.CHECK_APP_ROOT);
					sendNotification(WorldConst.AUTO_SUB_PACKLIST);
					sendNotification(WorldConst.GET_COMMAND);
					sendNotification(WorldConst.CHECK_ANR);
					sendNotification(WorldConst.GET_CHARATER_EQUIPMENT,[PackData.app.head.dwOperID.toString()]);
					
					break;
				case COST_GOLD_INFO:
					(facade.retrieveProxy(VideoConfigProxy.NAME) as VideoConfigProxy).updateValueInUser(true);
					sendNotification(CoreConst.TOAST,new ToastVO(('检测到您刚才看电影意外关闭,返回您银币:'+PackData.app.CmdOStr[1]),1.8));
					break;
				case CoreConst.REC_SER_TIME:
					var timeProxy:TimeProxy = facade.retrieveProxy(TimeProxy.NAME) as TimeProxy;
					
					var d:Date;
					
					if(!result.isErr){
						d = new Date(PackData.app.CmdOStr[4],PackData.app.CmdOStr[5]-1,PackData.app.CmdOStr[6],
							PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],PackData.app.CmdOStr[3]);
					}else{
						d = new Date();
					}
					
					
					timeProxy.setDate(d);
					
					
					//同步平板时间
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"同步平板时间");
					sendNotification(CoreConst.SYN_PAD_TIME,d);
					
					break;
				case CoreConst.SYN_PAD_TIME_COMPLETE:
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"发送后台登录标记");
					
					break;
				case WorldConst.RECORD_LOGIN_INFO_COMPLETE:
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"获取个人配置信息");
					break;
				case WorldConst.GET_PER_CONFIG_OVER :
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"检查约定信息");
					break;
				case WorldConst.CHECK_PROMISE_OVER : 
					
					break;
				case GOT_MONEY :
					/*sendNotification(CoreConst.STARTUP_STEP_BEGIN,"取个人金币数");
					if(!result.isErr){
						Global.goldNumber = parseInt(PackData.app.CmdOStr[4]);
					}
					
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"检查程序权限");
					sendNotification(CoreConst.CHECK_APP_ROOT);*/
					break;
				case CoreConst.CHECK_APP_ROOT_COMPLETE:
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"上传平板信息");
					sendNotification(CoreConst.INUP_PAD_INFO);
					break;
				case CoreConst.REC_VERSION :
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"发送本地程序列表");
					break;
				case WorldConst.REC_PACKLIST :
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"获取个人执行命令");
					
					break;
				case WorldConst.GET_COMMAND_OVER :
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"获取个人装备信息");
					
					break;
				case WorldConst.GET_CHARATER_EQUIPMENT_COMPLETE:
//					trace("角色是："+PackData.app.CmdOStr[1]);
//					trace("装备是："+PackData.app.CmdOStr[2]);
					if(!result.isEnd){
						dressList.insert(PackData.app.CmdOStr[1],[PackData.app.CmdOStr[2],PackData.app.CmdOStr[3]]);
					}else{
						if(dressList.containsKey(PackData.app.head.dwOperID)){							
							Global.myDressList = dressList.find(PackData.app.head.dwOperID.toString())[0];
							Global.myLevel = dressList.find(PackData.app.head.dwOperID.toString())[1];
						}else{
							Global.myDressList = "";
							Global.myLevel = 0;
						}
						
						//如果没装备，则更新默认装备
						if(Global.myDressList == ""  || !Global.myDressList){
							//取性别
							getStdInfo();
							
						}else{
							
//							sendNotification(WorldConst.GET_STD_FNLVL,PackData.app.head.dwOperID.toString());
							sendNotification(CoreConst.STARTUP_STEP_BEGIN,"初始化数据完成......");
							sendNotification(CoreConst.DATA_INITIALISED);
							facade.removeMediator(this.getMediatorName());
							
						}
						
						
					}
					
					
					break;
				case GET_CUST_DATA_EXT:
					if(!result.isErr){
						//女
						if( PackData.app.CmdOStr[2] == 0 ){
							upDefaultEquip("face_face1,defaultset2");
						}else{
							upDefaultEquip("face_face1,defaultset");
						}
						
					}else{
						upDefaultEquip("face_face1,defaultset");
					}
					
					
					break;
				case UPDATE_DEFAULT_EQUIP:
					
//					if(!result.isErr){
//						Global.myDressList = "face_face1,defaultset";
//					}
					
//					sendNotification(WorldConst.GET_STD_FNLVL,PackData.app.head.dwOperID.toString());
					sendNotification(CoreConst.STARTUP_STEP_BEGIN,"初始化数据完成......");
					sendNotification(CoreConst.DATA_INITIALISED);
					facade.removeMediator(this.getMediatorName());
					
					
					break;
				
				
				default:
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [CoreConst.START_GET_INITIALIZE_DATA,CoreConst.REC_SER_TIME,COST_GOLD_INFO,USER_KILL,
				WorldConst.UPDATE_TASKLIST_COMPLETE,CoreConst.REC_VERSION,WorldConst.RECORD_LOGIN_INFO_COMPLETE,
				WorldConst.CHECK_PROMISE_OVER,WorldConst.GET_CHARATER_EQUIPMENT_COMPLETE,GOT_MONEY,
				WorldConst.GET_PER_CONFIG_OVER,WorldConst.GET_COMMAND_OVER,WorldConst.REC_PACKLIST,
				CoreConst.CHECK_APP_ROOT_COMPLETE,CoreConst.SYN_PAD_TIME_COMPLETE,UPDATE_DEFAULT_EQUIP,
				GET_CUST_DATA_EXT];
		}
		
		
	}
}
