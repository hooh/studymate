package com.mylib.game.controller
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.controller.IslandSwitchScreenCommand;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.EnableScreenCommandVO;
	import com.studyMate.world.model.MyCharaterInforMediator;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.Sprite;
	
	public class MutiOLTransferMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MutiOLTransferMediator";
		
		private var UPDATE_REC:String = NAME + "UpdateRec";
		
		//人物说话
		private var saying:Vector.<String> = new Vector.<String>;
		
		private var isMutiPlaying:Boolean = true;	//标记当前轮询是否进行中
		private var mutiControl:IMutiOLManager;
		private var mutiModuleMap:HashMap;
		private var mdMap:HashMap = new HashMap();
		
		public function MutiOLTransferMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			
			initMutiModule();
			
			if(Global.hasLogin){
				isMutiPlaying = true;
				start();
			}
			
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case UPDATE_REC:
					
					if(!result.isErr){
						var mutiData:String = PackData.app.CmdOStr[1];
						trace("消息队列："+mutiData);
						
						if(isMutiPlaying)
							tranferMutiData(mutiData);
					}
					break;
				case WorldConst.MUTICONTROL_READY:
					
					//完成消息模块的处理，重新轮询
					TweenLite.delayedCall(5,update);
					
					//延迟1秒处理缓存，用户给空隙执行轮询内的2次通信
					TweenLite.delayedCall(1,doSwitch);
					
					break;
				case WorldConst.MUTICONTROL_START:
					isMutiPlaying = true;
					TweenLite.delayedCall(2,update);
					
					break;
				case WorldConst.DO_SWITCH_STOP:
					TweenLite.killTweensOf(doSwitch);
					break;
				case WorldConst.MUTICONTROL_STOP:
					isMutiPlaying = false;
					TweenLite.killTweensOf(update);
					TweenLite.killTweensOf(doSwitch);
					break;
				case WorldConst.DELAY_SWITCH_STOP:
//					AppLayoutUtils.cpuLayer.removeEventListener(Event.ENTER_FRAME,delaySwitch);
					TweenLite.killTweensOf(delaySwitch);
					
					break;
				case WorldConst.REMOVE_POPUP_SCREEN:
					sendNotification(WorldConst.MUTICONTROL_START);
					sendNotification(CoreConst.MANUAL_LOADING,true);
					facade.registerCommand(WorldConst.SWITCH_SCREEN,IslandSwitchScreenCommand);

					break;
				case WorldConst.ENABLE_GPU_SCREENS:
					
					var egvo:EnableScreenCommandVO = notification.getBody() as EnableScreenCommandVO;
					
					if(egvo.enable){
						sendNotification(WorldConst.MUTICONTROL_START);
						sendNotification(CoreConst.MANUAL_LOADING,true);
						facade.registerCommand(WorldConst.SWITCH_SCREEN,IslandSwitchScreenCommand);
						
					}else{
						sendNotification(CoreConst.MANUAL_LOADING,false);
						TweenLite.killTweensOf(update);
					}
					
					
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [UPDATE_REC,WorldConst.MUTICONTROL_READY,WorldConst.MUTICONTROL_STOP,WorldConst.MUTICONTROL_START,
				WorldConst.REMOVE_POPUP_SCREEN,WorldConst.ENABLE_GPU_SCREENS,WorldConst.DELAY_SWITCH_STOP,WorldConst.DO_SWITCH_STOP];
		}
		
		//接收完数据，处理被截获的switch逻辑
		private function doSwitch():void{
			if(CacheTool.has(HappyIslandMediator.NAME,"switchScreenVO")){
				if(Global.isLoading)
					return;
				
				sendNotification(CoreConst.MANUAL_LOADING,false);
				sendNotification(CoreConst.LOADING,true);

				TweenLite.delayedCall(0.5,delaySwitch);
				
			}
		}
		private function delaySwitch():void{
			TweenLite.killTweensOf(delaySwitch);

			var type:String;
			if(CacheTool.has(HappyIslandMediator.NAME,"switchType"))
				type = CacheTool.getByKey(HappyIslandMediator.NAME,"switchType") as String;
			
			sendNotification(WorldConst.ISLAND_SWITCHSCREEN_FUN,CacheTool.getByKey(HappyIslandMediator.NAME,"switchScreenVO"),type);
			
		}
		
		
		//初始化各消息模块
		private function initMutiModule():void{
			mutiModuleMap = new HashMap;
			
			var mutilocation:MutiLocationMediator = new MutiLocationMediator();
			facade.registerMediator(mutilocation);
			mutiModuleMap.insert("L",mutilocation);
			
			var mutiWSpeak:MutiWSpeakMediator = new MutiWSpeakMediator();
			facade.registerMediator(mutiWSpeak);
			mutiModuleMap.insert("W",mutiWSpeak);
			
			var mutiPSpeak:MutiPSpeakMediator = new MutiPSpeakMediator();
			facade.registerMediator(mutiPSpeak);
			mutiModuleMap.insert("I",mutiPSpeak);
			
			var mutiFGame:MutiFightGameMediator = new MutiFightGameMediator();
			facade.registerMediator(mutiFGame);
			mutiModuleMap.insert("F",mutiFGame);
			
		}
		
		//拆分消息
		private function tranferMutiData(_mutiData:String):void{
			var messIdx:String;
			var messMD:String;
			
			//消息为空，由多人定位模块处理
			if(_mutiData == " " || _mutiData == ""){
				
				messIdx = "L";
				messMD = _mutiData;
				
			//消息不为空	
			}else{
				
				//消息串分界
				var mdListArr:Array = _mutiData.split(";");
				var flag:String;	//L:位置	 W     I     G
				var content:String;
				mdMap.clear();
				
				for(var j:int=0;j<mdListArr.length;j++){
					
					flag = (mdListArr[j] as String).split(":")[0];
					content = (mdListArr[j] as String).split(":")[1];
					
					mdMap.insert(flag,content);
				}
				
				//根据优先级处理不同消息标识
				
				//有战斗信息，直接提醒
				var fightMess:String = "";
				if(mdMap.containsKey("F"))
					fightMess = mdMap.find("F");
				mutiControl = getMutiModuleByID("F");
				mutiControl.setData(fightMess);
				
				//私聊、广播、多人位置 入口
				if(mdMap.containsKey("I") && getMutiModuleByID("I").isReady(mdMap.find("I"))){
					
					messIdx = "I";
					messMD = mdMap.find("I");
					
				}else if(mdMap.containsKey("W") && getMutiModuleByID("W").isReady(mdMap.find("W"))){
					
					messIdx = "W";
					messMD = mdMap.find("W");
					
					
				}else if(mdMap.containsKey("L")){
					
					messIdx = "L";
					messMD = mdMap.find("L");
					
				}
				
			}
			
			//如果所有操作不执行，则调用更新玩家坐标，清理场景玩家
			if(!messIdx){
				
				messIdx = "L";
				messMD = mdMap.find("L");
				
			}
			mutiControl = getMutiModuleByID(messIdx);
			mutiControl.setData(messMD);
			
		}
		
		private function getMutiModuleByID(_id:String):IMutiOLManager{
			
			return mutiModuleMap.find(_id) as IMutiOLManager
			
		}

		public function start():void{
			
			TweenLite.delayedCall(5,update);
		}
		
		public function update():void{
			TweenLite.killTweensOf(update);
			if(!isMutiPlaying)
				return;
			if(Global.isLoading){
				TweenLite.delayedCall(2,update);
				return;
			}
			
			var playerCharaterManagement:MyCharaterInforMediator = facade.retrieveMediator(MyCharaterInforMediator.NAME) as MyCharaterInforMediator;
			PackData.app.CmdIStr[0] = CmdStr.QRY_SCENE_USER_INFO;
			PackData.app.CmdIStr[1] = playerCharaterManagement.map;
			PackData.app.CmdIStr[2] = Global.player.operId;
			
			var playerView:Sprite = playerCharaterManagement.playerCharater.view;
			PackData.app.CmdIStr[3] = (int(playerView.x)).toString();
			PackData.app.CmdIStr[4] = (int(playerView.y)).toString();
			PackData.app.CmdInCnt = 5;
			
			sendNotification(CoreConst.LOADING_CLOSE_PROCESS);
			sendNotification(CoreConst.SEND_11,new SendCommandVO(UPDATE_REC,null,"cn-gb",null,SendCommandVO.QUEUE));
			
		}

		
		
		override public function onRemove():void
		{
			TweenLite.killTweensOf(doSwitch);
			TweenLite.killTweensOf(delaySwitch);
			TweenLite.killTweensOf(update);
			
			facade.removeMediator(MutiLocationMediator.NAME);
			facade.removeMediator(MutiWSpeakMediator.NAME);
			facade.removeMediator(MutiPSpeakMediator.NAME);
			facade.removeMediator(MutiFightGameMediator.NAME);
		}
		

	}
}