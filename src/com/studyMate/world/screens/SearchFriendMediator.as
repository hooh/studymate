package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.controller.vo.CharaterInfoVO;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	
	import flash.text.TextFormat;
	
	import de.polygonal.ds.HashMap;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	public class SearchFriendMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SearchFriendMediator";
		private static const GET_STUDENT_INFO:String = NAME + "getStudentInfo";
		
		private var vo:SwitchScreenVO;
		
		private var dressList:HashMap = new HashMap();
		private var humanId:String;
		
		public function SearchFriendMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		

		override public function onRegister():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
			
			init();
		}
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GET_STUDENT_INFO:
					if(PackData.app.CmdOStr[0] == "M00"){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
							640,381,null,"您输入的ID号不存在，请重新输入。"));
						
						idInput.text = "";
					}else{
						humanId = PackData.app.CmdOStr[1];
						
						sendNotification(WorldConst.GET_CHARATER_EQUIPMENT,[humanId]);
					}
					break;
				case WorldConst.GET_CHARATER_EQUIPMENT_COMPLETE:
					if(!result.isEnd){
						dressList.insert(PackData.app.CmdOStr[1],PackData.app.CmdOStr[2]);
					}else{
						cancleBtnHandle(null);
						if(dressList.containsKey(humanId))
							sendNotification(WorldConst.SWITCH_SCREEN,
								[new SwitchScreenVO(CharaterInfoMediator,new CharaterInfoVO(null,humanId,dressList.find(humanId)),
									SwitchScreenType.SHOW,view.stage,640,381)]);
						else
							sendNotification(WorldConst.SWITCH_SCREEN,
								[new SwitchScreenVO(CharaterInfoMediator,new CharaterInfoVO(null,humanId,"face_face1"),
									SwitchScreenType.SHOW,view.stage,640,381)]);
					}
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [WorldConst.GET_CHARATER_EQUIPMENT_COMPLETE,GET_STUDENT_INFO];
		}
		
		private var modifySp:Sprite;
		private var idInput:TextFieldHasKeyboard;
		private function init():void{
			modifySp = new Sprite();
			view.addChild(modifySp);
			
			var quad:Quad = new Quad(Global.stageWidth, Global.stageHeight, 0);
			quad.alpha = 0.7;
			modifySp.addChild(quad);
			
			var searchIdBg:Image = new Image(Assets.getAtlasTexture("targetWall/otherScroll"));
			view.addChild(searchIdBg);
			searchIdBg.x = 640-(searchIdBg.width>>1); 
			searchIdBg.y = 381-(searchIdBg.height>>1);
			

			
			idInput = new TextFieldHasKeyboard();
			idInput.name = "idInput";
			idInput.restrict = "A-Z a-z 0-9";
			idInput.defaultTextFormat = new TextFormat("HuaKanT",28);
			idInput.prompt = "请输入您查找的ID";
			idInput.maxChars = 16;
			idInput.x = searchIdBg.x + 15; 
			idInput.y = 365;
			idInput.width = searchIdBg.width; 
			idInput.height = 47;
			Starling.current.nativeOverlay.addChild(idInput);
			
//			idInput.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN,idInputHandle);
			
			
			var sureBtn:Button = new Button();
			sureBtn.label = "确认";
			sureBtn.x = 800;
			sureBtn.y = 385-searchIdBg.height;
			sureBtn.addEventListener(Event.TRIGGERED,sureBtnHandle);
			view.addChild(sureBtn);
			
			var cancleBtn:Button = new Button();
			cancleBtn.label = "取消";
			cancleBtn.x = 800;
			cancleBtn.y = 390;
			cancleBtn.addEventListener(Event.TRIGGERED,cancleBtnHandle);
			view.addChild(cancleBtn);
		}
		
		private function sureBtnHandle(event:Event):void{
			if(idInput.text == "")
				sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
					640,381,null,"ID号不能为空，请重新输入"));
			else
				getInfo(idInput.text);
		}
		private function cancleBtnHandle(event:Event):void{
			vo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}
		
		private function getInfo(_name:String):void{
			PackData.app.CmdIStr[0] = CmdStr.GET_STUDENT_INFO;
			PackData.app.CmdIStr[1] = _name;
			PackData.app.CmdIStr[2] = "";
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_STUDENT_INFO));
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			Starling.current.nativeOverlay.removeChild(idInput);
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			
		}
	}
}