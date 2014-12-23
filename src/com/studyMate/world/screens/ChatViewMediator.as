package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.ICharater;
	import com.mylib.game.charater.TalkingProxy;
	import com.mylib.game.controller.MutiSpeechMediator;
	import com.mylib.game.controller.MutiWSpeakMediator;
	import com.mylib.game.controller.vo.PChatInfoVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.BitmapFontUtils;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.component.sysface.ScrollTextExtends;
	import com.studyMate.world.component.sysface.SysFacePanelMediator;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.controller.vo.RemindPriMessVO;
	import com.studyMate.world.controller.vo.SendSimSimiMessageCommandVO;
	import com.studyMate.world.model.MyCharaterInforMediator;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.component.ChatFriendList;
	import com.studyMate.world.screens.component.ChatViewBmpProxy;
	import com.studyMate.world.screens.component.ChatViewlSimpleBtn;
	import com.studyMate.world.screens.component.MainChatCpuScroller;
	import com.studyMate.world.screens.component.MutiChoseBox;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import mx.utils.StringUtil;
	
	import de.polygonal.ds.HashMap;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ChatViewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ChatViewMediator";
		public static const CHANGE_CHANEL:String = NAME + "ChangeChanel";
		public static const SHOW_FRIEND_CHAT:String = NAME + "ShowFriendChat";
		public static const UPDATE_FIREND_LIST:String = NAME + "UpdateFriendList";

		private static const IN_WORLD_MESS_COMPLETE:String = NAME + "InWordMessComplete";
		private static const INUP_INSTANT_MESS_COMPLETE:String = NAME + "InupInstantMessComplete";
		private static const MOVE_2_INSTMESSLOG_COMPLETE:String = NAME + "Move2InstmesslogComplete";
		private static const QRY_ALLINS_MESS_COMPLETE:String = NAME + "QryAllinsMessComplete";

		private var relListItemSpVoList:Vector.<RelListItemSpVO>;
		private var cwSp:Sprite = new Sprite;
		private var wchatTF:ScrollTextExtends;
		private var isShowMain:Boolean;	//聊天面板显示状态
		private var mainChatSp:Sprite = new Sprite;	//聊天面板
		private var textInput:TextFieldHasKeyboard;
		private var chatFriList:ChatFriendList;	//好友列表面板
		private var chatStyle:String = "";
		private var talkProxy:TalkingProxy;
		private var currentFriId:String = "";
		private var captain:ICharater;
		
		private var mutiChoseBox:MutiChoseBox;
		private var speechView:SpeechChatView;	//语音界面
		private var talkTimes:int = 3; //说话次数，防刷屏
		private var canTalk:Boolean = true;	//是否可以使用聊天
		public function ChatViewMediator(_relListItemSpVoList:Vector.<RelListItemSpVO>,_canTalk:Boolean,viewComponent:Object=null)
		{
			relListItemSpVoList = _relListItemSpVoList;
			canTalk = _canTalk;
			
			super(NAME, new Sprite);
		}
		override public function onRegister():void
		{
			captain = (facade.retrieveMediator(MyCharaterInforMediator.NAME) as MyCharaterInforMediator).playerCharater;

			initBitmapFont();
			
			createMainChatSp();
		}
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case CHANGE_CHANEL:
					mainChatScroller.visible = false;
					
					chatStyle = notification.getBody() as String;
					
					if(chatStyle != "WC")
						isShowMain = false;
					if(chatStyle != "PC"){
						getChatScroll("PC").removeUI();
//						chatFriList.clickItemByIdx(-1);
						chatFriList.clickItem(null);
						currentFriId = "";
						
					}
					
					if(chatStyle == "WC" || chatStyle == "PC")
						getHisBtn.visible = true;
					else
						getHisBtn.visible = false;
					
					mainChatScroller = getChatScroll(chatStyle);
					getChatScroll(chatStyle).visible = true;
					
					break;
				case IN_WORLD_MESS_COMPLETE:
					if(!result.isErr){
						trace("发送成功..");
						
					}
					
					break;
				case WorldConst.REC_SIMSIMI_MSG:
					
					var idx:int=0;
					var sentence:String = notification.getBody() as String;
					var i:int=0;
					var oldIdx:int;
					var nextStr:String;
					TweenLite.killTweensOf(talkProxy.npcSay);
					while(idx<sentence.length){
						
						oldIdx = idx;
						idx+=15;
						
						if(idx<sentence.length){
							nextStr = sentence.substr(oldIdx,15);
						}else{
							nextStr = sentence.substring(oldIdx);
						}
						
						TweenLite.delayedCall(i*4,talkProxy.npcSay,[nextStr]);
						i++;
						
						
					}
					if(sentence.length > 0){
						
						getChatScroll("AC").setOtherChat("npc",getNowTime(),sentence);
					}
					break;
				
				case INUP_INSTANT_MESS_COMPLETE:
					if(!result.isErr){
						
						if(chatFriList && chatFriList.currentItem){
							var _pchatVO:PChatInfoVO = new PChatInfoVO(PackData.app.CmdOStr[1],
								PackData.app.head.dwOperID.toString(),Global.player.realName,
								chatFriList.currentItem.relList.rstdId,chatFriList.currentItem.relList.realName,
								getNowTime(),"text",nowTextInput);
							locRecordList.push(_pchatVO);
						}
						nowTextInput = "";
					}
					
					
					break;
				case SHOW_FRIEND_CHAT:
					var _id:String = notification.getBody() as String;
					currentFriId = _id;
					
					getChatScroll("PC").removeUI();
					
					setMainChatByFri(_id);
					
					break;
				case MOVE_2_INSTMESSLOG_COMPLETE:
					
					if(!result.isErr){
						
						//本地内存更新
						for(var j:int=0;j<readIdArr.length;j++){
							
							
							for(var k:int=0;k<locChatList.length;k++){
								
								//有该记录，转移到本地record
								if(locChatList[k].id == readIdArr[j]){
									
									locRecordList.push(locChatList[k]);
									locChatList.splice(k,1);
									break;
									
									
								}
							}
						}
						
						readIdArr.splice(0,readIdArr.length);
					}
					
					break;
				case QRY_ALLINS_MESS_COMPLETE:
					
					
					if(!result.isEnd){
						
						
						var pchatVO:PChatInfoVO = new PChatInfoVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],
							PackData.app.CmdOStr[3],PackData.app.CmdOStr[4],
							PackData.app.CmdOStr[5],PackData.app.CmdOStr[6],
							PackData.app.CmdOStr[7],PackData.app.CmdOStr[8]);
						
						historyList.push(pchatVO);
						
						
						
					}else{
						if(historyList.length > 0){
							
							for(var p:int=0;p<historyList.length;p++){
								if(!hasLocRecord(historyList[p]))
									locRecordList.push(historyList[p]);
							}
							
							
							getChatScroll("PC").removeUI();
							setMainChatByFri(currentFriId);
							getChatScroll("PC").resetPos();
							
						}
					}
					break;
				case WorldConst.MUTI_CHOSE_REMIND:
					
					var _visibel:Boolean = notification.getBody() as Boolean;
					//多选框显示，缩小聊天区域
					if(_visibel){
						TweenLite.to(getChatScroll("PC").scroll,0.3,{height:250});
						TweenLite.to(getChatScroll("WC").scroll,0.3,{height:250});
						TweenLite.to(getChatScroll("AC").scroll,0.3,{height:250});
						
						
						
					}else{
						TweenLite.to(getChatScroll("PC").scroll,0.3,{height:300});
						TweenLite.to(getChatScroll("WC").scroll,0.3,{height:300});
						TweenLite.to(getChatScroll("AC").scroll,0.3,{height:300});
					}
					
					
					
					break;
				case UPDATE_FIREND_LIST:
					if(!result.isErr){
						sendNotification(WorldConst.ALERT_SHOW,new AlertVo("温馨提示：好友成功添加，请回退并重新进入小岛才能发私信哦。",false,"",""));
					}
					
					
					break;
				case MutiSpeechMediator.UPLOAD_SPEECH_COMPLETE:
					sendNotification(WorldConst.MUTICONTROL_START);
					break;
				case MutiSpeechMediator.SPEECH_DOWN_COMPLETE:
					sendNotification(WorldConst.MUTICONTROL_START);
					break;
				case SpeechChatView.HIDE_SPEECH_VIEW:
					textInput.visible = true;
					break;
			}
		}
		override public function listNotificationInterests():Array
		{
			return [IN_WORLD_MESS_COMPLETE,CHANGE_CHANEL,WorldConst.REC_SIMSIMI_MSG,
				MOVE_2_INSTMESSLOG_COMPLETE,SHOW_FRIEND_CHAT,QRY_ALLINS_MESS_COMPLETE,INUP_INSTANT_MESS_COMPLETE,
				WorldConst.MUTI_CHOSE_REMIND,UPDATE_FIREND_LIST,SpeechChatView.HIDE_SPEECH_VIEW,
				MutiSpeechMediator.UPLOAD_SPEECH_COMPLETE,MutiSpeechMediator.SPEECH_DOWN_COMPLETE];
		}
		//初始化位图字体
		private function initBitmapFont():void{
			
			var nameStr:String = "";
			for(var i:int=0;i<relListItemSpVoList.length;i++)
				nameStr += relListItemSpVoList[i].realName;
			
			if(nameStr != ""){
				BitmapFontUtils.dispose();
				
				nameStr += ".0123456789";
				
				var assets:Vector.<flash.display.DisplayObject> = new Vector.<flash.display.DisplayObject>;
				var bmp:Bitmap = Assets.getTextureAtlasBMP(Assets.store["ChatViewTexture"],Assets.store["ChatViewXML"],"friItemBg");
				bmp.name = "friItemBg";
				assets.push(bmp);
				bmp = Assets.getTextureAtlasBMP(Assets.store["ChatViewTexture"],Assets.store["ChatViewXML"],"firMessNum");
				bmp.name = "firMessNum";
				assets.push(bmp);
				bmp = Assets.getTextureAtlasBMP(Assets.store["ChatViewTexture"],Assets.store["ChatViewXML"],"friIconF");
				bmp.name = "friIconF";
				assets.push(bmp);
				
				var tf:TextFormat = new TextFormat('HeiTi',14);
				tf.letterSpacing = -1;
				BitmapFontUtils.init(nameStr,assets,tf);
			}
			
			
		}
		
		//初始化聊天面板
		private function createMainChatSp():void{

			var bg:Image = new Image(Assets.getTexture("chatViewBg"));
			mainChatSp.addChild(bg);
			
			var EnTf:TextFormat = new TextFormat("HeiTi",25,0);
			textInput = new TextFieldHasKeyboard();
			textInput.defaultTextFormat = EnTf;
			textInput.visible = false;
			textInput.x = 386;
			textInput.y = 400;
//			textInput.border = true;
			textInput.height = 50;
			textInput.width = 560;
			textInput.maxChars = 33;
			AppLayoutUtils.cpuLayer.addChild(textInput);
			textInput.addEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
			
			var sendBtn:starling.display.Button = new starling.display.Button(Assets.getChatViewTexture("sendBtn"));
			sendBtn.x = 600;
			sendBtn.y = 392;
			mainChatSp.addChild(sendBtn);
			sendBtn.addEventListener(Event.TRIGGERED,sendBtnHandle);
			
			
			//关闭按钮
			var closeBtn:starling.display.Button = new starling.display.Button(Assets.getChatViewTexture("closeBtn"));
			closeBtn.x = 657;
			closeBtn.y = -18;
			mainChatSp.addChild(closeBtn);
			closeBtn.addEventListener(Event.TRIGGERED,closeBtnHandle);
			
			//好友列表
			chatFriList = new ChatFriendList(relListItemSpVoList);
			chatFriList.x = 315;
			chatFriList.y = 17;
			AppLayoutUtils.uiLayer.addChild(chatFriList);
			chatFriList.visible = false;
			
			//主聊天面板
			mainChatSp.x = 360;
			mainChatSp.y = 15;
			AppLayoutUtils.uiLayer.addChild(mainChatSp);
			mainChatSp.visible = false;
			isShowMain = false;

			//频道多选框
			mutiChoseBox = new MutiChoseBox();
			mutiChoseBox.x = 15;
			mutiChoseBox.y = 298;
			mainChatSp.addChild(mutiChoseBox);
	
			var inputTypeBtn:ChatViewlSimpleBtn = new ChatViewlSimpleBtn(true,Assets.getChatViewTexture("keyborad2Btn"),Assets.getChatViewTexture("keyborad1Btn"));
			inputTypeBtn.x = mutiChoseBox.x+mutiChoseBox.width;
			inputTypeBtn.y = 348;
			mainChatSp.addChild(inputTypeBtn);
			inputTypeBtn.addBtnListener(Event.TRIGGERED,changInputHandler);
			
			var expresionBtn:ChatViewlSimpleBtn = new ChatViewlSimpleBtn(false,Assets.getChatViewTexture("expresionBtn"));
			expresionBtn.x = inputTypeBtn.x+inputTypeBtn.width;
			expresionBtn.y = 348;
			mainChatSp.addChild(expresionBtn);
			expresionBtn.addBtnListener(Event.TRIGGERED,showExpresionSp);
			
			var speechBtn:ChatViewlSimpleBtn = new ChatViewlSimpleBtn(false,Assets.getChatViewTexture("speechBtn"));
			speechBtn.x = expresionBtn.x+expresionBtn.width;
			speechBtn.y = 348;
			mainChatSp.addChild(speechBtn);
			speechBtn.addBtnListener(Event.TRIGGERED,speechBtnHandle);
	
			
			//初始化聊天内容出面板
			setMainChat();
			
			
			//语音背景
			speechView = new SpeechChatView;
			speechView.visible = false;
			Starling.current.nativeOverlay.addChild(speechView);
		}
		

		private function changInputHandler():void
		{
			if(textInput.useKeyboard){
				textInput.useKeyboard = false;
				textInput.needsSoftKeyboard = true;	
				textInput.requestSoftKeyboard();
				textInput.setFocus();;
			}else{
				textInput.useKeyboard = true;
				textInput.needsSoftKeyboard = false;		
				textInput.setFocus();
			}
		}
		private function showExpresionSp():void{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SysFacePanelMediator,textInput,SwitchScreenType.SHOW,Global.stage,textInput.x,textInput.y-236)]);
		}
		private function speechBtnHandle(e:Event):void{
			
			//没完成任务，不能语音
			if(!canTalk){
				//如果是向客服私聊，则允许
				if(chatStyle != "PC" || !chatFriList.currentItem || chatFriList.currentItem.relList.relaType != "K"){
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("你今天还没完成任务哦，请完成任务再来说说吧...(*^__^*) ",false,"",""));
					
					textInput.text = "";
					return;
					
				}
			}
			
			if(chatFriList.currentItem){			
				sendNotification(WorldConst.SET_MODAL,true);
				
//				speechView.visible = true;
				speechView.enterSpeech(chatFriList.currentItem.relList.rstdId,chatFriList.currentItem.relList.realName);
				
				
				textInput.visible = false;
			}else{
				sendNotification(WorldConst.ALERT_SHOW,new AlertVo("请先选择一位好友.",false,"",""));
			}
			

		}
		
		private var scrollMap:HashMap = new HashMap;	//缓存3个聊天窗口
		private var mainChatScroller:MainChatCpuScroller;
		private var getHisBtn:starling.display.Button;
		private function setMainChat():void{
			
			getHisBtn = new starling.display.Button(Assets.getChatViewTexture("historyBtn"));
			getHisBtn.x = (mainChatSp.width-getHisBtn.width)>>1;
			getHisBtn.y = 15;
			getHisBtn.visible = false;
			mainChatSp.addChild(getHisBtn);
			getHisBtn.addEventListener(Event.TRIGGERED,getHisBtnHandle);
			

			
			var scroll:MainChatCpuScroller = new MainChatCpuScroller(mainChatSp.x,mainChatSp.y+45,670,300);
			AppLayoutUtils.cpuLayer.addChild(scroll);
			scroll.visible = false;
			scrollMap.insert("WC",scroll);
			
			scroll = new MainChatCpuScroller(mainChatSp.x,mainChatSp.y+45,670,300);
			AppLayoutUtils.cpuLayer.addChild(scroll);
			scroll.visible = false;
			scrollMap.insert("PC",scroll);
			
			scroll = new MainChatCpuScroller(mainChatSp.x,mainChatSp.y+45,670,300);
			AppLayoutUtils.cpuLayer.addChild(scroll);
			scroll.visible = false;
			scrollMap.insert("AC",scroll);
			
			mainChatScroller = scrollMap.find("WC");
			
			talkProxy = facade.retrieveProxy(TalkingProxy.NAME) as TalkingProxy;
		}
		
		public function getChatScroll(_chanel:String):MainChatCpuScroller{
			
			return scrollMap.find(_chanel) as MainChatCpuScroller;
			
		}
		
/**	主窗口模块	***************************************************************************************/			
		//输入框，回车
		private function inputHandle(e:KeyboardEvent = null):void{
			if(e.keyCode == Keyboard.ENTER){
				
				sendBtnHandle(null);
			}
			
		}
		
		
		private var nowTextInput:String = "";
		//点击"发送"按钮
		private function sendBtnHandle(e:Event):void{
			if(StringUtil.trim(textInput.text) == "")
				return;
			
			//没完成任务，不能聊天
			if(!canTalk){
				//如果是向客服私聊，则允许
				
				if(chatStyle != "PC" || !chatFriList.currentItem || chatFriList.currentItem.relList.relaType != "K"){
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("你今天还没完成任务哦，请完成任务再来说说吧...(*^__^*) ",false,"",""));
					
					textInput.text = "";
					return;
					
				}
			}
			
			
			//广播
			if(chatStyle == "WC"){
				//有发言次数，才能发言
				if(talkTimes > 0){
					talkTimes--;
					TweenLite.killTweensOf(updateTimes);
					
					if(talkTimes == 0){
						//刷屏，导致次数为0 ,惩罚至9秒加会次数1
						TweenLite.delayedCall(6,updateTimes);
						
					}else
						TweenLite.delayedCall(3,updateTimes);
					
					sendWC2Server(textInput.text);
					
					setWChatText("我  ： " +textInput.text);
					getChatScroll("WC").setMyChat(getNowTime(),textInput.text);
					
					
					talkProxy.playerSay(captain,textInput.text);
				}else
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("您说得太快了，歇会，有话慢慢说...(*^__^*) ",false,"",""));
				
				
			}else if(chatStyle == "PC"){
				//私聊
				
				if(chatFriList.currentItem){
					getChatScroll("PC").setMyChat(getNowTime(),textInput.text);
					
					sendPC2Server(chatFriList.currentItem.relList.rstdId,chatFriList.currentItem.relList.realName,textInput.text);
					
					nowTextInput = textInput.text;
					
				}else
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("请先选择一位好友.",false,"",""));
				
				//NPC对话
			}else if(chatStyle == "AC"){
				if(talkProxy.npc != null){
					
					
					getChatScroll("AC").setMyChat(getNowTime(),textInput.text);
					
					talkProxy.playerSay(captain,textInput.text);
					
					sendNotification(WorldConst.SEND_SIMSIMI_MSG,new SendSimSimiMessageCommandVO(textInput.text));
				}else{
					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("请先选中一位人物。",false,"",""));
				}
			}
			
			textInput.text = "";
			
		}
		
		private function updateTimes():void{
			
			if(talkTimes < 3 && talkTimes >= 0){
				talkTimes++;
				
				if(talkTimes != 3)
					TweenLite.delayedCall(3,updateTimes);
				
			}
		}
		
		
		
/**	广播模块	***************************************************************************************/
		//广播聊天记录
		private var wcRecordStr:String="";
		//左下角聊天显示框
		public function createWorldChatSp():void{
			view.addChild(cwSp);
			
			var cwbg:Image = new Image(Assets.getChatViewTexture("worldChatBg"));
//			cwSp.addChild(cwbg);
			
			cwSp.y = 735 - cwSp.height;
			
			
			//滚动字幕
			wchatTF= new ScrollTextExtends();
			wchatTF.width = 220;
			wchatTF.height = 100;
			wchatTF.x = 14;
			wchatTF.y = 12;
			wchatTF.verticalScrollPosition = -30;
			wchatTF.embedFonts = true;
			wchatTF.textFormat = new TextFormat("HeiTi",14, 0x3a2002);
			cwSp.addChild(wchatTF);
			
			
			cwSp.addEventListener(TouchEvent.TOUCH,cwSpHandle);
		}
		//设置广播面板
		public function setWChatText(_str:String):void{
//			trace(_str);
			wcRecordStr += "\n\n"+_str;
			
//			wchatTF.text = wcRecordStr;
			
			
			if(wcRecordStr.length>500){
				wcRecordStr = wcRecordStr.substring(wcRecordStr.indexOf("\n\n")+1);
			}else
				wchatTF.verticalScrollPosition += 20;
			
			wchatTF.scrollToPageIndex(0,wchatTF.verticalScrollPosition+1,1);
			
			wchatTF.text = wcRecordStr;
			
		}
		//广播后台发送
		private function sendWC2Server(_wcStr:String):void{
			TweenLite.killTweensOf(sendWC2Server);
			if(Global.isLoading){
				TweenLite.delayedCall(2,sendWC2Server,[_wcStr]);
				return;
			}
			
			PackData.app.CmdIStr[0] = CmdStr.IN_WORLD_MESS;
			PackData.app.CmdIStr[1] = 0;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[3] = Global.player.realName;
			PackData.app.CmdIStr[4] = _wcStr;	//聊天内容
			PackData.app.CmdInCnt = 5;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(IN_WORLD_MESS_COMPLETE));
			
		}
		private var beginY:Number;
		private var endY:Number;
		//点击广播窗口
		private function cwSpHandle(event:TouchEvent):void{
			
			var touchPoint:Touch = event.getTouch(event.target as starling.display.DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginY = touchPoint.globalY;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endY = touchPoint.globalY;
					if(Math.abs(endY-beginY) < 10){
						
						chatFriList.clickItem(null);
						
						showMainChat(!isShowMain,"WC");

//						isShowMain = !isShowMain;
					}
				}
			}
		}
		
		
/**	私聊模块	***************************************************************************************/	
		
		public var locRecordList:Vector.<PChatInfoVO> = new Vector.<PChatInfoVO>;	//本地已读私信
		private var locChatList:Vector.<PChatInfoVO> = new Vector.<PChatInfoVO>;	//本地已收未读私信
		private var readIdArr:Array = new Array;	//转移到历史表的id序列
		private var historyList:Vector.<PChatInfoVO> = new Vector.<PChatInfoVO>;
		
		
		
		//设置好友列表提醒
		public function setFriListRemind(_pchatVo:PChatInfoVO):void{
			
			chatFriList.updateList(_pchatVo);
			
			sendNotification(WorldConst.REMIND_PRIVATE_MESS,new RemindPriMessVO(true,_pchatVo.sendId));
		}
		public function freshFriList():void{
			chatFriList.freshList();
			
		}
		
		//设置已收未读私信
		public function setLocChat(_locChatList:Vector.<PChatInfoVO>):void{
			locChatList = _locChatList;
			
			if(currentFriId != ""){
				getChatScroll("PC").removeUI();
				
				setMainChatByFri(currentFriId);
				
				if(chatFriList.currentItem){
					chatFriList.currentItem.stopShake();
				}
			}
		}
		
		//显示不同好友的聊天窗口
		private function setMainChatByFri(_id:String):void{
			//按id升序
			locRecordList.sort(sortLocRecord);
			
			//把已读私信显示
			for(var i:int=0;i<locRecordList.length;i++){
				
				if(locRecordList[i].sendId == _id)
					getChatScroll("PC").setOtherChat(locRecordList[i].sendName,locRecordList[i].time,locRecordList[i].content,false,locRecordList[i].type);
				if(locRecordList[i].recId == _id && locRecordList[i].sendId == PackData.app.head.dwOperID.toString())
					getChatScroll("PC").setMyChat(locRecordList[i].time,locRecordList[i].content,locRecordList[i].type);
				
			}
			
			//把已收未读私信显示，并且告诉后台该信息已读
			for(i=0;i<locChatList.length;i++){
				
				if(locChatList[i].sendId == _id){
					getChatScroll("PC").setOtherChat(locChatList[i].sendName,locChatList[i].time,locChatList[i].content,false,locChatList[i].type);
					
					
					readIdArr.push(locChatList[i].id);
				}
				
			}
			
			move2Log(readIdArr.join(","));
		}
		private function move2Log(_readId:String):void{
			if(_readId == "")
				return;
			TweenLite.killTweensOf(move2Log);
			if(Global.isLoading){
				TweenLite.delayedCall(2,move2Log,[_readId]);
				return;
			}
			//轮询中2次通信，通知切换界面缓存
			sendNotification(WorldConst.DO_SWITCH_STOP);
			sendNotification(WorldConst.DELAY_SWITCH_STOP);
			sendNotification(CoreConst.LOADING,false);
			
			PackData.app.CmdIStr[0] = CmdStr.MOVE_2_INSTMESSLOG;
			PackData.app.CmdIStr[1] = _readId;
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(MOVE_2_INSTMESSLOG_COMPLETE));
			
		}
		
		private function hasLocRecord(_pchat:PChatInfoVO):Boolean{
			var isHas:Boolean;
			
			for(var i:int=0;i<locRecordList.length;i++){
				if(locRecordList[i].id == _pchat.id){
					isHas = true;
					break;
				}
			}
			
			if(isHas)
				return true;
			else
				return false;
		}
		
		private function sortLocRecord(_a:PChatInfoVO,_b:PChatInfoVO):int{
			var aid:int = _a.id;
			var bid:int = _b.id;
			
			if(aid > bid) {
				return 1;
			} else if(aid < bid) {
				return -1;
			} else {
				return 0;
			}
		}
		
		//取历史列表
		private function getHisBtnHandle():void{
			if(chatStyle == "PC" && currentFriId != "")
				getHistoryChat(currentFriId);
			else if(chatStyle == "WC")
				sendNotification(MutiWSpeakMediator.GET_WC_HISTORY,"");
		}
		private function getHistoryChat(_id:String):void{
			TweenLite.killTweensOf(getHistoryChat);
			if(Global.isLoading){
				TweenLite.delayedCall(2,getHistoryChat,[_id]);
				return;
			}
			historyList.splice(0,historyList.length);
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_ALLINS_MESS;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = _id;
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_ALLINS_MESS_COMPLETE));
		}
		
		
		//私信后台发送
		private function sendPC2Server(_id:String,_name:String,_pcStr:String):void{
			TweenLite.killTweensOf(sendPC2Server);
			if(Global.isLoading){
				TweenLite.delayedCall(2,sendPC2Server,[_id,_name,_pcStr]);
				return;
			}
			
			
			PackData.app.CmdIStr[0] = CmdStr.INUP_INSTANT_MESS;
			PackData.app.CmdIStr[1] = 0;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[3] = Global.player.realName;
			PackData.app.CmdIStr[4] = _id;	
			PackData.app.CmdIStr[5] = _name;
			PackData.app.CmdIStr[6] = "text";	
			PackData.app.CmdIStr[7] = _pcStr;	//聊天内容
			PackData.app.CmdInCnt = 8;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(INUP_INSTANT_MESS_COMPLETE));
			
			
			
		}
/**	共有函数	***************************************************************************************/	
		
		public function showMainChat(_doShow:Boolean,_chatStyle:String="",_friId:String=""):void{
			if(_doShow){
				mainChatSp.visible = true;
				chatFriList.visible = true;
				textInput.visible = true;
//				mainChatSp.addChild(textInput);
				
				mutiChoseBox.setBtnLocation(_chatStyle);
				
				//如果有，则先关闭上一频道
				if(mainChatScroller)
					mainChatScroller.visible = false;
				
				if(_chatStyle == "WC")	isShowMain = true;
				else	isShowMain = false;
				
				if(_chatStyle == "WC" || _chatStyle == "PC")	getHisBtn.visible = true;
				else	getHisBtn.visible = false;
				
				if(_chatStyle == "PC" && _friId != "")
					chatFriList.clickItemById(_friId);
				
				mainChatScroller = getChatScroll(_chatStyle);
				getChatScroll(_chatStyle).visible = true;
			}else{
				//隐藏
				mainChatSp.visible = false;
				textInput.visible = false;
//				mainChatSp.removeChild(textInput);
				
				chatFriList.visible = false;
				mainChatScroller.visible = false;
				isShowMain = false;
			}
		}
		private function getNowTime():String{
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("yyyyMMdd-HHmmss");
			
			return dateFormatter.format(new Date);
		}
		private function closeBtnHandle():void{
			showMainChat(false);
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function onRemove():void
		{
			super.onRemove();
			BitmapFontUtils.dispose();
			if(mainChatScroller)
				TweenLite.killTweensOf(mainChatScroller.scroll);
			TweenLite.killTweensOf(talkProxy.npcSay);
			TweenLite.killTweensOf(sendWC2Server);
			TweenLite.killTweensOf(sendPC2Server);
			TweenLite.killTweensOf(move2Log);
			TweenLite.killTweensOf(getHistoryChat);
			TweenLite.killTweensOf(updateTimes);
			
			
			view.removeChildren(0,-1,true);
			
			AppLayoutUtils.uiLayer.removeChild(chatFriList,true);
			AppLayoutUtils.uiLayer.removeChild(mainChatSp,true);
			
			if(speechView){
				speechView.dispose();
				Starling.current.nativeOverlay.removeChild(speechView);
			}
			
			
			facade.removeProxy(ChatViewBmpProxy.NAME);
			for(var i:int=0;i<scrollMap.getKeySet().length;i++)
				AppLayoutUtils.cpuLayer.removeChild(scrollMap.find(scrollMap.getKeySet()[i]));
			
			if(textInput){
//				textInput.useKeyboard = false;
				AppLayoutUtils.cpuLayer.removeChild(textInput);
				textInput.removeEventListener(KeyboardEvent.KEY_DOWN,inputHandle);
				textInput = null;
			}
		}
	}
}