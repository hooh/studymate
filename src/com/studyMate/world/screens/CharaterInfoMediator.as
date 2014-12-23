package com.studyMate.world.screens
{
	import com.byxb.utils.centerPivot;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.CharaterInfoVO;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.chatroom.ChatAlertMediator;
	
	import flash.geom.Rectangle;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class CharaterInfoMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "CharaterInfoMediator";
		public static const GET_MONEY:String = NAME + "getMoney";
		public static const GET_STUDENT_INFO:String = NAME + "getStudentInfo";
		public static const HIDE_VIEW:String = NAME + "HideView";
		public static const UPDATE_MY_RELATE:String = NAME + "updateMyRelate";
		
		private static const INSERT_STD_RELATE:String = NAME + "insertStdRelate";
		private static const DEL_STD_RELATE:String = NAME + "delStdRelate";
		private static const GET_STUDENT_EQUIP:String = NAME + "getStudentEquip";
		
		
		private var vo:SwitchScreenVO;
		private var humanId:String;
		private var humanDressList:String;

		private var studentName:String;
		private var nickName:String;
		private var stdId:String;
		private var sex:String;
		private var gold:String;
		private var level:String;
		private var sign:String;
		
		private var SNameText:TextField;
		private var NNText:TextField;
		private var IDText:TextField;
		private var SexText:TextField;
		private var goldText:TextField;
		private var levelText:TextField;
		private var signText:TextField;
		
		private var humanPool:HumanPoolProxy;
		private var friVo:RelListItemSpVO;
		
		private var isshowId:Boolean = false;
		
		public function CharaterInfoMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
//			friVo = vo.data as RelListItemSpVO;
			friVo = (vo.data as CharaterInfoVO).reltVo;
			
			//friVo不为空，则是由好友列表中切换出来的
			if(friVo){	//有个人信息、有金币、仅取个人装备
				
				studentName = friVo.realName;
				humanId = stdId = friVo.rstdId;
				nickName = friVo.nickName;
				sex = friVo.gender;
				gold = friVo.goldNum;
				sign = friVo.sign;
				
				getEquipment(stdId);
				
				
			}else if((vo.data as CharaterInfoVO).equip != "-1" && (vo.data as CharaterInfoVO).equip != ""){	//有装备，取金币、取个人信息
				humanId = (vo.data as CharaterInfoVO).id;
				humanDressList = (vo.data as CharaterInfoVO).equip;
				level = (vo.data as CharaterInfoVO).level;
				getGold();
			}else{	//取装备、取金币、取个人信息
				isshowId = true;
				humanId = stdId = (vo.data as CharaterInfoVO).id;
				getEquipment(humanId);
				
			}
		}
		
		override public function onRegister():void{
			sendNotification(PersonalInfoViewMediator.HIDE_VIEW);
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
//			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(false, NAME));
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this,true)));
			
			init();
			
			
		}
		private var dressMap:HashMap = new HashMap();
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case GET_STUDENT_EQUIP:
					if(!result.isEnd){
						dressMap.insert(PackData.app.CmdOStr[1],[PackData.app.CmdOStr[2],PackData.app.CmdOStr[3]]);
						
					}else{
						if(dressMap.containsKey(stdId)){
							humanDressList = dressMap.find(stdId)[0];
							level = dressMap.find(stdId)[1];
						}else{
							humanDressList = "face_face1";
						}
						
						if(isshowId){
							getGold();
						}else{
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						}
						
					}
					break;
				case GET_STUDENT_INFO:
					stdId = PackData.app.CmdOStr[1];
					studentName = PackData.app.CmdOStr[5];
					nickName = PackData.app.CmdOStr[4];
					sex = PackData.app.CmdOStr[21];
					sign = PackData.app.CmdOStr[22];
					
					friVo = new RelListItemSpVO();
					friVo.realName = studentName;
					friVo.rstdId = stdId;
					friVo.nickName = nickName;
					friVo.gender = sex;
					friVo.goldNum = gold;
					friVo.sign = sign;
					
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					break;
				case GET_MONEY:
					gold = PackData.app.CmdOStr[4];
					
					getInfo();
					break;
				case INSERT_STD_RELATE:
					if(!(notification.getBody() as DataResultVO).isErr){
						
						if(PackData.app.CmdOStr[0] == "0M1"){
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
								[new SwitchScreenVO(ChatAlertMediator,[null,studentName+" 已经是你的好友了哦。"],
									SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
						}else{
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
								[new SwitchScreenVO(ChatAlertMediator,[null,"成功添加 "+studentName+" 为好友！"],
									SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
							
							dealBtn.enabled = false;
							Facade.getInstance(CoreConst.CORE).sendNotification(UPDATE_MY_RELATE,new CharaterInfoVO(friVo,null,null,1));
						}
						
					}
					break;
				case DEL_STD_RELATE:
					if(!result.isErr){
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
							[new SwitchScreenVO(ChatAlertMediator,[null,"成功删除好友 "+studentName],
								SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
						dealBtn.enabled = false;
						Facade.getInstance(CoreConst.CORE).sendNotification(UPDATE_MY_RELATE,new CharaterInfoVO(friVo,null,null,0));
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
							[new SwitchScreenVO(ChatAlertMediator,[null,"删除失败"],
								SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
					}
					
					break;
					
				case HIDE_VIEW : 
					vo.type = SwitchScreenType.HIDE;
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
			}
		}
		override public function listNotificationInterests():Array{
			return [GET_STUDENT_INFO,GET_MONEY,INSERT_STD_RELATE,HIDE_VIEW,GET_STUDENT_EQUIP,DEL_STD_RELATE];
		}
		
		private function init():void{
			var bg:Image = new Image(Assets.getChatViewTexture("charaterInfo/infoBg"));
			view.addChild(bg);
			centerPivot(view);
			
			
			SNameText = new TextField(200,50,"","HeiTi",23,0x220a01);
			SNameText.x = 255;
			SNameText.y = 20;
			SNameText.hAlign = HAlign.LEFT;
			view.addChild(SNameText);
			
			NNText = new TextField(200,50,"","HeiTi",23,0x220a01);
			NNText.x = 255;
			NNText.y = 53;
			NNText.hAlign = HAlign.LEFT;
			view.addChild(NNText);
			
			IDText = new TextField(200,50,"","HeiTi",23,0x220a01);
			IDText.x = 255;
			IDText.y = 85;
			IDText.hAlign = HAlign.LEFT;
			view.addChild(IDText);
			
			SexText = new TextField(200,50,"","HeiTi",23,0x220a01);
			SexText.x = 255;
			SexText.y = 120;
			SexText.hAlign = HAlign.LEFT;
			view.addChild(SexText);
			
			levelText = new TextField(200,50,"","HeiTi",23,0x220a01);
			levelText.x = 255;
			levelText.y = 155;
			levelText.hAlign = HAlign.LEFT;
			view.addChild(levelText);
			
			goldText = new TextField(200,50,"","HeiTi",23,0x220a01);
			goldText.x = 95;
			goldText.y = 183;
			goldText.hAlign = HAlign.LEFT;
			view.addChild(goldText);
			
			signText = new TextField(350,120,"","HeiTi",20,0x220a01);
			signText.x = 55;
			signText.y = 286;
			signText.hAlign = HAlign.LEFT;
			signText.vAlign = VAlign.TOP;
			view.addChild(signText);
			
			
			var closeBtn:Button = new Button(Assets.getChatViewTexture("charaterInfo/closeBtn"));
			closeBtn.x = 416;
			closeBtn.y = -20;
			closeBtn.addEventListener(Event.TRIGGERED,closeBtnHandle);
			view.addChild(closeBtn);
			
			var texture:Texture = (vo.data as CharaterInfoVO).sign == 1 ? 
				Assets.getChatViewTexture("chatRoom/addFriendBtn") : Assets.getChatViewTexture("charaterInfo/delFriendBtn");
			dealBtn = new Button(texture);
			dealBtn.x = 175;
			dealBtn.y = 422;
			dealBtn.addEventListener(Event.TRIGGERED,dealBtnHandle);
			//自己的资料界面，不能添加/删除好友
			if(humanId != PackData.app.head.dwOperID.toString())
			{
				view.addChild(dealBtn);
			}
			
			
			showInfo();
			createHuman();
		}
		private var dealBtn:Button;
		private var charater:ICharater;
		private function createHuman():void{
			
			charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
			GlobalModule.charaterUtils.configHumanFromDressList(charater as HumanMediator,humanDressList,new Rectangle());
			
			charater.view.x = 105;
			charater.view.y = 135;
			charater.view.scaleX = 1;
			charater.view.scaleY = 1;
			charater.view.alpha = 1;
			view.addChild(charater.view);
		}
		private function showInfo():void{
			SNameText.text = studentName;
			NNText.text = nickName;
			IDText.text = stdId;
			levelText.text = getStandLvl(level);
			goldText.text = gold;
			signText.text = sign;
			
			
			if(sex == "0")	SexText.text = "女";
			else	SexText.text = "男";
		}
		private function getStandLvl(_lvl:String):String{
			var __lvl:int = parseInt(_lvl);
			var lvl:int = 0;
			if(__lvl != 0){
				var p:int = __lvl/100;
				var q:int = __lvl%100;
				
				//能被100整除
				if(q == 0){
					lvl = p;
				}else{
					lvl = p+1;
				}
			}
			return lvl.toString();
		}
		
		
		private function closeBtnHandle(event:Event):void{
//			if(friVo)
//				sendNotification(PersonalInfoViewMediator.SHOW_VIEW);
//			else
				sendNotification(HIDE_VIEW);
		}
		private function dealBtnHandle(event:Event):void{
			/*if(!Global.isLoading)
				sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(view,view.width>>1,view.height>>1,doAddFriend,"确定添加 "+nickName+" 为好友吗？"));*/
			if(!Global.isLoading){
				if((vo.data as CharaterInfoVO).sign == 1)
				{
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
						[new SwitchScreenVO(ChatAlertMediator,[doAddFriend,"确定增加 "+studentName+" 为好友？"],
							SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
				}else{
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
						[new SwitchScreenVO(ChatAlertMediator,[doDelFriend,"确定删除好友 "+studentName+" ？"],
							SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
				}
				
				
				
			}
		}
		private function doAddFriend():void{
			if(friVo)
			{
				friVo.relaType = "F";
			}
			
			
			PackData.app.CmdIStr[0] = CmdStr.INSERT_STD_RELAT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = humanId;
			PackData.app.CmdIStr[3] = "F";
			PackData.app.CmdInCnt = 4;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(INSERT_STD_RELATE,null,"cn-gb",null,SendCommandVO.QUEUE));
		}
		private function doDelFriend():void{
			PackData.app.CmdIStr[0] = CmdStr.DELETE_STD_RELAT;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = humanId;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(DEL_STD_RELATE,null,"cn-gb",null,SendCommandVO.QUEUE));
			
		}
		
		private function getGold():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
			PackData.app.CmdIStr[1] = humanId;
			PackData.app.CmdIStr[2] = "SYSTEM.SMONEY";
			PackData.app.CmdInCnt =3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_MONEY,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
		}
		private function getInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_STUDENT_INFO;
			PackData.app.CmdIStr[1] = "";
			PackData.app.CmdIStr[2] = humanId;
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_STUDENT_INFO,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
		}
		private function getEquipment(_stdId:String):void{
			PackData.app.CmdIStr[0] = CmdStr.GET_CHARATER_EQUIPMENT;
			PackData.app.CmdIStr[1] = _stdId;
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_STUDENT_EQUIP,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
		}
		
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charater;
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
//			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(true));
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			view.removeChildren(0,-1,true);
		}
	}
}