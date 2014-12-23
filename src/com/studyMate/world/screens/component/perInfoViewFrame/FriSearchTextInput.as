package com.studyMate.world.screens.component.perInfoViewFrame
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.GpuTextInput;
	import com.studyMate.world.screens.PersonalInfoViewMediator;
	
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import feathers.events.FeathersEventType;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class FriSearchTextInput extends Sprite
	{
		private static const NAME:String = "FriSearchTextInput";
		public static const SEARCH_STUDENT:String = NAME + "SearchStudent";
		
		
		//当前搜索项--- nameBtn:名字; idBtn:ID号; schoolBtn:学校
		private var searchTopic:String = "nameBtn";
		private var nameBtn:Button;
		private var idBtn:Button;
		private var schoolBtn:Button;
		
		private var selectSp:Sprite;
		private var selectBg:Image;
		private var btnSp:Sprite;
		private var searchTF:GpuTextInput;
		
		private var isShow:Boolean = false;
		
		public function FriSearchTextInput()
		{
			super();
			
			//添加搜索框
			var searchBg:Image = new Image(Assets.getPersonalInfoTexture("searchInputBg"));
			addChild(searchBg);
			
			selectSp = new Sprite;
			selectSp.y = -90;
			addChild(selectSp);
			
			selectBg = new Image(Assets.getPersonalInfoTexture("searchSelectBtnBg"));
			selectBg.visible = false;
			selectSp.addChild(selectBg);
			btnSp = new Sprite;
			btnSp.x = 10;
			btnSp.y = 20;
			selectSp.addChild(btnSp);
			
			//按钮
			
			idBtn = new Button(Assets.getPersonalInfoTexture("searchSelectBtn_ID"));
			idBtn.name = "idBtn";
			idBtn.visible = false;
			idBtn.addEventListener(Event.TRIGGERED,sortBtn);
			btnSp.addChild(idBtn);
			schoolBtn = new Button(Assets.getPersonalInfoTexture("searchSelectBtn_school"));
			schoolBtn.name = "schoolBtn";
			schoolBtn.y = 40;
			schoolBtn.visible = false;
			schoolBtn.addEventListener(Event.TRIGGERED,sortBtn);
			btnSp.addChild(schoolBtn);
			nameBtn = new Button(Assets.getPersonalInfoTexture("searchSelectBtn_name"));
			nameBtn.name = "nameBtn";
			nameBtn.y = 80;
			nameBtn.addEventListener(Event.TRIGGERED,sortBtn);
			btnSp.addChild(nameBtn);
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,hideBtnHandle);
			
			
			searchTF = new GpuTextInput();
			searchTF.x = 90;
			searchTF.y = 8;
			searchTF.maxChars = 8;
			searchTF.width = 165; 
			searchTF.height = 33;
			addChild(searchTF);
			searchTF.setTextFormat(new TextFormat("HeiTi",20,0x676665));
			searchTF.prompt = "输入搜索";
			searchTF.text = "";
			searchTF.addEventListener(FeathersEventType.ENTER,doSearch);
		}
		
		private function sortBtn(e:Event):void{
			var btn:Button = e.currentTarget as Button;
			if(!btn)
				return;
			
			//点击最下面的按钮，显示按钮列表
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
			var lvl:int = 0;
			
			for(var i:int=0;i<btnSp.numChildren;i++){
				//是该按钮，放到最下面
				if(btnSp.getChildAt(i).name == _btnName){
					btnSp.getChildAt(i).y = 80;
					
				}else{
					btnSp.getChildAt(i).y = lvl*40;
					lvl++;
				}
			}
		}
		
		
		private function hideBtnHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					if(!this.getBounds(Starling.current.stage).contains(touchPoint.globalX,touchPoint.globalY) &&isShow){ //主菜单区域
						//关闭
						setSelctVisible(false);
					}
				}
			}
		}
		
		
		
		public function doSearch():void{
			if(Global.isLoading || StringUtil.trim(searchTF.text) == "")
				return;
			
			var perViewMediator:PersonalInfoViewMediator = 
				Facade.getInstance(CoreConst.CORE).retrieveMediator(PersonalInfoViewMediator.NAME) as PersonalInfoViewMediator;
			perViewMediator.searchFriList.splice(0,perViewMediator.searchFriList.length);
			
			var searArr:Array = getSearchData();
			PackData.app.CmdIStr[0] = CmdStr.SEARCH_STUDENT;
			PackData.app.CmdIStr[1] = searArr[0];	//id
			PackData.app.CmdIStr[2] = searArr[1];	//登陆账号
			PackData.app.CmdIStr[3] = searArr[2];	//昵称
			PackData.app.CmdIStr[4] = searArr[3];	//真实姓名
			PackData.app.CmdIStr[5] = searArr[4];	//学校
			PackData.app.CmdInCnt = 6;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(SEARCH_STUDENT));
			
		}
		private function getSearchData():Array{
			
			var _array:Array = new Array;
			switch(searchTopic){
				case "nameBtn":
					_array.push("*");
					_array.push("*");
					_array.push("*");
					_array.push(searchTF.text);
					_array.push("*");
					break;
				case "idBtn":
					_array.push(searchTF.text);
					_array.push("*");
					_array.push("*");
					_array.push("*");
					_array.push("*");
					
					break;
				case "schoolBtn":
					_array.push("*");
					_array.push("*");
					_array.push("*");
					_array.push("*");
					_array.push(searchTF.text);
					break;
			}
			
			return _array;
		}
		
		override public function dispose():void
		{
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,hideBtnHandle);
			removeChildren(0,-1,true);
			super.dispose();
		}
		
		
		
	}
}