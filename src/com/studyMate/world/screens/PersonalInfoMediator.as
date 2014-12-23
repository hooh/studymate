package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import myLib.myTextBase.GpuTextInput;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.StudentInfoVO;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.events.FeathersEventType;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class PersonalInfoMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "PersonalInfoMediator";
		public static const GET_STUDENT_INFO:String = NAME + "getStudentInfo";
		private static const GET_MONEY:String = NAME + "getMoney";
		
		private var charater:ICharater;
		
		private var vo:SwitchScreenVO;
		private var hasCreate:String;

		private var gold:String;
		
		private var SNameText:TextField;
		private var BirText:TextField;
		private var NNText:TextField;
		private var SexText:TextField;
		private var goldText:TextField;
//		private var signInput:TextFieldHasKeyboard;
		private var signInput:GpuTextInput;
		
		private var stuInfoVo:StudentInfoVO = new StudentInfoVO();
		private var tips:TextField;
		
		public function PersonalInfoMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			this.hasCreate = vo.data[0];
			
			getInfo();
			
//			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		

		private var dressPanelSp:Sprite;
		override public function onRegister():void{
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);

			var bg:Image = new Image(Assets.getTexture("personalInfoBg"));
			view.addChild(bg);
			bg.x = 40;
			
			TweenLite.from(view,0.5,{alpha:0,y:-view.height,ease:Linear.easeNone});
			if(hasCreate != null && hasCreate !=""){
				TweenLite.delayedCall(0.5,function start():void{
					//提示创建角色
					sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
						640,381,null,"欢迎进入新世界！首次登陆，请创建您的角色。"));
				});
			}
			showCharater();
			
			init();
			
			dressPanelSp= new Sprite();
			dressPanelSp.x = 90;
			dressPanelSp.y = 385;
			view.addChild(dressPanelSp);
			createDressPanel();
			
//			tips = new TextField(600,50,"更多超炫时装，即将到来...","HuaKanT",23,0x00fc03);
			tips = new TextField(600,50,"Tips：世界杯球迷套装，可在右边选择号码.","HuaKanT",23,0x00fc03);
//			tips.x = 470;
			tips.x = 420;
			tips.y = 255;
			dressPanelSp.addChild(tips);
//			TweenMax.to(tips,10,{color:0x0004fb,repeat:int.MAX_VALUE,yoyo:true,ease:Linear.easeNone});
			
			
			
			
			this.backHandle = function():void{
				if((stuInfoVo.sign != signInput.text) && signInput.text != ""){
					sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,
						640,381,saveSign,"签名已修改，是否需要保存？",cancleSave));
				}else
					sendNotification(WorldConst.POP_SCREEN);
			}
		}
		private function showCharater():void{
			var charaterSp:Sprite = new Sprite();
			
			charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
			if(hasCreate != null && hasCreate !=""){
				//新建人物，先配上脸
//				CharaterUtils.humanDressFun(charater as HumanMediator,"face_face1");
				GlobalModule.charaterUtils.configHumanFromDressList(charater as HumanMediator,"face_face1,shoes1",new Rectangle());
			}else{
//				CharaterUtils.humanDressFun(charater as HumanMediator,Global.myDressList);
				GlobalModule.charaterUtils.configHumanFromDressList(charater as HumanMediator,Global.myDressList,new Rectangle());
			}
			
			
			charaterSp.addChild(charater.view);
			charater.view.x = 0;
			charater.view.y = 0;
			charaterSp.x = 280;
			charaterSp.y = 255;
			view.addChild(charaterSp);
			
		}
		private function init():void{
			
			signInput = new GpuTextInput();
			signInput.x = 490;
			signInput.y = 70;
			signInput.maxChars = 60;
			signInput.width = 470; 
			signInput.height = 86;
			view.addChild(signInput);
			signInput.setTextFormat(new TextFormat("HeiTi",23,0x9b6938));
			signInput.stageTextField.multiline = true;
			signInput.stageTextField.isEditable = true;
			signInput.prompt = "请输入您的个性签名...";
			signInput.addEventListener(FeathersEventType.ENTER,inputHandle);
			
			
			SNameText = new TextField(200,50,"","HeiTi",23,0x816452);
			SNameText.x = 555;
			SNameText.y = 215;
			SNameText.hAlign = HAlign.LEFT;
			view.addChild(SNameText);
			
			BirText = new TextField(200,50,"","HuaKanT",23,0x816452);
			BirText.x = 555;
			BirText.y = 275;
			BirText.hAlign = HAlign.LEFT;
			view.addChild(BirText);
			
			NNText = new TextField(200,50,"","HuaKanT",23,0xfeaaaa);
			NNText.x = 910;
			NNText.y = 200;
			NNText.hAlign = HAlign.LEFT;
			view.addChild(NNText);
			
			
			SexText = new TextField(200,50,"","HuaKanT",23,0xe86729);
			SexText.x = 910;
			SexText.y = 243;
			SexText.hAlign = HAlign.LEFT;
			view.addChild(SexText);
			
			goldText = new TextField(200,50,"","HuaKanT",23,0xe86729);
			goldText.x = 910;
			goldText.y = 286;
			goldText.hAlign = HAlign.LEFT;
			view.addChild(goldText);
			
			var relatListBtn:Button = new Button();
			relatListBtn.label = "好友列表";
			relatListBtn.x = 480;
			relatListBtn.y = 350;
			view.addChild(relatListBtn);
			relatListBtn.addEventListener(Event.TRIGGERED,relatListBtnHandle);
			
			var searchFriendBtn:Button = new Button();
			searchFriendBtn.label = "添加好友";
			searchFriendBtn.x = 580;
			searchFriendBtn.y = 350;
			view.addChild(searchFriendBtn);
			searchFriendBtn.addEventListener(Event.TRIGGERED,searchFriendBtnHandle);
			
			
			var modifyNNBtn:Button = new Button();
			modifyNNBtn.label = "修改昵称";
			modifyNNBtn.x = 880;
			modifyNNBtn.y = 350;
			view.addChild(modifyNNBtn);
			modifyNNBtn.addEventListener(Event.TRIGGERED,modifyNNBtnHandle);	

			showInfo();
			
		}
		private function getInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_STUDENT_INFO;
			PackData.app.CmdIStr[1] = Global.user;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_STUDENT_INFO,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
		}
		private function getGold():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "SYSTEM.SMONEY";
			PackData.app.CmdInCnt =3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_MONEY,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
		}
		private function showInfo():void{
			try
			{
				if(stuInfoVo.sex == "0"){
					charater.actor.getProfile().sex = "F";
					charater.sex = "F";
				}else{
					charater.actor.getProfile().sex = "M";
					charater.sex = "M";
				}
//				if(stuInfoVo.sign == "")	signInput.text = "请输入您的个性签名...";
//				else	signInput.text = stuInfoVo.sign;
				signInput.text = stuInfoVo.sign;
				
				SNameText.text = stuInfoVo.realName+"("+stuInfoVo.operId+")";
				BirText.text = stuInfoVo.birth.substr(0,4)+"-"+stuInfoVo.birth.substr(4,2)+"-"+stuInfoVo.birth.substr(6,2);
				NNText.text = stuInfoVo.nickName;
				goldText.text = gold;
				
				if(stuInfoVo.sex == "0")	SexText.text = "女";
				else	SexText.text = "男";
			} 
			catch(error:Error) 
			{
				
			}
		}
		private function inputFocusInHandle(event:FocusEvent):void{
			signInput.addEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
		}
		private function inputFocusOutHandle(event:FocusEvent):void{
			signInput.removeEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
		}
//		private function inputHandle(e:KeyboardEvent):void{
		private function inputHandle(e:Event):void{
//			if(e.keyCode==13){
				closeInput();
//			}						
		}
		private function closeInput():void{
			if(stuInfoVo.sign != signInput.text){
				var signStr:String = signInput.text.replace(/'/g,"\\'");
				sendNotification(WorldConst.UPDATE_STU_SIGN,signStr);
			}
		}
		
		private function saveSign():void{
			closeInput();
		}
		private function cancleSave():void{
			sendNotification(WorldConst.POP_SCREEN);
		}
		
		//查看好友列表
		private function relatListBtnHandle(event:Event):void{
			sendNotification(WorldConst.SWITCH_SCREEN,
				[new SwitchScreenVO(RelationListMediator,null,SwitchScreenType.SHOW,view.stage,640,430)]);
		}
		//查找、添加好友
		private function searchFriendBtnHandle(event:Event):void{
			/*sendNotification(WorldConst.SWITCH_SCREEN,
				[new SwitchScreenVO(CharaterInfoMediator,["63","face_face1,set1"],
					SwitchScreenType.SHOW,view.stage,640,381)]);*/
			sendNotification(WorldConst.SWITCH_SCREEN,
				[new SwitchScreenVO(SearchFriendMediator,null,SwitchScreenType.SHOW,view)]);
			
		}
		//修改密码
//		private function modifyPSWBtnHandle(event:Event):void{
//			sendNotification(WorldConst.SWITCH_SCREEN,
//				[new SwitchScreenVO(ModifyPerInfoMediator,["password",stuInfoVo],SwitchScreenType.SHOW,view)]);
//		}
		//修改昵称
		private function modifyNNBtnHandle(event:Event):void{
			stuInfoVo.sign = signInput.text;
			
			sendNotification(WorldConst.SWITCH_SCREEN,
				[new SwitchScreenVO(ModifyPerInfoMediator,["nickName",stuInfoVo],SwitchScreenType.SHOW,view)]);
		}
		
		private function createDressPanel():void{
			sendNotification(WorldConst.SWITCH_SCREEN,
				[new SwitchScreenVO(DressPanelMediator,[charater,hasCreate],SwitchScreenType.SHOW,dressPanelSp)]);
		}
	

		
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GET_STUDENT_INFO:
					if(!result.isErr){
						stuInfoVo.operId = PackData.app.CmdOStr[1];
						stuInfoVo.nickName = PackData.app.CmdOStr[4];
						stuInfoVo.realName = PackData.app.CmdOStr[5];
						stuInfoVo.smsTelNo = PackData.app.CmdOStr[6];
						stuInfoVo.birth = PackData.app.CmdOStr[13];
						stuInfoVo.mtomrrow = PackData.app.CmdOStr[14];
						stuInfoVo.qanswer1 = PackData.app.CmdOStr[15];
						stuInfoVo.lixiang = PackData.app.CmdOStr[16];
						stuInfoVo.aihao = PackData.app.CmdOStr[17];
						stuInfoVo.smile = PackData.app.CmdOStr[18];
						stuInfoVo.school = PackData.app.CmdOStr[19];
						stuInfoVo.sclass = PackData.app.CmdOStr[20];
						stuInfoVo.sex = PackData.app.CmdOStr[21];
						stuInfoVo.sign = PackData.app.CmdOStr[22];
						
						
						getGold();
					}
					
					break;
				case GET_MONEY:
					if(!result.isErr){
						gold = PackData.app.CmdOStr[4];
						
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						
						
					}
					
					break;
				
				case WorldConst.UPDATE_STU_SIGN_COMPLETE:
					if(PackData.app.CmdOStr[0] == "000"){
						stuInfoVo.sign = signInput.text;
						
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"修改成功！"));
					}else{
						sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(view,640,381,null,"修改失败！"));
					}
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [GET_STUDENT_INFO,GET_MONEY,WorldConst.UPDATE_STU_SIGN_COMPLETE];
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function onRemove():void{
			super.onRemove();
//			closeInput();
//			TweenLite.killTweensOf(tips);
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			signInput.removeEventListener(FocusEvent.FOCUS_IN,inputFocusInHandle);
			signInput.removeEventListener(FocusEvent.FOCUS_OUT,inputFocusOutHandle);
			if(signInput.hasEventListener(KeyboardEvent.KEY_DOWN))
				signInput.removeEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
//			Starling.current.nativeOverlay.removeChild(signInput);	
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charater;
		}
	}
}