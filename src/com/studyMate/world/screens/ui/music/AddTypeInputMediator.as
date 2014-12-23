package com.studyMate.world.screens.ui.music
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.screens.ExchangeMusicMediator;
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
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class AddTypeInputMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "AddTypeInputMediator";
		
		public static const ADD_TYPE_SECCEED:String = NAME + "ADD_TYPE_SECCEED";
		
		private var txtInput:TextFieldHasKeyboard;
		private var ADD_TYPE_RESULT:String = NAME + "ADD_TYPE_RESULT";
		private var pareVO:SwitchScreenVO;
		private var yesBtn:Button;		
		private var info:String='';
		
		public function AddTypeInputMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		
		override public function onRegister():void{
			facade.retrieveMediator(ExchangeMusicMediator.NAME).getViewComponent().touchable = false;
			
			view.x = 290;
			view.y = 210;
			var bg:Image = new Image(Assets.getMusicSeriesTexture("addTypeAlert"));			
			bg.y = 8;
			
			/*var delBtn:Button = new Button(Assets.getMusicSeriesTexture("delIcon"));
			delBtn.x = 417;*/
			
			yesBtn = new Button(Assets.getMusicSeriesTexture("yesButtonIcon"));
			yesBtn.x = 190;
			yesBtn.y = 145;
			
			var tf:TextFormat = new TextFormat("HeiTi",36,0xFFFFFF);
			
			txtInput = new TextFieldHasKeyboard();
			txtInput.restrict = "^`\/";
			txtInput.antiAliasType = AntiAliasType.ADVANCED;
			txtInput.embedFonts = true;
			txtInput.x = 340;
			txtInput.y = 274;
			txtInput.maxChars = 7;
			txtInput.width = 390;
			txtInput.height = 54;
			txtInput.defaultTextFormat = tf;
			txtInput.prompt = "请输入新类名"
						
			view.addChild(bg);
			//view.addChild(delBtn);
			view.addChild(yesBtn);
			Starling.current.nativeOverlay.addChild(txtInput);
			
			txtInput.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			txtInput.addEventListener(FocusEvent.FOCUS_IN,txtInputFocusInHandler);
			yesBtn.addEventListener(TouchEvent.TOUCH,yesTounchHandler);
			view.addEventListener(TouchEvent.TOUCH,thisTounchHandler);
			//delBtn.addEventListener(TouchEvent.TOUCH,stageTounchHandler);
			view.stage.addEventListener(TouchEvent.TOUCH,stageTounchHandler);
			//txtInput.setFocus();	
		}
		
		protected function txtInputFocusInHandler(event:FocusEvent):void
		{
			// TODO Auto-generated method stub
			//txtInput.selectRange(0,txtInput.text.length);
			sendNotification(SoftKeyBoardConst.KEYBOARD_HASBG,0x0C92B7);//键盘带背景
		}
		
		protected function keyDownHandler(e:KeyboardEvent):void{
			if(e.keyCode == 13) {//回车
				e.preventDefault();
				e.stopImmediatePropagation();
				result();
			}
		}
		private function yesTounchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase==TouchPhase.BEGAN){
				e.stopImmediatePropagation();
				result();
			}
		}
		private function thisTounchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase==TouchPhase.BEGAN){
				e.stopImmediatePropagation();
			}
		}
		private function result():void{
			info = StringUtil.trim(txtInput.text);
			if(info.length>0){					
				yesBtn.removeEventListener(TouchEvent.TOUCH,yesTounchHandler);
				sendinServerInofFunc(CmdStr.DEL_RESOURCE,ADD_TYPE_RESULT,["UMGI",PackData.app.head.dwOperID.toString(),Global.user,"0","",PackData.app.head.dwOperID.toString(),info,"MUSIC",""])
			}
		}
		private function stageTounchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase==TouchPhase.BEGAN){
				e.stopImmediatePropagation();
				pareVO.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
			}			
		}
		private function sendinServerInofFunc(command:String,reveive:String,infoArr:Array):void{
			PackData.app.CmdIStr[0] = command;
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+1] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+1;	
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台
		}
		override public function onRemove():void{
			facade.retrieveMediator(ExchangeMusicMediator.NAME).getViewComponent().touchable = true;
			view.stage.removeEventListener(TouchEvent.TOUCH,stageTounchHandler);
			txtInput.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			txtInput.removeEventListener(FocusEvent.FOCUS_IN,txtInputFocusInHandler);
			Starling.current.nativeOverlay.removeChild(txtInput);
			view.removeChildren(0,-1,true);
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case ADD_TYPE_RESULT:
					if((PackData.app.CmdOStr[0] as String)=="000"){
						trace("分类 成功 表示"+(PackData.app.CmdOStr[1] as String));
						sendNotification(ADD_TYPE_SECCEED,["",PackData.app.CmdOStr[1],"",info]);
					}
					pareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [ADD_TYPE_RESULT];
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
	}
}