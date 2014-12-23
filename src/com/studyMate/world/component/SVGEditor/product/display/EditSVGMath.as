package com.studyMate.world.component.SVGEditor.product.display
{
	import com.lorentz.SVG.utils.SVGUtil;
	import com.studyMate.global.Global;
	import myLib.myTextBase.TextFieldHasKeyboard;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditText;
	import com.studyMate.world.component.SVGEditor.utils.EditType;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;

	internal class EditSVGMath extends EditSVGBase implements IEditText
	{
		
		private var _text:String = "";
		private var textField:TextField;
		private var content:Sprite;
		
		public function EditSVGMath()
		{
			this.type = EditType.image;
			super();
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
			trace('set text');
		}
		override protected function doubleClickHandler(event:MouseEvent):void
		{
			super.doubleClickHandler(event);
			if(content){
				removeChild(content);
				content = null;
			}
			if(textField ==null){
				render();
			}
			if(!this.contains(textField)){
				this.addChild(textField);
			}
			if(textField){
				Global.stage.focus = textField;
				textField.setSelection(0,textField.length);
				textField.requestSoftKeyboard();
			}
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,true);
		}
		
		
		override public function getElementXML():XML
		{
			var xml:XML = <image></image>;
			xml.@id = id;
			xml.@x = x;
			xml.@y = y;		
			xml.@width = getAttribute("width");
			xml.@height = getAttribute("height");
			
			var xlink:Namespace = new Namespace("http://www.w3.org/1999/xlink");			
			var temp:String = text;
			temp = temp.replace(/\n|\r|\t/g, "<br/>");
			temp = temp.replace(/({\\kern\s1pt})/g,'~');
			temp = SVGUtil.prepareXMLText(temp);
			if(StringUtil.trim(temp)==''){
				xml.@xlink::href = '';
			}else{
				xml.@xlink::href ='formula:'+ temp;					
			}
			return xml;
		}
		
		
		
		override protected function render(e:Event=null):void
		{
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,true);
			var temp:String = String(getAttribute("xlink:href"));
			var tf:TextFormat = new TextFormat("HeiTi",16,0);
			temp = temp.substr(8);
			temp = 	temp.replace(/<br\/>/g,"\n");	
			if(textField==null){
				textField = new TextField();
				textField.type = TextFieldType.INPUT;
				var width:String = String(getAttribute("width"));
				textField.width = int(width.substring(0,width.indexOf("px")));
				//textField.addEventListener(Event.CHANGE,changeHandler);
				textField.border = true;
//				Global.stage.focus = textField;
//				textField.requestSoftKeyboard();
				textField.borderColor = 0x8080FF;
				textField.background= true;
				textField.backgroundColor = 0xFFFFFF
				textField.multiline = true;
				if(tf.font!=null){
					textField.embedFonts = true;					
				}
				textField.antiAliasType = AntiAliasType.ADVANCED;
				textField.defaultTextFormat = tf;	
				textField.autoSize = TextFieldAutoSize.LEFT;
				
			}
			textField.text = temp;		
			if(content){
				content.x = 0;
				content.y = 0;
				this.addChildAt(content,0);
			}else if(!this.contains(textField)){
				this.addChild(textField);
			}
			
			super.render(e);
		}
		
		override protected function removeStageHandler(event:Event):void
		{
			
			super.removeStageHandler(event);
			content = null;
			/*if(textField){
				textField.selectable = false;
				textField = null;
			}*/
			
		}
		
		
		override public function setAttribute(name:String, value:Object):void
		{
			if(name=='content'){
				content = value as Sprite;
				return;
			}
			if(name=='xlink:href'){
				value = value.replace(/({\\kern\s1pt})/g,'~');
			}
			super.setAttribute(name, value);
		}
	}
}