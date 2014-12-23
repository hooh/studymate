package myLib.myTextBase
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import myLib.myTextBase.events.EDUKeyboardEvent;
	import myLib.myTextBase.interfaces.ITextInputCpu;
	import myLib.myTextBase.utils.KeyBoardConst;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
		
	public class TextFieldHasKeyboard extends TextField implements ITextInputCpu
	{		
		private var _useKeyboard:Boolean; //是否启用软键盘,true使用，false不使用
		
		
		private var hasPrompt:Boolean;
		private var promptTF:TextFormat;
		private var dfTF:TextFormat;
		private var promptStr:String="";
		
		public function TextFieldHasKeyboard()
		{
			KeyBoardConst.current_Textinput = null;
			useKeyboard = true;
			this.type = TextFieldType.INPUT;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStagedHandler);
			this.addEventListener(KeyboardEvent.KEY_DOWN,keyboardDownHandler);
		}
		
		protected function keyboardDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == 13){
				if(!Global.manualLoading){
					if(!Global.isLoading){						
						this.dispatchEvent(new EDUKeyboardEvent(EDUKeyboardEvent.ENTER));
					}
				}else{
					this.dispatchEvent(new EDUKeyboardEvent(EDUKeyboardEvent.ENTER));
				}
			}
		}
		private function addedToStageHandler(e:Event):void {
			dfTF = this.defaultTextFormat;
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			if(hasPrompt){
				this.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);				
			}
		}
		
		private function removeFromStagedHandler(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStagedHandler);
			useKeyboard = false;
			TweenLite.killDelayedCallsTo(actionTxt);
			this.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
			this.removeEventListener(KeyboardEvent.KEY_DOWN,keyboardDownHandler);
			Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.RESET_SORFTKEYBOARD);	
			KeyBoardConst.current_Textinput = null;
		}
		
		protected function Keyboard_Activating_Handler(event:SoftKeyboardEvent):void
		{
			if(useKeyboard){
				event.preventDefault();
			}
		}
		
		public var reg:RegExp ;
		public function set softKeyboardRestrict(value:RegExp):void{
			reg = value;
		}
		
		
		
		
		//实时检测硬键盘的开启状态
		private function focusInHandler(event:Event=null):void
		{
			if(useKeyboard){
				KeyBoardConst.current_Textinput = this;
				Facade.getInstance(CoreConst.CORE).sendNotification(KeyBoardConst.CHANGE_KEYBORD);
			}
			if(hasPrompt && super.text==promptStr){
				super.text = "";
				if(dfTF){					
					super.setTextFormat(dfTF);
					super.defaultTextFormat = dfTF;
				}
			}
		}
		
		private function focusOutHandler(event:FocusEvent):void{
			TweenLite.killDelayedCallsTo(actionTxt);
			TweenLite.delayedCall(0.2,actionTxt);	
		}
		private function actionTxt():void{
			if(hasPrompt && super.text==""){
				super.text = promptStr;
				if(promptTF)	super.setTextFormat(promptTF);
			}
		}
		override public function get text():String
		{
			if(hasPrompt && super.text ==promptStr){
				return "";
			}
			return super.text;
		}
		
		override public function set text(value:String):void
		{
			if(hasPrompt && value==""){
				//showDefaultTxt();
				super.text = promptStr;
				if(promptTF)	super.setTextFormat(promptTF);
				TweenLite.killDelayedCallsTo(actionTxt);
			}else{
				super.text = value;	
				if(dfTF){
					super.setTextFormat(dfTF);
					super.defaultTextFormat = dfTF;					
				}
			}
		}
		
		override public function set defaultTextFormat(format:TextFormat):void
		{
			super.defaultTextFormat = format;
			dfTF = format;
		}
		
		
		
		private function showDefaultTxt():void{
			super.text = promptStr;
		}
		
		/**
		 * 默认提示文本
		 * @param str
		 * 
		 */		
		public function set prompt(str:String):void{
			hasPrompt = true;
			if(promptTF==null){
				promptTF = new TextFormat("HeiTi",this.getTextFormat().size,0xE9DEBD,true);
			}
			if(promptStr!=str){
				promptStr = str;
				super.text = promptStr;
				super.setTextFormat(promptTF);
			}
		}
		
		
		
		public function get useKeyboard():Boolean {
			return _useKeyboard;
		}
		
		public function set useKeyboard(value:Boolean):void {
			_useKeyboard=value;
			if(_useKeyboard){
				this.addEventListener(FocusEvent.FOCUS_IN,focusInHandler);	
				this.addEventListener(MouseEvent.CLICK,focusInHandler);	
				this.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,Keyboard_Activating_Handler);
			}else{
				this.removeEventListener(MouseEvent.CLICK,focusInHandler);	
				this.removeEventListener(FocusEvent.FOCUS_IN,focusInHandler);		
				this.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,Keyboard_Activating_Handler);
			}
		}
		
		public function setFocus():void
		{
			if(this.stage){
				if(_useKeyboard){
					this.needsSoftKeyboard = true;
					this.requestSoftKeyboard();
				}
				this.stage.focus = this;
				//trace(super.text);
				if(hasPrompt && super.text==promptStr){
					super.text = "";
					if(dfTF){						
						this.setTextFormat(dfTF);
						super.defaultTextFormat = dfTF;
					}
				}
			}			
		}
		
		public function insertText(value:String):void
		{
			if(reg){
				if(!reg.test(value)){
					value ='';
				}				
			}
			super.replaceText(super.selectionBeginIndex,super.selectionEndIndex,value);
		}
		
		public function get selectionAnchorPosition():int
		{
			return super.selectionBeginIndex;
		}
		
		public function get selectionActivePosition():int
		{
			return super.selectionEndIndex;
		}
		
		public function selectTextRange(startIndex:int, endIndex:int =-1):void
		{
			if(endIndex < 0)
			{
				endIndex = startIndex;
			}
			super.setSelection(startIndex,endIndex);
		}
	}
}