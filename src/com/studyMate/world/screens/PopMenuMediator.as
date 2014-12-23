package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.SimpleScriptNewProxy;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.LayoutToolUtils;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	import fl.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class PopMenuMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "PopMenuMediator";
		
		
		private var prepareVO:SwitchScreenVO;
		private var shape:Shape;
		private var  word:String = "";
		private var tf:TextFormat;

		private var checkBtn:Button;
		private var checkSentence:Button;
		
		public function PopMenuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void{
			shape = new Shape();
			shape.graphics.beginFill(0x999999);
			shape.graphics.drawRoundRect(0,0,105,55,20);
			shape.graphics.endFill();
			view.addChild(shape);
			view.addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);

			tf = new TextFormat("HeiTi",26,0x8080FF,true);
			
			checkBtn = new Button();
			checkBtn.label = "查字典";
			checkBtn.width = 105;
			checkBtn.height = 55;
			checkBtn.setStyle("textFormat", tf);
			checkBtn.x = 0;
			checkBtn.y = 0;
			checkBtn.addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);			
			view.addChild(checkBtn);
			checkBtn.addEventListener(MouseEvent.MOUSE_DOWN,checkWord);
			
			sendNotification(WorldConst.GET_SCREEN_FAQ);	//查询界面										
		}
		
		private var screenStr:String;
		private var sentenceStr:String;
		protected function checkSentenceHandler(event:MouseEvent):void
		{
			var inputStr:String = StringUtil.trim(sentenceStr);
			if(inputStr!=""){
				var noteArr:Array = SimpleScriptNewProxy.getScriptByTab("<TEXT2>","</TEXT2>",LayoutToolUtils.script);
				var SentenceArr:Array = sentenceStr.match( /(\(\d*\.\d*\))/);
				if(SentenceArr!=null && SentenceArr.length>0 && noteArr!=null && noteArr.length>0){
					var flagStr:String = SentenceArr[0];
					flagStr = flagStr.substr(0,1)+'@'+flagStr.substr(1);//(@1.2)
					flagStr = flagStr.replace("(","<");
					flagStr = flagStr.replace(")",'>');
//					trace(flagStr);
					
					var targetStr:String = noteArr[0];
					var start:int = targetStr.indexOf(flagStr);
					var result:String='';
					if(start!=-1){
						var end:int = targetStr.indexOf('<@@>',start);
						if(end!=-1){
							result = targetStr.substring(start,end);							
						}else{
							result = targetStr.substr(start);
						}
					}
					if(result.length>0){
						PackData.app.CmdIStr[0] = CmdStr.SEND_FAQ_TRANSLATION;
						PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
						PackData.app.CmdIStr[2] = '查句意(已译)'+screenStr;//菜单名称
						PackData.app.CmdIStr[3] = '0';
						PackData.app.CmdIStr[4] = 'H';
						PackData.app.CmdIStr[5] = sentenceStr;
						PackData.app.CmdInCnt = 6;	
						sendNotification(CoreConst.SEND_1N,new SendCommandVO(''));	//派发调用绘本列表参数，调用后台
						
//						stageDownHandler();
						var data:Object = {title:inputStr,content:result};
						if(!facade.hasMediator(SentenceDictionaryMediator.NAME)){
							prepareVO.type = SwitchScreenType.HIDE;
							sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO,new SwitchScreenVO(SentenceDictionaryMediator,data,SwitchScreenType.SHOW,AppLayoutUtils.cpuLayer)]);
						}
						return;
					}
				}
				
				PackData.app.CmdIStr[0] = CmdStr.Send_FAQ_Info;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = '查句意：'+screenStr;//菜单名称
				PackData.app.CmdIStr[3] = sentenceStr;
				PackData.app.CmdInCnt = 4;	
				sendNotification(CoreConst.SEND_1N,new SendCommandVO('SEND_FAQ_SUCCED'));	//派发调用绘本列表参数，调用后台
				
				sendNotification(CoreConst.TOAST,new ToastVO("该句尚未翻译,我们会尽快解答,请在FAQ中查看."));
			}else{
				sendNotification(CoreConst.TOAST,new ToastVO("只可查询文章中带序号的句子."));
			}
		}
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case WorldConst.SET_SCREENT_FAQ:
					screenStr = notification.getBody() as String;
					if(screenStr.indexOf("阅读界面")==0){
						if(checkSentence==null){
							shape.width = 214;
							checkSentence = new Button();
							checkSentence.label = "查句意";
							checkSentence.width = 105;
							checkSentence.height = 55;
							checkSentence.setStyle("textFormat", tf);
							checkSentence.x = 108;
							view.addChild(checkSentence);
							checkSentence.addEventListener(MouseEvent.MOUSE_DOWN,checkSentenceHandler);
						}
					}					
					break;
				case WorldConst.CHECK_SENTENCE:
					sentenceStr = notification.getBody() as String;
					var i:int = sentenceStr.indexOf('\r');
					if(i>1){
						sentenceStr = sentenceStr.substr(0,i);
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.SET_SCREENT_FAQ,WorldConst.CHECK_SENTENCE];
		}
		
		private function addedToStageHandler(e:Event):void{
			checkBtn.removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN,stageDownHandler,false,10);
		}
		
		private function stageDownHandler(e:MouseEvent=null):void{
		//	e.stopImmediatePropagation();
			Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageDownHandler);
			exit();
		}
		private function removedFromStageHandler(e:Event):void
		{
			if(Global.stage.hasEventListener(MouseEvent.MOUSE_DOWN))
				Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageDownHandler);
		}
		
	
		private function exit():void{			
			prepareVO.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);	
		}
		private function checkWord(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			if(!facade.hasMediator(DictionaryMediator.NAME)){
				prepareVO.type = SwitchScreenType.HIDE;
				sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO,new SwitchScreenVO(DictionaryMediator,word,SwitchScreenType.SHOW,AppLayoutUtils.cpuLayer)]);
				
			}
			else{
				sendNotification(DictionaryMediator.UPDATE_WORD,word);
			}
			
			stageDownHandler();
		}
				
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRemove():void{
			checkBtn.removeEventListener(MouseEvent.MOUSE_DOWN,checkWord);
			checkBtn.parent.removeChild(checkBtn);
			checkBtn = null;
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			prepareVO = vo;
			if(vo.data){
				if(vo.data is String){					
					word = vo.data.toString();
				}else{
					word = vo.data.selectWord;
					sentenceStr = vo.data.sentenceStr;
				}
			}			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
	}
}