package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.card.GameCharaterData;
	import com.mylib.game.house.HouseInfoVO;
	import com.mylib.game.house.IslandNpcHouseMediator;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.MyNPCList;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PixelHitArea;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class GardenIslandMediator extends SceneMediator
	{
		public static const NAME:String = "GardenIslandMediator";
		public static const HOUSE_CLICK:String = NAME + "HouseClick";
		private static const DEL_NPC_COMPLETE:String = NAME + "DelNpcComplete";
		
		private var vo:SwitchScreenVO;
		public var houseList:Vector.<HouseInfoVO>;
		
		private var npcHouseHolder:Sprite;
		private var addHouseBtn:Button;
		
		private var hitArea:PixelHitArea;
		
		private var npcList:MyNPCList;
		private var currentHouse:HouseInfoVO;
		
		public function GardenIslandMediator(_hitArea:PixelHitArea, _houseList:Vector.<HouseInfoVO>, viewComponent:Object=null, camera:CameraSprite=null)
		{
			hitArea = _hitArea;
			houseList = _houseList.concat();
			
			super(NAME, viewComponent, camera);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
		}
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case HOUSE_CLICK:
					
					var houseVo:HouseInfoVO = notification.getBody() as HouseInfoVO;
					currentHouse = houseVo;
					
					var cpList:Vector.<GameCharaterData> = new Vector.<GameCharaterData>;
					
					cpList = (facade.retrieveMediator(IslandsMapMediator.NAME) as IslandsMapMediator).getCPListByHouseId(houseVo.relatId);
					
					/*var npc:String = "";
					
					for(var i:int=0;i<cpList.length;i++){
						
						npc += cpList[i].name+" |";
					}
					
					sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(view.stage,640,381,null,"房子\""+houseId+"\"被点击。 里面住了 "+npc));	*/
					
					
					houseTF.text = "当前驿站："+houseVo.name;
					npcCountTF.text = "统领人数："+cpList.length;
					
					npcList.updateDateByCplist(cpList);
					npcList.visible = true;
					teamControlSp.visible = true;
					
					break;
				case DEL_NPC_COMPLETE:
					if(!result.isErr){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(camera.parent,
							640,381,null,"武将放逐成功！"));
						
						
						//更新本地数据
						var len:int = (facade.retrieveMediator(IslandsMapMediator.NAME) as IslandsMapMediator).myCardPlayerList.length;
						for(var i:int=0;i<len;i++){
							if((facade.retrieveMediator(IslandsMapMediator.NAME) as IslandsMapMediator).myCardPlayerList[i].npcId == (npcList.selectedItem as GameCharaterData).id){
									
								(facade.retrieveMediator(IslandsMapMediator.NAME) as IslandsMapMediator).myCardPlayerList.splice(i,1);
								break;
							}
						}
						
						//刷新npcList
						var _cpList:Vector.<GameCharaterData> = new Vector.<GameCharaterData>;
						_cpList = (facade.retrieveMediator(IslandsMapMediator.NAME) as IslandsMapMediator).getCPListByHouseId(currentHouse.relatId);
						npcCountTF.text = "统领人数："+_cpList.length;
						npcList.updateDateByCplist(_cpList);
					}
					break;
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [HOUSE_CLICK,DEL_NPC_COMPLETE];
		}
		
		override public function onRegister():void
		{
			
			npcHouseHolder = new Sprite();
			camera.addChild(npcHouseHolder);
			
			createFrontPanel();
			
		}
		
		
		override public function run():void
		{
			facade.registerMediator(new IslandNpcHouseMediator(npcHouseHolder,hitArea,houseList));
			
			setHSRange();
			
			addHouseBtn.visible = true;
		}
		
		override public function pause():void
		{
			addHouseBtn.visible = false;
			npcList.visible = false;
			teamControlSp.visible = false;
			
			npcHouseHolder.removeChildren(0,-1,true);
			
			facade.removeMediator(IslandNpcHouseMediator.NAME);
		}
		
		

		
		private var teamControlSp:Sprite;
		private var hideListBtn:feathers.controls.Button;
		private var abandonBtn:feathers.controls.Button;
		private var houseTF:TextField;
		private var npcCountTF:TextField;
		
		private function createFrontPanel():void{
			
			//测试添加房子
			addHouseBtn = new Button();
			addHouseBtn.x = 900;
			addHouseBtn.label = "慢科地产无限公司";
			addHouseBtn.visible = false;
			addHouseBtn.addEventListener(Event.TRIGGERED,addHouseHandle);
			camera.parent.addChild(addHouseBtn);
			
			
			npcList = new MyNPCList();
			npcList.y = 0;
			npcList.visible = false;
			camera.parent.addChild(npcList);
			
			teamControlSp = new Sprite();
			teamControlSp.visible = false;
			camera.parent.addChild(teamControlSp);
			
			
			hideListBtn = new feathers.controls.Button();
			hideListBtn.x = 420;
			hideListBtn.y = 80;
			hideListBtn.label = "隐藏队列";
			hideListBtn.addEventListener(Event.TRIGGERED,hideListBtnHandle);
			teamControlSp.addChild(hideListBtn);
			
			
			abandonBtn = new feathers.controls.Button();
			abandonBtn.x = 420;
			abandonBtn.y = 130;
			abandonBtn.label = "放逐武将";
			abandonBtn.addEventListener(Event.TRIGGERED,abandonBtnHandle);
			teamControlSp.addChild(abandonBtn);
			
			houseTF = new TextField(640,30,"当前驿站：","HuaKanT",28);
			houseTF.x = 600;
			houseTF.y = 85;
			houseTF.hAlign = HAlign.LEFT;
			teamControlSp.addChild(houseTF);
			
			npcCountTF = new TextField(640,30,"统领人数：","HuaKanT",28);
			npcCountTF.x = 600;
			npcCountTF.y = 145;
			npcCountTF.hAlign = HAlign.LEFT;
			teamControlSp.addChild(npcCountTF);
		}
		private function hideListBtnHandle(event:Event):void{
			npcList.visible = false;
			teamControlSp.visible = false;
			
		}
		private function abandonBtnHandle(event:Event):void{
			if(npcList.selectedItem && currentHouse)
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(camera.parent,
					640,381,delNpc,"确定放逐武将： "+(npcList.selectedItem as GameCharaterData).name,null,(npcList.selectedItem as GameCharaterData).id));
			else
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(camera.parent,
					640,381,null,"请您先指派需要放逐的武将。"));
		}
		private function delNpc(npcId:String):void{
			PackData.app.CmdIStr[0] = CmdStr.OUT_PLAYID_ROOMNPC;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = currentHouse.relatId;
			PackData.app.CmdIStr[3] = npcId;
			PackData.app.CmdInCnt = 4;
			
			sendNotification(CoreConst.SEND_11,new SendCommandVO(DEL_NPC_COMPLETE));
			
			
			
			
		}
		private function addHouseHandle(event:Event):void{	
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HouseStoreMediator,npcHouseHolder,SwitchScreenType.SHOW, view.stage)]);
			
		}
			
		
		public function setHSRange(scrToRight:Boolean=false):void{
			var redge:uint = 0;
			
			if(npcHouseHolder.numChildren > 2)
				redge = (npcHouseHolder.numChildren-2)*320;
			
			right = redge+640;
			
			sendNotification(SceneSwitcherMediator.UPDATE_SCENE_RANGE,this);
			
			
			if(scrToRight)
				sendNotification(SceneSwitcherMediator.MOVE_SCENE,right);
			
			
			
//			range.x = -640-ledge;
//			range.width = 1280+ledge+redge;
			
//			sendNotification(CharaterControllerMediator.UPDATE_CHARATER_CONTROLHOLDER,range);
			
		}
		
		
		
		
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			facade.removeMediator(IslandNpcHouseMediator.NAME);
		}
		
		
	}
}