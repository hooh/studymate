package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.FreeScrollerMediator;
	import com.mylib.framework.controller.ZoomMediator;
	import com.mylib.framework.controller.vo.TransformVO;
	import com.mylib.framework.controller.vo.ZoomResultVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import myLib.myTextBase.events.EDUKeyboardEvent;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.model.vo.CoordinateMediatorVO;
	import com.studyMate.world.model.vo.StandardItemsVO;
	
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
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
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class HonourViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "HonourViewMediator";
		private static const GET_USER_LEVEL:String = "GetUserLevel";
		private static const GET_STUDENT_INFO:String = "getStudentInfo";
		
		private var standardFile:File = Global.document.resolvePath(Global.localPath+"standard.txt");
		private var stream:FileStream = new FileStream();
		
		private var standItemVoList:Vector.<StandardItemsVO> = new Vector.<StandardItemsVO>;
		private var maxNumber:Number;
		
		private var style:ICoordinateStyle;
		
		private var name:String;
		private var mark:String;
		private var nameTF:TextField;
		private var idTF:TextFieldHasKeyboard;
		private var currentId:String;
		private var curLelTF:TextField;
		private var curMarkTF:TextField;
		
		private var goal1:String;
		private var goal2:String;
		private var goal3:String;
		
		private var vo:SwitchScreenVO;
		private var isFirstIn:Boolean;
		private var tvo:TransformVO;
		private var currentLevel:int;
		
		private var lvlSp:Sprite;
		private var lvlOneBtn:Button;
		private var lvlTwoBtn:Button;
		private var lvlThrBtn:Button;
		
		public function HonourViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			isFirstIn = true;
			
			getUserLevel(PackData.app.head.dwOperID.toString(),"yy.W");
		}
		private function getUserLevel(_id:String,_type:String):void{
			PackData.app.CmdIStr[0] = CmdStr.QUI_USER_LEVEL;
			PackData.app.CmdIStr[1] = _id;
			PackData.app.CmdIStr[2] = _type;
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_USER_LEVEL));
		}
		private function getInfo(_id:String):void{
			PackData.app.CmdIStr[0] = CmdStr.GET_STUDENT_INFO;
			PackData.app.CmdIStr[1] = "";
			PackData.app.CmdIStr[2] = _id;
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_STUDENT_INFO));
		}
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case GET_USER_LEVEL:
					if(!result.isErr){
						
						mark = PackData.app.CmdOStr[3];
						currentId = PackData.app.CmdOStr[1];
						
						goal1 = PackData.app.CmdOStr[4];
						goal2 = PackData.app.CmdOStr[5];
						goal3 = PackData.app.CmdOStr[6];
						
						//根据ID，查找用户名
						getInfo(currentId);

					}
					break;
				case GET_STUDENT_INFO:
					if(!result.isErr){
						name = PackData.app.CmdOStr[5];
						
						
						//首次进入界面
						if(isFirstIn){
							isFirstIn = false;
							
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
							
						}else{
							//更新新角色船的位置
							sendNotification(WorldMapCoordinateMediator.SHOW_LINES,1);
							
							nameTF.text = name;
							curMarkTF.text = mark.toString();
							updateMyMark(int(mark));
							updateGoalMark(int(goal1));
						}
						
						
					}
					break;
				
			}
		}
		override public function listNotificationInterests():Array
		{
			return [GET_USER_LEVEL,GET_STUDENT_INFO];
		}
		
		override public function onRegister():void
		{
//			sendNotification(WorldConst.HIDE_MAIN_MENU);
			
			sendNotification(WorldConst.HIDE_MENU_BUTTON);
			
			style = new CoordinateStyleMediator();
			
			currentLevel = 1;
			
			var local:Point = new Point(0,0);
			var edge:Rectangle = new Rectangle(0,0,0,0);
			tvo = new TransformVO(local,edge);
			
			
			sendNotification(WorldConst.SWITCH_SCREEN,[
				new SwitchScreenVO(WorldMapCoordinateMediator,tvo,SwitchScreenType.SHOW,view),
				new SwitchScreenVO(FreeScrollerMediator,tvo,SwitchScreenType.SHOW,view),
				new SwitchScreenVO(ZoomMediator,tvo,SwitchScreenType.SHOW,view)
			]);
			//异步处理
			sendNotification(WorldConst.SWITCH_SCREEN,[
				new SwitchScreenVO(WorldMapMediator,tvo,SwitchScreenType.SHOW,view,0,0,0)
			]);
			
			loadStandardData();
			
			sendNotification(WorldMapCoordinateMediator.INIT_COORDINATEVO,
				new CoordinateMediatorVO(style,standItemVoList,maxNumber));
			sendNotification(WorldMapCoordinateMediator.SHOW_LINES,currentLevel);
			
			
			
			
			createControlHolder();
			
			
			trace("@VIEW:HonourViewMediator:");

		}
		//控制面板
		private function createControlHolder():void{
			var titleBg:Image = new Image(Assets.getWorldMapTexture("title_Bg"));
			view.addChild(titleBg);
			
			nameTF = new TextField(130,59,"","HeiTi",28,0xffffff);
			nameTF.nativeFilters = [new GlowFilter(0x002649,1,5,5,20)];
			nameTF.hAlign = HAlign.LEFT;
			nameTF.vAlign = VAlign.CENTER;
			nameTF.text = name;
			nameTF.x = 80;
			view.addChild(nameTF);
			
			
			curLelTF = new TextField(100,59,"","HuaKanT",28,0xffbc00);
			curLelTF.nativeFilters = [new GlowFilter(0x002649,1,5,5,20)];
			curLelTF.hAlign = HAlign.LEFT;
			curLelTF.vAlign = VAlign.CENTER;
			curLelTF.text = "熟练";
			curLelTF.x = 355;
			view.addChild(curLelTF);
			
			var taskTypleTF:TextField = new TextField(150,59,"","HuaKanT",28,0xffffff);
			taskTypleTF.nativeFilters = [new GlowFilter(0x002649,1,5,5,20)];
			taskTypleTF.hAlign = HAlign.LEFT;
			taskTypleTF.vAlign = VAlign.CENTER;
			taskTypleTF.text = "英语单词：";
			taskTypleTF.x = 535;
			view.addChild(taskTypleTF);
			
			curMarkTF = new TextField(130,59,"","HuaKanT",28,0xffbc00);
			curMarkTF.nativeFilters = [new GlowFilter(0x002649,1,5,5,20)];
			curMarkTF.hAlign = HAlign.LEFT;
			curMarkTF.vAlign = VAlign.CENTER;
			curMarkTF.text = mark.toString();
			curMarkTF.x = 690;
			view.addChild(curMarkTF);
			
			
			
			
			var searchBg:Image = new Image(Assets.getWorldMapTexture("search_Input"));
			searchBg.x = 1050;
			searchBg.y = 10;
			view.addChild(searchBg);
			

			currentId = PackData.app.head.dwOperID.toString();

			idTF = new TextFieldHasKeyboard();
			idTF.restrict = "0-9";
			idTF.defaultTextFormat = new TextFormat("HeiTi",33);
			idTF.maxChars = 8;
			idTF.x = 1090;
			idTF.y = 10;
			idTF.width = 100;
			idTF.text = currentId;
			Starling.current.nativeOverlay.addChild(idTF);
			idTF.addEventListener(EDUKeyboardEvent.ENTER,idTFHandle);
			sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,true);
			
			var searchBtn:Button = new Button(Assets.getWorldMapTexture("search_Btn"));
			searchBtn.x = 1190;
			searchBtn.y = 10;
			searchBtn.addEventListener(Event.TRIGGERED,searchBtnHandle);
			view.addChild(searchBtn);
			
			
			
			
			TweenLite.delayedCall(1,function():void{
				updateMyMark(int(mark));
				updateGoalMark(int(goal1));
			});

			
			createLvlPanel();
			
			
		}
		private function createLvlPanel():void{
			lvlSp = new Sprite();
			lvlSp.name = "lvlSp";
			lvlSp.y = 100;
			view.addChild(lvlSp);
			lvlSp.addEventListener(TouchEvent.TOUCH,lvlSpTouchHandle);
			
			var lvlBg:Image = new Image(Assets.getWorldMapTexture("lvl_Bg"));
			lvlSp.addChild(lvlBg);
			
			lvlOneBtn = new Button(Assets.getWorldMapTexture("lvl_Btn1_down"));
			lvlOneBtn.name = "1";
			lvlOneBtn.y = 8;
			lvlOneBtn.x = 3;
			lvlSp.addChild(lvlOneBtn);
			lvlOneBtn.addEventListener(Event.TRIGGERED,lvlBtnHandle);
			
			lvlTwoBtn = new Button(Assets.getWorldMapTexture("lvl_Btn2_up"));
			lvlTwoBtn.name = "2";
			lvlTwoBtn.y = 60;
			lvlTwoBtn.x = 3;
			lvlSp.addChild(lvlTwoBtn);
			lvlTwoBtn.addEventListener(Event.TRIGGERED,lvlBtnHandle);
			
			lvlThrBtn = new Button(Assets.getWorldMapTexture("lvl_Btn3_up"));
			lvlThrBtn.name = "3";
			lvlThrBtn.y = 112;
			lvlThrBtn.x = 3;
			lvlSp.addChild(lvlThrBtn);
			lvlThrBtn.addEventListener(Event.TRIGGERED,lvlBtnHandle);
			
			
		}
		private var spedgeX:Number;
		private var spedgeY:Number;
		private var isMove:Boolean;
		private function lvlSpTouchHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject);
			if(touch){
				if(touch.phase==TouchPhase.BEGAN){
					TweenLite.killTweensOf(lvlSp);
					isMove = false;
					
					sendNotification(WorldConst.SET_ROLL_SCREEN,false);
					
					spedgeX = touch.globalX - lvlSp.x;
					spedgeY = touch.globalY - lvlSp.y;
					
				}else if(touch.phase==TouchPhase.MOVED){
					isMove = true;
					
					lvlSp.x = touch.globalX - spedgeX;
					lvlSp.y = touch.globalY - spedgeY;
					
				}else if(touch.phase==TouchPhase.ENDED){
					
					sendNotification(WorldConst.SET_ROLL_SCREEN,true);
				
					
					var endX:Number = 0;
					var endY:Number = touch.globalY - spedgeY;
					
					if(touch.globalX >= 640)
						endX = 1280-lvlSp.width;
					if(endY < 100)
						endY = 100;
					else if(endY > 500)
						endY = 500
					
					
					TweenLite.to(lvlSp,1,{x:endX,y:endY});
					
					
				}
				
				
				
			}
			
		}
	
		private function lvlBtnHandle(event:Event):void{
			
			if((lvlSp.x < -10 || lvlSp.x > 10) && (lvlSp.x < (1280-lvlSp.width-10) || lvlSp.x > (1280-lvlSp.width+10))){
				trace("在拖");
				return;
			}
			/*if(isMove){
				trace("在拖");
				return;
			}*/
			
			
			lvlOneBtn.upState = Assets.getWorldMapTexture("lvl_Btn1_up");
			lvlTwoBtn.upState = Assets.getWorldMapTexture("lvl_Btn2_up");
			lvlThrBtn.upState = Assets.getWorldMapTexture("lvl_Btn3_up");
			
			
			var name:String = (event.target as Button).name;
			(event.target as Button).upState = Assets.getWorldMapTexture("lvl_Btn"+name+"_down");
			
			if(name != currentLevel.toString()){
				currentLevel = int(name);
				
				sendNotification(WorldMapCoordinateMediator.SHOW_LINES,currentLevel);
				
				updateMyMark(int(mark));
				switch(name){
					case "1":updateGoalMark(int(goal1));	curLelTF.text = "熟练"; break;
					case "2":updateGoalMark(int(goal2));	curLelTF.text = "精通"; break;
					case "3":updateGoalMark(int(goal3));	curLelTF.text = "专家"; break;
				}
			}
		}
		
		//加载标准胡数据
		private function loadStandardData():void{
			if(standardFile.exists){
				stream.open(standardFile,FileMode.READ);
				var str:String = stream.readMultiByte(stream.bytesAvailable,PackData.BUFF_ENCODE);
				
				var strArr:Array = str.split("\n");
				var standItemVo:StandardItemsVO;
				var itemArr:Array;
				maxNumber = 0;
				for(var i:int=0;i<strArr.length;i++){
					itemArr = strArr[i].split(",");
					
					standItemVo = new StandardItemsVO();
					standItemVo.name = itemArr[0];
					standItemVo.standData = itemArr[1];
					standItemVo.level = itemArr[2];
					
					
					standItemVoList.push(standItemVo);
					
					if(Number(itemArr[0]) > maxNumber)
						maxNumber = Number(itemArr[0]);
				}
				stream.close();
			}else{
				stream.open(standardFile,FileMode.WRITE);
				stream.writeMultiByte("\n",PackData.BUFF_ENCODE);
				stream.close();
				
			}
		}
		
		private function idTFHandle(e:EDUKeyboardEvent):void{
			searchBtnHandle(null);
			
		}
		private function searchBtnHandle(event:Event):void{
			if(idTF.text != currentId){
				currentLevel = 1;
				curLelTF.text = "熟练";
				getUserLevel(idTF.text,"yy.W");
			}
			
		}
		
		private function updateMyMark(myMark:int):void{
			sendNotification(WorldMapCoordinateMediator.UPDATE_MYMARK,myMark);
		}
		private function updateGoalMark(myMark:int):void{
			sendNotification(WorldMapCoordinateMediator.UPDATE_GOALMARK,myMark);
		}

		
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function onRemove():void
		{
			sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,false);
			idTF.removeEventListener(EDUKeyboardEvent.ENTER,idTFHandle);
			
			Starling.current.nativeOverlay.removeChild(idTF);
			TweenLite.killTweensOf(lvlSp);
			
			sendNotification(WorldConst.HIDE_SETTING_SCREEN);
			
			sendNotification(WorldConst.SHOW_MENU_BUTTON);
			lvlSp.removeChildren(0,-1,true);
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
	}
}