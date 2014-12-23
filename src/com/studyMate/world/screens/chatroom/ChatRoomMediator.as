package com.studyMate.world.screens.chatroom
{
	import com.mylib.api.ISwitchScreenProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.mylib.game.controller.vo.PChatInfoVO;
	import com.mylib.game.controller.vo.WChatInfoVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.component.weixin.SpeechConst;
	import com.studyMate.world.component.weixin.VoiceState;
	import com.studyMate.world.component.weixin.VoicechatComponent;
	import com.studyMate.world.component.weixin.vo.WeixinVO;
	import com.studyMate.world.controller.vo.CharaterInfoVO;
	import com.studyMate.world.controller.vo.CharaterStateVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.CharaterInfoMediator;
	import com.studyMate.world.screens.HappyIslandMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ChatRoomMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "ChatRoomMediator";
		public static const INSERT_STD_RELATE:String = NAME + "insertStdRelate";
		public static const APPLY_ADD_RELATE:String = NAME + "applyAddRelate";
		
		private static const GET_RELATE_LIST:String = NAME + "getRelateList";
		private static const SEARCH_STUDENT:String = NAME + "searchStudent";
		
		private static const GET_WCHAT_COMPLETE:String = NAME + "getWChatComplete";
		private static const GET_PCHAT_COMPLETE:String = NAME + "getPChatComplete";
		
		private static const INSERT_FILE_COMPLETE:String = NAME + "insertFileComplete";//插入语音、图片成功
		private static const INSERT_PC_COMPLETE:String = NAME + "insertPCComplete";//插入私聊文本成功
		
		private static const SEL_TASK_STATUS:String = NAME + "selTaskStatus";
		private static const QRY_WC_HISTORY_COMPLETE:String = NAME + "qryWcHistoryComplete";
		private static const QRY_PC_HISTORY_COMPLETE:String = NAME + "qryPcHistoryComplete";
		
		private var vo:SwitchScreenVO;
		
		
		private var relateList:Array = [];
		private var perlistSp:PersonListSprite;
		
		
		private var searchList:SearchList;
		private var searchArr:Array = [];
		
		
		private var WCChatVoice:VoicechatComponent;
		private var PCChatVoice:VoicechatComponent;
		
		//世界聊天idx
		private var wcIdx:int = 0;
		private var pcIdx:int = 0;
		
		private var filterProxy:ChatRoomFilterProxy;
		
		private var canTalk:Boolean;
		
		private var chatOLProxy:ChatRoomOLProxy;
		
		private var inScreenType:int = 0;	//0:HappyIslandMediator  1:其他界面
		private var showOperId:int = -1;	//要显示的operId；
		
		private var isRegisted:Boolean = false;	//标记注册，处理切出、切入导致重复接受消息
		
		private var locPCDealist:Array = [];
		
		public function ChatRoomMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			showOperId = int(vo.data);
			
			var switchProxy:ISwitchScreenProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.SWITCH_SCREEN_PROXY) as ISwitchScreenProxy;
			inScreenType = (switchProxy.currentGpuScreen is HappyIslandMediator) ? 0 : 1;
			
			/*getRelateList();*/
			checkTaskState()
			
			
		}
		override public function onRegister():void
		{
			isRegisted = true;
			
//			sendNotification(WorldConst.DISABLE_WORLD_BACK);
//			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,keybackHandle);
			
			//敏感字过滤
			filterProxy = new ChatRoomFilterProxy();
			facade.registerProxy(filterProxy);
			
			//联系人列表
			perlistSp = new PersonListSprite(relateList);
			perlistSp.x = -300;
			perlistSp.addEventListener("PerListClick",perlistClickHandle);
			
			var clipSp:Sprite = new Sprite;
			clipSp.addChild(perlistSp);
			clipSp.clipRect = new Rectangle(0,0,267,734);
			view.mainSp.addChild(clipSp);
			view.perlistSp = perlistSp;
			
			
			initWCComponent();
			initPCComponent();
			
			
			//搜索列表
			view.search.addEventListener(SearchSprite.SEARCH_STUDENT,searchHandle);
			view.perInfoBtn.addEventListener(Event.TRIGGERED,perInfoBtnHandle);
			view.wchistoryBtn.addEventListener(Event.TRIGGERED,getWCHistory);
			view.pchistoryBtn.addEventListener(Event.TRIGGERED,getPCHistory);
			
			//处理聊天心跳
			chatOLProxy = new ChatRoomOLProxy;
			facade.registerProxy(chatOLProxy);
			
			view.show(inScreenType);
			//设置公众聊天隐藏
			if(inScreenType == 1)
			{
				view.hideWCTab();
			}
			
			if(PackData.app.head.dwOperID.toString() == "63" || PackData.app.head.dwOperID.toString() == "67"){
				canTalk = true;
			}
			
			//有id,要选中好友，判断 是否好友，不是则邀请添加；是则选中好友
			if(showOperId && showOperId != -1){
				if(hadRelatInf(showOperId)){
					//选中好友
					view.selePerson(showOperId);
					
				}else{
					//申请加好友
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
						[new SwitchScreenVO(ChatAlertMediator,[applyAddFriend,"他(她)还不是您的好友哦，是否看看他(她)，再加好友？"],
							SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
					
					
				}
				
			}
			
			trace("@VIEW:ChatRoomMediator:");
			
		}
		private function applyAddFriend():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
				[new SwitchScreenVO(CharaterInfoMediator,new CharaterInfoVO(null,showOperId.toString(),"-1",1),
					SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
		}
		
		
		private function initWCComponent():void{
			WCChatVoice = new VoicechatComponent();
			if(!canTalk){				
				WCChatVoice.activeVoice = false;
			}
			WCChatVoice.y = 70;
			
			WCChatVoice.configView.viewWidth = 1188;
			WCChatVoice.configView.useTeacherIcon = false;
			WCChatVoice.configView.viewHeight = 560;
			WCChatVoice.configText.textInputView =  WCTextInputView;
			WCChatVoice.configText.dropDownView = null;
			WCChatVoice.configText.insertTextFun = insWCTextHandler;
			WCChatVoice.configText.insertImgFun = null;
			WCChatVoice.configVoice.voiceInputView = null;
			WCChatVoice.configVoice.dropDownView = null;
			WCChatVoice.configVoice.inserVoiceFun = null;
			WCChatVoice.configVoice.tryListenView = null;	
			view.wtalkSp.addChild(WCChatVoice);
			
			WCChatVoice.activeAutoScroll(true);
//			WCChatVoice.viewVisible = false;
			WCChatVoice.visible = false;
			view.wcVoiChat = WCChatVoice;
		}
		
		private function initPCComponent():void{
			PCChatVoice = new VoicechatComponent();
			if(!canTalk){					
				PCChatVoice.activeVoice = false;
			}
			PCChatVoice.y = 70;
			
			PCChatVoice.configView.viewWidth = 944;
			PCChatVoice.configView.useTeacherIcon = false;
			PCChatVoice.configView.viewHeight = 570;
			PCChatVoice.configText.textInputView =  PCTextInputView;
			PCChatVoice.configText.dropDownView = PCDropDownView;
			PCChatVoice.configText.insertTextFun = insPCTextHandler;
			PCChatVoice.configText.insertImgFun = insertImgHandler;
			PCChatVoice.configVoice.voiceInputView = PCVoiceInputView;
			PCChatVoice.configVoice.dropDownView = PCDropDownView;
			PCChatVoice.configVoice.inserVoiceFun = insertVoiceHandler;
			PCChatVoice.configVoice.tryListenView = PCTryListenView;	
			view.ptalkSp.addChild(PCChatVoice);
			
			PCChatVoice.activeAutoScroll(true);
//			PCChatVoice.viewVisible = false;
//			PCChatVoice.visible = false;
			view.pcVoiChat = PCChatVoice;
			
		}
		
		private var isFirst:Boolean = true;
		private function insWCTextHandler(mtxt:String):WeixinVO{
			
			if(!canTalk)
			{
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
					[new SwitchScreenVO(ChatAlertMediator,[null,"未完成任务，还不能聊天哦！"],
						SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,200)]);
				return null;
			}
			
			
			var newStr:String = filterProxy.replaceSensitiveWord(mtxt);
			
			PackData.app.CmdIStr[0] = CmdStr.IN_WORLD_MESS;
			PackData.app.CmdIStr[1] = 0;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[3] = Global.player.realName;
			PackData.app.CmdIStr[4] = newStr;	//聊天内容
			PackData.app.CmdInCnt = 5;
			sendNotification(CoreConst.SEND_11,new SendCommandVO("",null,'cn-gb',null,SendCommandVO.QUEUE));
			
			
			var messageVO:WeixinVO = new WeixinVO;
			messageVO.sedid = PackData.app.head.dwOperID.toString();
			messageVO.sedname = Global.player.realName
			messageVO.sedtime = MyUtils.getTimeFormat1();
			messageVO.mtype = 'text';
			messageVO.mtxt = newStr;
			messageVO.hasRead = true;
			messageVO.owner = true;
			return messageVO;
			
		}
		
		private function insPCTextHandler(mtxt:String):ChatVo{
			//需要先选择聊天对象
			var vo:RelListItemSpVO = perlistSp ? perlistSp.hadSelect : null;
			if(!vo)
			{
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
					[new SwitchScreenVO(ChatAlertMediator,[null,"请先选择你发送的对象哦！"],
						SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,200)]);
				return null;
			}
			
			if(!canTalk)
			{
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
					[new SwitchScreenVO(ChatAlertMediator,[null,"未完成任务，还不能聊天哦！"],
						SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,200)]);
				return null;
			}
			
			
			var newStr:String = filterProxy.replaceSensitiveWord(mtxt);
			
			PackData.app.CmdIStr[0] = CmdStr.INUP_INSTANT_MESS;
			PackData.app.CmdIStr[1] = 0;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[3] = Global.player.realName;
			PackData.app.CmdIStr[4] = vo.rstdId;	
			PackData.app.CmdIStr[5] = vo.realName;
			PackData.app.CmdIStr[6] = "text";	
			PackData.app.CmdIStr[7] = newStr;	//聊天内容
			PackData.app.CmdInCnt = 8;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(INSERT_PC_COMPLETE,null,'cn-gb',null,SendCommandVO.QUEUE));
			
			var messageVO:ChatVo = new ChatVo;
			messageVO.sedid = PackData.app.head.dwOperID.toString();
			messageVO.sedname = Global.player.realName
			messageVO.sedtime = MyUtils.getTimeFormat1();
			messageVO.mtype = 'text';
			messageVO.mtxt = newStr;
			messageVO.hasRead = true;
			messageVO.owner = true;
			messageVO.recId = vo.rstdId;
			
			//加入本地记录
			locRecord.push(messageVO);
			var idx:int = locRecord.length-1;
			locPCDealist.push(idx);
			
			return messageVO;
		}
		private function insertImgHandler(file:File):ChatVo{
			//需要先选择聊天对象
			var vo:RelListItemSpVO = perlistSp ? perlistSp.hadSelect : null;
			if(!vo)
			{
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
					[new SwitchScreenVO(ChatAlertMediator,[null,"请先选择你发送的对象哦！"],
						SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,200)]);
				return null;
			}
			
			CacheTool.put(NAME,'recId',vo.rstdId);
			CacheTool.put(NAME,'recName',vo.realName);
			
			var messageVO:ChatVo = new ChatVo();
			messageVO.sedid = PackData.app.head.dwOperID.toString();
			messageVO.sedname = Global.player.realName;
			messageVO.sedtime = MyUtils.getTimeFormat();
			messageVO.mtype = 'pic';
			messageVO.mtxt = file.name;
			messageVO.voiceState = VoiceState.loadingState;
			messageVO.minf = '';
			messageVO.hasRead = true;	
			messageVO.recId = vo.rstdId;
			//加入本地记录
			locRecord.push(messageVO);
			var idx:int = locRecord.length-1;
			locPCDealist.push(idx);
			
			sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(file,file.name,'pic',WorldConst.UP_IM_FILE,INSERT_FILE_COMPLETE));																									
			return messageVO;			
		}
		private function insertVoiceHandler(file:File,totalTime:String='0'):ChatVo{
			var vo:RelListItemSpVO = perlistSp ? perlistSp.hadSelect : null;
			if(!vo)
			{
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
					[new SwitchScreenVO(ChatAlertMediator,[null,"请先选择你发送的对象哦！"],
						SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,200)]);
				return null;
			}
			
			CacheTool.put(NAME,'recId',vo.rstdId);
			CacheTool.put(NAME,'recName',vo.realName);
			
			var messageVO:ChatVo = new ChatVo();
			messageVO.sedid = PackData.app.head.dwOperID.toString();
			messageVO.sedname = Global.player.realName;
			messageVO.sedtime = MyUtils.getTimeFormat();
			messageVO.mtype = 'voice';
			messageVO.mtxt = file.name;
			messageVO.voiceState = VoiceState.loadingState;
			messageVO.minf = totalTime;
			messageVO.hasRead = true;			
			messageVO.recId = vo.rstdId; 	
			//加入本地记录
			locRecord.push(messageVO);
			var idx:int = locRecord.length-1;
			locPCDealist.push(idx);
			
			sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(file,file.name,'voice',WorldConst.UP_IM_FILE,INSERT_FILE_COMPLETE));
			return messageVO;
		}
		
		
		private function getWordChat(_newIdx:int=0):void{
			//本地idx为0，或者新旧idx不等，则重新取记录
			if(wcIdx == 0 || wcIdx != _newIdx)
			{
				PackData.app.CmdIStr[0] = CmdStr.QRY_WORLD_MESS_AFID;
				PackData.app.CmdIStr[1] = wcIdx;
				PackData.app.CmdInCnt = 2;
				sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_WCHAT_COMPLETE,null,'cn-gb',null,SendCommandVO.QUEUE));
			}
		}
		
		private function getPerChat(num:int):void{
			if(num == 0)
			{
				view.tipSp.visible = false;
			}else if(!view.pcVoiChat.visible){
				view.tipSp.visible = true;
				view.tipsTF.text = num.toString();
			}
			
			if(num != 0 && pcIdx != num)
			{
				
				
				
				autoMoveArr = [];
				
				PackData.app.CmdIStr[0] = CmdStr.QRYUR_INS_MESS;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdInCnt = 2;
				sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_PCHAT_COMPLETE,null,'cn-gb',null,SendCommandVO.QUEUE));
			}
			
			
		}
		
//		private var wcHisId:int = 0;
//		private var getTimes:int = 1;
		private var hisWCList:Array = [];
		private function getWCHistory():void{
			
//			wcHisId -= 50*getTimes;
//			getTimes++;
			
			if(minIdx > 0){
				hisWCList.splice(0,hisWCList.length);
				
				PackData.app.CmdIStr[0] = CmdStr.QRY_WORLD_MESS_AFID_NEW;
				PackData.app.CmdIStr[1] = minIdx;
				PackData.app.CmdIStr[2] = "50";
				PackData.app.CmdInCnt = 3;
				sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_WC_HISTORY_COMPLETE,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
			}
		}
		
		private function updateWCHistory(_data:Array):void{
			//刷新世界聊天框
			for (var i:int = 0; i < hisWCList.length; i++) 
//			for (var i:int = hisWCList.length-1; i >= 0; i--) 
			{
				if((hisWCList[i] as WeixinVO).id < minIdx.toString())
				{
					WCChatVoice.addMsgItemAt(hisWCList[i] as WeixinVO, 0);
					
					minIdx = int((hisWCList[i] as WeixinVO).id);
				}
				
			}
			
		}
		
		private var hadPCidList:Array = [];
		private var hisPCList:Array = [];
		private function getPCHistory():void{
			var vo:RelListItemSpVO = perlistSp ? perlistSp.hadSelect : null;
			if(vo && hadPCidList.indexOf(vo.rstdId) == -1)
			{
				hadPCidList.push(vo.rstdId);
				hisPCList.splice(0,hisPCList.length);
				
				PackData.app.CmdIStr[0] = CmdStr.QRY_ALLINS_MESS;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = vo.rstdId;
				PackData.app.CmdIStr[3] = "0";
				PackData.app.CmdIStr[4] = "50";
				PackData.app.CmdInCnt = 5;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_PC_HISTORY_COMPLETE,null,'cn-gb',null,SendCommandVO.QUEUE));
			}
		}
		private function updatePCHistory():void{
			
			var vo:RelListItemSpVO = perlistSp ? perlistSp.hadSelect : null;
			if(vo)
			{
				for (var i:int = 0; i < hisPCList.length; i++) 
				{
					PCChatVoice.addMsgItemAt(hisPCList[i], 0);
					locRecord.push(hisPCList[i]);
				}
				/*for (var i:int = hisPCList.length-1 ; i >= 0; i--) 
				{
					PCChatVoice.addMsgItemAt(hisPCList[i], 0);
					locRecord.push(hisPCList[i]);
				}*/
				
			}
			
		}
		private function lrPcidHad(_pcid:String):Boolean{
			for (var i:int = 0; i < locRecord.length; i++) 
			{
				if((locRecord[i] is WeixinVO) && ((locRecord[i] as WeixinVO).id == _pcid))
				{
					return true;
				}
				
			}
			return false;
		}
		
		
		private function freshSearchList(data:Array):void{
			//还原
			view.searchNonTips.visible = false;
			if(searchList){
				searchList.removeFromParent(true);
			}
			
			if(data.length > 0){
				searchList = new SearchList;
				searchList.y = 207;
				searchList.width = 1111;
				searchList.height = 450;
				view.searchSp.addChild(searchList);
				
				searchList.updateData(data);
				
			}else{
				view.searchNonTips.visible = true;
				
			}
			
			
		}
		
		
		private var showPid:String = "-1";
		private var locRecord:Array = [];
		private var autoMoveArr:Array = [];
		private var cachePCList:Array = [];
		
		private function perlistClickHandle(e:Event):void{
			var clickItem:PersonListItem = e.data as PersonListItem;
			view.ptaklTitle.text = "与 "+clickItem.relatVo.realName+" 聊天中...";
			
			
			//显示不同id，则清空，并加入本地已存的记录
			if(showPid != "-1" && showPid != clickItem.relatVo.rstdId)
			{
				PCChatVoice.clearMsgItem();
				
				var lrpc:Array = lrPCHad(clickItem.relatVo.rstdId);
				for (var i:int = 0; i < lrpc.length; i++) 
				{
					PCChatVoice.addMsgItem(lrpc[i]);
				}
			}
			showPid = clickItem.relatVo.rstdId;
			
			
			var moveId:Array = [];
			//查看本地记录是否有，有则additem到窗口
			var result:Array = cachePCHadSendid(clickItem.relatVo.rstdId);
			for (i = 0; i < result.length; i++) 
			{
				PCChatVoice.addMsgItem(result[i]);
				locRecord.push(result[i]);
				
				moveId.push((result[i] as WeixinVO).id);
			}
			
			
			if(moveId.length > 0)
			{
				for (i = 0; i < moveId.length; i++) 
				{
					for (var j:int = 0; j < cachePCList.length; j++) 
					{
						if((cachePCList[j] as WeixinVO).id == moveId[i]){
							cachePCList.splice(j,1);
							pcIdx--;
							break;
						}
					}
				}
				perlistSp.remind = cachePCList;
				 
				PackData.app.CmdIStr[0] = CmdStr.MOVE_2_INSTMESSLOG;
				PackData.app.CmdIStr[1] = moveId.join(",");
				PackData.app.CmdInCnt = 2;
				sendNotification(CoreConst.SEND_11,new SendCommandVO("",null,'cn-gb',null,SendCommandVO.QUEUE));
			}
		}
		
		
		private function dealNewPChat(mesvo:WeixinVO):Boolean{
			
			//如果当前已选对象，则直接additem到窗口，不需要插入记录
			//如果不是， 判断本地记录有没有，有的话则不处理，没有则插入
			
			//需要先选择聊天对象
			var vo:RelListItemSpVO = perlistSp ? perlistSp.hadSelect : null;
			if(vo && vo.rstdId == mesvo.sedid && view.tabBar.selectedIndex == 1)
			{
				PCChatVoice.addMsgItem(mesvo);
				locRecord.push(mesvo);
				return true;
				
			}else if(!cachePCHadMess(mesvo)){
				cachePCList.push(mesvo);
				//新人，加入陌生人
				
				//addRelatMang
				var had:Boolean = false;
				for (var i:int = 0; i < relateList.length; i++) 
				{
					if((relateList[i] as RelListItemSpVO).rstdId == mesvo.sedid)
					{
						had = true;
						break;
					}
				}
				if(!had)
				{
					var _newvo:RelListItemSpVO = new RelListItemSpVO;
					_newvo.realName = mesvo.sedname;
					_newvo.rstdId = mesvo.sedid;
					_newvo.nickName = "";
					_newvo.gender = "";
					_newvo.goldNum = "";
					_newvo.sign = "";
					_newvo.relaType = "S";
					addRelatMang(_newvo);
				}
				
				
				pcIdx++;
				return false;
				
			}
			
			return false;
			
		}
		
		private function cachePCHadMess(mesvo:WeixinVO):Boolean{
			for (var i:int = 0; i < cachePCList.length; i++) 
			{
				if((cachePCList[i] as WeixinVO).id == mesvo.id)
				{
					return true;
				}
			}
			return false;
		}
		
		private function cachePCHadSendid(sendId:String):Array{
			var result:Array = [];
			for (var i:int = 0; i < cachePCList.length; i++) 
			{
				if((cachePCList[i] as WeixinVO).sedid == sendId)
				{
					result.push(cachePCList[i]);
				}
			}
			return result;
		}
		
		private function lrPCHad(sendId:String):Array{
			var result:Array = [];
			for (var i:int = 0; i < locRecord.length; i++) 
			{
				if(((locRecord[i] is ChatVo) && (locRecord[i] as ChatVo).recId == sendId) ||
					((locRecord[i] is WeixinVO) && ((locRecord[i] as WeixinVO).sedid == sendId)))
				{
					result.push(locRecord[i]);
				}
				
			}
			result.sort(sortLrPc);
			return result;
		}
		private function sortLrPc(_a:WeixinVO,_b:WeixinVO):int{
			var aid:int = int(_a.id);
			var bid:int = int(_b.id);
			
			if(aid > bid) {
				return 1;
			} else if(aid < bid) {
				return -1;
			} else {
				return 0;
			}
		}
		
		private function autoMove():void{
			if(autoMoveArr.length > 0)
			{
				PackData.app.CmdIStr[0] = CmdStr.MOVE_2_INSTMESSLOG;
				PackData.app.CmdIStr[1] = autoMoveArr.join(",");
				PackData.app.CmdInCnt = 2;
				sendNotification(CoreConst.SEND_11,new SendCommandVO("",null,'cn-gb',null,SendCommandVO.QUEUE));
			}
			autoMoveArr = [];
		}
		
		private function hadRelatInf(_id:int):Boolean{
			for (var i:int = 0; i < relateList.length; i++) 
			{
				if((relateList[i] as RelListItemSpVO).rstdId == _id.toString())
				{
					return true;
				}
			}
			return false;
		}
		
		private function delRelatItem(friVo:RelListItemSpVO):void{
			for (var i:int = 0; i < relateList.length; i++) 
			{
				if((relateList[i] as RelListItemSpVO).rstdId == friVo.rstdId)
				{
					relateList.splice(i,1);
					break;
				}
			}
		}
		private function addRelatMang(newVo:RelListItemSpVO, _justAdd:Boolean=false):void{
			//本地已存在，则是分组转移，否则是新加好友
			
			if(_justAdd)
			{
				relateList.push(newVo);
				perlistSp.updateVo(newVo,true);
				return;
			}
			
			for (var i:int = 0; i < relateList.length; i++) 
			{
				if((relateList[i] as RelListItemSpVO).rstdId == newVo.rstdId)
				{
					var oldVo:RelListItemSpVO = relateList[i] as RelListItemSpVO;
					perlistSp.updateVo(oldVo,false);
					
					(relateList[i] as RelListItemSpVO).relaType = newVo.relaType;
					perlistSp.updateVo(newVo,true);
					
					
					return;
				}
			}
			
			relateList.push(newVo);
			perlistSp.updateVo(newVo,true);
		}
		
		//设置好友上线/下线
		private var locOnList:Dictionary = new Dictionary;
		private function setOnOnline(_list:String):void{
			for(var i:String in locOnList){
				locOnList[i] = false;
				
			}
			
			var list:Array = _list.split(",");
			for (var j:int = 0; j < list.length; j++) 
			{
				var had:Boolean = false;
				for(var k:String in locOnList){
					if(k == list[j])
					{
						locOnList[k] = true;
						had = true;
						break;
					}
				}
				//如果本地没有，则新添加
				if(!had)
				{
					locOnList[list[j]] = true;
				}
				
			}
			
			var onArr:Array = [];
			var offArr:Array = [];
			for(var p:String in locOnList) 
			{
				if(!locOnList[p]){
					trace(p+"下线");
					
					offArr.push(p);
					delete locOnList[p];
				}else{
					onArr.push(p);
				}
			}
			
			perlistSp.setOnOff(onArr, offArr);
		}
		
		private var applyChaVo:CharaterInfoVO;
		
		private var per:Number=0;
		private var minIdx:int = 0;
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case WorldConst.BROADCAST_ISLAND:
				case WorldConst.BROADCAST_CHATROOM:
					if(isRegisted)
					{
						getWordChat(PackData.app.CmdOStr[2]);
						per = getTimer();
						getPerChat(PackData.app.CmdOStr[1]);
					}
					break;
				case WorldConst.BROADCAST_ONLINE:
					
					var now:Number = getTimer()-per;
					
					setOnOnline(PackData.app.CmdOStr[1]);
					break;
				
				case GET_WCHAT_COMPLETE:
					//取回聊天记录
					if(!result.isEnd){
						var messId:int = PackData.app.CmdOStr[1];
						if(messId > wcIdx)
						{
							wcIdx = messId;
//							wcHisId = wcIdx;
						}
						if(minIdx == 0){
							
							minIdx = messId;
							
						}else if(minIdx > messId){
							minIdx = messId;
						}
						
						if(!isFirst && PackData.app.CmdOStr[2] == PackData.app.head.dwOperID.toString())
						{
							break;
						}
						
						
						var mesVo:WeixinVO = new WeixinVO();
						mesVo.sedid = PackData.app.CmdOStr[2];
						mesVo.sedname = PackData.app.CmdOStr[3];
						mesVo.sedtime = getTimeFromat(PackData.app.CmdOStr[4]);
						mesVo.mtype = 'text';
						mesVo.mtxt = PackData.app.CmdOStr[5];
						mesVo.hasRead = true;
						mesVo.owner = mesVo.sedid==PackData.app.head.dwOperID.toString() ? true:false;
						
						
						WCChatVoice.addMsgItem(mesVo);
						//更新岛上人物聊天
						sendNotification(WorldConst.UPDATE_CHARATER_STATE,
							new CharaterStateVO(mesVo.sedid,"",null,mesVo.mtxt,"","set5,face_face1"));
					}else{
						isFirst = false;
						
					}
					break;
				case GET_PCHAT_COMPLETE:
					//接收私信
					if(!result.isEnd){
						mesVo = new WeixinVO();
						mesVo.id = PackData.app.CmdOStr[1];
						mesVo.sedid = PackData.app.CmdOStr[2];
						mesVo.sedname = PackData.app.CmdOStr[3];
						mesVo.sedtime = getTimeFromat(PackData.app.CmdOStr[6]);
						mesVo.mtype = PackData.app.CmdOStr[7];
						mesVo.mtxt = PackData.app.CmdOStr[8];
						mesVo.hasRead = true;
						mesVo.owner = false;
						
						if(dealNewPChat(mesVo))
						{
							autoMoveArr.push(mesVo.id);
						}
					}else{
						//设置提醒
						perlistSp.remind = cachePCList;
						autoMove();
					}
					
					
					break;
				
				case GET_RELATE_LIST:
					if(!result.isEnd){
						var vo:RelListItemSpVO = new RelListItemSpVO();
						vo.userId = PackData.app.CmdOStr[1];
						vo.rstdId = PackData.app.CmdOStr[2];
						vo.rstdCode = PackData.app.CmdOStr[3];
						vo.realName = PackData.app.CmdOStr[4];
						vo.relaType = PackData.app.CmdOStr[5];
						vo.nickName = PackData.app.CmdOStr[7];
						vo.gender = PackData.app.CmdOStr[8];
						vo.goldNum = PackData.app.CmdOStr[9];
						vo.birth = PackData.app.CmdOStr[10];
						vo.school = PackData.app.CmdOStr[11];
						vo.sign = PackData.app.CmdOStr[12];
						
						relateList.push(vo);
						
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
						
					}
					
					break;
				case SEARCH_STUDENT:
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
						
						searchArr.push(_searVo);
					}else{
						freshSearchList(searchArr);
					}
					
					break;
				case APPLY_ADD_RELATE:
					applyChaVo = notification.getBody() as CharaterInfoVO;
					applyChaVo.reltVo.relaType = "F";
					
					PackData.app.CmdIStr[0] = CmdStr.INSERT_STD_RELAT;
					PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = applyChaVo.reltVo.rstdId;
					PackData.app.CmdIStr[3] = "F";
					PackData.app.CmdInCnt = 4;
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,
						new SendCommandVO(INSERT_STD_RELATE,null,"cn-gb",null,SendCommandVO.QUEUE));
					
					break;
				case INSERT_STD_RELATE:
					if(PackData.app.CmdOStr[0] == "0M1"){
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
							[new SwitchScreenVO(ChatAlertMediator,[null,"已经是你的好友了哦。"],
								SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
							[new SwitchScreenVO(ChatAlertMediator,[null,"成功添加好友！"],
								SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
						Facade.getInstance(CoreConst.CORE).sendNotification(CharaterInfoMediator.UPDATE_MY_RELATE,applyChaVo);
					}
					
					break;
				case CharaterInfoMediator.UPDATE_MY_RELATE:
					//新增、删除好友，刷新好友列表、查询列表
					var infoVo:CharaterInfoVO = notification.getBody() as CharaterInfoVO;
					if(infoVo.sign == 1)
					{
						//本来已经有该vo，则是分组管理的操作
						addRelatMang(infoVo.reltVo);
						
					}else{
						delRelatItem(infoVo.reltVo);
						perlistSp.updateVo(infoVo.reltVo,false);
						perlistSp.clearSelct();
						view.ptaklTitle.text = "";
						
					}
					break;
				case INSERT_FILE_COMPLETE:
					
					var wPath:String = PackData.app.CmdOStr[4];			
					Facade.getInstance(PCChatVoice.core).sendNotification(SpeechConst.FILE_DOWNCOMPLETE_STATE,wPath);
					
					var idx:int = locPCDealist.shift();
					var __tmp:Object = locRecord[idx];
					if(__tmp is ChatVo)
					{
						(__tmp as ChatVo).id = PackData.app.CmdOStr[5];	
					}
					
					
					break;
				case INSERT_PC_COMPLETE:
					if(!result.isErr)
					{
						idx = locPCDealist.shift();
						__tmp = locRecord[idx];
						if(__tmp is ChatVo)
						{
							(__tmp as ChatVo).id = PackData.app.CmdOStr[1];	
						}
						
					}
					
					break;
				case SEL_TASK_STATUS:
					
					if(!result.isErr){
						
						var _status:String = PackData.app.CmdOStr[1];
						
						if(_status == "Y")
							canTalk = true;
						else
							canTalk = false;
						
						
						getRelateList();
						
					}else{
						canTalk = true;
						
						//出错了，直接允许进入娱乐岛
						getRelateList();
					}
					break;
				case QRY_WC_HISTORY_COMPLETE:
					//取回公众聊天历史记录
					if(!result.isEnd){
						messId = PackData.app.CmdOStr[1];
						
						
						
						
						mesVo = new WeixinVO();
						mesVo.id = PackData.app.CmdOStr[1];
						mesVo.sedid = PackData.app.CmdOStr[2];
						mesVo.sedname = PackData.app.CmdOStr[3];
						mesVo.sedtime = getTimeFromat(PackData.app.CmdOStr[4]);
						mesVo.mtype = 'text';
						mesVo.mtxt = PackData.app.CmdOStr[5];
						mesVo.hasRead = true;
						mesVo.owner = mesVo.sedid==PackData.app.head.dwOperID.toString() ? true:false;
						hisWCList.push(mesVo);
						
					}else{
						updateWCHistory(hisWCList);
						
					}
					
					break;
				case SpeechConst.USER_LABEL_CLICK:
					var uservo:WeixinVO = notification.getBody() as WeixinVO;
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
						[new SwitchScreenVO(CharaterInfoMediator,new CharaterInfoVO(null,uservo.sedid,"-1",1),
							SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
					
					break;
				case QRY_PC_HISTORY_COMPLETE:
					//取回私人聊天历史记录
					if(!result.isEnd){
						//本地没有，则插入记录
						if(!lrPcidHad(PackData.app.CmdOStr[1]))
						{
							var _pcvo:ChatVo = new ChatVo();
							_pcvo.id = PackData.app.CmdOStr[1];
							_pcvo.sedid = PackData.app.CmdOStr[2];
							_pcvo.sedname = PackData.app.CmdOStr[3];
							_pcvo.recId = PackData.app.CmdOStr[4];
							_pcvo.sedtime = getTimeFromat(PackData.app.CmdOStr[6]);
							_pcvo.mtype = PackData.app.CmdOStr[7];
							_pcvo.mtxt = PackData.app.CmdOStr[8];
							_pcvo.hasRead = true;
							_pcvo.owner = _pcvo.sedid==PackData.app.head.dwOperID.toString() ? true:false;
							hisPCList.push(_pcvo);
							
						}
						
					}else{
						updatePCHistory();
					}
					
					break;
				
			}
		}
		override public function listNotificationInterests():Array
		{
			return [WorldConst.BROADCAST_ISLAND,WorldConst.BROADCAST_CHATROOM,WorldConst.BROADCAST_ONLINE,GET_RELATE_LIST,
				SEARCH_STUDENT,INSERT_STD_RELATE,CharaterInfoMediator.UPDATE_MY_RELATE,GET_WCHAT_COMPLETE,
				GET_PCHAT_COMPLETE,INSERT_FILE_COMPLETE,APPLY_ADD_RELATE,SEL_TASK_STATUS,QRY_WC_HISTORY_COMPLETE,
				SpeechConst.USER_LABEL_CLICK,QRY_PC_HISTORY_COMPLETE,INSERT_PC_COMPLETE];
		}
		
		
		private function perInfoBtnHandle():void{
			var vo:RelListItemSpVO = perlistSp ? perlistSp.hadSelect : null;
			if(vo)
			{
				var oper:int = vo.relaType == "F" ? 0 : 1;
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
					[new SwitchScreenVO(CharaterInfoMediator,new CharaterInfoVO(vo,null,null,oper),
						SwitchScreenType.SHOW,AppLayoutUtils.uiLayer,640,381)]);
			}
			//OnlineControlMediator
		}
		
		//取好友列表
		private function getRelateList():void{
			PackData.app.CmdIStr[0] = CmdStr.QRY_STD_RELATLIST;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(GET_RELATE_LIST,null,"cn-gb",null,SendCommandVO.QUEUE));
		}
		
		private function searchHandle(e:Event):void{
			var searchStr:String = e.data as String;
			
			if(StringUtil.trim(searchStr) == "")
				return;
			
			searchArr = [];
			
			var searArr:Array = new Array("*","*","*","*","*");
			searArr[getSearchIdx()] = searchStr;
			PackData.app.CmdIStr[0] = CmdStr.SEARCH_STUDENT;
			PackData.app.CmdIStr[1] = searArr[0];	//id
			PackData.app.CmdIStr[2] = searArr[1];	//登陆账号
			PackData.app.CmdIStr[3] = searArr[2];	//昵称
			PackData.app.CmdIStr[4] = searArr[3];	//真实姓名
			PackData.app.CmdIStr[5] = searArr[4];	//学校
			PackData.app.CmdInCnt = 6;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(SEARCH_STUDENT,null,"cn-gb",null,SendCommandVO.QUEUE|SendCommandVO.SCREEN));
			
		}
		private function getSearchIdx():int{
			if(view.search.searchTopic == "nameBtn"){
				return 3;
			}else if(view.search.searchTopic == "idBtn"){
				return 0;
			}else if(view.search.searchTopic == "schoolBtn"){
				return 4;
			}
			return 2;
		}
		
		//20130821-153445   ->   2013-08-21 15:34:45
		private function getTimeFromat(_time:String):String{
			
			var __time:String = 
				_time.substr(0,4) + "-"+
				_time.substr(4,2) + "-"+
				_time.substr(6,2) + " "+
				_time.substr(9,2) + ":"+
				_time.substr(11,2) + ":"+
				_time.substr(13,2);
			
			
			return __time;
		}
		
		//检查是否完成任务，判断能否聊天
		private function checkTaskState():void{
			
			PackData.app.CmdIStr[0] = CmdStr.SEL_TASK_STATUS;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(SEL_TASK_STATUS,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));//否则下载过程进入会重复点击报错
			
		}
		
		
		private function keybackHandle(event:KeyboardEvent):void
		{
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
				event.preventDefault();
				event.stopImmediatePropagation();
				
				vo.type = SwitchScreenType.HIDE;
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[vo]);
				
			}
		}
		
		public function get view():ChatRoomView{
			return getViewComponent() as ChatRoomView;
		}
		override public function get viewClass():Class
		{
			return ChatRoomView;
		}
		override public function onRemove():void{
			super.onRemove();
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN,keybackHandle);
			
//			sendNotification(WorldConst.ENABLE_WORLD_BACK);
			
			
			facade.removeProxy(ChatRoomOLProxy.NAME);
			facade.removeProxy(ChatRoomFilterProxy.NAME);
			
			
			CacheTool.clr(NAME,'recId');
			CacheTool.clr(NAME,'recName');
			
			
			
			
			view.removeChildren(0,-1,true);
		}
	}
}