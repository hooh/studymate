package com.studyMate.world.screens.email.emailmediator
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.email.ContactData;
	import com.studyMate.world.screens.email.emailview.WriteEmailView;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;
	
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.Event;

	public class WriteEmailViewMediator extends ScreenBaseMediator
	{
		private const NAME:String = "WriteEmailViewMediator";
		
		private const QRYSTDRELATLIST:String = "QryStdRelatList";
		
		private const SENDITNEMAIL:String = "SendItnMail";
		
		private var prepareVO:SwitchScreenVO;
		
		private var contactVec:Vector.<ContactData> = new Vector.<ContactData>();

		public function WriteEmailViewMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent);
		}
		
		private var sendid:String = "";
		private var subject:String = "";
		private var sendname:String = "";
		override public function prepare(vo:SwitchScreenVO):void
		{
			if(vo.data != null){
				sendid = vo.data.sendid;
				subject = vo.data.subject;
				sendname = vo.data.send;
				arr.push(vo.data);
			}
			prepareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return WriteEmailView
		}
		
		public function get view():WriteEmailView
		{
			return getViewComponent()as WriteEmailView 
		}
		
		
		private var croomUVec:ListCollection = new ListCollection();

		override public function onRegister():void
		{
			if(sendname != ""){
				view.addressee.text = sendname;
				if(subject.slice(0,2) != "回复"){
					view.title.text = "回复："+subject;
				}else{
					view.title.text = subject;
				}
				idArr.push(sendid);
			}
			view.contact.addEventListener(Event.TRIGGERED,contactHandler);
			view.croomList.addEventListener(Event.CHANGE,selectContactHandler);
			view.send.addEventListener(Event.TRIGGERED,sendEmailHandler);
			view.addressee.addEventListener(KeyboardEvent.KEY_DOWN,delContactHandler);
			view.mailtext.addEventListener(KeyboardEvent.KEY_DOWN,newlineHandler);
			view.addressee.addEventListener(MouseEvent.CLICK,delHandler);
			view.changeKeyboard.addEventListener(Event.TRIGGERED,selectKeyboardHandler);
			view.mailtext.addEventListener(MouseEvent.CLICK,hideListHandler,false,0,true);
			view.title.addEventListener(MouseEvent.CLICK,hideListHandler,false,0,true);
		}
		
		protected function hideListHandler(event:MouseEvent):void
		{
			view.croomList.visible = false;		
			view.croomList.selectedIndex= -1;
		}
		
		private function selectKeyboardHandler():void
		{
			if(view.mailtext.useKeyboard){
				view.mailtext.useKeyboard = false;
				view.mailtext.needsSoftKeyboard = true;
				view.mailtext.requestSoftKeyboard();
				view.mailtext.setFocus();;
			}else{
				view.mailtext.useKeyboard = true;
				view.mailtext.needsSoftKeyboard = false;
				TweenLite.killTweensOf(view.mailtext);
				view.mailtext.setFocus();
			}	
		}
		
		protected function delHandler(event:MouseEvent):void
		{
			var selectStart:int = view.addressee.getCharIndexAtPoint(event.localX,event.localY);
			if(selectStart == -1){
				return
			}
			var start:int = 0;
			var stop:int = view.addressee.text.length;
			for(var i:int = 0;i<10;i++){
				if(view.addressee.text.charAt(selectStart-i) == ","){
					start = selectStart - i;
				}
				if(view.addressee.text.charAt(selectStart + i) == ","){
					stop = selectStart + i;
					break;
				}
			}
			if(start == 0){
				stop++;
			}
			for(var j:int = 0;j<arr.length;j++){
				if(start == 0){
					if(arr[j] == view.addressee.text.slice(start,stop-1)){
						idArr.splice(j,1);
						arr.splice(j,1);
					}
				}else{
					if(arr[j] == view.addressee.text.slice(start+1,stop)){
						idArr.splice(j,1);
						arr.splice(j,1);
					}
				}
			}
			view.addressee.text  = view.addressee.text.substr(0,start) + view.addressee.text.substr(stop,view.addressee.text.length);
		}
		
		protected function newlineHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == 13){
				event.preventDefault();
				view.mailtext.text = view.mailtext.text.substr(0,view.mailtext.selectionEndIndex) + "\n" +view.mailtext.text.substr(view.mailtext.selectionEndIndex,view.mailtext.length);
				view.mailtext.selectTextRange(view.mailtext.selectionEndIndex+1,view.mailtext.selectionEndIndex+1);
			}
		}
		
		protected function delContactHandler(event:KeyboardEvent):void
		{
 	 		if(arr.length != 0&&event.keyCode==8){
				arr.splice(arr.length-1,1);
				idArr.splice(idArr.length -1,1);
				view.addressee.text = String(arr);
			}
		}
		
		private function sendEmailHandler():void
		{
			if(idArr.length != 0){
				
				if(mx.utils.StringUtil.trim(view.mailtext.text )!= ""){
					PackData.app.CmdIStr[0] = CmdStr.SENDITNEMAIL;
					PackData.app.CmdIStr[1] =  PackData.app.head.dwOperID.toString();
					PackData.app.CmdIStr[2] =  Global.player.realName;
					PackData.app.CmdIStr[3] = String(idArr) +";"
					PackData.app.CmdIStr[4] = MyUtils.getTimeFormat();
					PackData.app.CmdIStr[5] = view.title.text;
					PackData.app.CmdIStr[6] = "";
					PackData.app.CmdIStr[7] = view.mailtext.text;
					PackData.app.CmdInCnt = 8;
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(SENDITNEMAIL));
				}else{
					sendNotification(CoreConst.TOAST,new ToastVO("请先填写邮件内容~"));
				}
			}else{
				sendNotification(CoreConst.TOAST,new ToastVO("请先选择邮件接收人~"));
			}
			

		}
		
		private function sendMessageHandler():void
		{
			view.send.touchable = true;			
		}
		
		private var arr:Array = new Array();
		private var idArr:Array = new Array();
		private function selectContactHandler(e:Event):void
		{
			if(view.croomList.selectedItem != null){
				var _contact:String = view.croomList.selectedItem.custname +"<"+view.croomList.selectedItem.custid+">"+"  ";
				for(var i:int = 0;i<arr.length;i++){
					if(arr[i] == _contact){
						arr.splice(i,1);
						idArr.splice(i,1);
					}
				}
				if(arr.length>4){
					arr.splice(arr.length-1,1);
					idArr.splice(idArr.length-1,1);
				}
				arr.push(_contact);
				idArr.push(view.croomList.selectedItem.custid);
				view.addressee.text = String(arr);
			}
		}
		
		private function contactHandler():void
		{
			if(!view.croomList.visible){
				if(croomUVec.length == 0){
					PackData.app.CmdIStr[0] = CmdStr.QRY_STD_RELATLIST;
					PackData.app.CmdIStr[1] =  PackData.app.head.dwOperID.toString();
					PackData.app.CmdInCnt = 2;
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRYSTDRELATLIST));	
				}else{
					view.croomList.visible = true;
				}
			}else{
				view.croomList.visible = false;	
				view.croomList.selectedIndex = -1
			}

		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.HIDE_SETTING_SCREEN,QRYSTDRELATLIST,SENDITNEMAIL]
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var _result:DataResultVO = notification.getBody()as DataResultVO;
			var _contactdata:ContactData = new ContactData();
			switch(notification.getName())
			{
				case WorldConst.HIDE_SETTING_SCREEN:
				{
					prepareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
					break;
				}
				case QRYSTDRELATLIST:
				{
					if(!_result.isErr){
						if(!_result.isEnd){
							_contactdata.custid = PackData.app.CmdOStr[2];
							_contactdata.custname = PackData.app.CmdOStr[4];
							croomUVec.push(_contactdata);
						}else{
							view.croomList.visible = true;
							view.croomList.dataProvider = croomUVec;
						}
					}
					break;
				}
				case SENDITNEMAIL:
				{
					if(!_result.isErr){
						if(PackData.app.CmdOStr[0] == "000"){
							sendSuccessEmail();
						}
					}else{
						
					}
				}
			}
		}
		
		private function sendSuccessEmail():void
		{
			view.successTip.visible = true;
			view.mailtext.text = "";
			view.title.text = "";
			view.addressee.text = "";
			arr.length = 0;
			idArr.length = 0;
			view.croomList.selectedIndex =-1;
			TweenLite.killDelayedCallsTo(hideSuccessTipHandler);
			TweenLite.delayedCall(2,hideSuccessTipHandler);
		}
		
		private function hideSuccessTipHandler():void
		{
			view.successTip.visible = false;
		}
		
		override public function onRemove():void
		{
			view.mailtext.text = "";
			croomUVec.removeAll();
			arr.length = 0;
			idArr.length = 0;
			view.successTip.visible = false;
			view.contact.removeEventListener(Event.TRIGGERED,contactHandler);
			view.croomList.removeEventListener(Event.CHANGE,selectContactHandler);
			view.send.removeEventListener(Event.TRIGGERED,sendEmailHandler);
			view.addressee.removeEventListener(KeyboardEvent.KEY_DOWN,delContactHandler);
			view.mailtext.removeEventListener(KeyboardEvent.KEY_DOWN,newlineHandler);
			view.addressee.removeEventListener(MouseEvent.CLICK,delHandler);
			TweenLite.killDelayedCallsTo(hideSuccessTipHandler);
			super.onRemove();
		}
	
	}
}