package myLib.myTextBase.extendsFeather
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	import feathers.controls.text.StageTextTextEditor;
	import feathers.events.FeathersEventType;
	
	public class StageTextEditorExtends extends StageTextTextEditor implements ItextEditorExtends
	{
		public function StageTextEditorExtends()
		{
			super();
		}
		
		public function get stageTextField():StageTextFieldExtends{
			return this.stageText as StageTextFieldExtends;
		}
		
		public function get measureTextField():TextField{
			return _measureTextField;
		}
		
		/**
		 * @重写创建方法，剞劂flash.text.StageText搜狗输入法禁用不了
		 */
		override protected function createStageText():void
		{
			this._stageTextIsComplete = false;
			var StageTextType:Class;
			var initOptions:Object;
			StageTextType = StageTextFieldExtends;
			initOptions = { multiline: this._multiline };
			this.stageText = new StageTextType(initOptions);
			this.stageText.visible = false;
			this.stageText.addEventListener(flash.events.Event.CHANGE, stageText_changeHandler);
			this.stageText.addEventListener(KeyboardEvent.KEY_DOWN, stageText_keyDownHandler);
			this.stageText.addEventListener(KeyboardEvent.KEY_UP, stageText_keyUpHandler);
			this.stageText.addEventListener(FocusEvent.FOCUS_IN, stageText_focusInHandler);
			this.stageText.addEventListener(FocusEvent.FOCUS_OUT, stageText_focusOutHandler);
			this.stageText.addEventListener(flash.events.Event.COMPLETE, stageText_completeHandler);
			this.invalidate();
		}
		
		override protected function stageText_focusOutHandler(event:FocusEvent):void
		{
			this._stageTextHasFocus = false;
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.invalidate(INVALIDATION_FLAG_SKIN);
			this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}
		public function get selectionAnchorPosition():int
		{
			return stageTextField.selectionAnchorIndex;
		}
		
		
		
		
		public function get selectionActivePosition():int
		{
			return stageTextField.selectionActiveIndex;
			
		}
		
		public function insertText(value:String):void
		{
//			trace(text.substring(0,selectionAnchorPosition));
//			trace(text.substring(selectionActivePosition));
//			super.text = text.substring(0,selectionAnchorPosition)+value+text.substring(selectionActivePosition);
//			this.stageText.text = super.text;
			
			stageTextField.insertText(value);
			super.text = stageTextField.text;
		}
		
	
	}
}