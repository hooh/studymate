package com.studyMate.world.screens.chatroom
{
	import com.studyMate.global.Global;
	
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import feathers.events.FeathersEventType;
	
	import myLib.myTextBase.GpuTextInput;
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class SearchSprite extends Sprite
	{
		
		private static const NAME:String = "SearchSprite";
		public static const SEARCH_STUDENT:String = NAME + "SearchStudent";
		
		
		//当前搜索项--- nameBtn:名字; idBtn:ID号; schoolBtn:学校
		public var searchTopic:String = "idBtn";
		private var nameBtn:Button;
		private var idBtn:Button;
		private var schoolBtn:Button;
		
		private var selectSp:Sprite;
		private var selectBg:Image;
		private var btnSp:Sprite;
		private var searchTF:TextFieldHasKeyboard;
		
		private var isShow:Boolean = false;
		
		public function SearchSprite()
		{
			super();
			
			//添加搜索框
			var searchBg:Image = new Image(Assets.getChatViewTexture("chatRoom/searchBg"));
			addChild(searchBg);
			
			selectSp = new Sprite;
			selectSp.x = 15;
			selectSp.y = 12;
			addChild(selectSp);
			
			selectBg = new Image(Assets.getChatViewTexture("chatRoom/selectBtnBg"));
			selectBg.visible = false;
			selectSp.addChild(selectBg);
			btnSp = new Sprite;
			btnSp.y = 18;
			selectSp.addChild(btnSp);
			
			//按钮
			
			idBtn = new Button(Assets.getChatViewTexture("chatRoom/selectBtn_Id"));
			idBtn.name = "idBtn";
			idBtn.addEventListener(Event.TRIGGERED,sortBtn);
			btnSp.addChild(idBtn);
			nameBtn = new Button(Assets.getChatViewTexture("chatRoom/selectBtn_Name"));
			nameBtn.name = "nameBtn";
			nameBtn.visible = false;
			nameBtn.y = 45;
			nameBtn.addEventListener(Event.TRIGGERED,sortBtn);
			btnSp.addChild(nameBtn);
			schoolBtn = new Button(Assets.getChatViewTexture("chatRoom/selectBtn_School"));
			schoolBtn.name = "schoolBtn";
			schoolBtn.y = 90;
			schoolBtn.visible = false;
			schoolBtn.addEventListener(Event.TRIGGERED,sortBtn);
			btnSp.addChild(schoolBtn);
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,hideBtnHandle);
			
			
			searchTF = new TextFieldHasKeyboard();
			searchTF.defaultTextFormat = new TextFormat("HeiTi",30,0x676665);
			searchTF.x = 225;
			searchTF.y = 74;
			searchTF.maxChars = 15;
			searchTF.width = 700; 
			searchTF.height = 53;
			Global.stage.addChild(searchTF);
//			searchTF.setTextFormat(new TextFormat("HeiTi",30,0x676665));
			searchTF.prompt = "请先在左边下拉菜单选择搜索项（ID/姓名/学校）";
			searchTF.text = "";
//			searchTF.addEventListener(FeathersEventType.ENTER,doSearch);
			searchTF.addEventListener(KeyboardEvent.KEY_DOWN,doSearch);
			
			
			var searchBtn:Button = new Button(Assets.getChatViewTexture("chatRoom/searchBtn"));
			searchBtn.x = 1025;
			searchBtn.y = 17;
			searchBtn.addEventListener(Event.TRIGGERED,doSearch1);
			addChild(searchBtn);
		}
		
		private function sortBtn(e:Event):void{
			var btn:Button = e.currentTarget as Button;
			if(!btn)
				return;
			
			//点击最上面的按钮，显示按钮列表
			if(btn.name == searchTopic){
				if(!isShow){
					setSelctVisible(true);
				}else{
					//关闭
					setSelctVisible(false);
				}
			}else{
				searchTopic = btn.name;
				setBtnLocation(btn.name);
				setSelctVisible(false);
			}
		}
		
		override public function get visible():Boolean
		{
			return super.visible;
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if(value){
				searchTF.visible = true;
			}else{
				searchTF.visible =false;
			}
		}
		
		private function setSelctVisible(_visible:Boolean):void{
			selectBg.visible = _visible;
			setOtherBtnVisible(searchTopic,_visible);
			isShow = _visible;
		}
		private function setOtherBtnVisible(_clickBtn:String,_visible:Boolean):void{
			for (var i:int = 0; i < btnSp.numChildren; i++) 
			{
				var _btn:Button = btnSp.getChildAt(i) as Button;
				if(_btn.name != _clickBtn)
					_btn.visible = _visible;
			}
		}
		private function setBtnLocation(_btnName:String):void{
			var lvl:int = 1;
			
			for(var i:int=0;i<btnSp.numChildren;i++){
				//是该按钮，放到最下面
				if(btnSp.getChildAt(i).name == _btnName){
					btnSp.getChildAt(i).y = 0;
					
				}else{
					btnSp.getChildAt(i).y = lvl*45;
					lvl++;
				}
			}
		}
		
		
		private function hideBtnHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					if(Starling.current.stage.contains(selectSp) && 
						!selectSp.getBounds(Starling.current.stage).contains(touchPoint.globalX,touchPoint.globalY) &&isShow){ //主菜单区域
						//关闭
						setSelctVisible(false);
					}
				}
			}
		}
		
		
		
		public function doSearch(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.ENTER){				
				this.dispatchEvent(new Event(SEARCH_STUDENT,e.bubbles,searchTF.text));
			}		
		}
		public function doSearch1(e:Event):void{
				this.dispatchEvent(new Event(SEARCH_STUDENT,e.bubbles,searchTF.text));
					
		}
		
		override public function dispose():void
		{
			searchTF.removeEventListener(KeyboardEvent.KEY_DOWN,doSearch);
			Global.stage.removeChild(searchTF);
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,hideBtnHandle);
			removeChildren(0,-1,true);
			super.dispose();
		}
		
	}
}