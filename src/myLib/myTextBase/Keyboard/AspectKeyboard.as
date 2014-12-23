package myLib.myTextBase.Keyboard
{
	import com.greensock.TweenLite;
	import com.mylib.framework.utils.AssetTool;
	import myLib.myTextBase.utils.KeyboardType;
	
	import flash.events.Event;

	internal class AspectKeyboard extends KeyboardBase
	{
		public function AspectKeyboard()
		{
			this.type = KeyboardType.ASPECT_KEYBOARD;
			keyboard_class = AssetTool.getCurrentLibClass("Aspect_Keyboard");
			super();
		}
		
		override protected function addToStageHandler(event:flash.events.Event):void
		{
			super.addToStageHandler(event);
			mainUI.y -=10;
		}
		
		
		override public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			mainUI.graphics.clear();
			mainUI.graphics.beginFill(_backgroundColor,0.8);
			mainUI.graphics.drawRect(1010,0,mainUI.width,mainUI.height);
			mainUI.graphics.endFill();
		}
		

		override protected function enterSpecial(i:int,name:String=''):void{
			var t0:int;
			if(i==0){
				iTextInput.setFocus();
				switch(name){
					case '_0l':
						currentIndex = iTextInput.selectionAnchorPosition;
						if(currentIndex>0){
							currentIndex--;
							iTextInput.selectTextRange(currentIndex,currentIndex);	
						}	
						break;
					case '_0r':
						currentIndex = iTextInput.selectionAnchorPosition;
						if(currentIndex<iTextInput.text.length){
							currentIndex++;
							iTextInput.selectTextRange(currentIndex,currentIndex);	
						}	
						break;
					case '_0ll':
						currentIndex = iTextInput.selectionAnchorPosition;
						if(currentIndex>0){
							t0 = iTextInput.text.lastIndexOf(' ',currentIndex-1);
							if(t0!=-1){
								currentIndex = t0;
							}else{
								currentIndex = 0;
							}
							iTextInput.selectTextRange(currentIndex,currentIndex);	
						}
						break;
					case '_0rr':
						currentIndex = iTextInput.selectionAnchorPosition;
						if(currentIndex<iTextInput.text.length){
							t0 = iTextInput.text.indexOf(' ',currentIndex+1);
							if(t0!=-1){
								currentIndex = t0;
							}else{
								currentIndex = iTextInput.text.length;
							}
							iTextInput.selectTextRange(currentIndex,currentIndex);	
						}
						break;
					default:
						break;
				}
			}else{
				super.enterSpecial(i,name);
			}
			
		}
		
		

	}
}