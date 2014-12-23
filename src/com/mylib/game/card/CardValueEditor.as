package com.mylib.game.card
{
	import feathers.controls.TextInput;
	import feathers.core.PropertyProxy;
	
	import starling.display.Sprite;
	
	public class CardValueEditor extends Sprite
	{
		private var typeSelector:CardTypeSelector;
		private var valueEditor:TextInput;
		private var _data:CValue;
		
		
		public function CardValueEditor()
		{
			typeSelector = new CardTypeSelector(CardTypeSelector.bgTexture,CardTypeSelector.frameTexture);
			addChild(typeSelector);
			typeSelector.y = 4;
			
			valueEditor = new TextInput();
			addChild(valueEditor);
			valueEditor.width = 50;
			
			
			valueEditor.x = 160;
			
			var property:PropertyProxy = new PropertyProxy();
			property.maxChars =2;
			property.restrict  = "0-9";
			valueEditor.textEditorProperties = property;
			
			
		}
		
		public function set data(_d:CValue):void{
			_data = _d;
			
			valueEditor.text = _data.value.toString();
			typeSelector.type = _data.type;
			
		}
		
		public function updateData():void{
			if(_data){
				_data.type = typeSelector.type;
				_data.value = parseInt(valueEditor.text);
				
			}
			
		}
		
		
		public function get data():CValue{
			return _data;
		}
		
		
		
	}
}