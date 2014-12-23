package myLib.myTextBase
{
	import com.mylib.framework.CoreConst;
	import myLib.myTextBase.extendsFeather.ItextEditorExtends;
	import myLib.myTextBase.extendsFeather.StageTextEditorExtends;
	import myLib.myTextBase.interfaces.ITextInputGpu;
	import myLib.myTextBase.utils.KeyBoardConst;
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.Event;
	

	/**
	 * GPU 层输入调用键盘
	 * 
	 * 增加的属性
	 * @ useKeyboard 是否使用软键盘，默认true
	 * @ useDefaultSkin 是否使用默认皮肤。默认不使用
	 * @ selectionAnchorPosition 
	 * @ selectionActivePosition
	 * 
	 * @author wt
	 * 
	 */	

	public class GpuTextInput extends TextInput implements ITextInputGpu	
	{
		private var _useKeyboard:Boolean; //是否启用软键盘,true使用，false不使用
		private var textEditorExtends:ItextEditorExtends;
		
		public var useDefaultSkin:Boolean;
		public var stageTextField:StageTextEditorExtends = new StageTextEditorExtends();
		private var tf:TextFormat;
		
		public function GpuTextInput()
		{
			
			useKeyboard = true;
			this._textEditorFactory = extendsEditor;										
			super();	
					
//			this.addEventListener(FeathersEventType.ENTER,inputHandle);
		}
	/*	
		private function inputHandle(e:starling.events.Event):void
		{
			if(!Global.manualLoading){
				if(!Global.isLoading){						
					this.dispatchEvent(new EDUKeyboardEvent(EDUKeyboardEvent.ENTER));
				}
			}else{
				this.dispatchEvent(new EDUKeyboardEvent(EDUKeyboardEvent.ENTER));
			}
		}*/
		public function setTextFormat(_val:TextFormat):void{
			tf = _val;
		}
		
		private function extendsEditor():ItextEditorExtends{
//			stageTextField = new StageTextEditorExtends();
			
			if(tf){
				stageTextField.fontFamily = tf.font;
				stageTextField.fontSize = int(tf.size);
				stageTextField.color = uint(tf.color);
				var boldFontDescription:FontDescription = new FontDescription(tf.font,FontWeight.NORMAL,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
				this.promptProperties.elementFormat = new ElementFormat(boldFontDescription, int(tf.size), uint(tf.color));
			}else{
				stageTextField.fontFamily = "HeiTi";
				stageTextField.fontSize = 25;
				stageTextField.color = 0;
				boldFontDescription = new FontDescription("HeiTi",FontWeight.NORMAL,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
				this.promptProperties.elementFormat = new ElementFormat(boldFontDescription, 25, 0);
			}

			return stageTextField;
		}
		
		override protected function refreshTextEditorProperties():void
		{
			if(useDefaultSkin){				
				super.refreshTextEditorProperties();
			}else{
				this.textEditor.displayAsPassword = this._displayAsPassword;
				this.textEditor.maxChars = this._maxChars;
				this.textEditor.restrict = this._restrict;
				this.textEditor.isEditable = this._isEditable;
			}
		}
		
		
		override protected function createTextEditor():void
		{
			super.createTextEditor();
			textEditorExtends = textEditor as ItextEditorExtends;	
			this.textEditorExtends.stageTextField.textField.addEventListener(MouseEvent.MOUSE_UP,triggerdHandler);
			if(_useKeyboard){
				this.textEditorExtends.stageTextField.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,Keyboard_Activating_Handler,false,0,true);
			}
		}
		
		override protected function layoutChildren():void
		{
			super.layoutChildren();
			this.textEditor.x = 0;
			this.textEditor.y = 0;
			this.textEditor.width = this.actualWidth;
			this.textEditor.height = this.actualHeight;
			
			if(currentState=="focused"){
				if(!_useKeyboard){
					if(this.textEditorExtends){
						if(this.textEditorExtends.stageTextField){
							this.textEditorExtends.stageTextField.textField.needsSoftKeyboard = true;
							this.textEditorExtends.stageTextField.textField.requestSoftKeyboard();
						}
					}
				}
			}
		}
		
		
		protected function triggerdHandler(event:flash.events.Event):void
		{
			this.dispatchEvent(new starling.events.Event(starling.events.Event.TRIGGERED));
		}
		

		override protected function textInput_removedFromStageHandler(event:starling.events.Event):void{
//			TweenLite.killDelayedCallsTo(super.focusOutHandler);
//			TweenLite.killDelayedCallsTo(super.textEditor_focusOutHandler);
			Facade.getInstance(CoreConst.CORE).sendNotification(SoftKeyBoardConst.RESET_SORFTKEYBOARD);	
			KeyBoardConst.current_Textinput = null;
//			useKeyboard = false;
			
			super.textInput_removedFromStageHandler(event);
		}
		
		override protected function refreshBackgroundSkin():void
		{
			// TODO Auto Generated method stub
			if(useDefaultSkin){
				
				super.refreshBackgroundSkin();
			}
		}
		
		
		
		private function focusInHandler2(e:starling.events.Event):void{
			if(useKeyboard){
				KeyBoardConst.current_Textinput = this;
				Facade.getInstance(CoreConst.CORE).sendNotification(KeyBoardConst.CHANGE_KEYBORD);
			}
		}
		
		public function get selectionAnchorPosition():int
		{
			return this.textEditorExtends.selectionActivePosition;
		}
		
		public function get selectionActivePosition():int
		{
			return this.textEditorExtends.selectionActivePosition;
		}
		
		
		public function get useKeyboard():Boolean {
			return _useKeyboard;
		}
		
		public function selectTextRange(startIndex:int, endIndex:int =-1):void
		{
			if(endIndex < 0){
				endIndex = startIndex;
			}
			if(startIndex<0){
				startIndex = 0;
			}
			if(endIndex>this._text.length){
				endIndex = this._text.length;
			}
			super.selectRange(startIndex,endIndex);
		}
		
		
		
		public function set useKeyboard(value:Boolean):void {
			_useKeyboard=value;
			if(_useKeyboard){
				this.addEventListener(FeathersEventType.FOCUS_IN,focusInHandler2);
				if(this.textEditorExtends){
					if(this.textEditorExtends.stageTextField)
						this.textEditorExtends.stageTextField.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,Keyboard_Activating_Handler,false,0,true);
				}
			}else{
				this.removeEventListener(FeathersEventType.FOCUS_IN,focusInHandler2);	
				if(this.textEditorExtends){
					if(this.textEditorExtends.stageTextField)
						this.textEditorExtends.stageTextField.textField.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,Keyboard_Activating_Handler);
				}
			}
		}
		
		protected function Keyboard_Activating_Handler(event:SoftKeyboardEvent):void
		{
			if(useKeyboard){
				event.preventDefault();
			}
		}
		
		public function set needsSoftKeyboard(value:Boolean):void{
			if(value){
				if(this.textEditorExtends){
					if(this.textEditorExtends.stageTextField){
						this.textEditorExtends.stageTextField.textField.needsSoftKeyboard = true;
						this.textEditorExtends.stageTextField.textField.requestSoftKeyboard();
					}
				}
			}
			super.setFocus();
		}
		
		public function insertText(value:String):void
		{
			this.textEditorExtends.insertText(value);
			
		}
		override public function setFocus():void
		{
			super.setFocus();
			if(_useKeyboard){
								
			}else{
				if(this.textEditorExtends){
					if(this.textEditorExtends.stageTextField){
						this.textEditorExtends.stageTextField.textField.needsSoftKeyboard = true;
						this.textEditorExtends.stageTextField.textField.requestSoftKeyboard();
					}
				}
			}
			
		}

		
		
		//效率优化
		/*override protected function focusInHandler(event:starling.events.Event):void
		{
			TweenLite.killDelayedCallsTo(super.focusOutHandler);
			super.focusInHandler(event);
		}
		
		//效率优化
		override protected function focusOutHandler(event:starling.events.Event):void
		{
			TweenLite.killDelayedCallsTo(super.focusOutHandler);
			TweenLite.delayedCall(0.1,super.focusOutHandler,[event]);
		}
		
		override protected function textEditor_focusInHandler(event:starling.events.Event):void
		{
			TweenLite.killDelayedCallsTo(super.textEditor_focusOutHandler);
			super.textEditor_focusInHandler(event);
		}
		
		override protected function textEditor_focusOutHandler(event:starling.events.Event):void
		{
			TweenLite.killDelayedCallsTo(super.textEditor_focusOutHandler);
			TweenLite.delayedCall(0.2,super.textEditor_focusOutHandler,[event]);
		}*/
		
		
		
	}
}