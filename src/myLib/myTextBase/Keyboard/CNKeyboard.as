package myLib.myTextBase.Keyboard
{
	import com.mylib.framework.utils.AssetTool;
	import myLib.myTextBase.interfaces.ITextInputCpu;
	import myLib.myTextBase.interfaces.ITextInputGpu;
	import myLib.myTextBase.utils.KeyboardType;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import starling.events.Event;

	/**
	 * 中文键盘
	 * @author wt
	 * 
	 */	
	internal class CNKeyboard extends KeyboardBase
	{
		private var pinyinBar:PinYinBar;
		private var text:String = "";
		
		protected var beginChar:int;
		protected var endChar:int;
		
		public function CNKeyboard()
		{
			this.type = KeyboardType.CN_KEYBOARD;
//			keyboard_class = AssetTool.getCurrentLibClass("Left_Pinyin_Keyboard");
			keyboard_class = MaterialManage.getInstance().cn_meterial;
			super();
			
		}
		override protected function addToStageHandler(event:flash.events.Event):void
		{
			super.addToStageHandler(event);
			pinyinBar = new PinYinBar();
			pinyinBar.y = -58;
			pinyinBar.addEventListener(DataEvent.DATA,pinyinHandler);
			mainUI.addChildAt(pinyinBar,0);		
			
			if(iTextInput && iTextInput is ITextInputCpu){
				(iTextInput as ITextInputCpu).addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,false,0,true);	
			}else if(iTextInput && iTextInput is ITextInputGpu){
				(iTextInput as ITextInputGpu).addEventListener(starling.events.Event.TRIGGERED,touchHandler);
			}
		}
		override protected function removeStageHandler(event:flash.events.Event):void
		{
			if(iTextInput && iTextInput is ITextInputCpu){
				(iTextInput as ITextInputCpu).removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,false);	
			}
			super.removeStageHandler(event);
			
		}
		private function touchHandler():void
		{
			text = '';
			
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			text = '';
		}		
		
		override protected function delLetter(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			iTextInput.setFocus();
			if(text!=""){
				endChar--;
				
				text = text.substr(0,text.length-1);
				iTextInput.insertText(text);
				iTextInput.selectTextRange(beginChar,endChar);
				pinyinBar.setString(text);
			}else{				
				super.delLetter(e);
			}
		}
		
		
		override protected function enterChar_Enter(i:int):void
		{
			if(iTextInput.maxChars != 0){
				var len:int = iTextInput.text.length -  iTextInput.maxChars;
				if(len>0){
					iTextInput.insertText("");
				}
			}else{
				iTextInput.insertText(text);	
			}
			
			//super.enterChar_Enter(i);
			var m:int = iTextInput.selectionAnchorPosition+text.length;
			iTextInput.setFocus();
			iTextInput.selectTextRange(m,m);
			text = "";
		}
		
		
		override protected function enterChar_ABC(i:int):void
		{
			if(i==32){//空格
				if(text==""){
					iTextInput.insertText(" ");
					var n:int = iTextInput.selectionAnchorPosition+1;
					iTextInput.selectTextRange(n,n);
				}else{
					iTextInput.insertText(text);										
					n = iTextInput.selectionAnchorPosition+text.length;
					text = "";
					iTextInput.selectTextRange(n,n);
				}
				return;											
			}else if(i==44 || i==46){
				if(text != ""){
					pinyinBar.setFirstHanzi();											
				}
				iTextInput.insertText(String.fromCharCode(i));
				n = iTextInput.selectionAnchorPosition + 1;
				iTextInput.selectTextRange(n,n);
				text = "";											
				return;
			}
			
			if(text == ""){
				beginChar = iTextInput.selectionAnchorPosition;
				endChar = iTextInput.selectionAnchorPosition+1;
			}else{
				endChar ++;
			}
			if(text.length+1>19){//中文连打输入限制20个字符
				return;
			}
			text += String.fromCharCode(i);
			iTextInput.insertText(text);
			iTextInput.selectTextRange(beginChar,endChar);
			pinyinBar.setString(text);
		}
		
		
		
		override protected function enterSpecial(i:int,name:String=''):void
		{
			if(i==8){//删除按键	
				iTextInput.setFocus();
				if(text!=""){
					endChar--;
					
					text = text.substr(0,text.length-1);
					iTextInput.insertText(text);
					iTextInput.selectTextRange(beginChar,endChar);
					pinyinBar.setString(text);
					return;
				}
			}			
			
			super.enterSpecial(i);
		}
		
		override public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			mainUI.graphics.clear();
			mainUI.graphics.beginFill(_backgroundColor,0.8);
			if(MaterialManage.getInstance().useBigSize){
				mainUI.graphics.drawRect(0,-58,1280,360);
			}else{				
				mainUI.graphics.drawRect(0,-58,1280,320);
			}
			mainUI.graphics.endFill();
			
			
		}
		/**-------------------------------中文输入-------------------------------------*/
		override public function InsertChinese(chineseArr:Array):void{
			if(chineseArr){
				if(pinyinBar){
					pinyinBar.insertChinese(chineseArr.concat());
				}
			}
		}
		
	
		//点击文字条事件
		private function pinyinHandler(e:DataEvent):void{
			if(iTextInput.maxChars != 0 && (iTextInput.text.length - text.length+e.data.length)>iTextInput.maxChars){
				iTextInput.setFocus();
				iTextInput.insertText("");
				return;
			}
			iTextInput.setFocus();
			iTextInput.insertText(e.data);
			text = "";
			var i:int = iTextInput.selectionAnchorPosition+e.data.length;
			iTextInput.selectTextRange(i,i);
		}	
	}
}