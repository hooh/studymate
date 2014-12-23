package com.studyMate.module.game.gameEditor
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.card.CValue;
	import com.mylib.game.card.GameCharaterData;
	import com.mylib.game.card.HeroAttribute;
	import com.mylib.game.card.SkeletonType;
	import com.mylib.game.charater.BMPCharaterMediator;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.game.api.NPCEditorConst;
	import com.studyMate.world.component.NPCList;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.CardGameStageMediator;
	import com.studyMate.world.screens.DressPanelMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.text.TextFormat;
	
	import de.polygonal.core.ObjectPool;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class NPCEditorMediator extends ScreenBaseMediator
	{	
		private var list:NPCList;
		
		
		private var gameHolder:Sprite;
		
		private var uiHolder:Sprite;
		
		
		private var charater:HumanMediator;
		
		private var editEquipmentBtn:Button;
		private var panelVO:SwitchScreenVO;
		private var newPlayerBtn:Button;
		private var savePlayerBtn:Button;
		private var refreshListBtn:Button;
		private var delBtn:Button;
		private var skeletonList:PickerList;
		private var ai:TextInput;
		private var scale:TextInput;
		
		private var bmpCharater:BMPCharaterMediator;
		
		private var bmpSuitsEditor:BMPSuitEditor;
		
		private var fcp:FightCharaterPoolProxy;
		
		
		public function NPCEditorMediator(viewComponent:Object=null)
		{
			super(ModuleConst.NPC_EDITOR, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var dvo:DataResultVO;
			switch(notification.getName())
			{
				case NPCEditorConst.UPDATE_LIST_REC:{
					dvo = notification.getBody() as DataResultVO;
					
					if(dvo.isErr){
						
					}else{
						updateListData(dvo.para[0]);
					}
					
					break;
				}
				case NPCEditorConst.NPC_DEL:{
					dvo = notification.getBody() as DataResultVO;
					
					if(dvo.isErr){
						
					}else{
						
						
						if((PackData.app.CmdOStr[0] as String).charAt(1)!="M"){
							
							
							deletListData(dvo.para[0]);
							
							
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
		
		private function deletListData(cardPlayer:GameCharaterData):void{
			if(list.dataProvider){
				var dataCollection:ListCollection = list.dataProvider;
				
				var idx:int = -1;
				for (var i:int = 0; i < dataCollection.length; i++) 
				{
					var dataItem:GameCharaterData = dataCollection.getItemAt(i) as GameCharaterData
					if(dataItem.name==cardPlayer.name){
						idx = i;
						break;
					}
				}
				
				if(idx>=0){
					dataCollection.removeItemAt(idx);
				}
				
				
			}
			
			
			
		}
		
		private function updateListData(cardPlayer:GameCharaterData):void{
			list.dataProvider||=new ListCollection();
			var dataCollection:ListCollection = list.dataProvider;
			
			var founded:Boolean = false;
			for (var i:int = 0; i < dataCollection.length; i++) 
			{
				var dataItem:GameCharaterData = dataCollection.getItemAt(i) as GameCharaterData
				if(dataItem.name==cardPlayer.name){
					dataCollection.setItemAt(cardPlayer.clone(),i);
					founded = true;
					break;
				}
			}
			
			if(!founded){
				dataCollection.addItem(cardPlayer.clone());
			}
			
			list.validate();
			
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [NPCEditorConst.UPDATE_LIST_REC,NPCEditorConst.NPC_DEL];
		}
		
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		private function getNACList():void{
			/*PackData.app.CmdIStr[0] = CmdStr.QRYNPCROLEINFO;
			PackData.app.CmdIStr[1] = "*";
			PackData.app.CmdInCnt = 2;
			sendNotification(ApplicationFacade.SEND_11,new SendCommandVO(NPC_LIST_REC));*/
		}
		
		
		override public function onRegister():void
		{
			
			uiHolder = new Sprite();
			view.addChild(uiHolder);
			
			list = new NPCList();
			list.y = 60;
			view.addChild(list);
			list.addEventListener( Event.CHANGE, list_changeHandler );
			
			bmpSuitsEditor = new BMPSuitEditor;
			uiHolder.addChild(bmpSuitsEditor);
			bmpSuitsEditor.y = 380;
			
			bmpSuitsEditor.updateBtn.addEventListener(Event.TRIGGERED,bmpSuitsUpdateHandle);
			
			
			/*for (var i:int = 0; i < 100; i++) 
			{
				rawData.push(new NPCRawDataVO("","abcdefghijklmno","face_face1,clothes14,shoes2,hair18,sword","E",
				"1_5|2_4|3_3|4_2|5_1"
				));
				
			}*/
			
			
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			
//			game.setGroupData(game.group1,playersData.slice(0,5),1);
//			game.setGroupData(game.group2,playersData.slice(5,10),-1);
//			game.startGame();
			
			uiHolder.addChild(list);
			
			
			charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool).object;
			uiHolder.addChild(charater.view);
			
			fcp = new FightCharaterPoolProxy(true);
			facade.registerProxy(fcp);
			fcp.init();
			
			
			fcp.charaterPool = facade.retrieveProxy(ModuleConst.BMP_FIGHTER_POOL) as ObjectPool;
			
			
			
			bmpCharater = (facade.retrieveProxy(ModuleConst.BMP_FIGHTER_POOL) as ObjectPool).object;
			bmpCharater.idle();
			uiHolder.addChild(bmpCharater.view);
			bmpCharater.view.x = 1200;
			bmpCharater.view.y = 300;
			GlobalModule.charaterUtils.humanDressFun(bmpCharater,"bmpNpc_boar1");
			bmpCharater.action("die",false);
			
			charater.view.x = 1100;
			charater.view.y = 300;
			charater.sex = "A";
			
			panelVO = new SwitchScreenVO(DressPanelMediator,[charater,null],SwitchScreenType.HIDE,uiHolder,0,300);
			
			
			editEquipmentBtn = new Button();
			editEquipmentBtn.addEventListener(TouchEvent.TOUCH,editEquipmentBtnHandle);
			editEquipmentBtn.label = "装备";
			editEquipmentBtn.x = 440;
			editEquipmentBtn.y = 10;
			uiHolder.addChild(editEquipmentBtn);
			
			newPlayerBtn = new Button();
			newPlayerBtn.label = "新增npc";
			newPlayerBtn.addEventListener(TouchEvent.TOUCH,newPlayerBtnHandle);
			newPlayerBtn.x = 500;
			newPlayerBtn.y = 10;
			uiHolder.addChild(newPlayerBtn);
			
			savePlayerBtn = new Button();
			savePlayerBtn.label = "保存";
			savePlayerBtn.addEventListener(TouchEvent.TOUCH,savePlayerBtnHandle);
			savePlayerBtn.x = 600;
			savePlayerBtn.y = 10;
			uiHolder.addChild(savePlayerBtn);
			
			refreshListBtn = new Button;
			refreshListBtn.label = "刷新列表";
			refreshListBtn.x = 440;
			refreshListBtn.y = 60;
			uiHolder.addChild(refreshListBtn);
			refreshListBtn.addEventListener(TouchEvent.TOUCH,refreshListBtnHandle);
			
			delBtn = new Button;
			
			delBtn.label = "删除";
			delBtn.x = 550;
			delBtn.y = 60;
			uiHolder.addChild(delBtn);
			delBtn.addEventListener(Event.TRIGGERED,delListBtnHandle);
			
			
			
			skeletonList = new PickerList();
			skeletonList.prompt = "骨骼类型";
			skeletonList.dataProvider = new ListCollection([{text:SkeletonType.HUMAN,value:SkeletonType.HUMAN},{text:SkeletonType.BMP,value:SkeletonType.BMP}]);
			skeletonList.typicalItem = { text: "骨骼类型" };
			skeletonList.labelField = "text";
			skeletonList.selectedIndex = -1;
			skeletonList.x = 550;
			skeletonList.y = 120;
			skeletonList.listProperties.@itemRendererProperties.labelField = "text";
			uiHolder.addChild(skeletonList);
			
			
			ai = new TextInput;
			ai.prompt = "ai";
			ai.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			ai.promptProperties.embedFonts = true;
			ai.x = 440;
			ai.y = 180;
			uiHolder.addChild(ai);
			
			
			scale = new TextInput;
			scale.prompt = "scale";
			scale.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			scale.promptProperties.embedFonts = true;
			scale.restrict = "0-9";
			scale.maxChars = 1;
			scale.x = 440;
			scale.y = 240;
//			scale.setFocus();
			uiHolder.addChild(scale);
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(NPCValueEditorPanel,null,SwitchScreenType.SHOW,uiHolder,700,20)]);
			
		}
		
		private function bmpSuitsUpdateHandle(event:Event):void
		{
			
			GlobalModule.charaterUtils.humanDressFun(bmpCharater,bmpSuitsEditor.suitTxt.text);
			bmpCharater.action(bmpSuitsEditor.actionTxt.text);
			
		}		
		
		private function delListBtnHandle(event:Event):void
		{
			var editor:NPCValueEditorPanel = facade.retrieveMediator(ModuleConst.NPC_VALUE_EDITOR_PANEL) as NPCValueEditorPanel;
			editor.updateData();
			if(!editor.data){
				return;
			}
			var delItem:GameCharaterData = editor.data;
			
			PackData.app.CmdIStr[0] = CmdStr.DEL_NPC_ROLE_INFO;
			PackData.app.CmdIStr[1] = delItem.name;
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(NPCEditorConst.NPC_DEL,[delItem]));
		}		
			
			
		private function refreshListBtnHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				list.updateData();
				
			}
		}
		
		private function savePlayerBtnHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				var editor:NPCValueEditorPanel = facade.retrieveMediator(ModuleConst.NPC_VALUE_EDITOR_PANEL) as NPCValueEditorPanel;
				editor.updateData();
				if(editor.data.name==""){
					
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("请输入npc名字"));
					
					return;
				}
				if(skeletonList.selectedItem){
					editor.data.skeleton = skeletonList.selectedItem.value;
				}else{
					editor.data.skeleton = skeletonList.dataProvider.getItemAt(0).value;
				}
				
				editor.data.job = parseInt(ai.text);
				editor.data.scale = parseFloat(scale.text);
				
				if(!editor.data){
					return;
				}
				
				
				if(editor.data.skeleton==SkeletonType.BMP){
					editor.data.equiment = bmpSuitsEditor.suitTxt.text;
				}else{
					editor.data.equiment = GlobalModule.charaterUtils.getHumanDressList(charater);
				}
				
				
				
				PackData.app.CmdIStr[0] = CmdStr.INTUPD_NPC_ROLE_INFO;
				PackData.app.CmdIStr[1] = editor.data.name;
				PackData.app.CmdIStr[2] = editor.data.equiment;
				PackData.app.CmdIStr[3] = editor.data.charaterClass;
				PackData.app.CmdIStr[4] = editor.data.fullHP.toString();
				PackData.app.CmdIStr[5] = editor.data.state;
				PackData.app.CmdIStr[6] = editor.data.skeleton;
				PackData.app.CmdIStr[7] = editor.data.job.toString();
				PackData.app.CmdIStr[8] = editor.data.scale.toString();
				PackData.app.CmdIStr[9] = CardGameStageMediator.getCardPlayerPropertyStr(editor.data);
				PackData.app.CmdInCnt = 10;
				sendNotification(CoreConst.SEND_11,new SendCommandVO(NPCEditorConst.UPDATE_LIST_REC,[editor.data]));
			}
		}
		
		private function newPlayerBtnHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				var editor:NPCValueEditorPanel = facade.retrieveMediator(ModuleConst.NPC_VALUE_EDITOR_PANEL) as NPCValueEditorPanel;
				
				var newData:GameCharaterData = new GameCharaterData();
				newData.state = "a";
				newData.charaterClass = "f";
				newData.fullHP = 30;
				
				newData.values = new Vector.<CValue>;
				for (var i:int = 0; i < HeroAttribute.cardColor.length; i++) 
				{
					var card:CValue = new CValue(i+1, Math.random()*11);
					newData.values.push(card);
				}
				editor.data = newData;
				
				
				GlobalModule.charaterUtils.configHumanFromDressList(charater,"",null);
				
				list.selectedIndex = -1;
				list.isSelectable = false;
				list.validate();
				list.isSelectable = true;
				
			}
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool).object=charater;
			(facade.retrieveProxy(ModuleConst.BMP_FIGHTER_POOL) as ObjectPool).object = bmpCharater;
			
		}
		
		
		private function editEquipmentBtnHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				if(skeletonList.selectedItem){
					
					if(skeletonList.selectedItem.value==SkeletonType.BMP){
						panelVO.type = SwitchScreenType.HIDE;
						sendNotification(WorldConst.SWITCH_SCREEN,[panelVO]);
						
						bmpSuitsEditor.visible=!bmpSuitsEditor.visible;
						
					}else{
						bmpSuitsEditor.visible = false;
						if(panelVO.type==SwitchScreenType.SHOW){
							panelVO.type = SwitchScreenType.HIDE;
						}else{
							panelVO.type = SwitchScreenType.SHOW;
						}
						sendNotification(WorldConst.SWITCH_SCREEN,[panelVO]);
					}
				}
				
			}
			
		}
		
		private function list_changeHandler(event:Event):void
		{
			var list:List = List( event.currentTarget );
			if(list.selectedItem){
				
				
				if((list.selectedItem as GameCharaterData).skeleton ==SkeletonType.BMP ){
					GlobalModule.charaterUtils.configHumanFromDressList(bmpCharater,(list.selectedItem as GameCharaterData).equiment,null);
					bmpCharater.action("idle");
					bmpSuitsEditor.suitTxt.text = (list.selectedItem as GameCharaterData).equiment;
					
				}else{
					GlobalModule.charaterUtils.configHumanFromDressList(charater,(list.selectedItem as GameCharaterData).equiment,null);
					charater.look("normal");
				}
				
				
				
				
				var editor:NPCValueEditorPanel = facade.retrieveMediator(ModuleConst.NPC_VALUE_EDITOR_PANEL) as NPCValueEditorPanel;
				
				editor.data = (list.selectedItem as GameCharaterData).clone();
				ai.text = editor.data.job.toString();
				scale.text = editor.data.scale.toString();
				
				skeletonList.selectedIndex = -1;
				for (var i:int = 0; i < skeletonList.dataProvider.length; i++) 
				{
					if(skeletonList.dataProvider.getItemAt(i).text == (list.selectedItem as GameCharaterData).skeleton){
						skeletonList.selectedIndex = i;
					}
				}
				
				panelVO.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[panelVO]);
				bmpSuitsEditor.visible = false;
				
			}
			
		}		
		
		
		
		
		
		
	}
}
import feathers.controls.Button;
import feathers.controls.TextInput;

import starling.display.Sprite;

class BMPSuitEditor extends Sprite{
	
	public var suitTxt:TextInput;
	public var actionTxt:TextInput;
	
	public var updateBtn:Button;
	
	public function BMPSuitEditor(){
		suitTxt = new TextInput;
		addChild(suitTxt);
		
		actionTxt = new TextInput;
		addChild(actionTxt);
		actionTxt.y = 50;
		
		updateBtn = new Button();
		updateBtn.label = "更新";
		addChild(updateBtn);
		
		updateBtn.x = 250;
		
		
	}
	
	
}

