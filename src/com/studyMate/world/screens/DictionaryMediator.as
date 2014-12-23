package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.ReadTextVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.SoundVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.model.vo.AlertVo;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import mx.utils.StringUtil;
	
	import fl.controls.TextArea;
	
	import myLib.myTextBase.TextFieldHasKeyboard;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;

	public class DictionaryMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "DictionaryMediator";	
		
		public static const UPDATE_WORD:String = NAME+"updateWord";
		public const GET_WORD_MEANING:String = "getWordMeaning";
		public  var prepareVO:SwitchScreenVO;
		
		private var startDragBtn:SimpleButton;
		private var closeBtn:Sprite;
		private var confirmBtn:Sprite;
		private var searchBtn:Sprite;
		private var inputTxt:TextFieldHasKeyboard;
		private var readBtn:SimpleButton;
		private var dic_content:TextArea;
		private var detailContent:String = "";
		private var url:String = "";
		private var position:uint;
		private var duration:uint;
		private var soundVO:SoundVO;
		
		public static var title:String = "";
		public static var content:String = "";
				
		public function DictionaryMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
			TweenLite.killDelayedCallsTo(changeFocus);
			sendNotification(CoreConst.SOUND_STOP);
			Starling.current.stage.touchable = true;
			readBtn.removeEventListener(MouseEvent.CLICK,readHandler);
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,StageMouseUpHandler);
			view.removeChildren();
			readBtn = null;
			super.onRemove();
		}
		override public function onRegister():void
		{										
			var bgClass:Class =  AssetTool.getCurrentLibClass("ui_dic_bg3");//右上角退出图片
			var bg:Sprite = new bgClass;
			view.addChild(bg);
		
			closeBtn = bg.getChildByName("closeBtn") as Sprite;
			startDragBtn = bg.getChildByName("startDragBtn") as SimpleButton;
			readBtn = bg.getChildByName("readBtn") as SimpleButton;
			
			
			var textformat:TextFormat = new TextFormat("comic",30);
			var textformat1:TextFormat = new TextFormat("HeiTi",24);
			inputTxt = new TextFieldHasKeyboard();
			inputTxt.x = 140;
			inputTxt.y = 99;
			inputTxt.maxChars = 25;
			inputTxt.width = 366;
			inputTxt.height = 44;
			inputTxt.defaultTextFormat = textformat;
			
			dic_content = bg.getChildByName("dic_content") as TextArea;
			dic_content.setStyle("upSkin",new Sprite);
			dic_content.setStyle("textFormat",textformat1);
			dic_content.setStyle("antiAliasType",AntiAliasType.ADVANCED);			
			dic_content.editable = false;

			closeBtn.addEventListener(MouseEvent.CLICK,removeHandler);
			readBtn.addEventListener(MouseEvent.CLICK,readHandler);
			startDragBtn.addEventListener(MouseEvent.MOUSE_DOWN,startDragMouseDownHandler);
			
			var word:String = prepareVO.data.toString();
			getWordCommand(word);
			sendNotification(WorldConst.DICTIONARY_SHOW);		
			inputTxt.addEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);			
			
			sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
			sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,false);
			
			bg.addChild(inputTxt);
			sendNotification(SoftKeyBoardConst.KEYBOARD_HASBG,0xF3E8C7);//键盘带背景
			
			Starling.current.stage.touchable = false;
			view.x = (Global.stage.stageWidth-view.width)/2;
			view.y = (Global.stage.stageHeight-view.height)/2;
			
			trace("@VIEW:DictionaryMediator:");
		}
		
		protected function startDragMouseDownHandler(event:MouseEvent):void
		{
			view.startDrag(false,new Rectangle(-400,-40,1600,750));
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,StageMouseUpHandler);
		}		
		
		protected function StageMouseUpHandler(event:MouseEvent):void
		{
			view.stopDrag();
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,StageMouseUpHandler);
		}
		
		
		protected function inputTXTKeyDownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == 13) {//回车
				e.preventDefault();
				e.stopImmediatePropagation();
				getWordCommand(StringUtil.trim(inputTxt.text));
//				sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
			}
		}
		
		private	var reg:RegExp =  /[\一-\龥]/;
		private var currendWord:String;
		public function getWordCommand(word:String):void{
			if(word!='' && word!=null){	
				if(reg.test(word)){
					sendNotification(CoreConst.TOAST,new ToastVO("暂时只支持英文翻译,请勿包含中文"));
					return;
				}
				if(currendWord!=word){
					currendWord = word;				
				}else{
					return;
				}
				PackData.app.CmdIStr[0] = CmdStr.SELECT_WORD_ORIG;
				PackData.app.CmdIStr[1] = word;
				PackData.app.CmdIStr[2] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdInCnt = 3;
				sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_WORD_MEANING,null,'cn-gb',null,SendCommandVO.QUEUE|SendCommandVO.UNIQUE));
			}else{
				inputTxt.text = '';
				TweenLite.killDelayedCallsTo(changeFocus);
				TweenLite.delayedCall(0.5,changeFocus);	
			}
		}
		private function changeFocus():void
		{
			inputTxt.setFocus();
		}
		override public function handleNotification(notification:INotification):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO('s '+notification.getName(),"DictionaryMediator",0));

			var _name:String = notification.getName();
			switch(_name){
				case GET_WORD_MEANING:
					var name:Array = PackData.app.CmdOStr as Array;
					if(name[0]=="000"){
						title = name[2];
						var meaning:String = name[14];
						meaning = meaning.replace(/\^+/g,"\n");
						//单词、音标、单词意思、记忆法
						if(title==""){
							content =  name[2]+" "+MyUtils.toSpell2(name[13])+"\n"+ meaning+"\n"+ name[16];
							detailContent = (name[15] as String).replace(/\^+/g,"\n");
						}else{
							content =  name[2]+" "+MyUtils.toSpell(name[13])+"\n"+ meaning+"\n"+ name[16];
							detailContent = (name[15] as String).replace(/\^+/g,"\n");
						}
						url = name[12] as String;
						var _position:int = formatMilliSecond(name[18] as String);
						position = _position;
						duration = formatMilliSecond(name[19] as String)-_position;
						
						inputTxt.text = title;
						dic_content.text = content+'\n附加含义: \n'+detailContent;	
						
					}else {//所有异常处理，都显示查不到该单词即可
						/*title = "没有查到该单词.";
						content = name[0]+"\n"+name[14]+"\n"+name[1]+"\n"+name[2]+"\n"+name[13]+"\n"+name[16];
						detailContent = (name[15] as String).replace(/\^+/g,"\n");*/
						var word:String = prepareVO.data.toString();
						inputTxt.text = word;
						dic_content.text = "\n 抱歉!没有查到该单词。";
					}
									
					break;
				case UPDATE_WORD:
					var wordStr:String = notification.getBody() as String;
					getWordCommand(StringUtil.trim(wordStr));
					break;
				
				
				case SoftKeyBoardConst.NO_KEYBOARD:
					Starling.current.stage.touchable = false;
					break;
			}
			
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO('e '+notification.getName(),"DictionaryMediator",0));

		}				
		override public function listNotificationInterests():Array{
			return [GET_WORD_MEANING,SoftKeyBoardConst.NO_KEYBOARD,UPDATE_WORD];
		}
		//_time--mm:ss.nnn
		private function formatMilliSecond(time:String):int{
			var millisecond:int;
			var second:int;
			var minute:int;
			var hour:int;
			var index:int;
			if(time != "" && time.indexOf(":")>0){			
				index = time.lastIndexOf('.');
				millisecond = parseInt(time.substr(index+1));
				
				var arr:Array = time.substring(0,index).split(':');
				second = arr.pop()*1000;
				minute = arr.pop()*60*1000;
				if(arr.length>0){
					hour = arr.pop()*60*60*1000;
				}
			}
			
			return millisecond+second+minute+hour;
		}
			
		private function removeHandler(e:Event):void{
			prepareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
			trace("@VIEW:FullScreenMenuMediator:");
		}
		private function searchHandler(e:Event):void{
			getWordCommand(inputTxt.text);
		}
		private function readHandler(e:Event):void{
			//Android平台调用TTS才能朗读
			/*if(Global.OS == OSType.ANDROID){
				sendNotification(ApplicationFacade.READ_TEXT,new ReadTextVO(dic_title.text,1,0.5));
			}else{
				//SkinnableAlert.show("Android平台才有此功能。","Tips");
			}*/
			
			
			if(url != "" &&url != "-1"){
				soundVO = new SoundVO("edu/mp3/ESOUND_" + url + ".mp3",position,duration);
				sendNotification(CoreConst.SOUND_PLAY,soundVO);
			}else{
				//后台没返回读音，由TTS提供
				//				Android平台调用TTS才能朗读
				if(Global.OS == OSType.ANDROID){
					sendNotification(CoreConst.TOAST,new ToastVO("抱歉,没有该单词读音"));
					sendNotification(CoreConst.READ_TEXT,new ReadTextVO(inputTxt.text,1,0.5));
				}else{
					//SkinnableAlert.show("Android平台才有此功能。","Tips");
//					sendNotification(WorldConst.ALERT_SHOW,new AlertVo("\nAndroid平台才有此功能!",false));//提交订单
					sendNotification(CoreConst.TOAST,new ToastVO("Android平台才有此功能!"));
				}
			}
		}
		
		private function detailHandler(e:MouseEvent):void{
			inputTxt.setSelection(0,inputTxt.length);
			dic_content.text = detailContent;
		}
		
		private function keyDownHandler(e:KeyboardEvent):void{
			if(e.keyCode==Keyboard.LEFT||e.keyCode==Keyboard.RIGHT){
				e.stopPropagation();
			}
			if(e.keyCode == 10||e.keyCode==13){
				searchHandler(null);
			}
		}		
		
		
		override public function prepare(vo:SwitchScreenVO):void{				
			prepareVO = vo;			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);			
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
	}
}