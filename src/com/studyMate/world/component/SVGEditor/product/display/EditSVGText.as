package com.studyMate.world.component.SVGEditor.product.display
{
	import com.lorentz.SVG.utils.SVGColorUtils;
	import com.lorentz.SVG.utils.SVGUtil;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditText;
	import com.studyMate.world.component.SVGEditor.utils.EditType;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
		
	internal class EditSVGText extends EditSVGBase implements IEditText
	{
		private var tf:TextFormat;
		private var _text:String = "";
		private var myWidth:Number;
		protected var textField:TextField;		
		
		public function EditSVGText(){
			this.type = EditType.text;
			tf = new TextFormat();			
		}
		
		
		public function get text():String
		{
			if(textField){
				return textField.text;
				
			}else
				return '';
		}

		public function set text(value:String):void
		{
			needUpdate = true;
			_text = value;
		}

		override public function getElementXML():XML
		{
			var xml:XML = <text></text>;
			setXML(xml);	
			if(textField){
				
				xml.@width = textField.width;
			}
			var temp:String = text;
			if(StringUtil.trim(temp)==''){				
				temp = '';
			}else{
				
				temp = temp.replace(/\n|\r|\t/g, "<br/>");	
			}
			xml.children()[0] = SVGUtil.prepareXMLText(temp);
			return xml;
		}
		
		override protected function doubleClickHandler(event:MouseEvent):void
		{
			super.doubleClickHandler(event);
			if(textField){
				Global.stage.focus = textField;
				textField.setSelection(0,textField.length);
				textField.needsSoftKeyboard = true;
				textField.requestSoftKeyboard();			
			}
			
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,true);
		}
		

		override protected function render(e:Event=null):void
		{		
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,true);
			var temp:String = _text;
			temp = 	temp.replace(/<br\/>/g,"\n");				
			if(textField==null){
				textField = new TextField();
				textField.type = TextFieldType.INPUT;
				textField.addEventListener(KeyboardEvent.KEY_DOWN,txtKeyDownHandler,false,1);
				textField.addEventListener(Event.CHANGE,changeHandler);
				textField.border = true;
				textField.borderColor = 0x8080FF;
				textField.wordWrap = true;
				textField.multiline = true;
				textField.embedFonts = true;	
				textField.antiAliasType = AntiAliasType.ADVANCED;
				/*if(tf.font!=null){
				}*/
				textField.defaultTextFormat = tf;
				textField.autoSize = TextFieldAutoSize.LEFT;
				this.addChild(textField);
				if(myWidth){
					textField.width = myWidth;
				}
				
				
			}else{
				textField.defaultTextFormat = tf;	
				textField.setTextFormat(tf);
			}
			textField.text = temp;		
			if(hasAttribute("width")){//文本宽高没用
				textField.width = Number(getAttribute("width"));
			}
			/*if(hasAttribute("height")){
				textField.height = int(getAttribute("height"));
			}*/
			if(dragRect){
				dragRect.width = this.myWidth;
				dragRect.height = this.height;
			}
			super.render(e);
		}
		
		protected function txtKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.TAB){
				event.preventDefault();
				event.stopImmediatePropagation();
				
				textField.replaceText(textField.selectionBeginIndex,textField.selectionEndIndex,'　　');
				trace("侦测到tab键盘");
			}
		}
		
		protected function changeHandler(event:Event):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(SVGConst.PROPERTIES,this);
		}
		
		override public function setAttribute(name:String, value:Object):void
		{
			super.setAttribute(name, value);
			switch(name){
				case "font-family":
					tf.font = String(value);					
					break;
				case "font-size":
					tf.size = value;
					break;
				case "fill":
					tf.color = SVGColorUtils.parseToUint(String(value));
					break;
				case "width":
					myWidth = Number(value);
					break;
			}			
			
		}		
	}
}