package com.studyMate.module.engLearn
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.engLearn.api.FastLearnConst;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * 快速进入学习的入口,包含学单词，阅读，口语
	 * @author wt
	 * 
	 */	
	public class FastLearnMediator extends ScreenBaseMediator
	{
		private var input:TextFieldHasKeyboard;//口语
		private var input1:TextFieldHasKeyboard;//阅读
		private var input2:TextFieldHasKeyboard;//学单词
		
		
		public function FastLearnMediator( viewComponent:Object=null)
		{						
			super(ModuleConst.FAST_LEARN, viewComponent);
		}
		override public function onRemove():void
		{
			input.removeEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);
			Starling.current.nativeOverlay.removeChild(input);
			
			input1.removeEventListener(KeyboardEvent.KEY_DOWN,input1TXTKeyDownHandler);
			Starling.current.nativeOverlay.removeChild(input1);
			
			input2.removeEventListener(KeyboardEvent.KEY_DOWN,input1TXTKeyDownHandler);
			Starling.current.nativeOverlay.removeChild(input2);
			super.onRemove();
		}
		
		override public function onRegister():void
		{
			var bg:Quad = new Quad(1280,752,0);
			bg.alpha = 0.5;
			view.addChild(bg);
			
			var txt:TextField = new TextField(200,70,"请输入口语标识","HeiTi",22);
			txt.x = 300;
			txt.y = 200;
			view.addChild(txt);
			
			var tf:TextFormat = new TextFormat("HeiTi",33,0xFFFFFF);
			input = new TextFieldHasKeyboard();
			input.width = 300;
			input.height = 70;
			input.embedFonts = true;
			input.defaultTextFormat = tf;
			input.x = 550;
			input.y = 200;
			input.border = true;
			Starling.current.nativeOverlay.addChild(input);
			input.addEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);
			
			var txt1:TextField = new TextField(200,70,"请输入阅读标识","HeiTi",22);
			txt1.x = 300;
			txt1.y = 350;
			view.addChild(txt1);
			
			input1 = new TextFieldHasKeyboard();
			input1.width = 300;
			input1.height = 70;
			input1.embedFonts = true;
			input1.defaultTextFormat = tf;
			input1.x = 550;
			input1.y = 350;
			input1.border = true;
			Starling.current.nativeOverlay.addChild(input1);
			input1.addEventListener(KeyboardEvent.KEY_DOWN,input1TXTKeyDownHandler);
			
			
			var txt2:TextField = new TextField(200,70,"请输入学单词标识","HeiTi",22);
			txt2.x = 300;
			txt2.y = 500;
			view.addChild(txt2);
			
			input2 = new TextFieldHasKeyboard();
			input2.width = 300;
			input2.height = 70;
			input2.embedFonts = true;
			input2.defaultTextFormat = tf;
			input2.x = 550;
			input2.y = 500;
			input2.border = true;
			input2.text = "yy.W.";
			Starling.current.nativeOverlay.addChild(input2);
			input2.addEventListener(KeyboardEvent.KEY_DOWN,input2TXTKeyDownHandler);
			
			sendNotification(SoftKeyBoardConst.USE_SIMPLE_KEYBOARD,true);	
		}
		//学单词
		protected function input2TXTKeyDownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == 13) {//回车
				var str:String = StringUtil.trim(input2.text)
				
				sendinServerInofFunc(CmdStr.OBTAIN_WORD_LIST_THE,FastLearnConst.GET_WORD_TEST,[str],true);
			}
		}
		//口语
		private function inputTXTKeyDownHandler(e:KeyboardEvent):void {
			if(e.keyCode == 13) {//回车
				var str:String = StringUtil.trim(input.text)

				sendinServerInofFunc(CmdStr.GET_YYOralById,FastLearnConst.GET_SPOKEN_TEST,["@y.O",str]);
				//sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SpokenGpuMediator,data)]);
			}
		}
		
		//阅读
		private function input1TXTKeyDownHandler(e:KeyboardEvent):void {
			if(e.keyCode == 13) {//回车				
				var str:String = StringUtil.trim(input1.text)
				sendinServerInofFunc(CmdStr.GET_READING_TEXT,FastLearnConst.GET_READ_TEST,[str]);//根据id获取文章
			}
		}
		
		private function sendinServerInofFunc(command:String,reveive:String,infoArr:Array,Send_1N:Boolean = false):void{
			PackData.app.CmdIStr[0] = command;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+2] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+2;	
			if(Send_1N){
				sendNotification(CoreConst.SEND_1N,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台
				
			}else{
				sendNotification(CoreConst.SEND_11,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台
			}
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case FastLearnConst.GET_SPOKEN_TEST:
					if(PackData.app.CmdOStr[0] == "000"){//口语检测
						var data:Object = new Object();
						var str:String = StringUtil.trim(input.text);
						data.oralid = str;
						data.rrl = '';
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SpokenNewMediator,data)]);
					}
					break;
				case FastLearnConst.GET_READ_TEST://第二部获取阅读文本
					if(PackData.app.CmdOStr[0] == "000"){
						var data1:Object = new Object();
						var str1:String = StringUtil.trim(input1.text);
						data1.readId = str1;
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ReadBGMediator,data1),new SwitchScreenVO(CleanCpuMediator)]);
					}
					break;
				case FastLearnConst.GET_WORD_TEST:
					if((PackData.app.CmdOStr[0] as String).charAt(0)=="!"){
						var data2:Object = new Object();
						data2.rrl = StringUtil.trim(input2.text);
						sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WordLearningBGMediator,data2),new SwitchScreenVO(CleanCpuMediator)]);
					
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{			
			return [FastLearnConst.GET_SPOKEN_TEST,FastLearnConst.GET_READ_TEST,FastLearnConst.GET_WORD_TEST];
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
	}
}