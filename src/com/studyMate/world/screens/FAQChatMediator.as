package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.PopUpCommandVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpLoadCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.component.FAQBmpProxy;
	import com.studyMate.world.screens.view.FAQChatView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeFormatter;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import mx.utils.StringUtil;
	
	import fl.controls.Button;
	
	import myLib.myTextBase.events.EDUKeyboardEvent;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	
	import mycomponent.DrawBitmap;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class FAQChatMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "FAQChatMediator";		
		public static const HASFAQ:String = NAME+ "hasFaq";		
		private const Send_FAQ_Info:String  = "SendFAQInfo";
		private const FAQ_INFO:String = "FaqInfo";
		
		private var status:String = '';
		private var begin:int = 0;//起始下标
		private var count:String = '15'
		private var gap_Y:Number=4;
	
		private var prepareVO:SwitchScreenVO;
	
		private var faqBmpProxy:FAQBmpProxy;
		private var ScreenName:String = "";
		private var vecInfo:Vector.<String>;
		private var vecDate:Vector.<String>;
		
		public function FAQChatMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void{
			vecInfo = null;
			vecDate = null;
			facade.removeProxy(FAQBmpProxy.NAME);
			sendNotification(HASFAQ,false);
//			sendNotification(WorldConst.SHOW_MAIN_MENU);
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			view.inputTxt.removeEventListener(FocusEvent.FOCUS_IN,focusinHandler);
			view.inputTxt.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHander);
			view.inputTxt.removeEventListener(EDUKeyboardEvent.ENTER,keyDownHandler);
			view.sendBtn.removeEventListener(MouseEvent.CLICK,sendHandler);			
			view.closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
			view.dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);						
			
			view.mainUI.removeChildren();
			view.mainUI = null;
			sendNotification(WorldConst.REMOVE_POPUP_SCREEN,this);
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,stageKeydownHandler);

			
			TweenLite.killDelayedCallsTo(delay_focusin);
			TweenLite.killDelayedCallsTo(delay_focusout);
			super.onRemove();
		}
		override public function onRegister():void{
			sendNotification(WorldConst.POPUP_SCREEN,(new PopUpCommandVO(this)));
			view.init();
			
			vecInfo = new Vector.<String>;
			vecDate = new Vector.<String>;
			faqBmpProxy = new FAQBmpProxy;
			facade.registerProxy(faqBmpProxy);

			view.sendBtn.addEventListener(MouseEvent.CLICK,sendHandler);			
			view.closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
			view.dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			view.cameraBtn.addEventListener(MouseEvent.MOUSE_DOWN, cameraBtnHandler);
			view.changeKeyboardBtn.addEventListener(MouseEvent.MOUSE_DOWN,changeKeyboardHandler);						
			view.inputTxt.addEventListener(EDUKeyboardEvent.ENTER,keyDownHandler);
			view.inputTxt.addEventListener(FocusEvent.FOCUS_IN,focusinHandler);
			view.inputTxt.addEventListener(FocusEvent.FOCUS_OUT,focusOutHander);
			view.changeMsgBtn.addEventListener(MouseEvent.MOUSE_DOWN, changeMsgHandler);

			if(CalloutMenuMediator2.faqNum>0){//未读状态
				showStatusNo(0);
			}else{//已读状态
				showStatusAll(0);
			}
						
			view.mouseChildren = false;									
			sendNotification(WorldConst.GET_SCREEN_FAQ);			
			sendNotification(HASFAQ,true);		
			sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,false);
			
			view.x = (Global.stage.stageWidth-view.width)/2;
			
			view.upMoreBtn.addEventListener(MouseEvent.MOUSE_DOWN,getUpMsgHandler);
			view.downMoreBtn.addEventListener(MouseEvent.MOUSE_DOWN,getDownMsgHandler);
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,stageKeydownHandler,false,1);
			view.scroll.viewPort = view.UI;
			view.mainUI.addChild(view.scroll);
			view.mainUI.setChildIndex(view.upMoreBtn,view.mainUI.numChildren-1);
			view.mainUI.setChildIndex(view.downMoreBtn,view.mainUI.numChildren-1);
			
			trace("@VIEW:FAQChatMediator:");
			
		}
		protected function changeMsgHandler(event:MouseEvent=null):void
		{
			if(status!='N'){ ///显示未读
				showStatusNo(0)
			}else{//显示全部
				showStatusAll(0);
			}			
		}
		
		//显示未读消息状态
		private function showStatusNo(begin:int):void{
			view.upMoreBtn.visible = false;
			view.downMoreBtn.visible = false;
			status = 'N';
			this.begin = begin;
			getMsgHandler();
			view.changeMsgBtn.visible = true;
			view.noMsgIco.visible = false;
			view.allMsgIco.visible = true;
			CalloutMenuMediator2.faqNum = 0;
		}
		//显示全部消息状态
		private function showStatusAll(begin:int):void{			
			status = '';
			this.begin = begin;
			getMsgHandler();
			if(CalloutMenuMediator2.faqNum<=0){
				view.changeMsgBtn.visible = false;
				view.noMsgIco.visible = false;
				view.allMsgIco.visible = false;
			}else{
				view.noMsgIco.visible = true;
				view.allMsgIco.visible = false;
				view.changeMsgBtn.visible = true;
			}
		}
					
		protected function getMsgHandler(event:MouseEvent=null):void
		{			
			vecInfo.length = 0;
			vecDate.length = 0;
			view.mouseChildren = false;
			getFaqInfo();
		}
		
		
		private function getUpMsgHandler(event:MouseEvent=null):void{
			if(vecInfo.length>=15){
				begin+=15;
				getMsgHandler();
			}else{
				view.upMoreBtn.visible = false;
			}
		}
		
		private function getDownMsgHandler(event:MouseEvent=null):void{
			if(begin-15>=0){
				begin -=15;
				getMsgHandler();
			}else{
				view.downMoreBtn.visible = false;
			}
		}
		private function getFaqInfo():void{
			if(status=='N'){
				count = '100';
			}else{
				count = '15';
			}
			PackData.app.CmdIStr[0] = CmdStr.Get_FAQ_Info;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = count;
			PackData.app.CmdIStr[3] = begin;
			PackData.app.CmdIStr[4] = status;
			PackData.app.CmdInCnt = 5;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(FAQ_INFO,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
		}
		
		protected function stageKeydownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode ==Keyboard.BACK || event.keyCode == Keyboard.ESCAPE){
				event.stopImmediatePropagation();
				event.preventDefault();
			}
		}
		
		protected function focusOutHander(event:FocusEvent):void
		{
			TweenLite.killDelayedCallsTo(delay_focusout);
			TweenLite.killDelayedCallsTo(delay_focusin);
			TweenLite.delayedCall(0.2,delay_focusout);
		}
		
		protected function focusinHandler(event:FocusEvent):void
		{
			TweenLite.killDelayedCallsTo(delay_focusin);
			TweenLite.killDelayedCallsTo(delay_focusout);
			TweenLite.delayedCall(0.2,delay_focusin);
		}
		
		protected function delay_focusin():void{
//			if(!view.inputTxt.useKeyboard){				
				TweenLite.killTweensOf(view);
				TweenLite.to(view,0.5,{y:-130});
//			}
		}
		protected function delay_focusout():void{
			if(view.y<-50){				
				TweenLite.killTweensOf(view);
				TweenLite.to(view,0.5,{y:-0});
			}
		}
		
		protected function changeKeyboardHandler(event:MouseEvent):void
		{
			if(view.inputTxt.useKeyboard){	
				sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
				view.inputTxt.useKeyboard = false;
				view.inputTxt.needsSoftKeyboard = true;
				view.inputTxt.requestSoftKeyboard();
				view.inputTxt.setFocus();;
			}else{
				view.inputTxt.useKeyboard = true;
				view.inputTxt.needsSoftKeyboard = false;
				view.inputTxt.setFocus();		
			}			
		}
		
		
		
		private function closeHandler(event:MouseEvent):void{
			prepareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
			
			trace("@VIEW:"+MyUtils.getScreen()+":");
		}
		
		private function keyDownHandler(e:EDUKeyboardEvent):void{
			sendHandler();
		}
		private function sendHandler(event:MouseEvent=null):void{
			var inputStr:String = StringUtil.trim(view.inputTxt.text);		
			if(inputStr!=""){
				PackData.app.CmdIStr[0] = CmdStr.Send_FAQ_Info;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = 'Q:'+ScreenName;//菜单名称
				PackData.app.CmdIStr[3] = inputStr;
				PackData.app.CmdInCnt = 4;	
				sendNotification(CoreConst.SEND_1N,new SendCommandVO(Send_FAQ_Info));	//派发调用绘本列表参数，调用后台
			}
		}
		
		
		private function dragDownHandler(e:MouseEvent):void{
			view.startDrag(false,new Rectangle(-600,-50,Global.stage.stageWidth+200,Global.stage.stageHeight-10));
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		private function mouseUpHandler(e:MouseEvent):void{
			view.stopDrag();
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		private function cameraBtnHandler(e:MouseEvent):void{
			sendNotification(WorldConst.CALL_CAMERA);
		}
		
		
		override public function handleNotification(notification:INotification):void{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()) {
				case WorldConst.SET_SCREENT_FAQ:
					ScreenName = notification.getBody() as String;
					break;
				case Send_FAQ_Info://发送faq消息
					if(!result.isErr){
						var inputStr:String = StringUtil.trim(view.inputTxt.text);
						vecInfo.push(inputStr+"@&#");	
						vecDate.push(getTimeFormat()+"@#$");
						view.inputTxt.text = "";						
						var bmp:Bitmap = faqBmpProxy.chatboxR(getTimeFormat(),inputStr);
						bmp.x = 250;
						bmp.y = gap_Y;
						gap_Y += bmp.height+10;
						view.UI.addChild(bmp);
						if(view.UI.numChildren>75){
							var height:Number = (view.UI.removeChildAt(0) as DisplayObject).height+10;
							gap_Y -= height;
							for(var i:int = 0;i<view.UI.numChildren;i++){
								view.UI.getChildAt(i).y -= height;
							}
							view.UI.graphics.clear();
							view.UI.graphics.beginFill(0,0);
							view.UI.graphics.drawRect(0,0,500,view.UI.height);
							view.UI.graphics.endFill();
						}
						view.UI.y = view.scroll.height - view.UI.height;	
						view.scroll.update();
					}
					break;
				case FAQ_INFO://第一次打开faq接收消息
					if((PackData.app.CmdOStr[0] as String).charAt(1)=="0"){//接收
//						begin++;
						var str1:String = PackData.app.CmdOStr[8];
						vecInfo.push(str1);
						vecDate.push(PackData.app.CmdOStr[5]+"@#$"+PackData.app.CmdOStr[7]);
					}else if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){
						view.mouseChildren = true;
//						initializeShow();
						if(vecInfo.length==0){
//							view.UI.removeChildren();
//							gap_Y = 4;
//							view.UI.graphics.clear();
							if(status=='N'){
								sendNotification(CoreConst.TOAST,new ToastVO('没有更多未读消息了'));								
							}else{
								sendNotification(CoreConst.TOAST,new ToastVO('没有更多已读消息了'));								

							}
						}else{							
							wholeShow();
							upDownVisibleHandler();							
						}
					}else{
						view.mouseChildren = true;
					}
					
					break;
				case WorldConst.CAMERA_OVER : 
					var path:String = notification.getBody() as String;
					trace(path);
					loadPhoto(path);
					break;
				case CoreConst.UPLOAD_COMPLETE:
					PackData.app.CmdIStr[0] = CmdStr.Send_FAQ_Info;
					PackData.app.CmdIStr[1] = '150';
					PackData.app.CmdIStr[2] = "上传图片";//菜单名称
					PackData.app.CmdIStr[3] = "id: "+PackData.app.head.dwOperID.toString();
					PackData.app.CmdInCnt = 4;	
					sendNotification(CoreConst.SEND_1N,new SendCommandVO(''));	//派发调用绘本列表参数，调用后台
					removePicture();
					break;
				case WorldConst.BROADCAST_FAQ:
					var faqNum:int = int(notification.getBody());
					if(faqNum > 0){
						if(status==''){	//如果是全部状态下					
							view.noMsgIco.visible = true;
							view.allMsgIco.visible = false;
							view.changeMsgBtn.visible = true;
						}else{//如果是未读状态下
							showStatusNo(0);//刷新一遍
						}
					}
					break;
			}			
		}
		private function upDownVisibleHandler():void{
			if(status=='N'){
				view.upMoreBtn.visible = false;
				view.downMoreBtn.visible = false;
			}else{
				if(begin<15){//最底下
					if(vecInfo.length<15){										
						view.upMoreBtn.visible = false;
						view.downMoreBtn.visible = false;
					}else{
						view.upMoreBtn.visible = true;
						view.downMoreBtn.visible = false;
					}
				}else if(begin>=15){
					if(vecInfo.length<15){											
						view.upMoreBtn.visible = false;
						view.downMoreBtn.visible = true;
					}else{
						view.upMoreBtn.visible = true;
						view.downMoreBtn.visible = true;
					}
				}													
			}
		}
		//初始显示的页数
		/*private function initializeShow():void{
			if(vecInfo.length>2){
				view.moreBtn.visible = true;
				view.moreBtn.addEventListener(MouseEvent.MOUSE_DOWN,moreHandler);
				for(var i:int = 2;i>0;i--){
					var date5:String = vecDate[vecDate.length-i].split("@#$")[0];
					var date7:String = vecDate[vecDate.length-i].split("@#$")[1];
					bmpAddUI(vecInfo[vecInfo.length-i],date5,date7);
				}								
			}else{
				for(i=0;i<vecInfo.length;i++){
					date5 = vecDate[i].split("@#$")[0];
					date7 = vecDate[i].split("@#$")[1];
					bmpAddUI(vecInfo[i],date5,date7);
				}
			}
			view.UI.graphics.clear();
			view.UI.graphics.beginFill(0,0);
			view.UI.graphics.drawRect(0,0,500,view.UI.height);
			view.UI.graphics.endFill();
			view.scroll.viewPort = view.UI;
			view.UI.y = view.scroll.height - view.UI.height;
			view.addChild(view.scroll);
		}*/
		//全部显示的页数
		private function wholeShow():void{
			view.UI.removeChildren();
			gap_Y = 4;
			var len:int = vecInfo.length;
			for(var i:int=0;i< len;i++){
				var date5:String = vecDate[i].split("@#$")[0];
				var date7:String = vecDate[i].split("@#$")[1];
				bmpAddUI(vecInfo[i],date5,date7);
			}
			
			view.UI.y = view.scroll.height - view.UI.height;
			
			
			view.UI.graphics.clear();
			view.UI.graphics.beginFill(0,0);
			view.UI.graphics.drawRect(0,0,500,view.UI.height);
			view.UI.graphics.endFill();
			view.scroll.update();
			
			
		}
		
		
		
		private function bmpAddUI(infoStr:String,date5:String,date7:String):void{
			var str1:String = infoStr;
			var j:int = str1.indexOf("@&#");
			var title:String = StringUtil.trim(str1.substr(0,j));
			var content:String = StringUtil.trim(str1.substr(j+3));//内容..
			if(title!=""){
				bmp = faqBmpProxy.chatboxR( DataStr(date5),title);
				bmp.y = gap_Y;
				bmp.x = 250;
				gap_Y += bmp.height+10;
				view.UI.addChild(bmp);
			}
			if(content!=""){
				bmp = faqBmpProxy.chatboxL( DataStr(date7),content);
				bmp.x = 10;
				bmp.y = gap_Y;
				gap_Y += bmp.height+10;
				view.UI.addChild(bmp);
			}
		}
			
		//20120730-092611转12-07-30 09:26:11
		private function DataStr(str:String):String{
			var myStr:String = str.substr(2,2)+"-"+str.substr(4,2)+"-"+str.substr(6,2)+" "
				+str.substr(9,2)+":"+str.substr(11,2)+":"+str.substr(13);
			return myStr;
		}	
		private function getTimeFormat():String {						
			var dateFormatter:DateTimeFormatter = new DateTimeFormatter("en-US");			
			dateFormatter.setDateTimePattern("yy-MM-dd HH:mm:ss");
			return dateFormatter.format(Global.nowDate);							
		}
		override public function listNotificationInterests():Array{
			return [Send_FAQ_Info,FAQ_INFO,WorldConst.BROADCAST_FAQ,WorldConst.CAMERA_OVER,CoreConst.UPLOAD_COMPLETE,WorldConst.SET_SCREENT_FAQ];
		}
		
		
		private var loadImagePath:String;
		private function loadPhoto(imagePath:String):void{
			if (imagePath) {
				var loader:Loader = new Loader();
				loadImagePath = imagePath;
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,LoaderComHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.load(new URLRequest("file://" + imagePath));
			}
		}		
		protected function ioErrorHandler(event:IOErrorEvent):void{			
		}
		
		private var bmp:Bitmap;
		private function LoaderComHandler(event:flash.events.Event):void{
			var loader:Loader = event.target.loader as Loader;
			bmp = new DrawBitmap(loader,Global.stageWidth,Global.stageHeight);
			savePicture(bmp.bitmapData, loadImagePath);
			bmp.x = ((Global.stageWidth - bmp.width) >> 1) - view.x; bmp.y = ((Global.stageHeight - bmp.height) >> 1) - view.y;
			view.addChild(bmp);
			addButtons();
		}
		private function savePicture(bmd:BitmapData,url:String):void{
			var j:JPEGEncoderOptions=new JPEGEncoderOptions(75);
			var b:ByteArray=new ByteArray();
			var rec:Rectangle = new Rectangle(0,0,bmd.width,bmd.height);
			bmd.encode(rec,j,b);
			var file:File = new File(url);
			var fs:FileStream = new FileStream();
			try{
				fs.open(file,FileMode.WRITE);
				fs.writeBytes(b);
				fs.close();
			}catch(e:Error){
				trace(e.message);
			}
		}
		
		private var uploadBtn:Button;
		private var cancleBtn:Button;
		private function addButtons():void{
			uploadBtn = new Button();
			uploadBtn.label = "上传";
			uploadBtn.x = (Global.stageWidth >> 1) - 100 - uploadBtn.width - view.x; uploadBtn.y = 700 - view.y;
			uploadBtn.addEventListener(MouseEvent.CLICK,uploadPictureHandler);
			view.addChild(uploadBtn);
			
			cancleBtn = new Button();
			cancleBtn.label = "取消";
			cancleBtn.x = (Global.stageWidth >> 1) + 100 - view.x; cancleBtn.y = 700 - view.y;
			cancleBtn.addEventListener(MouseEvent.CLICK,canclePictureHandler);
			view.addChild(cancleBtn);
		}
		
		private function uploadPictureHandler(event:MouseEvent):void{
			var file:File = new File(loadImagePath);
			uploadBtn.visible = false;
			cancleBtn.visible = false;
			sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(file,"faq/" + file.name,null,WorldConst.UPLOAD_PERSON_INIT));
		}
		
		private function canclePictureHandler(event:MouseEvent):void{
			removePicture();
		}
		
		private function removePicture():void{			
			var file:File = new File(loadImagePath);
			if(file != null){
				if(file.exists){
					file.deleteFile();
				}
			}
			
			if(uploadBtn)	view.removeChild(uploadBtn);
			if(cancleBtn) view.removeChild(cancleBtn);
			if(bmp){
				if(view.contains(bmp))
					view.removeChild(bmp);
			}
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;	
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);	
		}
		
		override public function get viewClass():Class
		{
			return FAQChatView;
		}
		
		public function get view():FAQChatView{
			return getViewComponent() as FAQChatView;
		}
	}
}