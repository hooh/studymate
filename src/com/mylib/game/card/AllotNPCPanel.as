package com.mylib.game.card
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.component.NPCList;
	import com.studyMate.world.model.vo.IslandDataVO;
	import com.studyMate.world.screens.BasementMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class AllotNPCPanel extends ScreenBaseMediator
	{
		public static const NAME:String = "AllotNPCPanel";
		private var npcList:NPCList;
		private var closeBtn:Button;
		private var tvo:SwitchScreenVO;
		private var currentSelector:NPCSelectItem;
		private var bg:Quad;
		private var lvData:IslandDataVO;
		private var npcListData:Vector.<GameCharaterData>;
		private const UPDATE_NPC_COMPLETE:String = "updateNpcComplete";
		private var basement:BasementMediator;
		
		private const DELETE_NPC_COMPLETE:String = "deleteNpcComplete";
		
		
		
		public function AllotNPCPanel(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			bg = new Quad(600,600,0xfdca5d);
			view.addChild(bg);
			
			
			npcList = new NPCList();
			
			npcList.addEventListener( Event.CHANGE, list_changeHandler );
			
			npcList.visible = false;
			
			closeBtn = new Button();
			closeBtn.label = "关闭";
			closeBtn.x = 500;
			view.addChild(closeBtn);
			closeBtn.addEventListener(Event.TRIGGERED,closeHandle);
			
			
			
			
			
			var selector:NPCSelectItem;
			for (var i:int = 0; i < 3; i++) 
			{
				selector = new NPCSelectItem;
				selector.x = i*100+100;
				selector.y = 100;
				selector.addEventListener(NPCSelectItem.SELECT,itemSelectorHandle);
				selector.addEventListener(NPCSelectItem.DELETE,itemDeleteHandle);
				view.addChild(selector);
				
				if(i<basement.heros.length){
					selector.charaterData = basement.heros[i].data;
				}
				
			}
			
			view.addChild(npcList);
			
		}
		
		private function itemDeleteHandle(event:Event):void
		{
			
			PackData.app.CmdIStr[0] = CmdStr.DEL_PLAY_NPC_LAND;
			PackData.app.CmdIStr[1] = (event.currentTarget as NPCSelectItem).charaterData.allotId;
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(DELETE_NPC_COMPLETE,[event.currentTarget]));
			
		}
		
		private function isEnableChoosed(element:GameCharaterData, index:int, arr:Vector.<GameCharaterData>):Boolean {
			
			return element.allotId==null;
		}
		
		
		private function itemSelectorHandle(event:Event):void
		{
				
			npcList.playersData=npcListData.filter(isEnableChoosed);
			npcList.refreshList();
			currentSelector = event.currentTarget as NPCSelectItem;
			
			
			npcList.visible = true;
				
		}
		
		private function closeHandle(event:Event):void
		{
			tvo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[tvo]);
		}		
		
		private function list_changeHandler(event:Event):void
		{
			var list:List = List( event.currentTarget );
			if(list.selectedItem){
				
				PackData.app.CmdIStr[0] = CmdStr.INUP_PLAYNPCLAND;
				if(currentSelector.charaterData){
					PackData.app.CmdIStr[1] = currentSelector.charaterData.allotId;
				}else{
					PackData.app.CmdIStr[1] = "0";
				}
				
				
				PackData.app.CmdIStr[2] = Global.player.operId;
				PackData.app.CmdIStr[3] = lvData.id.toString();
				PackData.app.CmdIStr[4] = (list.selectedItem as GameCharaterData).id;
				PackData.app.CmdInCnt = 5;
				sendNotification(CoreConst.SEND_11,new SendCommandVO(UPDATE_NPC_COMPLETE,[currentSelector,list.selectedItem,PackData.app.CmdIStr[1]]));
				
				
				
				
			}
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var vo:DataResultVO;
			switch(notification.getName())
			{
				case UPDATE_NPC_COMPLETE:
				{
					
					vo = notification.getBody() as DataResultVO;
					if(!vo.isErr){
						npcList.visible = false;
						npcList.selectedItem = null;
						npcList.validate();
						var selector:NPCSelectItem = vo.para[0];
						var charaterData:GameCharaterData = vo.para[1];
						
						selector.charaterData = charaterData;
						
						charaterData.allotId = PackData.app.CmdOStr[1];
						if(vo.para[2]!=PackData.app.CmdOStr[1]){
							basement.heros.push(new GameCharater(charaterData,null));
						}else{
							
							for (var i:int = 0; i < basement.heros.length; i++) 
							{
								if(basement.heros[i].data.allotId==PackData.app.CmdOStr[1]){
									basement.heros[i].data.allotId = null;
									
									if(basement.heros[i].fighter){
										TweenLite.killTweensOf(basement.heros[i].fighter);
										(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).object = basement.heros[i].fighter;
										basement.heros[i].fighter.charater.view.removeFromParent();
									}
									
									
									basement.heros[i] = new GameCharater(charaterData,null);
									break;
								}
							}
							
						}
						
						
					}
					
					break;
				}
				case DELETE_NPC_COMPLETE:{
					vo = notification.getBody() as DataResultVO;
					
					if(!vo.isErr){
						
						if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){
							for (var j:int = 0; j < basement.heros.length; j++) 
							{
								if(basement.heros[j].data.allotId==PackData.app.CmdOStr[1]){
									break;
								}
							}
							
							if(basement.heros[j].fighter){
								TweenLite.killTweensOf(basement.heros[j].fighter);
								(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).object = basement.heros[j].fighter;
								basement.heros[j].fighter.charater.view.removeFromParent();
								basement.heros[j].fighter = null;
							}
							
							basement.heros[j].data.allotId = null;
							basement.heros.splice(j,1);
							
							(vo.para[0] as NPCSelectItem).charaterData = null;
							
							
							
							
						}
						
						
						
						
						
					}
					
					
					
					
					
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			
			
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [UPDATE_NPC_COMPLETE,DELETE_NPC_COMPLETE];
		}
		
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			tvo = vo;
			lvData = tvo.data[0] as IslandDataVO;
			npcListData = tvo.data[1] as Vector.<GameCharaterData>;
			basement = tvo.data[2];
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
	}
}