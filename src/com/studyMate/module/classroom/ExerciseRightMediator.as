package com.studyMate.module.classroom
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.p2p.P2pProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.classroom.view.CRDropDownView;
	import com.studyMate.module.classroom.view.CRTextInputView;
	import com.studyMate.module.classroom.view.CRTryListenView;
	import com.studyMate.module.classroom.view.CRVoiceInputView;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.component.weixin.SpeechConst;
	import com.studyMate.world.component.weixin.VoiceState;
	import com.studyMate.world.component.weixin.VoicechatComponent;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.filesystem.File;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.events.Event;
	
	/**
	 * 教室辅导界面。右侧聊天界面。
	 * 控制语音聊天和文字聊天的。
	 * 	 
	 */	
	public class ExerciseRightMediator extends ScreenBaseMediator
	{
		public static const NAME:String = 'ExerciseRightMediator';
		
		private const QRY_CLASSROOM_MSG:String = NAME+'QryClassroomMsg';//查询聊天记录
		private const INSERT_MSG_COMPLETE:String = 'insert_msg_complete';//插入文字成功
		private const INSERT_FILE_COMPLETE:String = 'insert_voice_complete';//插入语音成功
		
		private var croomVO:CroomVO;
		
		private var isFirst:Boolean = true;
		private var current_MaxMsgId:int=-1;
		private var beat_msgId:int; 		//聊天索引
		
		private var _userOnline:String ;
		private var isTeacher:Boolean;//自己是否是老师
		public var chatAndVoice:VoicechatComponent;
		private var tid:String;

		public function ExerciseRightMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		public function set userOnline(value:String):void
		{
			if(_userOnline != value && !CRoomConst.isComplete){				
				_userOnline = value;
				view.userHolder.removeChildren(0,-1,true);
				if(_userOnline == '当前在线id:无'){
//					sendNotification(CRoomConst.HAS_ANYONE,false);
//					CRoomConst.hasAnyone = false;
					view.showTip('对方已下线,当前无在线用户');
					if(PackData.app.head.dwOperID.toString() == croomVO.tid){
						var teachIcon:Image = new Image(Assets.getWeixinTexture('teacherIcon'));
						teachIcon.x = 28;
						teachIcon.width = 29;
						teachIcon.height = 29;
						view.userHolder.addChild(teachIcon);
					}else{
						var studentIcon:Image = new Image(Assets.getWeixinTexture('studentIcon'));
						studentIcon.width = 29;
						studentIcon.height = 29;
						view.userHolder.addChild(studentIcon);
					}
				}else{
//					CRoomConst.hasAnyone = true;
//					sendNotification(CRoomConst.HAS_ANYONE,true);
					view.showTip(value+' 进入界面');
					teachIcon = new Image(Assets.getWeixinTexture('teacherIcon'));
					teachIcon.x = 28;
					view.userHolder.addChild(teachIcon);
					studentIcon = new Image(Assets.getWeixinTexture('studentIcon'));
					view.userHolder.addChild(studentIcon);
					teachIcon.width = 29;
					teachIcon.height = 29;
					studentIcon.width = 29;
					studentIcon.height = 29;
					
				}
			}
			
		}

		override public function onRemove():void{
			croomVO = null;
			
			TweenLite.killDelayedCallsTo(conTips);
			if(p2pProxy){
				p2pProxy.close();
			}
			
			super.onRemove();
		}
		override public function onRegister():void{
			tid = CacheTool.getByKey(ClassroomMediator.NAME,'tid') as String;
			if(PackData.app.head.dwOperID.toString() == tid){//是老师则加上老师头像
				isTeacher = true;
			}

			
			chatAndVoice = new VoicechatComponent();
			chatAndVoice.x = 720;
			chatAndVoice.y = 54;
			
			chatAndVoice.configView.viewWidth = 568;
			chatAndVoice.configView.useTeacherIcon = true;
			if(!CRoomConst.isComplete){
				chatAndVoice.configView.viewHeight = 606;
				chatAndVoice.configText.textInputView =  CRTextInputView;
				chatAndVoice.configText.dropDownView = CRDropDownView;
				chatAndVoice.configText.insertTextFun = insertTextHandler;
				chatAndVoice.configText.insertImgFun = insertImgHandler;
				chatAndVoice.configVoice.voiceInputView = CRVoiceInputView;
				chatAndVoice.configVoice.dropDownView = CRDropDownView;
				chatAndVoice.configVoice.inserVoiceFun = insertVoiceHandler;
				chatAndVoice.configVoice.tryListenView = CRTryListenView;	
			}else{
				view.checkAuto.visible = false;
				chatAndVoice.configView.viewHeight = 680;
			}
			
			view.holder.addChild(chatAndVoice);
			
			view.checkAuto.addEventListener(Event.CHANGE, check_changeHandler );
			
			p2pProxy = facade.retrieveProxy(P2pProxy.NAME) as P2pProxy;
			
			if(!CRoomConst.isComplete){				
				p2pBtn = new Button;
				p2pBtn.label = "语音通话";
				p2pBtn.width = 140;
				p2pBtn.height = 38;
				p2pBtn.x = 840;
				p2pBtn.y = 2;
				p2pBtn.addEventListener(Event.TRIGGERED, p2pBtnHandle);
				view.addChild(p2pBtn);
			}
		}
		private var p2pBtn:Button;
		private var p2pProxy:P2pProxy;
		private var hadCollected:Boolean = false;
		private function p2pBtnHandle():void{
			if(!hadCollected){
				if(PackData.app.head.dwOperID.toString() == croomVO.tid){
					p2pProxy.doConnect(PackData.app.head.dwOperID.toString(),croomVO.sid);
				}else{
					p2pProxy.doConnect(PackData.app.head.dwOperID.toString(),croomVO.tid);
				}
				TweenLite.delayedCall(2,conTips);
//				p2pBtn.label = "断开通话";
				
			}else{
//				p2pBtn.label = "语音通话";
				p2pProxy.close();
				
			}
			
			
		}
		private function conTips():void{
			sendNotification(CoreConst.TOAST,new ToastVO('网络不畅通，请耐心等待，或者重试！'));
		}
		
		private function insertTextHandler(mtxt:String):MessageVO{
			PackData.app.CmdIStr[0] = CmdStr.IN_CLASSROOM_MESSAGE;
			PackData.app.CmdIStr[1] =  CacheTool.getByKey(ClassroomMediator.NAME,'crid') as String;
			PackData.app.CmdIStr[2] = (facade.retrieveMediator(ExercisesLeftMediator.NAME) as ExercisesLeftMediator).current_Qid;//题目标识
			PackData.app.CmdIStr[3] = PackData.app.head.dwOperID;
			PackData.app.CmdIStr[4] = Global.player.realName;
			PackData.app.CmdIStr[5] = 'text'
			PackData.app.CmdIStr[6] = 'text' 
			PackData.app.CmdIStr[7] = mtxt;
			PackData.app.CmdInCnt = 8;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(INSERT_MSG_COMPLETE,null,'cn-gb',null,SendCommandVO.QUEUE));
			
			var messageVO:MessageVO = new MessageVO();
			messageVO.crid =  CacheTool.getByKey(ClassroomMediator.NAME,'crid') as String;
			messageVO.sedid = PackData.app.head.dwOperID.toString();
			messageVO.sedname = Global.player.realName
			messageVO.sedtime =MyUtils.getTimeFormat1();
			messageVO.mtype = 'text';
			messageVO.mtxt = mtxt;
			messageVO.hasRead = true;
//			messageVO.tid = CacheTool.getByKey(ClassroomMediator.NAME,'tid') as String;
			messageVO.isTeacher = isTeacher;
			return messageVO;
		}
		
		private function insertImgHandler(file:File):MessageVO{
			var messageVO:MessageVO = new MessageVO();
			messageVO.crid = CacheTool.getByKey(ClassroomMediator.NAME,'crid') as String;
			messageVO.sedid = PackData.app.head.dwOperID.toString();
			messageVO.sedname = Global.player.realName
			messageVO.sedtime =MyUtils.getTimeFormat();
			messageVO.mtype = 'pic';
			messageVO.mtxt = file.name;
//			messageVO.tid = CacheTool.getByKey(ClassroomMediator.NAME,'tid') as String;
			messageVO.isTeacher = isTeacher;
			messageVO.voiceState = VoiceState.loadingState;
			messageVO.minf = '';
			messageVO.hasRead = true;	
			totalTime = '';
			sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(file,file.name,'pic',WorldConst.UPLOAD_SPEECHCR_INIT,INSERT_FILE_COMPLETE));																										
			return messageVO;			
		}
		
		public var totalTime:String='0';
		private function insertVoiceHandler(file:File,totalTime:String='0'):MessageVO{
			var messageVO:MessageVO = new MessageVO();
			messageVO.crid = CacheTool.getByKey(ClassroomMediator.NAME,'crid') as String;
			messageVO.sedid = PackData.app.head.dwOperID.toString();
			messageVO.sedname = Global.player.realName
			messageVO.sedtime =MyUtils.getTimeFormat();
			messageVO.mtype = 'voice';
			messageVO.mtxt = file.name;
//			messageVO.tid = CacheTool.getByKey(ClassroomMediator.NAME,'tid') as String;
			messageVO.isTeacher = isTeacher;
			messageVO.voiceState = VoiceState.loadingState;
			messageVO.minf = totalTime;
			messageVO.hasRead = true;			
			this.totalTime = totalTime;								
			sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(file,file.name,'voice',WorldConst.UPLOAD_SPEECHCR_INIT,INSERT_FILE_COMPLETE));																							
			
			return messageVO;
		}
		
		
		private function check_changeHandler():void
		{
			chatAndVoice.configVoice.autoPlay = view.checkAuto.isSelected;
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				case WorldConst.BROADCAST_CLASS:
					beat_msgId = int(PackData.app.CmdOStr[2]);
					
					if(current_MaxMsgId < int(beat_msgId)){
						if(current_MaxMsgId==-1) current_MaxMsgId=0;
						cmdGetMsg();
					}
					
					var beat_userIds:String = PackData.app.CmdOStr[3];
					if(beat_userIds==''){						
						userOnline = '当前在线id:无';
					}else{
						userOnline = '当前在线id:'+beat_userIds;
					}
					break;
				
				case QRY_CLASSROOM_MSG://查看聊天消息
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){//接收
						var messageVO:MessageVO = new MessageVO(PackData.app.CmdOStr);
//						messageVO.tid = croomVO.tid;
						if(messageVO.sedid==  tid){							
							messageVO.isTeacher = true;
						}
						current_MaxMsgId = int(messageVO.id);	
						if(messageVO.mtype!='write'){							
							chatAndVoice.addMsgItem(messageVO);
						}else{
							if(PackData.app.head.dwOperID.toString() == messageVO.sedid){
								if(!CRoomConst.hasDrawBoard && messageVO.minf!='C'){
									CRoomConst.hasDrawBoard = true;
									Global.isFirstSwitch = false;
									sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(DrawBoardMediator,null,SwitchScreenType.SHOW)]);
									Global.isFirstSwitch = true;
								}
								sendNotification(CRoomConst.EVENT_SELF_DRAWBOARD,messageVO);
							}else{
								sendNotification(CRoomConst.EVENT_OTHER_DRAWBOARD,messageVO);
							}
						}
//						trace('返回的聊天标识：',current_MaxMsgId);											
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){
						if(isFirst){							
							isFirst = false;
							//如果已完成，则停止心跳
							if(CRoomConst.isComplete){
								sendNotification(CoreConst.STOP_BEAT);
							}else{
								chatAndVoice.activeAutoScroll(true);
								
							}
						}
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="M"){
						
					}					
					break;
				case INSERT_MSG_COMPLETE:
					if((PackData.app.CmdOStr[0] as String)=="000"){
						current_MaxMsgId = PackData.app.CmdOStr[1];					
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="M"){//出错退出
						sendNotification(CoreConst.TOAST,new ToastVO('发送失败!'));
					}
					break;
				case INSERT_FILE_COMPLETE:
					var wPath:String = PackData.app.CmdOStr[4];
					current_MaxMsgId = PackData.app.CmdOStr[5];					
					Facade.getInstance(chatAndVoice.core).sendNotification(SpeechConst.FILE_DOWNCOMPLETE_STATE,wPath);
					break;
				case CRoomConst.INSERT_TEXT:
					var obj:MessageVO = insertTextHandler(notification.getBody() as String);
					chatAndVoice.addMsgItem(obj);
					break;
				case WorldConst.P2P_CONENCT:
					hadCollected = true;
					p2pBtn.label = "断开通话";
					
					TweenLite.killDelayedCallsTo(conTips);
					sendNotification(CoreConst.TOAST,new ToastVO('成功连接到语音间，请通知对方连接房间。'));
					break;
				case WorldConst.P2P_CONNECT_ON:
					sendNotification(CoreConst.TOAST,new ToastVO('可以语音啦!双方已成功连接！'));
					break;
				case WorldConst.P2P_CONNECT_OFF:
					hadCollected = false;
					p2pBtn.label = "语音通话";
					
					sendNotification(CoreConst.TOAST,new ToastVO('关闭语音间！'));
					break;
			}
		}

		override public function listNotificationInterests():Array{
			return [
				WorldConst.BROADCAST_CLASS,
				INSERT_FILE_COMPLETE,
				INSERT_MSG_COMPLETE,
				QRY_CLASSROOM_MSG,
				CRoomConst.INSERT_TEXT,
				WorldConst.P2P_CONENCT,
				WorldConst.P2P_CONNECT_ON,
				WorldConst.P2P_CONNECT_OFF
			];
		}
		

		private var index:Vector.<int> = new Vector.<int>;
		
		//查询聊天消息
		private function cmdGetMsg():void{
//			trace('查询聊天消息咯',current_MaxMsgId);
			PackData.app.CmdIStr[0] = CmdStr.QRY_CLASSROOM__MESSAGE_AFTER;
			PackData.app.CmdIStr[1] = croomVO.crid;
			PackData.app.CmdIStr[2] = PackData.app.head.dwOperID;
			PackData.app.CmdIStr[3] = current_MaxMsgId;
//			PackData.app.CmdIStr[3] = '1';
			PackData.app.CmdInCnt = 4;
			
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_CLASSROOM_MSG,null,PackData.BUFF_ENCODE,index,SendCommandVO.QUEUE | SendCommandVO.UNIQUE));
		}	
		
		override public function get viewClass():Class{
			return ChatView;
		}		
		public function get view():ChatView{
			return getViewComponent() as ChatView;
		}
		
		override public function prepare(vo:SwitchScreenVO):void{	
			index.push(9);
			croomVO = vo.data as CroomVO;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
	}
}