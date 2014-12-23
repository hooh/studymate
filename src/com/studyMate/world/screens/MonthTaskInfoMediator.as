package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.controller.vo.EnableScreenCommandVO;
	
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.layout.TiledRowsLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
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
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class MonthTaskInfoMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "MonthTaskInfoMediator"; 
		private const QUERYLNDAYINFO:String = NAME + "QueryLnDayInfo";
		private var vo:SwitchScreenVO; 
		
		private var id:String;
		private var container:ScrollContainer; 
		private var layout:TiledRowsLayout;
		private var infoArray:Array;
		private var dayArray:Array;
		private var beginDay:int = 0;
		private var selectDay:String;
		private var onTouchBeginY:int;
		private var onTouchEndY:int;
		
		private var closeBtn:starling.display.Button;
		
		private var _selectMonth:String;
		private var monthArray:Array = ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"];
		private var showMonth:TextField;
		
		private var isNewPage:Boolean = false;
		
		public function MonthTaskInfoMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		public function get selectMonth():String
		{
			return _selectMonth;
		}

		public function set selectMonth(value:String):void{
			var findFirst:Boolean = false;
			var oldSelectMonth:String = _selectMonth;
			var position:int;
			showMonth.text = monthArray[parseInt(value) - 1];
			_selectMonth = value;
			if(isNewPage){
			for(var i:int = 0; i < container.numChildren; i++){
				var objectIndex:DisplayObject = container.getChildAt(i);
				if(objectIndex.name.substr(4,2) == oldSelectMonth){
					objectIndex.alpha = 0.5;
				}else if(objectIndex.name.substr(4,2) == value){
					objectIndex.alpha = 1;
					if(!findFirst){
						findFirst = true;
						position = objectIndex.y;
					}
				}
			}
			if(findFirst){
				if(position > container.maxVerticalScrollPosition){
					var time:Number = (container.maxVerticalScrollPosition - container.verticalScrollPosition) / 100;
					TweenLite.to(container, Math.abs(time), {verticalScrollPosition:container.maxVerticalScrollPosition});
				}else{
					var time2:Number = ( position - container.verticalScrollPosition ) / 100;
					TweenLite.to(container, Math.abs(time2), {verticalScrollPosition:position});
				}
			}
			}
		}

		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			id = vo.data as String;
			if(!id){
				id = Global.player.operId;
			}
			datainit();
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		private function getData():void{
			container.removeChildren(0, -1, true);
			if(CacheTool.has("MonthTaskInfoMediator","sid")){
				var sid:String = CacheTool.getByKey("MonthTaskInfoMediator","sid") as String;
				if(sid == id){
					if(CacheTool.has("MonthTaskInfoMediator","infoArray")){
						infoArray = CacheTool.getByKey("MonthTaskInfoMediator","infoArray") as Array;
						dealData();
						return;
					}
				}
			}
			sendGetDataCommand();
		}
		
		public static const GETUSERINFO:String = NAME + "GetUserInfo";
		
		private function getUserInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.CHECK_STUDENT_ID;
			PackData.app.CmdIStr[1] = parseInt(sidInput.text).toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(GETUSERINFO));
		}
		
		private function sendGetDataCommand():void{
			CacheTool.clr("MonthTaskInfoMediator","verticalScrollPosition");
			infoArray = new Array();
			PackData.app.CmdIStr[0] = CmdStr.QUERYLNDAYINFO;
			PackData.app.CmdIStr[1] = id;
			PackData.app.CmdIStr[2] = dateFormat(dayArray[beginDay]);
			PackData.app.CmdIStr[3] = dateFormat(dayArray[59]);
			PackData.app.CmdInCnt = 4;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(QUERYLNDAYINFO));
		}
		
		private function dateFormat(date:Date):String{
			var dYear:String = String(date.getFullYear());
			var dMouth:String = String((date.getMonth() + 1 < 10) ? "0" : "") + (date.getMonth() + 1);
			var dDate:String = String((date.getDate() < 10) ? "0" : "") + date.getDate();
			return dYear+dMouth+dDate;
		}
		
		private function datainit():void{
			selectDay = new String();
			var date:Date = new Date(Global.nowDate.time);
			var weekday:int = date.day;
			var dayNum:int = 6 - weekday + 60;
			var beginDate:Date = date;
			var millisecondsPerDay:int = 1000 * 60 * 60 * 24;
			dayArray = new Array();
			beginDate.setTime(date.time - 60*24*60*60*1000);
			for(var i:int = 1; i <= dayNum; i++){
				var dayi:Date = new Date();
				dayi.setTime(beginDate.time + millisecondsPerDay * i);
				dayArray.push(dayi);
			}
			
			for(i = 0; i < 60; i++){
				if(dayArray[i].day == 0){
					beginDay = i;
					break;
				}
			}
		}
		
		private var sidInput:TextFieldHasKeyboard;
		private var searchBtn:feathers.controls.Button;
		
		override public function onRegister():void{
			var img:Image = new Image(Assets.getTexture("monthinfo"));
			view.addChild(img);
			img.x = ( Global.stageWidth - 860 ) / 2; img.y = ( Global.stageHeight - 515 ) / 2;
			
			var one:Image = new Image(Assets.getAtlasTexture("targetWall/otherScroll"));
			view.addChild(one);
			one.x = (Global.stageWidth - 346) / 2; one.y = 62;
			
			sidInput = new TextFieldHasKeyboard();
			sidInput.defaultTextFormat = new TextFormat("HeiTi",28);
			sidInput.text = id;
			sidInput.maxChars = 8;
			sidInput.x = (Global.stageWidth - 346) / 2 + 14; sidInput.y = 75;
			sidInput.width = one.width; sidInput.height = 47;
			Starling.current.nativeOverlay.addChild(sidInput);
			sidInput.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN,touchHandle);
			sidInput.addEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
			
			searchBtn = new feathers.controls.Button;
			searchBtn.label = "查询";
			searchBtn.x = 750; searchBtn.y = 62;
			view.addChild(searchBtn);
			searchBtn.height = one.height;
			searchBtn.addEventListener(Event.TRIGGERED,searchBtnHandler);
				
			showMonth = new TextField(190, 60, "", "HeiTi", 50, 0x784700,true);
			showMonth.autoScale = true;
			view.addChild(showMonth);
			showMonth.x = 540; showMonth.y = 167;
			
			layout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_NONE;
			layout.gap = 0;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			layout.useSquareTiles = false;
			
			container = new ScrollContainer();
			container.layout = layout;
			container.snapScrollPositionsToPixels = true;
			container.snapToPages = false;
			container.x = 244; container.y = 300;
			container.width = 785; container.height = 290;
			view.addChild(container);
			
			
			var texture:Texture = Assets.getAtlasTexture("parents/close");
			closeBtn = new starling.display.Button(texture);
			closeBtn.x = 1025; closeBtn.y = 200;
			closeBtn.addEventListener(TouchEvent.TOUCH, onCloseBtnHandler);
			view.addChild(closeBtn);
			sendNotification("Hide_DayTaskInfoMediator");
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			
			getData();
			
//			sendNotification(WorldConst.POPUP_SCREEN,new PopUpCommandVO(this,true));
			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(false, NAME));
//			sendNotification(WorldConst.HIDE_MAIN_MENU);
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,stageKeydownHandler,false,1);
			
			
			trace("@VIEW:MonthTaskInfoMediator:");
		}
		
		protected function stageKeydownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
				event.stopImmediatePropagation();
				event.preventDefault();
			}
		}
		
		private function touchHandle(e:flash.events.TouchEvent):void{
			sidInput.setSelection(0,sidInput.text.length);
			sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,true);
		}
		
		private function inputHandle(e:KeyboardEvent):void{
			if(e.keyCode==13){
				searchBtnHandler(null);
				/*var mouseEvent:MouseEvent = new MouseEvent(MouseEvent.CLICK,true,false,0,0);
				
				Global.stage.dispatchEvent(mouseEvent);*/
//				sendNotification(WorldConst.USE_SIMPLE_KEYBOARD,true);
			}						
		}
		
		private function dealData():void{
			container.removeChildren(0, -1, true);
			if(infoArray.length >= 0){
				var j:int = infoArray.length - 1;
				var today:Date = new Date(Global.nowDate.time);
				var todayString:String = dateFormat(today);
				var date:Sprite;
				var thismonth:TextField;
				var dateString:String
				_selectMonth = String((today.getMonth() + 1 < 10) ? "0" : "") + (today.getMonth() + 1);
				showMonth.text = monthArray[today.getMonth()];
				for(var i:int = beginDay; i < dayArray.length; i++){
					var sp:Sprite = new Sprite();
					var dateformat:String = dateFormat(dayArray[i]);
					sp.name = dateformat;
					var day:Image;
					if(todayString > dateformat){
						if(j < 0 || infoArray[j].date != dateformat ){
							day = new Image(Assets.getAtlasTexture("parents/noLogin"));
							sp.addChild(day);
						}else if(infoArray[j].finish == "B"){
							day = new Image(Assets.getAtlasTexture("parents/jia"));
							sp.addChild(day);
							if(j != 0) j--;
						}else{
							/*day = new Image(Assets.getAtlasTexture("parents/login"));
							sp.addChild(day);
							if(infoArray[j].finish == "Y"){
							var score:int = parseInt(infoArray[j].score);
							var star:Image;
							score = 100 * Math.random();
							if(score > 67){
							star = new Image(Assets.getAtlasTexture("parents/A"));
							}else if(score > 33){
							star = new Image(Assets.getAtlasTexture("parents/B"));
							}else{
							star = new Image(Assets.getAtlasTexture("parents/C"));
							}
							sp.addChild(star);
							star.x = 48; star.y = 0;
							}*/
							//							if(infoArray[j].finish == "Y"){
							var score:int = parseInt(infoArray[j].score);
							if(score >= 0){
								//								var star:Image;
								if(score >= 85){
									day = new Image(Assets.getAtlasTexture("parents/A"));
								}else if(score >= 60){
									day = new Image(Assets.getAtlasTexture("parents/B"));
								}else{
									day = new Image(Assets.getAtlasTexture("parents/C"));
								}
								sp.addChild(day);
							}else{
								day = new Image(Assets.getAtlasTexture("parents/login"));
								sp.addChild(day);
							}
							var gold:TextField = new TextField(44, 15, infoArray[j].gold, "HeiTi", 12, 0xff5700, true);
							gold.autoScale = true;
							gold.hAlign = HAlign.LEFT;
							gold.x = 10; gold.y = 30;
							sp.addChild(gold);
							if(j != 0) j--;
						}
						
						dateString = String((dayArray[i].getDate() < 10) ? "0" : "") + dayArray[i].getDate();
						date = Assets.getWordSprite(dateString,"HK");
						date.scaleX = 0.8; date.scaleY = 0.8;
						date.x = 20; date.y = 10;
						if((!isNewPage) && dayArray[i].date == 1){
							date = Assets.getWordSprite("");
							thismonth = new TextField(60,28,(dayArray[i].month+1) + "月","HeiTi",28,0,true);
							thismonth.autoScale = true;
							thismonth.y = 5;
							sp.addChild(thismonth);
						}
						sp.addChild(date);
						if(isNewPage){ 
							if(dateformat.substr(4,2) != selectMonth) sp.alpha = 0.5;
						}
						sp.addEventListener(TouchEvent.TOUCH, dayTouchHandler);
						container.addChild(sp);
					}else if(todayString == dateformat){
						day = new Image(Assets.getAtlasTexture("parents/thisDay"));
						sp.addChild(day);
						sp.addEventListener(TouchEvent.TOUCH, dayTouchHandler);
						container.addChild(sp);
						
						dateString = String((dayArray[i].getDate() < 10) ? "0" : "") + dayArray[i].getDate();
						date = Assets.getWordSprite(dateString,"HK");
						date.scaleX = 0.8; date.scaleY = 0.8;
						date.x = 20; date.y = 10;
						if((!isNewPage) && dayArray[i].date == 1){
							date = Assets.getWordSprite("");
							thismonth = new TextField(60,28,(dayArray[i].month+1) + "月","HeiTi",28,0,true);
							thismonth.x = 10; thismonth.y = 5;
							thismonth.autoScale = true;
							sp.addChild(thismonth);
						}
						sp.addChild(date);
						
					}else{
						day = new Image(Assets.getAtlasTexture("parents/weidao"));
						sp.addChild(day);
						container.addChild(sp);
						
						dateString = String((dayArray[i].getDate() < 10) ? "0" : "") + dayArray[i].getDate();
						date = Assets.getWordSprite(dateString,"HK");
						date.scaleX = 0.8; date.scaleY = 0.8;
						date.x = 25; date.y = 10;
						if((!isNewPage) && dayArray[i].date == 1){
							date = Assets.getWordSprite("");
							thismonth = new TextField(60,28,(dayArray[i].month+1) + "月","HeiTi",28,0,true);
							thismonth.x = 10; thismonth.y = 5;
							thismonth.autoScale = true;
							sp.addChild(thismonth);
						}
						sp.addChild(date);
						
					}
					if(CacheTool.has("MonthTaskInfoMediator","selectDay")){
						var selectDayStr:String = CacheTool.getByKey("MonthTaskInfoMediator","selectDay") as String;
						if(sp.name == selectDayStr){
							var selectMark:TextField = new TextField(111,47,"","HeiTi");
							selectMark.autoScale = true;
							selectMark.border = true;
							selectMark.name = "selectDay";
							sp.addChild(selectMark);
						}
					}
				}
			}
			TweenLite.killDelayedCallsTo(start);
			TweenLite.delayedCall(0.1,start);
			/*var positon:Number = 0;
			if(CacheTool.has("MonthTaskInfoMediator","verticalScrollPosition")){
				positon = CacheTool.getByKey("MonthTaskInfoMediator","verticalScrollPosition") as Number;
			}
			TweenLite.delayedCall(0.1,function start():void{
				if(positon == 0  && container.maxVerticalScrollPosition != 0){
					container.verticalScrollPosition = container.maxVerticalScrollPosition;
				}
				else
					container.verticalScrollPosition = positon;
			});*/
		}
		
		private function start():void{
			var positon:Number = 0;
			if(CacheTool.has("MonthTaskInfoMediator","verticalScrollPosition")){
				positon = CacheTool.getByKey("MonthTaskInfoMediator","verticalScrollPosition") as Number;
			}
			if(positon == 0  && container.maxVerticalScrollPosition != 0){
				container.verticalScrollPosition = container.maxVerticalScrollPosition;
			}
			else
				container.verticalScrollPosition = positon;		
		}
		
		private function searchBtnHandler(e:Event):void{
//			CacheTool.clr("MonthTaskInfoMediator","infoArray");
			if(isNaN(parseInt(sidInput.text))){
				sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(view,647,352, null, "输入的用户id必须为数字哟。"));
			}else{
				if(!Global.isLoading){					
					getUserInfo();
					sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
				}
			}
		}
		
		private function onCloseBtnHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				CacheTool.clr("MonthTaskInfoMediator","selectDay");
				CacheTool.clr("MonthTaskInfoMediator","sid");
				CacheTool.clr("MonthTaskInfoMediator","infoArray");
				vo.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
				sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
				
				trace("@VIEW:FullScreenMenuMediator:");
			}
		}
		
		private var touchLock:Boolean = false;
		
		private function dayTouchHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				onTouchBeginY = touch.globalY;
			}
			if(touch.phase == TouchPhase.ENDED){
				onTouchEndY = touch.globalY;
				if(Math.abs(onTouchBeginY - onTouchEndY) < 10 && !touchLock){
					touchLock = true;
					var name:String = (e.currentTarget as DisplayObject).name;
					/*if(name != selectDay){
						if(selectDay != ""){
							var oldSelectDay:String = selectDay;
							var oldSelectSprite:Sprite = container.getChildByName(oldSelectDay) as Sprite;
							oldSelectSprite.removeChild(oldSelectSprite.getChildByName("selectDay"));
						}
						selectDay = name;
						var selectMark:TextField = new TextField(111,47,"");
						selectMark.border = true;
						selectMark.name = "selectDay";
						(container.getChildByName(selectDay) as Sprite).addChild(selectMark);
						if( selectMonth != name.substr(4,2) ){
							selectMonth = name.substr(4,2);
						}
					}else{*/
					trace(name);
					if(selectDay != ""){
						var oldSelectDay:String = selectDay;
						var oldSelectSprite:Sprite = container.getChildByName(oldSelectDay) as Sprite;
						oldSelectSprite.removeChild(oldSelectSprite.getChildByName("selectDay"));
					}
					selectDay = name;
					CacheTool.put("MonthTaskInfoMediator","selectDay",selectDay);
					var selectMark:TextField = new TextField(111,47,"","HeiTi");
					selectMark.border = true;
					selectMark.autoScale = true;
					selectMark.name = "selectDay";
					(container.getChildByName(selectDay) as Sprite).addChild(selectMark);
					if( selectMonth != name.substr(4,2) ){
						selectMonth = name.substr(4,2);
					}
					CacheTool.put("MonthTaskInfoMediator","verticalScrollPosition",container.verticalScrollPosition);
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(DayTaskInfoMediator,[id,name],SwitchScreenType.SHOW,AppLayoutUtils.gpuLayer)]);
//					}
				}
			}
		}
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case QUERYLNDAYINFO : 
					if(!result.isEnd){
						infoArray.push({date:PackData.app.CmdOStr[2],finish:PackData.app.CmdOStr[3],score:PackData.app.CmdOStr[4],gold:PackData.app.CmdOStr[5]});
					}else{
						CacheTool.put("MonthTaskInfoMediator","sid",id);
						CacheTool.put("MonthTaskInfoMediator","infoArray",infoArray);
						dealData();
					}
					break;
				case "Hide_MonthTaskInfoMediator" : 
					vo.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					break;
				case GETUSERINFO : 
					if(!result.isErr){
						if(PackData.app.CmdOStr[2] == "0"){
							container.removeChildren(0, -1, true);
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(view,647,352, null, "没有id为 "+parseInt(sidInput.text).toString()+" 的用户哟，请重新输入。"));
						}else{
							id = parseInt(sidInput.text).toString();
							getData();
						}
					}
					break;
				default : 
					break;
			}
		}
		
		override public function listNotificationInterests():Array{
			return [QUERYLNDAYINFO,"Hide_MonthTaskInfoMediator",GETUSERINFO];
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function onRemove():void{
			TweenLite.killDelayedCallsTo(start);
//			sendNotification(WorldConst.SHOW_MAIN_MENU);
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,stageKeydownHandler);
			Starling.current.nativeOverlay.removeChild(sidInput);
			sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,false);
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
//			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(true));
			super.onRemove();
		}
	}
}