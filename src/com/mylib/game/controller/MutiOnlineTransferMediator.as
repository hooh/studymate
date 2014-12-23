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
	import com.studyMate.world.controller.vo.CharaterStateVO;
	import com.studyMate.world.controller.vo.EnableScreenCommandVO;
	import com.studyMate.world.model.MyCharaterInforMediator;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.Sprite;
	
	public class MutiOnlineTransferMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MutiOnlineTransferMediator";
		
		private var UPDATE_REC:String = NAME + "UpdateRec";
		private var p:Point;
		
		//人物说话
		private var saying:Vector.<String> = new Vector.<String>;
		
		private var dressMap:HashMap = new HashMap();
		private var playerList:Dictionary = new Dictionary();
		private var needStr:Vector.<String> = new Vector.<String>;
		
		public function MutiOnlineTransferMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			p = new Point();
			
			if(Global.hasLogin){
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
						var playerArr:Array = JSON.parse(PackData.app.CmdOStr[1]) as Array;
						trace(PackData.app.CmdOStr[1]);
						
						getPlayerList(playerArr);
					}
					doSwitch();
					break;
				case WorldConst.MYCHARATER_SAY:
					
					saying.push(notification.getBody().toString());
					
					break;
				case WorldConst.GET_CHARATER_EQUIPMENT_COMPLETE:
					if(!result.isEnd){
						dressMap.insert(PackData.app.CmdOStr[1],[PackData.app.CmdOStr[2]]);
						
						
					}else{
						for(var i:int=0;i<needStr.length;i++){
							playerList[needStr[i]] = true;
							
							//后台不存在该用户的装备，返回为空，则穿上默认装备
							if(!dressMap.containsKey(needStr[i])){
								
								sendNotification(WorldConst.UPDATE_CHARATER_STATE,
									new CharaterStateVO(needStr[i],"",new Point(Math.random()*1500,180),"","","set5,face_face1"));
								
							}else{
								//装备存在
								sendNotification(WorldConst.UPDATE_CHARATER_STATE,
									new CharaterStateVO(needStr[i],"",new Point(Math.random()*1500,180),"","",dressMap.find(needStr[i])[0]));
								
							}
						}
						
						TweenLite.delayedCall(5,update);
						
						doSwitch();
					}
					
					break;
				case WorldConst.REMOVE_POPUP_SCREEN:
					
//					var switchProxy:SwitchScreenProxy = facade.retrieveProxy(SwitchScreenProxy.NAME) as SwitchScreenProxy;
//					
//					//gpu层-showmessageMediator、freeScrollerMediator
//					if(!switchProxy.cpuFloatScreens.length&&switchProxy.gpuFloatScreens.length==2){
						TweenLite.delayedCall(2,update);
						sendNotification(CoreConst.MANUAL_LOADING,true);
						facade.registerCommand(WorldConst.SWITCH_SCREEN,IslandSwitchScreenCommand);
						
//					}
					
					break;
				case WorldConst.ENABLE_GPU_SCREENS:
					
					var egvo:EnableScreenCommandVO = notification.getBody() as EnableScreenCommandVO;
					
					if(egvo.enable){
						TweenLite.delayedCall(2,update);
						
						facade.registerCommand(WorldConst.SWITCH_SCREEN,IslandSwitchScreenCommand);
						
					}else{
						TweenLite.killTweensOf(update);
					}
					
					
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [UPDATE_REC,WorldConst.MYCHARATER_SAY,WorldConst.GET_CHARATER_EQUIPMENT_COMPLETE,
				WorldConst.REMOVE_POPUP_SCREEN,WorldConst.ENABLE_GPU_SCREENS];
		}
		//接收完数据，处理被截获的switch逻辑
		private function doSwitch():void{
			if(CacheTool.has(HappyIslandMediator.NAME,"switchScreenVO")){
				var type:String;
				
				if(CacheTool.has(HappyIslandMediator.NAME,"switchType"))
					type = CacheTool.getByKey(HappyIslandMediator.NAME,"switchType") as String;
				
				sendNotification(WorldConst.ISLAND_SWITCHSCREEN_FUN,CacheTool.getByKey(HappyIslandMediator.NAME,"switchScreenVO"),type);
			}
		}
		
		
		private function getPlayerList(_list:Array):void{
			for(var i:String in playerList){
				playerList[i] = false;
			}
			
			//清楚需要更新的人物列表
			needStr.splice(0,needStr.length);
			dressMap.clear();
			
			for (var j:int = 0; j < _list.length; j++){
				if(_list[j].operid!=Global.player.operId && _list[j].messageFlag == null){
					var isHad:Boolean = false;
					for(var k:String in playerList){
						if(k == _list[j].operid){
							isHad = true;
							break;
						}
					}
					
					if(!isHad)
						needStr.push(_list[j].operid);
				}
				
			}
			
			//有新人员，请求装备
			if(needStr.length > 0){
				sendNotification(WorldConst.GET_CHARATER_EQUIPMENT,[needStr.join(",")]);
			}else{
				
				
				updatePlayers(_list);
				
				TweenLite.delayedCall(5,update);
				
			}
			
		}
		private function updatePlayers(_list:Array):void{
			for (var i:int = 0; i < _list.length; i++) 
			{
				var o:Object = _list[i];
				if(o.operid && o.operid!=Global.player.operId){
					playerList[o.operid] = true;

					//更新其他玩家的位置
					p.setTo(o.xcoord,o.ycoord);
					
					sendNotification(WorldConst.UPDATE_CHARATER_STATE,new CharaterStateVO(o.operid,o.opername,p,o.addinfo));
				}
				
				if(o.messageFlag != null && o.messageFlag != "X"){
					sendNotification(WorldConst.HAVE_NEW_MESSAGE,o.messageFlag);
				}
			}

			for(var k:String in playerList) 
			{
				if(!playerList[k]){
					sendNotification(WorldConst.CHARATER_LEAVE,new CharaterStateVO(k));
					
					delete playerList[k];
				}
			}
			
			
			
		}
		
		
		
		
		
		
		public function start():void{
			
			TweenLite.delayedCall(5,update);
		}
		
		public function update():void{
			
			if(Global.isLoading){
				TweenLite.delayedCall(2,update);
				return;
			}
			
			
			var sayXmlStr:String = "";
			var char:String = "";
			var len:int = saying.length;
			
			if(len>0){
				for(var i:int=0;i<len;i++){
					var _str:String = saying[i];
					char = _str.charAt(_str.length-1);						
					if(char!=","&&char!="."&&char!="?"&&char!="!"&&char!="，"&&char!="。"&&char!="？"&&char!="！"){
						if((i+1)==len)
							sayXmlStr += _str+"."; 
						else
							sayXmlStr += _str+","; 
					}else
						sayXmlStr += _str;
				}
				
				
				saying.splice(0,len);
				
				
				var dialogueXml:XML = <dialogue/>;
				var sectionXml:XML;
				sectionXml = <section/>;
				
				//替换< 、 >
				sayXmlStr = sayXmlStr.replace(/\</g,"＜");
				sayXmlStr = sayXmlStr.replace(/\>/g,"＞");
				
				sayXmlStr = "<say>"+sayXmlStr+"</say>";
				
				
				sectionXml.say += XML(sayXmlStr);
				
				dialogueXml.section += sectionXml;
				
				sayXmlStr = dialogueXml.toXMLString();
				
				sayXmlStr = sayXmlStr.replace(/\n/g,"");
				
				
			}
			
			var playerCharaterManagement:MyCharaterInforMediator = facade.retrieveMediator(MyCharaterInforMediator.NAME) as MyCharaterInforMediator;
			PackData.app.CmdIStr[0] = CmdStr.QRYUSER_LOCALINFO;
			PackData.app.CmdIStr[1] = playerCharaterManagement.map;
			PackData.app.CmdIStr[2] = Global.player.operId;
			
			var playerView:Sprite = playerCharaterManagement.playerCharater.view;
			PackData.app.CmdIStr[3] = (int(playerView.x)).toString();
			PackData.app.CmdIStr[4] = (int(playerView.y)).toString();
			PackData.app.CmdIStr[5] = sayXmlStr;
			PackData.app.CmdIStr[6] = "";
			PackData.app.CmdInCnt = 7;
			
			sendNotification(CoreConst.LOADING_CLOSE_PROCESS);
			sendNotification(CoreConst.SEND_11,new SendCommandVO(UPDATE_REC));
			
			
		}

		
		
		override public function onRemove():void
		{
			TweenLite.killTweensOf(update);
		}
		

	}
}