package com.studyMate.module.game.gameEditor
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.card.GameCharaterData;
	import com.mylib.game.ui.HPTextPool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.ModuleUtils;
	import com.studyMate.module.game.api.GameTaskEditorConst;
	import com.studyMate.module.underWorld.api.IBasement;
	import com.studyMate.world.component.GameTaskList;
	import com.studyMate.world.component.NPCList;
	import com.studyMate.world.model.vo.GameTaskVO;
	import com.studyMate.world.screens.BasementMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class GameTaskEditorMediator extends ScreenBaseMediator
	{
		private var list:NPCList;
		private var gameHolder:Sprite;
		private var fightTaskUI:Sprite;
		
		private var gameUI:Sprite;
		private var taskUI:ScrollContainer;
		private var taskHolder:Sprite;
		private var _tabBar:TabBar;
		private var islandIds:TextInput;
		
		
		private var leftGroupIDS:Label;
		private var rightGroupIDS:Label;
		
		private var basement:IBasement;
		
		
		public function GameTaskEditorMediator(viewComponent:Object=null)
		{
			super(ModuleConst.GAMETASK_EDITOR, viewComponent);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			basement.reset();
			facade.removeMediator((basement as IMediator).getMediatorName());
			taskHolder.removeChildren(0,-1,true);
			gameUI.removeChildren(0,-1,true);
			gameHolder.removeChildren(0,-1,true);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRegister():void
		{
			var btn:Button;
//			btn.addEventListener(Event.TRIGGERED,
			
			taskHolder = new Sprite;
			view.addChild(taskHolder);
			
			if(!facade.hasProxy(HPTextPool.NAME)){
				facade.registerProxy(new HPTextPool);
			}
			
			
			gameUI = new Sprite;
			view.addChild(gameUI);
			gameUI.y = taskHolder.y = 60;
			
			_tabBar = new TabBar();
			_tabBar.dataProvider = new ListCollection(
				[
					{ label: "任务" },
					{ label: "战斗" }
				]);
			
			
			view.addChild(_tabBar);
			
			_tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			
			createTaskUI();
			
			
			
			list = new NPCList();
			list.y = 0;
			gameUI.addChild(list);
			
			var refreshListBtn:Button = new Button;
			refreshListBtn.label = "刷新列表";
			refreshListBtn.x = 500;
			gameUI.addChild(refreshListBtn);
			refreshListBtn.addEventListener(Event.TRIGGERED,refreshListBtnHandle);
			
			gameHolder = new Sprite();
			gameHolder.y = 440;
			gameUI.addChild(gameHolder);
			
			fightTaskUI = new Sprite;
			gameUI.addChild(fightTaskUI);
			fightTaskUI.x = 400;
			
			btn = new Button();
			btn.label = ">>>>left";
			fightTaskUI.addChild(btn);
			btn.addEventListener(Event.TRIGGERED,addLeftHandle);
			
			btn = new Button();
			btn.y = 60;
			btn.addEventListener(Event.TRIGGERED,addRightHandle);
			fightTaskUI.addChild(btn);
			btn.label = ">>>>right";
			
			btn = new Button();
			btn.y = 120;
			btn.addEventListener(Event.TRIGGERED,startHandle);
			fightTaskUI.addChild(btn);
			btn.label = "start";
			
			btn = new Button();
			btn.y = 120;
			btn.x = 80;
			btn.addEventListener(Event.TRIGGERED,resetHandle);
			fightTaskUI.addChild(btn);
			btn.label = "reset";
			
			btn = new Button();
			btn.y = 120;
			btn.x = 160;
			btn.addEventListener(Event.TRIGGERED,saveScriptHandle);
			fightTaskUI.addChild(btn);
			btn.label = "保存";
			
			leftGroupIDS = new Label;
			leftGroupIDS.y =200;
			gameUI.addChild(leftGroupIDS);
			
			rightGroupIDS = new Label;
			rightGroupIDS.y =200;
			rightGroupIDS.x = 700;
			gameUI.addChild(rightGroupIDS);
			
			
			rightGroupIDS.textRendererProperties.textFormat =leftGroupIDS.textRendererProperties.textFormat = new TextFormat( null, 16, 0 );

			
			basement = new BasementMediator("1");
			facade.registerMediator(basement as IMediator);
			
			gameHolder.addChild(basement.view);
			
			
		}
		
		private function saveScriptHandle(event:Event):void{
			
			scriptEditor.text = rightGroupIDS.text;
		}
		
		
		private var playerNumber:TextInput;
		private var scriptEditor:TextInput;
		private var time:TextInput;
		private var reward:TextInput;
		private var isMainLine:TextInput;
		private var orderNum:TextInput;
		private var description:TextInput;
		private var typeList:PickerList;
		private var taskName:TextInput;
		private var taskId:TextInput;
		private var taskCD:TextInput;
		
		private var taskList:GameTaskList;
		
		private function createTaskUI():void{
			
			
			var layout:TiledRowsLayout;
			layout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.gap = 20;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			layout.useSquareTiles = false;
			
			taskUI = new ScrollContainer();
			taskUI.layout = layout;
			taskUI.snapScrollPositionsToPixels = true;
			//			taskUI.snapToPages = true;
			taskUI.width = 800;
			taskUI.height = 700;
			taskHolder.addChild(taskUI);
			
			
			
			var btn:Button;
			
			typeList = new PickerList();
			typeList.prompt = "任务类型";
			
			typeList.dataProvider = new ListCollection([{text:"挖矿",value:"m"},{text:"战斗",value:"b"}]);
			typeList.typicalItem = { text: "任务类型" };
			typeList.labelField = "text";
			typeList.selectedIndex = -1;
			typeList.listProperties.@itemRendererProperties.labelField = "text";
			taskUI.addChild(typeList);
			
			taskId = new TextInput();
			taskId.prompt = "任务id";
			taskId.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			taskId.promptProperties.embedFonts = true;
			taskId.restrict = "0-9";
			taskUI.addChild(taskId);
			
			islandIds = new TextInput();
			islandIds.prompt = "岛屿id，逗号分隔";
			islandIds.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			islandIds.promptProperties.embedFonts = true;
			taskUI.addChild(islandIds);
			
			playerNumber = new TextInput();
			playerNumber.prompt = "玩家数目";
			playerNumber.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			playerNumber.promptProperties.embedFonts = true;
			playerNumber.maxChars = 1;
			playerNumber.restrict = "0-9";
			taskUI.addChild(playerNumber);
			
			
			scriptEditor = new TextInput();
			scriptEditor.prompt = "脚本";
			scriptEditor.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			scriptEditor.promptProperties.embedFonts = true;
			taskUI.addChild(scriptEditor);
			
			time = new TextInput;
			time.prompt = "任务时间";
			time.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			time.promptProperties.embedFonts = true;
			time.restrict = "0-9";
			taskUI.addChild(time);
			
			reward = new TextInput;
			reward.prompt = "奖励";
			reward.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			reward.promptProperties.embedFonts = true;
			reward.restrict = "0-9";
			taskUI.addChild(reward);
			
			isMainLine = new TextInput;
			isMainLine.prompt = "是否主线任务Y/N";
			isMainLine.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			isMainLine.promptProperties.embedFonts = true;
			isMainLine.restrict = "YN";
			isMainLine.maxChars = 1;
			taskUI.addChild(isMainLine);
			
			
			orderNum = new TextInput;
			orderNum.prompt = "顺序";
			orderNum.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			orderNum.promptProperties.embedFonts = true;
			orderNum.restrict = "0-9";
			orderNum.maxChars = 3;
			taskUI.addChild(orderNum);
			
			description = new TextInput;
			description.prompt = "任务描述";
			description.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			description.promptProperties.embedFonts = true;
			taskUI.addChild(description);
			
			
			taskName = new TextInput;
			taskName.prompt = "任务名称";
			taskName.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			taskName.promptProperties.embedFonts = true;
			taskName.setFocus();
			taskUI.addChild(taskName);
			
			taskCD = new TextInput;
			taskCD.prompt = "冷却";
			taskCD.promptProperties.textFormat = new TextFormat("HeiTi",14,0xffffff);
			taskCD.promptProperties.embedFonts = true;
			taskCD.restrict = "0-9";
			taskUI.addChild(taskCD);
			
			btn = new Button();
			btn.label = "保存";
			taskUI.addChild(btn);
			btn.addEventListener(Event.TRIGGERED,saveTaskHandle);
			
			btn = new Button();
			btn.label = "新建";
			taskUI.addChild(btn);
			btn.addEventListener(Event.TRIGGERED,newTaskHandle);
			
			btn = new Button();
			btn.label = "刷新";
			taskUI.addChild(btn);
			btn.addEventListener(Event.TRIGGERED,refreshGameTaskHandle);
			
			btn = new Button();
			btn.label = "删除";
			taskUI.addChild(btn);
			btn.addEventListener(Event.TRIGGERED,removeHandle);
			
			taskList = new GameTaskList();
			taskList.x = 800;
			taskHolder.addChild(taskList);
			
			taskList.addEventListener( Event.CHANGE, list_changeHandler );
			
		}
		
		private function removeHandle(event:Event):void{
			
			if(taskList.selectedItem){
				PackData.app.CmdIStr[0] = CmdStr.DELETE_GAME_TASK;
				PackData.app.CmdIStr[1] = (taskList.selectedItem as GameTaskVO).id.toString();
				PackData.app.CmdInCnt = 2;
				sendNotification(CoreConst.SEND_1N,new SendCommandVO(GameTaskEditorConst.REMOVE_TASK,[taskList.selectedItem]));
			}
			
		}
		
		
		private function list_changeHandler(event:Event):void
		{
			var list:List = List( event.currentTarget );
			if(list.selectedItem){
				var vo:GameTaskVO = list.selectedItem as GameTaskVO;
				taskId.text = vo.id.toString();
				description.text = vo.description;
				taskCD.text = vo.cd.toString();
				islandIds.text = vo.islandIDs;
				isMainLine.text = vo.isMainLine;
				taskName.text = vo.name;
				orderNum.text = vo.orderNum.toString();
				playerNumber.text = vo.playerNumber.toString();
				reward.text = vo.reward.toString();
				time.text = vo.time.toString();
				scriptEditor.text = vo.script;
				
				for (var i:int = 0; i < typeList.dataProvider.length; i++) 
				{
					if(typeList.dataProvider.data[i].value ==vo.type){
						
						
						typeList.selectedIndex = i;
						break;
						
					}
				}
				
				
				
				
			}
			
		}
		
		private function refreshGameTaskHandle(event:Event):void{
			taskList.updateData();
		}
		
		
		
		private function newTaskHandle(event:Event):void{
			taskId.text = "0";
			description.text = "";
			taskCD.text = "";
			islandIds.text = "";
			isMainLine.text = "";
			taskName.text = "";
			orderNum.text = "";
			playerNumber.text = "";
			reward.text = "";
			time.text = "";
			scriptEditor.text = "";
		}
		
		private function saveTaskHandle(event:Event):void{
			var vo:GameTaskVO = new GameTaskVO;
			vo.description = description.text;
			vo.id = taskId.text;
			vo.islandIDs = islandIds.text;
			vo.isMainLine = isMainLine.text;
			vo.orderNum = parseInt(orderNum.text);
			vo.playerNumber = parseInt(playerNumber.text);
			vo.reward = parseInt(reward.text);
			vo.script = scriptEditor.text;
			vo.name = taskName.text;
			vo.time = parseInt(time.text);
			vo.type = typeList.selectedItem.value;
			vo.cd = parseInt(taskCD.text);
			
			PackData.app.CmdIStr[0] = CmdStr.INT_UPD_GAME_TASK;
			PackData.app.CmdIStr[1] = vo.id.toString();
			PackData.app.CmdIStr[2] = vo.name;
			PackData.app.CmdIStr[3] = vo.description;
			PackData.app.CmdIStr[4] = vo.type;
			PackData.app.CmdIStr[5] = vo.script;
			PackData.app.CmdIStr[6] = vo.playerNumber.toString();
			PackData.app.CmdIStr[7] = vo.time;
			PackData.app.CmdIStr[8] = vo.reward.toString();
			PackData.app.CmdIStr[9] = vo.islandIDs;
			PackData.app.CmdIStr[10] = vo.isMainLine;
			PackData.app.CmdIStr[11] = vo.orderNum;
			PackData.app.CmdIStr[12] = vo.cd;
			PackData.app.CmdInCnt = 13;
			
			
			sendNotification(CoreConst.SEND_11,new SendCommandVO(GameTaskEditorConst.UPDATE_TASK,[vo]));
			
			
		}
		
		
		
		private function tabBar_changeHandler(event:Event):void
		{
			trace("selectedIndex: " + this._tabBar.selectedIndex.toString());
			
			if(this._tabBar.selectedIndex==1){
				gameUI.visible = true;
				taskHolder.visible = false;
			}else{
				gameUI.visible = false;
				taskHolder.visible = true;
			}
			
			
		}
		
		private function resetHandle(event:Event):void{
			leftGroupIDS.text = "";
			rightGroupIDS.text = "";
			
			basement.reset();
			
		}
		
		private function startHandle(event:Event):void{
		}
		
		private function addLeftHandle(event:Event):void{
			if(list.selectedItem){
				
				if(!leftGroupIDS.text||leftGroupIDS.text.length==0){
					leftGroupIDS.text = "";
				}else{
					leftGroupIDS.text+=",";
				}
				
				leftGroupIDS.text+=(list.selectedItem as GameCharaterData).id;
				
				basement.addHero((list.selectedItem as GameCharaterData).clone());
			}
		}
		
		private function addRightHandle(event:Event):void{
			if(list.selectedItem){
				
				
				if(!rightGroupIDS.text||rightGroupIDS.text.length==0){
					rightGroupIDS.text = "";
				}else{
					rightGroupIDS.text+=",";
				}
				
				rightGroupIDS.text+=(list.selectedItem as GameCharaterData).id;
				
				basement.addMonster((list.selectedItem as GameCharaterData).clone());
			}
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var dvo:DataResultVO;
			dvo = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case GameTaskEditorConst.UPDATE_TASK:{
					
					if(!dvo.isErr&&dvo.isEnd){
						
						if(String(PackData.app.CmdOStr[0]).charAt(1)!="M"){
							
							var vo:GameTaskVO = dvo.para[0];
							
							var dataCollection:ListCollection = taskList.dataProvider;
							
							var founded:Boolean = false;
							for (var i:int = 0; i < dataCollection.length; i++) 
							{
								var dataItem:GameTaskVO = dataCollection.getItemAt(i) as GameTaskVO;
								if(dataItem.name==vo.name){
									dataCollection.setItemAt(vo.clone(),i);
									founded = true;
									break;
								}
							}
							
							if(!founded){
								dataCollection.addItem(vo.clone());
							}
							
							taskList.validate();
							
						}
						
						
						
						
					}
					
					
					
					break;
				}
				case GameTaskEditorConst.REMOVE_TASK:{
					if(!dvo.isErr&&dvo.isEnd){
						if(String(PackData.app.CmdOStr[0]).charAt(1)!="M"){
							
							removeTask(dvo.para[0]);
							
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
		
		private function removeTask(vo:GameTaskVO):void{
			
			var dataCollection:ListCollection = taskList.dataProvider;
			var idx:int = -1;
			if(dataCollection){
				for (var i:int = 0; i < dataCollection.length; i++) 
				{
					var dataItem:GameTaskVO = dataCollection.getItemAt(i) as GameTaskVO;
					if(dataItem.id==vo.id){
						idx = i;
						break;
					}
				}
				
				if(idx>=0){
					dataCollection.removeItemAt(idx);
				}
				
				taskList.validate();
				
			}
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [GameTaskEditorConst.UPDATE_TASK,GameTaskEditorConst.REMOVE_TASK];
		}
		
		
		private function refreshListBtnHandle(event:Event):void
		{
			list.updateData();
			
			
		}		
		
		
	}
}