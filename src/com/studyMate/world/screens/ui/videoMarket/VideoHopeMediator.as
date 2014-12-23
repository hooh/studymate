package com.studyMate.world.screens.ui.videoMarket
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.screens.MusicMarketMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	/**
	 * 音乐许愿。
	 * @author wt
	 * 
	 */	
	public class VideoHopeMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "VideoHopeMediator";
		
		private const HOPE_VIDEO:String= NAME+"HOPE_VIDEO";
		
		
		private var pareVO:SwitchScreenVO;
		private var img:Image;
		private var searchTxt:TextFieldHasKeyboard;
		public function VideoHopeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			view.x = 377;
			view.y = 211;
			
			img = new Image(Assets.getMarketTexture("Frame/marketHopeAlert"));
			img.pivotX = img.width>>1;
			img.pivotY = img.height>>1;
			img.x += img.width>>1;
			img.y += img.height>>1;
			
			view.addChild(img);			
			
			img.addEventListener(TouchEvent.TOUCH,bgTouchHandler);
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,stageTouchHandler);
			TweenLite.from(img,0.6,{scaleX:0.1,scaleY:0.1,ease:Back.easeOut,onComplete:showHandler});
		}
		private function delBtnHandler(e:Event):void{		
			e.stopImmediatePropagation();
			
			pareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
		}
		
		override public function onRemove():void{
			TweenLite.killTweensOf(img);
			if(searchTxt){
				searchTxt.removeEventListener(KeyboardEvent.KEY_DOWN,searchDownHandler);
				searchTxt.removeEventListener(FocusEvent.FOCUS_IN,searchFocusInHandler);
				Starling.current.nativeOverlay.removeChild(searchTxt);
			}
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageTouchHandler);
			view.removeChildren(0,-1,true);
			super.onRemove();
		}
		
		private function bgTouchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase==TouchPhase.BEGAN){
				e.stopImmediatePropagation();
			}
		}
		private function showHandler():void{
			
			var sureBtn:TextField = new TextField(125,58,"许愿","HeiTi",30,0xFFFFFF,true);
			sureBtn.x = 427;
			sureBtn.y = 112;
			/*var sureBtn:Button = new Button(Assets.getMusicSeriesTexture("yesButtonIcon"));
			sureBtn.x = 267;
			sureBtn.y = 145;*/
			view.addChild(sureBtn);
			var bg:Quad = new starling.display.Quad(128,58,0x0a4475);
			bg.alpha = 0;
			bg.x = 427;
			bg.y = 112;
			view.addChild(bg);
			bg.addEventListener(TouchEvent.TOUCH,sureBtnHandler);
			
			var _delBtn:Button = new Button(Assets.getMarketTexture("Frame/delIcon"));
			_delBtn.x = 560;			
			view.addChild(_delBtn);
			_delBtn.addEventListener(Event.TRIGGERED,delBtnHandler);
			
			var tf:TextFormat = new TextFormat("HeiTi",34,0xFFFFFF);
			searchTxt = new TextFieldHasKeyboard();
			searchTxt.defaultTextFormat = tf;
			searchTxt.restrict = "^`\/";
			searchTxt.embedFonts = true;
			searchTxt.antiAliasType = AntiAliasType.ADVANCED;
			searchTxt.width = 337;
			searchTxt.height = 60;
			searchTxt.x = 450;
			searchTxt.y = 330;
			searchTxt.maxChars = 18;
			searchTxt.addEventListener(KeyboardEvent.KEY_DOWN,searchDownHandler);
			searchTxt.addEventListener(FocusEvent.FOCUS_IN,searchFocusInHandler);
			
			Starling.current.nativeOverlay.addChild(searchTxt); 			
			searchTxt.setFocus();
			
			var tip:TextField = new TextField(500,40,'小贴士：请许愿原创英文版电影','HeiTi',20);
			tip.x = 50;
			tip.y = 180;
			tip.touchable = false;
			view.addChild(tip);
		}
		
		private function stageTouchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase==TouchPhase.BEGAN){
				e.stopImmediatePropagation();
				pareVO.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
			}
		}
		
		private function sureBtnHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase==TouchPhase.BEGAN){
				e.stopImmediatePropagation();
				var infoStr:String = StringUtil.trim(searchTxt.text);
				
				if(infoStr !=""){		
					sendInfo(infoStr);
				}else{
					sendNotification(CoreConst.TOAST,new ToastVO("请输入您想要看电影"));
				}
			}
			
		}
		
		protected function searchFocusInHandler(event:FocusEvent):void
		{
			sendNotification(SoftKeyBoardConst.KEYBOARD_HASBG,0x0C92B7);//键盘带背景
		}
		
		protected function searchDownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == 13) {//回车
				e.preventDefault();
				e.stopImmediatePropagation();
				var infoStr:String = StringUtil.trim(searchTxt.text);
				if(infoStr !=""){																
					sendInfo(infoStr);
				}else{
					sendNotification(CoreConst.TOAST,new ToastVO("请输入您想要看电影"));
				}
			}
		}
		
		private function sendInfo(infoStr:String):void{
			/*PackData.app.CmdIStr[0] = CmdStr.Send_FAQ_Info;
			PackData.app.CmdIStr[1] = "150";
			PackData.app.CmdIStr[2] = '电影许愿';//菜单名称
			PackData.app.CmdIStr[3] = infoStr+"(id:"+PackData.app.head.dwOperID.toString()+")";
			PackData.app.CmdInCnt = 4;*/
			PackData.app.CmdIStr[0] = CmdStr.SEND_FAQ_TRANSLATION;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] =  '电影许愿';//菜单名称
			PackData.app.CmdIStr[3] = '0';
			PackData.app.CmdIStr[4] = 'H';
			PackData.app.CmdIStr[5] = infoStr;
			PackData.app.CmdInCnt = 6;	
			sendNotification(CoreConst.SEND_11,new SendCommandVO(HOPE_VIDEO));	//派发调用绘本列表参数，调用后台
		}
		
		
		
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			pareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case HOPE_VIDEO:
					if(PackData.app.CmdOStr[0] == "000"){
						sendNotification(CoreConst.TOAST,new ToastVO("已收到您的许愿,我们会尽快帮你实现。"));
					}else{
						sendNotification(CoreConst.TOAST,new ToastVO("通信有误,请稍后再用。"));
					}
					if(searchTxt){
						searchTxt.text = "";
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [HOPE_VIDEO];
		}
		
	}
}