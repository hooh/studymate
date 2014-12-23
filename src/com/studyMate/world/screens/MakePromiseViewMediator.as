package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.mylib.framework.utils.CacheTool;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	
	import flash.text.TextFormat;
	
	import feathers.controls.PickerList;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	public class MakePromiseViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "MakePromiseViewMediator";
		public static const CHECKSTUPASSWORD:String = NAME + "CheckStudentPassword";
		public static const CHECKPARPASSWORD:String = NAME + "CheckParrentPassword";
		public static const INSERTTARGETWALL:String = NAME + "InsertTargetWall";
		
		private var vo:SwitchScreenVO;
		private var leftInput:TextField;
		private var rightInput:PickerList;
		private var password1:TextFieldHasKeyboard;
		private var password2:TextFieldHasKeyboard;
		private var parentsArrForPickerList:Array;
		private var parentsArr:Array;
		private var leftFingerprint:Image;
		private var rightFingerprint:Image;
		private var leftPressEnter:Image;
		private var rightPressEnter:Image;
		
		private var year:TextFieldHasKeyboard;
		private var month:TextFieldHasKeyboard;
		private var day:TextFieldHasKeyboard;
		private var coins:TextFieldHasKeyboard;
		private var jiangLi:TextFieldHasKeyboard;
		private var today:TextField;
		
		private var touchLeftFinger:Boolean = false;
		private var touchRightFinger:Boolean = false;
		
		private var parentIndex:uint = 0;
		
		public function MakePromiseViewMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			init();
			
			leftInput = new TextField(231, 65, Global.player.name, "方正卡通简体", 30, 0x000000);
			leftInput.x = 233;leftInput.y = 145;
			view.addChild(leftInput);
			
			var myTextFormat:TextFormat = new TextFormat();
			myTextFormat.font = "HeiTi";
			myTextFormat.size = 25;
			myTextFormat.color = 0x000000;
			
			var jiangLiTextFormat:TextFormat = new TextFormat();
			jiangLiTextFormat.font = "HeiTi";
			jiangLiTextFormat.size = 20;
			jiangLiTextFormat.color = 0x000000;
			
			parentsArrForPickerList.fixed = true;
			rightInput = new PickerList();
			rightInput.dataProvider = new ListCollection(parentsArrForPickerList);
			view.addChild(rightInput);
			rightInput.typicalItem = {text: "Item 1000"};
			rightInput.labelField = "text";
			rightInput.listProperties.typicalItem = {text: "Item 1000"};
			rightInput.listProperties.@itemRendererProperties.labelField = "text";
			rightInput.validate();
			rightInput.addEventListener(Event.CHANGE,parentOnChange);
			rightInput.width = 231; rightInput.height = 66;
			rightInput.x = 829; rightInput.y = 144;
			
			/*name1 = new TextField(100, 32, Global.player.name, "", 25, 0xFF0000);
			name1.x = 172; name1.y = 279;
			view.addChild(name1);
			
			name2 = new TextField(138, 32, parentsArr[0].opercode, "", 20, 0xFF0000);
			name2.x = 147; name2.y = 412;
			view.addChild(name2);*/
			
			year = new TextFieldHasKeyboard();
			year.x = 269; year.y = 319;
			year.width = 63; year.height = 33;
			year.defaultTextFormat = myTextFormat;
			Starling.current.nativeOverlay.addChild(year);
			
			month = new TextFieldHasKeyboard();
			month.x = 367; month.y = 319;
			month.width = 42; month.height = 33;
			month.defaultTextFormat = myTextFormat;
			Starling.current.nativeOverlay.addChild(month);
			
			day = new TextFieldHasKeyboard();
			day.x = 445; day.y = 319;
			day.width = 42; day.height = 33;
			day.defaultTextFormat = myTextFormat;
			Starling.current.nativeOverlay.addChild(day);
			
			coins = new TextFieldHasKeyboard();
			coins.x = 316; coins.y = 412;
			coins.width = 67; coins.height = 33;
			coins.defaultTextFormat = myTextFormat;
			Starling.current.nativeOverlay.addChild(coins);
			
			jiangLi = new TextFieldHasKeyboard();
			jiangLi.x = 814; jiangLi.y = 365;
			jiangLi.multiline = true;jiangLi.wordWrap = true;
			jiangLi.width = 262; jiangLi.height = 138;
			jiangLi.defaultTextFormat = jiangLiTextFormat;
			Starling.current.nativeOverlay.addChild(jiangLi);
			
			password1 = new TextFieldHasKeyboard();
			password1.width = 159; password1.height = 61;
			Starling.current.nativeOverlay.addChild(password1);
			password1.x = 319; password1.y = 675;
			password1.defaultTextFormat = myTextFormat;
			password1.displayAsPassword = true;
			
			password2 = new TextFieldHasKeyboard();
			password2.width = 159; password2.height = 61;
			Starling.current.nativeOverlay.addChild(password2);
			password2.x = 916; password2.y = 675;
			password2.defaultTextFormat = myTextFormat;
			password2.displayAsPassword = true;
			
			leftPressEnter = new Image(Assets.getAtlasTexture("targetWall/PressEnter"));
			rightPressEnter = new Image(Assets.getAtlasTexture("targetWall/PressEnter"));
			view.addChild(leftPressEnter);
			view.addChild(rightPressEnter);
			leftPressEnter.x = 472; leftPressEnter.y = 575;
			rightPressEnter.x = 1068; rightPressEnter.y = 575;
			
			leftFingerprint = new Image(Assets.getAtlasTexture("targetWall/FingerPrint"));
			rightFingerprint = new Image(Assets.getAtlasTexture("targetWall/FingerPrint"));
			view.addChild(leftFingerprint);
			view.addChild(rightFingerprint);
			leftFingerprint.x = 500; leftFingerprint.y = 652;
			rightFingerprint.x = 1095; rightFingerprint.y = 652;
			
			leftFingerprint.addEventListener(TouchEvent.TOUCH, onLeftFingerPrint);
			rightFingerprint.addEventListener(TouchEvent.TOUCH, onRightFingerPrint);
			
			if(parentsArr.length <= 0){
				sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(view,647,352, onTuiChuHandler,"家长列表为空，不能制定约定，请先添加家长信息！"));
			}
			
		}
		
		private function parentOnChange(e:Event):void{
			parentIndex = rightInput.selectedIndex;
		}
		
		private function onLeftFingerPrint(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				TweenLite.to(leftPressEnter, 0.5, {scaleX:0, scaleY:0, x:539, y:655});
			}
			if(touch.phase == TouchPhase.ENDED){
/*				leftPressEnter.scaleX = 1.5; leftPressEnter.scaleY = 1.5;
				leftPressEnter.x = 439; leftPressEnter.y = 535;
//				leftPressEnter.x = 479; leftPressEnter.y = 583;
				TweenLite.from(leftPressEnter, 0.5, {scaleX:0, scaleY:0, x:539, y:655});*/
				TweenMax.to(leftPressEnter, 0.3, {scaleX:1, scaleY:1, yoyo:true,repeat:2, x:472, y:575});
			}
			if(e.touches.length == 2){
				var touch2:Touch = e.touches[1];
				if(touch2.target == rightFingerprint){
					if(touch2.phase == TouchPhase.BEGAN){
						checkDate();
						TweenLite.to(rightPressEnter, 0.5, {scaleX:0, scaleY:0, x:1135, y:655});
					}
					if(touch2.phase == TouchPhase.ENDED){
						TweenMax.to(rightPressEnter, 0.3, {scaleX:1, scaleY:1, yoyo:true,repeat:2, x:1068, y:575});
					}
				}
			}
		}
		
		private function onRightFingerPrint(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				TweenLite.to(rightPressEnter, 0.5, {scaleX:0, scaleY:0, x:1135, y:655});
			}
			if(touch.phase == TouchPhase.ENDED){
				TweenMax.to(rightPressEnter, 0.3, {scaleX:1, scaleY:1, yoyo:true,repeat:2, x:1068, y:575});
			}
			if(e.touches.length == 2){
				var touch2:Touch = e.touches[1];
				if(touch2.target == leftFingerprint){
					if(touch2.phase == TouchPhase.BEGAN){
						TweenLite.to(leftPressEnter, 0.5, {scaleX:0, scaleY:0, x:539, y:655});
						checkDate();
					}
					if(touch2.phase == TouchPhase.ENDED){
						TweenMax.to(leftPressEnter, 0.3, {scaleX:1, scaleY:1, yoyo:true,repeat:2, x:472, y:575});
					}
				}
			}
		}
		
		private function init():void{
			var img:Image = new Image(Assets.getTexture("ourRule1"));
			img.x = 4; img.y = 10;
			view.addChild(img);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRemove():void{
			Starling.current.nativeOverlay.removeChild(password1);
			Starling.current.nativeOverlay.removeChild(password2);
			Starling.current.nativeOverlay.removeChild(year);
			Starling.current.nativeOverlay.removeChild(month);
			Starling.current.nativeOverlay.removeChild(day);
			Starling.current.nativeOverlay.removeChild(coins);
			Starling.current.nativeOverlay.removeChild(jiangLi);
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(WorldConst.SHOW_LEFT_MENU);
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
		
		override public function listNotificationInterests():Array{
			return [CHECKSTUPASSWORD,CHECKPARPASSWORD,INSERTTARGETWALL];
		}
		
		override public function handleNotification(notification:INotification):void {
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case CHECKSTUPASSWORD : 
					if(!result.isErr){
						checkParPassword();
					}
					break;
				case CHECKPARPASSWORD : 
					if(!result.isErr){
						inserttagetWall();
					}
					break;
				case INSERTTARGETWALL : 
					if(!result.isErr){
						day.visible = false;
						jiangLi.visible = false;
//						view.addChild(new Image(Assets.getTexture("banTouMing")));
						var quad:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0);
						quad.alpha = 0.3;
						view.addChild(quad);
						var chengGong:Image = new Image(Assets.getAtlasTexture("targetWall/chenggong"));
						chengGong.x = 452; chengGong.y = 268;
						view.addChild(chengGong);
						chengGong.addEventListener(TouchEvent.TOUCH, onChenggongHandler);
					}
					break;
			}
		}
		
		private function doNothing():void{
			return;
		}
		
		private function onChenggongHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				view.removeEventListeners(TouchEvent.TOUCH);
				sendNotification(WorldConst.POP_SCREEN);
			}
		}
		
		private function onTuiChuHandler():void{
			sendNotification(WorldConst.POP_SCREEN);
		}
		
		private function checkStuPassword():void{
			PackData.app.CmdIStr[0] = CmdStr.VERFYOPERPASSWORD;
			PackData.app.CmdIStr[1] = Global.player.userName;
			PackData.app.CmdIStr[2] = password1.text;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CHECKSTUPASSWORD));
		}
		
		private function checkParPassword():void{
			PackData.app.CmdIStr[0] = CmdStr.VERFYOPERPASSWORD;
			PackData.app.CmdIStr[1] = parentsArr[parentIndex].opercode;
			PackData.app.CmdIStr[2] = password2.text;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(CHECKPARPASSWORD));
		}
		
		private function inserttagetWall():void{
			PackData.app.CmdIStr[0] = CmdStr.INSERTTAGETWALL;
			PackData.app.CmdIStr[1] = parentsArr[parentIndex].operid;
			PackData.app.CmdIStr[2] = Global.player.operId;
			PackData.app.CmdIStr[3] = getDate();
			PackData.app.CmdIStr[4] = "#";
			PackData.app.CmdIStr[5] = "coins:" + coins.text;
			PackData.app.CmdIStr[6] = jiangLi.text;
			PackData.app.CmdInCnt = 7;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(INSERTTARGETWALL));
		}
		
		private function getDate():String{
			if(month.text.length < 2) month.text = "0" + month.text;
			if(day.text.length < 2) day.text = "0" + day.text;
			return year.text + month.text + day.text;
		}
		
		private function addTishi(xx:int, yy:int):void{
//			var bantouming:Image = new Image(Assets.getTexture("banTouMing"));
			var bantouming:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0);
			bantouming.name = "bantouming";
			bantouming.alpha = 0.3;
			var tishi:Image = new Image(Assets.getAtlasTexture("targetWall/tanchukuang"));
			tishi.name = "tishi";
			view.addChild(bantouming);
			view.addChild(tishi);
			tishi.x = xx; tishi.y = yy;
			view.addEventListener(TouchEvent.TOUCH, onViewTouchHandler);
		}
		
		private function onViewTouchHandler(e:TouchEvent):void{
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				view.removeChild(view.getChildByName("bantouming"));
				view.removeChild(view.getChildByName("tishi"));
				year.visible = true;
				month.visible = true;
				day.visible = true;
				view.removeEventListener(TouchEvent.TOUCH, onViewTouchHandler);
			}
		}
		
		private function checkDate():void{
			if(year.text == ""){
				addTishi(161,95);
			}else if(month.text == ""){
				addTishi(252,95);
			}else if(day.text == ""){
				addTishi(333,95);
			}else if(coins.text == ""){
				year.visible = false;
				month.visible = false;
				day.visible = false;
				addTishi(211,188);
			}else if(jiangLi.text == ""){
				addTishi(755,142);
			}else if(password1.text == ""){
				addTishi(246,434);
			}else if(password2.text == ""){
				addTishi(845,434);
			}else{
				checkStuPassword();
			}
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			this.vo = vo;
			parentsArrForPickerList = new Array();
			parentsArr = new Array();
			parentsArr = CacheTool.getByKey("PromiseView","parentsList") as Array;
			for(var i:int = 0; i < parentsArr.length; i++){
				parentsArrForPickerList.push({text:parentsArr[i].enChenghu});
			}
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
	}
}