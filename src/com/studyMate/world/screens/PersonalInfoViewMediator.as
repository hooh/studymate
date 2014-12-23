package com.studyMate.world.screens
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.controller.vo.EnableScreenCommandVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.model.vo.StudentInfoVO;
	import com.studyMate.world.screens.component.perInfoViewFrame.FriListSp;
	import com.studyMate.world.screens.component.perInfoViewFrame.FriSearchTextInput;
	import com.studyMate.world.screens.component.perInfoViewFrame.FriendInfoList;
	import com.studyMate.world.screens.component.perInfoViewFrame.PerInfoSp;
	import com.studyMate.world.screens.component.perInfoViewFrame.SearchSp;
	
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import feathers.controls.ProgressBar;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class PersonalInfoViewMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "PersonalInfoViewMediator";
		public static const SHOW_VIEW:String = NAME + "ShowView";
		public static const HIDE_VIEW:String = NAME + "HideView";
		private static const GET_STUDENT_INFO:String = NAME + "getStudentInfo";
		private static const GET_MONEY:String = NAME + "getMoney";
		private static const GET_FRILIST:String = NAME + "GetFrilist";
		private static const ADD_FRIEND_COMPLETE:String = NAME + "AddFriendComplete";
		private static const DEL_FRIEND_COMPLETE:String = NAME + "DelFriendComplete";
		private static const GETSTDFNLVL:String = NAME+"GetStdFnLvl";
		
		public static const SET_EDIT_TEXTINPUT:String = NAME + "SetEditTextInput";
		
		//个人信息
		private var stuInfoVo:StudentInfoVO = new StudentInfoVO();
		private var gold:String;
		
		
		private var perInfoSp:PerInfoSp;
		private var friListSp:FriListSp;
		private var searchSp:SearchSp;
		
		private var inputName:String = "";
		
		public function PersonalInfoViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		
		private var vo:SwitchScreenVO;
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			getInfo();
			
		}
		override public function onRegister():void
		{
			sendNotification(CharaterInfoMediator.HIDE_VIEW);
			sendNotification(WorldConst.SET_ROLL_SCREEN,false);
//			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(false, NAME));
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this,true)));
			
			
			
			var bg:Image = new Image(Assets.getPersonalInfoTexture("perInfoBg"));
			bg.y = 40;
			view.addChild(bg);
			centerPivot(view);
			
			createSortBtn();
			
			//加入3个背景
			perInfoSp = new PerInfoSp(stuInfoVo,gold);
			friListSp = new FriListSp;
			searchSp = new SearchSp;
			view.addChild(perInfoSp);
			view.addChild(friListSp);
			view.addChild(searchSp);
			
			friListSp.visible = false;
			searchSp.visible = false;
			
			var experiencePro:ProgressBar = new ProgressBar();
			experiencePro.minimum = 0;
			experiencePro.maximum = 30;
			experiencePro.value = Number(Global.conDay);
			experiencePro.x = 150;
			experiencePro.y = 275;
			view.addChild(experiencePro);
			
			var fillTexture:Scale9Textures = new Scale9Textures(Assets.getPersonalInfoTexture("conDay"),new Rectangle(100,0,12,10));
			var fillSkin:Scale9Image = new Scale9Image(fillTexture);
			fillSkin.width = 0.2;
			fillSkin.pivotY = -fillSkin.height*0.14;
			fillSkin.scaleY = 0.81;
			fillSkin.pivotX = -2.5;
			experiencePro.fillSkin = fillSkin;
			experiencePro.backgroundSkin = new Image(Assets.getPersonalInfoTexture("updatePro"))
				
			var totalDay:TextField = new TextField(130,30,Global.conDay+"/30","HeiTi",12,0xf0f0f0,true);
			totalDay.x = 188;
			totalDay.y = 273;
			totalDay.nativeFilters = [new GlowFilter(0x004D63,1,3,3,10)];
			totalDay.hAlign = HAlign.LEFT;
			view.addChild(totalDay);
			
			
			var closeBtn:Button = new Button(Assets.getPersonalInfoTexture("closeBtn"));
			closeBtn.x = 483;
			closeBtn.y = 11;
			view.addChild(closeBtn);
			closeBtn.addEventListener(Event.TRIGGERED,closeBtnHandle);
			
			
			
		}
		
		private var btnTabBar:TabBar;
		private function createSortBtn():void{
			btnTabBar = new TabBar();
			btnTabBar.gap = -30;
			btnTabBar.x = 75;
			btnTabBar.y = 8;
			btnTabBar.dataProvider = new ListCollection(
				[				
					{ label: "" ,type:"perInfo" ,
						defaultIcon:new Image(Assets.getPersonalInfoTexture("taBtn_perInfo_up")) ,
						defaultSelectedIcon:new Image(Assets.getPersonalInfoTexture("taBtn_perInfo_down")),
						downIcon:new Image(Assets.getPersonalInfoTexture("taBtn_perInfo_down"))},
					/*{ label: "" ,type:"friList" ,
						defaultIcon:new Image(Assets.getPersonalInfoTexture("taBtn_friList_up")) ,
						defaultSelectedIcon:new Image(Assets.getPersonalInfoTexture("taBtn_friList_down")),
						downIcon:new Image(Assets.getPersonalInfoTexture("taBtn_friList_down"))},
					{ label: "" ,type:"search" ,
						defaultIcon:new Image(Assets.getPersonalInfoTexture("taBtn_search_up")) ,
						defaultSelectedIcon:new Image(Assets.getPersonalInfoTexture("taBtn_search_down")),
						downIcon:new Image(Assets.getPersonalInfoTexture("taBtn_search_down"))},*/
				]);
			
			btnTabBar.addEventListener(Event.CHANGE, btnTabBarChangeHandler);
			view.addChild(btnTabBar);
			btnTabBar.direction = TabBar.DIRECTION_HORIZONTAL;
			btnTabBar.customTabName = "btnTabBar";
			btnTabBar.tabProperties.stateToSkinFunction = null;
		}
		
		private function btnTabBarChangeHandler(event:Event):void{
			TweenLite.killTweensOf(getFriList);
			
			var selectType:String = btnTabBar.selectedItem.type;
			switch(selectType){
				case "perInfo":
					perInfoSp.visible = true;
					friListSp.visible = false;
					searchSp.visible = false;
					
					break;
				case "friList":
					getFriList();
					
					perInfoSp.visible = false;
					friListSp.visible = true;
					searchSp.visible = false;
					
					break;
				case "search":
					perInfoSp.visible = false;
					friListSp.visible = false;
					searchSp.visible = true;
					
					break;
			}
		}
		private function getFriList():void{
			TweenLite.killTweensOf(getFriList);
			if(Global.isLoading){
				TweenLite.delayedCall(2,getFriList);
				return;
			}
			
			friList.splice(0,friList.length);
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_STD_RELATLIST;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_FRILIST));
		}
		
		
		
		
		private function closeBtnHandle(e:Event):void{
			vo.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
		}
		
		
		
		private function getInfo():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_STUDENT_INFO;
			PackData.app.CmdIStr[1] = Global.user;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_STUDENT_INFO));
		}
		private function getGold():void{
			PackData.app.CmdIStr[0] = CmdStr.GET_MONEY;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = "SYSTEM.SMONEY";
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_MONEY));
		}
		
		override public function handleNotification(notification:INotification):void
		{
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
						getStudyLevel();
					}
					break;
				case GETSTDFNLVL:
				{
					if(!result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							Global.conDay = PackData.app.CmdOStr[2];
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						}
					}
					break;
				}
				case PerInfoSp.UPDATE_NICKNAME_COMPLETE:
					//昵称修改成功
					if(!result.isErr){
						perInfoSp.setNName(true);
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,view.width>>1,view.height>>1,null,"昵称修改成功!~O(∩_∩)O~"));
					
					}else{
						perInfoSp.setNName(false);
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,view.width>>1,view.height>>1,null,"十分抱歉，昵称修改失败，请与客服人员联系."));
					}
					break;
				case GET_FRILIST:
					if(!result.isEnd){
						var relListItemSpVo:RelListItemSpVO = new RelListItemSpVO();
						relListItemSpVo.userId = PackData.app.CmdOStr[1];
						relListItemSpVo.rstdId = PackData.app.CmdOStr[2];
						relListItemSpVo.rstdCode = PackData.app.CmdOStr[3];
						relListItemSpVo.realName = PackData.app.CmdOStr[4];
						relListItemSpVo.relaType = PackData.app.CmdOStr[5];
						relListItemSpVo.nickName = PackData.app.CmdOStr[7];
						relListItemSpVo.gender = PackData.app.CmdOStr[8];
						relListItemSpVo.goldNum = PackData.app.CmdOStr[9];
						relListItemSpVo.birth = PackData.app.CmdOStr[10];
						relListItemSpVo.school = PackData.app.CmdOStr[11];
						relListItemSpVo.sign = PackData.app.CmdOStr[12];
						
						friList.push(relListItemSpVo);
					}else{
						
						friListSp.updateFriList(friList);
						
					}
					break;
				case PerInfoSp.UPDATE_SIGN_COMPLETE:
					//签名修改成功
					if(!result.isErr){
						perInfoSp.setSigh(true);
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,view.width>>1,view.height>>1,null,"签名修改成功!~O(∩_∩)O~"));
						
					}else{
						perInfoSp.setSigh(false);
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,view.width>>1,view.height>>1,null,"十分抱歉，签名修改失败，请与客服人员联系."));
					}
					break;
				case FriSearchTextInput.SEARCH_STUDENT:
					//成功查找好友
					if(!result.isEnd){
						var _searVo:RelListItemSpVO = new RelListItemSpVO();
						_searVo.rstdId = PackData.app.CmdOStr[1];
						_searVo.rstdCode = PackData.app.CmdOStr[2];
						_searVo.nickName = PackData.app.CmdOStr[4];
						_searVo.realName = PackData.app.CmdOStr[5];
						_searVo.gender = PackData.app.CmdOStr[6];
						_searVo.goldNum = PackData.app.CmdOStr[7];
						_searVo.birth = PackData.app.CmdOStr[8];
						_searVo.school = PackData.app.CmdOStr[9];
						_searVo.sign = PackData.app.CmdOStr[10];
						
						searchFriList.push(_searVo);
					}else{
						
						searchSp.updateFriList(searchFriList);
					}
					break;
				case FriendInfoList.ADD_FRIEND:
					var addId:String = notification.getBody() as String;
					
					PackData.app.CmdIStr[0] = CmdStr.INSERT_STD_RELAT;
					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = addId;
					PackData.app.CmdIStr[3] = "F";
					PackData.app.CmdInCnt = 4;
					sendNotification(CoreConst.SEND_11,new SendCommandVO(ADD_FRIEND_COMPLETE));
					break;
				case FriendInfoList.DEL_FRIEND:
					var delId:String = notification.getBody() as String;
					
					PackData.app.CmdIStr[0] = CmdStr.DELETE_STD_RELAT;
					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = delId;
					PackData.app.CmdInCnt = 3;
					sendNotification(CoreConst.SEND_11,new SendCommandVO(DEL_FRIEND_COMPLETE));
					
					break;
				case ADD_FRIEND_COMPLETE:
					if(!result.isErr){
						
						if(PackData.app.CmdOStr[0] == "0M1")
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(view,view.width>>1,view.height>>1,null,"他已经是你的好友了哦..."));
						else
							sendNotification(WorldConst.DIALOGBOX_SHOW,
								new DialogBoxShowCommandVO(view,view.width>>1,view.height>>1,null,"成功添加好友！"));
					}
					break;
				case DEL_FRIEND_COMPLETE:
					if(!result.isErr){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,view.width>>1,view.height>>1,null,"成功删除好友！"));
						//更新好友列表
						getFriList();
					}else
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view,view.width>>1,view.height>>1,null,"好友删除失败！"));
					
					break;
				case SET_EDIT_TEXTINPUT:
					
					
					break;
				case SoftKeyBoardConst.NO_KEYBOARD:
					
					
					
					
					
					break;
				case HIDE_VIEW : 
//					vo.type = SwitchScreenType.HIDE;
//					sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
					view.visible = false;
//					sendNotification(WorldConst.SET_ROLL_SCREEN,true);
//					sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
					break;
				case SHOW_VIEW:
					view.visible = true;
					sendNotification(CharaterInfoMediator.HIDE_VIEW);
					
					//由CharaterInfoMediator切换回来，将派发消息使轮询恢复，在此需要重新停止轮询，且禁屏（因为调用POPUP_SCREEN没用，onRegister此类时已调用一次，不能重复POPUP_SCREEN）
					sendNotification(WorldConst.SET_ROLL_SCREEN,false);
					sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(false, NAME));
					sendNotification(WorldConst.SET_MODAL,true);
					break;
			}
		}
		
		private function getStudyLevel():void
		{
			PackData.app.CmdIStr[0] = CmdStr.GETSTDFNLVL;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID;
			PackData.app.CmdInCnt =2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(GETSTDFNLVL));
		}
		override public function listNotificationInterests():Array
		{
			return [GET_STUDENT_INFO,GET_MONEY,SET_EDIT_TEXTINPUT,SoftKeyBoardConst.NO_KEYBOARD,
				PerInfoSp.UPDATE_NICKNAME_COMPLETE,PerInfoSp.UPDATE_SIGN_COMPLETE,GET_FRILIST,
				FriSearchTextInput.SEARCH_STUDENT,FriendInfoList.ADD_FRIEND,FriendInfoList.DEL_FRIEND,
				ADD_FRIEND_COMPLETE,DEL_FRIEND_COMPLETE,HIDE_VIEW,SHOW_VIEW,GETSTDFNLVL];
		}
		private var friList:Vector.<RelListItemSpVO> = new Vector.<RelListItemSpVO>;
		public var searchFriList:Vector.<RelListItemSpVO> = new Vector.<RelListItemSpVO>;
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function onRemove():void
		{
			TweenLite.killTweensOf(getFriList);
			
			sendNotification(WorldConst.SET_ROLL_SCREEN,true);
			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(true));
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			
			view.removeChildren(0,-1,true);
		}
		
		
		
		
	}
}