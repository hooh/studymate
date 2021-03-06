package com.studyMate.world.screens.email.emailmediator
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.AlertVo;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.component.SysRewardCartoonMediator;
	import com.studyMate.world.screens.email.EmailData;
	import com.studyMate.world.screens.email.EmailView;
	import com.studyMate.world.screens.email.emailrender.EditorEmailListItemRendener;
	import com.studyMate.world.screens.email.emailrender.EmailNumListClassItemRendener;
	import com.studyMate.world.screens.email.emailview.UnreadEmailView;
	
	import flash.text.TextFormat;
	
	import feathers.controls.List;
	import feathers.controls.ScrollText;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.events.Event;

	public class UnreadEmailViewMediator extends ScreenBaseMediator
	{
		
		private const NAME:String = "UnreadEmailViewMediator";
		
		private const QRYEMAILTREE:String = "QryMailTree";
		private const SELEMAIL4PAD:String = "SelEmail4Pad";
		private const BATMARKREAD4P:String = "BatMarkRead4p";
		private const READEMAIL4PAD:String = "ReadEmail4Pad";
		private const DELEMAIL4PAD:String = "DELEMAIL4PAD";
		private const yesDelHandler:String = NAME+"yesDelHandler"
		
		private var prepareVO:SwitchScreenVO;
		private var emailVec:Vector.<EmailData> = new Vector.<EmailData>;
		private var delID:EmailData;
		
		private var unreadNum:Number;
		private var croomList:List;//列表组件
		private var croomUVec:ListCollection = new ListCollection();
		
		private var msgTextField2:ScrollText = new ScrollText();
		private var begin:int = -5;
		public var moreBtn:Button;


		
		public function UnreadEmailViewMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent);
			
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class	
		{
			return UnreadEmailView;
		}
		
		public function get view():UnreadEmailView{
			return getViewComponent() as UnreadEmailView;
		}

		
		override public function onRegister():void
		{
			
			view.addChild(msgTextField2);
			msgTextField2.x = 455;
			msgTextField2.y = 150;
			msgTextField2.width = 700;
			msgTextField2.height = 592;
			msgTextField2.paddingTop = 0;
			msgTextField2.isHTML = true;
			msgTextField2.textFormat = new TextFormat('HeiTi',21,0,true);
			msgTextField2.embedFonts = true;
			
			moreBtn = new Button(Assets.getEmailAtlasTexture("more"));
			moreBtn.x = 120;
			moreBtn.y = 700;
			view.addChild(moreBtn);
			moreBtn.addEventListener(Event.TRIGGERED,moreEmailHandler);
			
			croomList = new List();
			croomList.x = 0;
			croomList.y = 65;
			croomList.width = 420;
			croomList.height = 630;
			croomList.itemRendererType = EmailNumListClassItemRendener;
			croomList.dataProvider = croomUVec;
			view.addChild(croomList);
			view.editorBtn.addEventListener(Event.TRIGGERED,editorEmailListHandler);
			view.reviceBtn.addEventListener(Event.TRIGGERED,reviceEmailHandler);
			view.finshBtn.addEventListener(Event.TRIGGERED,finishEditorHandler);
			croomList.addEventListener(Event.CHANGE,selectCroomHandler);
			getEmailList();
		}
		
		
		private function moreEmailHandler():void
		{
			getEmailList()			
		}
		
		private function getGiftBtnHandler():void
		{
			if(croomList.selectedItem.isRead){
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SysRewardCartoonMediator,["奖励",PackData.app.CmdOStr[9]],SwitchScreenType.SHOW,view.stage,0,0)]);
			}
		}		
		
		private function selectCroomHandler(event:Event):void
		{
			if(croomList.selectedItem != null&&!Global.isLoading){
				view._label.visible = true;
				view._title.visible = true;
				view.hideBackground.visible = false;
				view.reviceBtn.visible = true;
				PackData.app.CmdIStr[0] = CmdStr.SELEMAIL4PAD;
				PackData.app.CmdIStr[1] = croomList.selectedItem.mailid;
				PackData.app.CmdIStr[2] =  PackData.app.head.dwOperID.toString();
				PackData.app.CmdInCnt = 3;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(SELEMAIL4PAD));
			
			}
		}
		
		private function delAllEmailHandler():void
		{
			PackData.app.CmdIStr[0] = CmdStr.BATMARKREAD4P;
			PackData.app.CmdIStr[1] =  PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(BATMARKREAD4P));
		}
		
		private function reviceEmailHandler():void
		{
			if(croomList.selectedItem != null){
				view.removeChild(msgTextField2,true)
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WriteEmailViewMediator,croomList.selectedItem,SwitchScreenType.SHOW,null,90,0)]);	
			}
		}
		
		private function editorEmailListHandler():void
		{
			view.editorBtn.visible = false;	
			view.finshBtn.visible = true;
//			getEmailList();
			croomList.itemRendererType = EditorEmailListItemRendener;
		}		
		
		private function finishEditorHandler():void
		{
			view.editorBtn.visible = true;
			view.finshBtn.visible = false;
			croomList.itemRendererType = EmailNumListClassItemRendener;
		}
		
		
		private function getEmailList():void
		{
			if(!Global.isLoading){
				begin = begin + 5;
				PackData.app.CmdIStr[0] = CmdStr.QRYEMAILTREE;
				PackData.app.CmdIStr[1] =  PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = "U";
				PackData.app.CmdIStr[3] = begin;
				PackData.app.CmdIStr[4] = 5;
				PackData.app.CmdInCnt = 5;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRYEMAILTREE));
			}
	
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.HIDE_SETTING_SCREEN,QRYEMAILTREE,SELEMAIL4PAD,EmailNumListClassItemRendener.COLLECTEMAIL,
					DELEMAIL4PAD,BATMARKREAD4P,READEMAIL4PAD,WorldConst.DELEMAIL,yesDelHandler]
		}
		
		
		private var num:int = 0;
		override public function handleNotification(notification:INotification):void
		{
			var _result:DataResultVO = notification.getBody()as DataResultVO;
			var _emaildata:EmailData = new EmailData();
			switch(notification.getName())
			{
				case WorldConst.HIDE_SETTING_SCREEN:
				{
					prepareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
					break;
				}
				case QRYEMAILTREE :
				{
					if(!_result.isErr){
						if(!_result.isEnd){
							_emaildata.mailid = PackData.app.CmdOStr[1];
							_emaildata.send = PackData.app.CmdOStr[2];
							_emaildata.creattime = PackData.app.CmdOStr[3];
							for(var i:int = 0;i<PackData.app.CmdOStr[2].length;i++){
								if(PackData.app.CmdOStr[2].charAt(i) == "<"){
									_emaildata.sendid = PackData.app.CmdOStr[2].slice(i+1,PackData.app.CmdOStr[2].length-1);
								}
							}
							_emaildata.mark = PackData.app.CmdOStr[5];
							_emaildata.readtime = PackData.app.CmdOStr[6];
							if(PackData.app.CmdOStr[7].length < 1){
								_emaildata.subject = "<无主题邮件>"
							}else{
								_emaildata.subject = PackData.app.CmdOStr[7];
							}
							unreadNum = PackData.app.CmdOStr[8];
							num = PackData.app.CmdOStr[8];
							_emaildata.other = PackData.app.CmdOStr[9];
							emailVec.push(_emaildata);
							view.shape.visible = false;
						}else{
							if(emailVec.length < 1){
								sendNotification(CoreConst.TOAST,new ToastVO("这是你全部未读邮件~"));
							}else{
								view.shape.visible = false;
								for(var j:int =0;j<emailVec.length;j++){
									croomUVec.push(emailVec[j]);
								}
								emailVec.length = 0;
								EmailView.numText.text = String(unreadNum);;	
								sendNotification(WorldConst.EMAIL_NUM);
							}
							if(croomUVec.length ==0){
								view.shape.visible = true;
								moreBtn.visible = false;
								sendNotification(WorldConst.EMAIL_NUM);
							}
							if(num<=5){
								moreBtn.visible = false;
							}else{
								moreBtn.visible = true;
							}
						}
					}
					break;
				}
				case SELEMAIL4PAD:
				{
					if(!_result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							if(!(croomList.selectedItem as EmailData).isRead){
								//数字减一
								if(PackData.app.CmdOStr[9] != ""&&!croomList.selectedItem.isRead){
									sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SysRewardCartoonMediator,["奖励",PackData.app.CmdOStr[9]],SwitchScreenType.SHOW,view.stage,0,0)]);
								}
								(croomList.selectedItem as EmailData).isRead = true;
								unreadNum--;
								begin--;
								EmailView.numText.text = String(unreadNum);	
								croomUVec.updateItemAt(croomList.selectedIndex);
							}
							view.hideBackground.visible = false;
							view.sendname.text = PackData.app.CmdOStr[3]+"<ID:"+PackData.app.CmdOStr[2]+">";
							if(PackData.app.CmdOStr[8].length == 1){
								view.title.text = "无主题邮件";
								view.title.color = 0x595653;
							}else{
								view.title.text = PackData.app.CmdOStr[8];
							}
							msgTextField2.text = PackData.app.CmdOStr[10];
							markReadMail();
						}
					}
					break;
				}
				case EmailNumListClassItemRendener.COLLECTEMAIL:
				{
					if(!_result.isErr){
					}
					break;
				}
				case DELEMAIL4PAD:
				{
					if(!_result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							unreadNum--;
							EmailView.numText.text = String(unreadNum);	
							if(unreadNum<1){
								sendNotification(WorldConst.EMAIL_NUM);
							}
							croomList.dataProvider.removeItem(delID);
						}
					}
					break;
				}
				case BATMARKREAD4P:
				{
					if(!_result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							getEmailList();
						}
					}
					break;
				}
				case READEMAIL4PAD:
				{
					if(!_result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							EmailView.numText.text = String(unreadNum);	
							sendNotification(WorldConst.EMAIL_NUM);
							if(msgTextField2.text.indexOf('<@#Log>')==0){
								sendNotification(WorldConst.UPLOAD_SYSTEM_LOG);
							}
						}
					}
					break;
				}
				case WorldConst.DELEMAIL:
				{
					delID = notification.getBody() as EmailData;
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.ALERT_SHOW,new AlertVo("你确定要这封未读邮件吗？",true,yesDelHandler));
					break;
				}
				case yesDelHandler:
				{
					PackData.app.CmdIStr[0] = CmdStr.DELEMAIL4PAD;
					PackData.app.CmdIStr[1] =  PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] = delID.mailid;
					PackData.app.CmdIStr[3] = "R";
					PackData.app.CmdInCnt = 4;
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(DELEMAIL4PAD));
					break;
				}
			}
		
		}
		
		private function markReadMail():void
		{
			if(!Global.isLoading){
				PackData.app.CmdIStr[0] = CmdStr.READEMAIL4PAD;
				PackData.app.CmdIStr[1] =  PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = croomList.selectedItem.mailid;
				PackData.app.CmdInCnt = 3;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(READEMAIL4PAD));
			}
		}		
		
		override public function onRemove():void
		{
			view.removeChild(msgTextField2,true);
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
		
		
	}
}