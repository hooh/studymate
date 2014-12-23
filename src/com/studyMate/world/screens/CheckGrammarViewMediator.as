package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.CheckGrammarVO;
	
	import mx.utils.StringUtil;
	
	import feathers.controls.Button;
	import feathers.controls.Radio;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class CheckGrammarViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "CheckGrammarViewMediator";
		private static const QUERY_COMPLETE:String = NAME + "queryComplete";
		private static const UPDATE_COMPLETE:String = NAME + "updateComplete";
		
		private var vo:SwitchScreenVO;
		
		public function CheckGrammarViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		private var tagTF:TextInput;
		private var countTF:TextInput
		private var toggleGroup:ToggleGroup;
		
		private var engTF:TextField;
		private var chnTF:TextField;
		override public function onRegister():void
		{
			view.root.stage.color = 0xffffff;
			
			var lab:TextField = new TextField(150,60,"标签1：","HeiTi",25);
			lab.x = 100;
			lab.y = 50;
			view.addChild(lab);
			
			lab = new TextField(150,60,"查询条数：","HeiTi",25);
			lab.x = 550;
			lab.y = 50;
			view.addChild(lab);
			
			
			tagTF = new TextInput();
			tagTF.width = 200;
			tagTF.height = 60;
			tagTF.x = 250;
			tagTF.y = 50;
			view.addChild(tagTF);
			tagTF.textEditorProperties.fontSize = 25;
			
			countTF = new TextInput;
			countTF.width = 200;
			countTF.height = 60;
			countTF.x = 730;
			countTF.y = 50;
			countTF.text = "100";
			view.addChild(countTF);
			countTF.textEditorProperties.fontSize = 25;
			
			lab = new TextField(150,60,"*","HeiTi",25);
			lab.x = 120;
			lab.y = 160;
			view.addChild(lab);
			lab = new TextField(150,60,"Yes","HeiTi",25);
			lab.x = 270;
			lab.y = 160;
			view.addChild(lab);
			lab = new TextField(150,60,"No","HeiTi",25);
			lab.x = 420;
			lab.y = 160;
			view.addChild(lab);
			
			
			toggleGroup = new ToggleGroup();
			var radio:Radio;
			radio = new Radio();
			radio.toggleGroup = toggleGroup;
			radio.x = 230;
			radio.y = 180;
			radio.name = "*";
			radio.isSelected = true;
			view.addChild(radio);
			
			radio = new Radio();
			radio.toggleGroup = toggleGroup;
			radio.x = 380;
			radio.y = 180;
			radio.name = "T";
			view.addChild(radio);
			
			radio = new Radio();
			radio.toggleGroup = toggleGroup;
			radio.x = 530;
			radio.y = 180;
			radio.name = "F";
			view.addChild(radio);
			
			var getBtn:Button = new Button;
			getBtn.label = "查询";
			getBtn.width = 150;
			getBtn.height = 60;
			getBtn.x = 730;
			getBtn.y = 150;
			getBtn.addEventListener(Event.TRIGGERED,getBtnHandle);
			view.addChild(getBtn);
			
			
			engTF = new TextField(415,150,"","HeiTi",20);
			engTF.x = 100;
			engTF.y = 315;
			engTF.border = true;
			engTF.hAlign = HAlign.LEFT;
			engTF.vAlign = VAlign.TOP;
			view.addChild(engTF);
			
			chnTF = new TextField(415,150,"","HeiTi",20);
			chnTF.x = 765;
			chnTF.y = 315;
			chnTF.border = true;
			chnTF.hAlign = HAlign.LEFT;
			chnTF.vAlign = VAlign.TOP;
			view.addChild(chnTF);
			
			var tranBtn:Button = new Button();
			tranBtn.label = "翻译=>";
			tranBtn.width = 150;
			tranBtn.height = 50;
			tranBtn.x = 565;
			tranBtn.y = 365;
			tranBtn.addEventListener(Event.TRIGGERED,tranBtnHandle);
			view.addChild(tranBtn);
			
			//选择状态
			btnTabBar = new TabBar();
			btnTabBar.width = 450;
			btnTabBar.height = 60;
			btnTabBar.x = 730;
			btnTabBar.y = 500;
			btnTabBar.dataProvider = new ListCollection(
				[				
					{ label: "?" ,type:"Q"},
					{ label: "Yes" ,type:"T"},
					{ label: "No" ,type:"F" },
				]);
			btnTabBar.addEventListener(Event.CHANGE, btnTabBarChangeHandler);
			view.addChild(btnTabBar);
			btnTabBar.selectedIndex = -1;
			
			
			var preBtn:Button = new Button;
			preBtn.width = 150;
			preBtn.height = 60;
			preBtn.x = 100;
			preBtn.y = 580;
			preBtn.label = "<=上一题";
			preBtn.addEventListener(Event.TRIGGERED,preBtnHandle);
			view.addChild(preBtn);
			
			var nextBtn:Button = new Button;
			nextBtn.width = 150;
			nextBtn.height = 60;
			nextBtn.x = 1030;
			nextBtn.y = 580;
			nextBtn.label = "下一题=>";
			nextBtn.addEventListener(Event.TRIGGERED,nextBtnHandle);
			view.addChild(nextBtn);
			
			//快捷键
			var tran2Btn:Button = new Button();
			tran2Btn.label = "查看翻译";
			tran2Btn.width = 150;
			tran2Btn.height = 60;
			tran2Btn.x = 1030;
			tran2Btn.y = 655;
			tran2Btn.addEventListener(Event.TRIGGERED,tranBtnHandle);
			view.addChild(tran2Btn);
			
			
			idxTips = new TextField(400,60,"--/--","HeiTi",35);
			idxTips.x = 440;
			idxTips.y = 660;
			view.addChild(idxTips);
			
			
		} 
		
		private function tranBtnHandle():void{
			if(currentIdx > -1 && currentIdx < dataList.length)
			{
				var curData:CheckGrammarVO = dataList[currentIdx] as CheckGrammarVO;
				chnTF.text = curData.chinese;
				hadCheck = true;
			}
			
		}
		
		private var currentIdx:int = 0;
		private var idxTips:TextField;
		
		private var btnTabBar:TabBar;
		private function btnTabBarChangeHandler(event:Event):void{
			if(currentIdx > -1 && currentIdx < dataList.length && hadCheck)
			{
				var curData:CheckGrammarVO = dataList[currentIdx] as CheckGrammarVO;
				var type:String = btnTabBar.selectedItem.type;
				
				updateStat(curData.instid, type);
			}
			
			
		}
		
		private var hadCheck:Boolean = false;
		private function preBtnHandle():void{
			if(currentIdx > 0)
			{
				currentIdx--;
			}
			
			showInfo();
		}
		private function nextBtnHandle():void{
			if(currentIdx < dataList.length-1)
			{
				currentIdx++;
			}
			
			showInfo();
		}
		
		
		private function showInfo():void{
			if(currentIdx > -1 && currentIdx < dataList.length){
				var curData:CheckGrammarVO = dataList[currentIdx] as CheckGrammarVO;
				
				engTF.text = curData.topic;
				chnTF.text = "";
				idxTips.text = (currentIdx+1)+"/"+dataList.length;
				hadCheck = false;
				
				
				//设置状态
				btnTabBar.selectedIndex = -1;
				if(curData.tag5 == "Q"){
					btnTabBar.selectedIndex = 0;
					
				}else if(curData.tag5 == "T"){
					btnTabBar.selectedIndex = 1;
					
					
				}else if(curData.tag5 == "F"){
					btnTabBar.selectedIndex = 2;
					
					
				}
				
				
				
			}
			
		}
		
		
		
		private function getBtnHandle():void{
			trace("选择查询："+tagTF.text+"||"+countTF.text+"||"+(toggleGroup.selectedItem as Radio).name);
			
			if(StringUtil.trim(tagTF.text) != "" && countTF.text != ""){
				
				
				getList();
			}
			
			
		}
		
		private function getList():void{
			dataList = [];
			currentIdx = 0;
			engTF.text = "";
			chnTF.text = "";
			idxTips.text = "--/--";
			hadCheck = false;
			btnTabBar.selectedIndex = -1;
			
			PackData.app.CmdIStr[0] = CmdStr.QUERY_GRAMTAG_DATA;
			PackData.app.CmdIStr[1] = tagTF.text;
			PackData.app.CmdIStr[2] = (toggleGroup.selectedItem as Radio).name;
			PackData.app.CmdIStr[3] = countTF.text;
			PackData.app.CmdInCnt = 4;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QUERY_COMPLETE));
		}
		private var dataList:Array = [];
		
		
		private function updateStat(id:int, stat:String):void{
			PackData.app.CmdIStr[0] = CmdStr.UPD_GRAMTAG_DATA;
			PackData.app.CmdIStr[1] = id;
			PackData.app.CmdIStr[2] = stat;
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(UPDATE_COMPLETE));
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case QUERY_COMPLETE:
					if(!result.isEnd){
						var gvo:CheckGrammarVO = new CheckGrammarVO;
						gvo.instid = PackData.app.CmdOStr[1];
						gvo.topic = PackData.app.CmdOStr[2];
						gvo.chinese = PackData.app.CmdOStr[3];
						gvo.source = PackData.app.CmdOStr[4];
						gvo.tag1 = PackData.app.CmdOStr[5];
						gvo.tag2 = PackData.app.CmdOStr[6];
						gvo.tag3 = PackData.app.CmdOStr[7];
						gvo.tag4 = PackData.app.CmdOStr[8];
						gvo.tag5 = PackData.app.CmdOStr[9];
						dataList.push(gvo);
						
					}else{
						
//						friListSp.updateFriList(friList);
						
						showInfo();
					}
					
					break;
				case UPDATE_COMPLETE:
					if(!result.isErr){
						
						(dataList[currentIdx] as CheckGrammarVO).tag5 = btnTabBar.selectedItem.type;
					}
					
					
					break;
				
			}
		}
		override public function listNotificationInterests():Array
		{
			return [QUERY_COMPLETE,UPDATE_COMPLETE];
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void
		{
			super.onRemove();
			
			view.removeChildren(0,-1,true);
		}
		
		
		
		
	}
}