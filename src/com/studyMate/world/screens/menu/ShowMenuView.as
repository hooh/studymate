package com.studyMate.world.screens.menu
{
	import com.studyMate.global.Global;
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.screens.CalloutMenuButton;
	
	import feathers.controls.ScrollContainer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class ShowMenuView extends Sprite
	{
		public function ShowMenuView()
		{
			creatBackground();
		}

		private var btnContainer:ScrollContainer;
		public var goldenText:TextField;
		public var diamondText:TextField;
		
//		private var menuIconObj:Object = new Object();
//		private var menuIconObj:Vector.<CalloutMenuButton> = new Vector.<CalloutMenuButton>;
		
//		public var pages:Vector.<IFlipPageRenderer>;

		
		private function creatBackground():void{
			
			btnContainer = new ScrollContainer();
			btnContainer.backgroundSkin = new Image(Assets.getTexture("menuBackground"));
			btnContainer.snapScrollPositionsToPixels = true;
			btnContainer.width = Global.stageWidth; btnContainer.height = Global.stageHeight;
			addChild(btnContainer);
			
			
			goldenText = new starling.text.TextField(200, 50, "","HeiTi",20,0xffffff,false);
			goldenText.x = 680;
			goldenText.y = 45;
			goldenText.hAlign = HAlign.LEFT; 
			addChild(goldenText);
			
			diamondText = new TextField(200,50,"","HeiTi",20,0xffffff,false);
			diamondText.x = 390;
			diamondText.y = 40;
			diamondText.hAlign = HAlign.LEFT;
			addChild(diamondText);
			addButtons();
//			creatPage();
			
		}
/*		
		private function creatPage():void
		{
			pages = new Vector.<IFlipPageRenderer>;
			var arr1:Array = new Array();
			var arr2:Array = new Array();
			for (var i:int = 0; i <menuIconObj.length; i++) 
			{
				arr1.push(menuIconObj[i]);
			}
			arr2.push(menuIconObj[menuIconObj.length-1]);
			pages[0]=new MenuPage(arr1,menuIconObj.length);
			pages[1]=new MenuPage(arr2,menuIconObj.length);
		}*/
		
		public var FAQBtn:CalloutMenuButton;
		public var musicBtn:CalloutMenuButton;
		public var appointBtn:CalloutMenuButton;
		public var achievementBtn:CalloutMenuButton;
		public var chatBtn:CalloutMenuButton;
		public var emailBtn:CalloutMenuButton;
		public var coachBtn:CalloutMenuButton;
		public var settingBtn:CalloutMenuButton;
		public var studyRepBtn:CalloutMenuButton;
		
		private function addButtons():void
		{
			FAQBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("FAQIcon"));
			FAQBtn.name = "FAQBtn"; FAQBtn.level = 3;
			addButton(FAQBtn,FAQBtn.level);
			showButton("FAQBtn");
			
			musicBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("musicIcon"));
			musicBtn.name = "musicBtn"; musicBtn.level = 2;
			addButton(musicBtn,musicBtn.level);
			showButton("musicBtn");
			
			emailBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("emailIcon"));
			emailBtn.name = "emailBtn"; emailBtn.level = 1;
			addButton(emailBtn,emailBtn.level);
			showButton("emailBtn");
			
			chatBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("chatIcon"));
			chatBtn.name = "chatBtn"; chatBtn.level = 1;
			addButton(chatBtn,chatBtn.level);
			showButton("chatBtn");

			
			achievementBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("achievementIcon"));
			achievementBtn.name = "achievementBtn"; achievementBtn.level = 1;
			addButton(achievementBtn,achievementBtn.level);
			showButton("achievementBtn");
			
			
			
			studyRepBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("studyReportIcon"));
			studyRepBtn.name = "studyRepBtn"; studyRepBtn.level = 1;
			addButton(studyRepBtn,studyRepBtn.level);
			showButton("studyRepBtn");

			
/*			coachBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("coachIcon"));
			coachBtn.name = "coachBtn"; coachBtn.level = 1;
			addChild(coachBtn);
			addButton(coachBtn);
			showButton("coachBtn");*/
			
			appointBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("appointIcon"));
			appointBtn.name = "appointBtn"; appointBtn.level = 1;
			addButton(appointBtn,appointBtn.level);
			showButton("appointBtn");

			
			settingBtn = new CalloutMenuButton(Assets.getMenuAtlasTexture("settingIcon"));
			settingBtn.name = "settingBtn"; settingBtn.level = 1;
			addButton(settingBtn,settingBtn.level);
			showButton("settingBtn");


		}		
		
		private var buttonMap:Array = new Array();
		private function addButton(btn:CalloutMenuButton,level:int):void{
			var name:String = btn.name;
			var _level:int = level
			for each (var i:CalloutMenuButton in buttonMap) {
				if(i.name == name){
					if(i == btn){
						return;
					}
					buttonMap.splice(buttonMap.indexOf(i),1);
					removeChild(i);
					i.dispose();
				}
			}
			buttonMap.push(btn);
		}
		
		private function showButton(name:String):void{
			if(btnContainer.getChildByName(name)){
				return;
			}
			var btn:CalloutMenuButton = getButton(name);
			if(btn){
				if(buttonMap.length<5){
					btn.x = 140 + 285*(buttonMap.length-1);
					btn.y = 180;
				}else{
					btn.x = 140 + 285*(buttonMap.length-5);
					btn.y = 440;
				}
				btnContainer.addChild(btn);
			}
		}
		
		private function getButton(name:String):CalloutMenuButton{
			for each (var i:CalloutMenuButton in buttonMap) {
				if(i.name == name){
					return i;
				}
			}
			return null;
		}
		
		public function showButtonByLevel(level:int = -1):void{
			btnContainer.removeChildren(0, -1);
			var num:int;
			if(level == -1){
				for each (var i:CalloutMenuButton in buttonMap) {
					btnContainer.addChild(i);
				}
			}else{
				for each (var j:CalloutMenuButton in buttonMap) {
					if(j.level == 2){
						num++;
						if(num<5){
							j.x = 140 + 285*(num-1);
							j.y = 180;
							btnContainer.addChild(j);
						}else{
							j.x = 140 + 285*(num-1);
							j.y = 440;
							btnContainer.addChild(j);
						}
					}else if(j.level == 3){
						num++;
						if(num<5){
							j.x = 140 + 285*(num-1);
							j.y = 180;
							btnContainer.addChild(j);
						}else{
							j.x = 140 + 285*(num-1);
							j.y = 440;
							btnContainer.addChild(j);
						}
					}
				}
				
			}
		}
		
	}
}