package com.mylib.game.controller
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.controller.vo.UserLocInfoVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.CharaterStateVO;
	import com.studyMate.world.model.MyCharaterInforMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MutiLocationMediator extends Mediator implements IMediator, IMutiOLManager
	{
		public static const NAME:String = "MutiLocationMediator";
		private var QRY_LOCATION_INFO_COMPLETE:String = NAME + "QryLocationInofComplete";
		
		//本地存储玩家列表
		private var playerList:Dictionary = new Dictionary();
		private var needStr:Array = new Array;
		
		private var dressMap:HashMap = new HashMap();
		private var p:Point;
		private var userLocVoList:Vector.<UserLocInfoVO> = new Vector.<UserLocInfoVO>;
		
		public function MutiLocationMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
			p = new Point();
			
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case WorldConst.GET_CHARATER_EQUIPMENT_COMPLETE:
					if(!result.isEnd){
						dressMap.insert(PackData.app.CmdOStr[1],[PackData.app.CmdOStr[2],PackData.app.CmdOStr[3]]);
						
					}else{
						
						//取完后，取登记
//						sendNotification(WorldConst.GET_LEVEL_LIST, [dressMap, needStr]);
						
						for(var i:int=0;i<needStr.length;i++){
							//将新人加入本地玩家列表
							playerList[needStr[i]] = true;
							
							//后台不存在该用户的装备，返回为空，则穿上默认装备
							if(!dressMap.containsKey(needStr[i])){
								
								sendNotification(WorldConst.UPDATE_CHARATER_STATE,
									new CharaterStateVO(needStr[i],"",new Point(Math.random()*1500,180),"","","set5,face_face1"));
								
							}else{
								//装备存在
								sendNotification(WorldConst.UPDATE_CHARATER_STATE,
									new CharaterStateVO(needStr[i],"",new Point(Math.random()*1500,180),"","",dressMap.find(needStr[i])[0],dressMap.find(needStr[i])[1]));
								
							}
						}
						
						sendNotification(WorldConst.MUTICONTROL_READY);
						
					}
					
					break;
				case QRY_LOCATION_INFO_COMPLETE:
					if(!result.isEnd){
						
						userLocVoList.push(new UserLocInfoVO(PackData.app.CmdOStr[1],
							PackData.app.CmdOStr[2],PackData.app.CmdOStr[3]));
						
					}else{
						for (var j:int = 0; j < userLocVoList.length; j++){
							/*trace("位置：x:"+userLocVoList[j].x+"y:"+userLocVoList[j].y);*/
							p.setTo(userLocVoList[j].x,userLocVoList[j].y);
							
							sendNotification(WorldConst.UPDATE_CHARATER_STATE,new CharaterStateVO(userLocVoList[j].id,"",p));
						}
						
						
						
						sendNotification(WorldConst.MUTICONTROL_READY);
					}
					break;
				
			}
		}
		override public function listNotificationInterests():Array
		{
			return [WorldConst.GET_CHARATER_EQUIPMENT_COMPLETE,QRY_LOCATION_INFO_COMPLETE];
		}
		
		
		
		
		public function setData(_mutiData:String):void
		{
			resetPlayerList();
			needStr.splice(0,needStr.length);
			
			//如果为空，则直接清理场景人物
			if(_mutiData == " " || _mutiData == "" || _mutiData == null){
				
				clearPlyer();
				
				sendNotification(WorldConst.MUTICONTROL_READY);
			
			//不为空，取装备、或者更新坐标	
			}else{
				/*trace("不空.");*/
				
				var mdArr:Array = _mutiData.split(",");
				
				for(var i:int=0;i<mdArr.length;i++){
					var isHad:Boolean = false;
					for(var j:String in playerList){
						if(j == mdArr[i]){
							isHad = true;
							break;
						}
					}
					
					if(!isHad)
						needStr.push(mdArr[i]);
					
				}
				
				//有新人员，请求装备
				if(needStr.length > 0){
					/*trace("有新人");*/
//					sendNotification(WorldConst.GET_CHARATER_EQUIPMENT,[needStr.join(",")]);
					updateEquipment(needStr.join(","));
				}else{
					/*trace("没新人，更新坐标");*/
					updatePlayers(mdArr);
					
				}
				
			}
		}
		
		private function updatePlayers(_idArr:Array):void{
			
			//标记在的人
			for (var i:int = 0; i < _idArr.length; i++) 
				playerList[_idArr[i]] = true;
			
			getLocation();
			
			
			clearPlyer();
		}
		
		private function getLocation():void{
			TweenLite.killTweensOf(getLocation);
			if(Global.isLoading){
				TweenLite.delayedCall(2,getLocation);
				return;
			}
			
			userLocVoList.splice(0,userLocVoList.length);
			
			var playerCharaterManagement:MyCharaterInforMediator = facade.retrieveMediator(MyCharaterInforMediator.NAME) as MyCharaterInforMediator;
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_LOCATION_INFO;
			PackData.app.CmdIStr[1] = playerCharaterManagement.map;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_LOCATION_INFO_COMPLETE,null,'cn-gb',null,SendCommandVO.QUEUE));
			
			
			
		}
		//更新装备
		private function updateEquipment(_idList:String):void{
			TweenLite.killTweensOf(updateEquipment);
			if(Global.isLoading){
				TweenLite.delayedCall(2,updateEquipment,[_idList]);
				return;
			}
			
			sendNotification(WorldConst.GET_CHARATER_EQUIPMENT,[_idList]);
			
			
		}
		
		private function getCharaterLevel():void{
//			for(var i:int=0;i<needStr.length;i++){
////				send
//				
//			}
			
			
		}
		
		
		public function isReady(_param:*):Boolean
		{
			//有人
			for(var i:String in playerList)
				return true;
			//没人
			return false;
		}
		
		

		
		
		//重置所有人，标记为flase。
		private function resetPlayerList():void{
			for(var i:String in playerList){
				playerList[i] = false;
				
			}
		}
		//清理场景人物
		private function clearPlyer():void{
			for(var i:String in playerList) 
			{
				if(!playerList[i]){
					sendNotification(WorldConst.CHARATER_LEAVE,new CharaterStateVO(i));
					trace("踢走："+i);
					delete playerList[i];
				}
			}
			
			
			
			
		}
		
		
		
		override public function onRemove():void
		{
			super.onRemove();
			
			TweenLite.killTweensOf(getLocation);
			TweenLite.killTweensOf(updateEquipment);
			
		}
		
		
		
		
	}
}