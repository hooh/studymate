package myLib.myTextBase.Keyboard
{
	import com.mylib.framework.utils.AssetTool;
	import myLib.myTextBase.utils.KeyboardType;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 英文键盘
	 * @author wt
	 * 
	 */	
	internal class USKeyboard extends KeyboardBase 
	{
		private static var flagBig:Boolean;//是否为大写，true为是
		
		
		
		public function USKeyboard()
		{
			this.type = KeyboardType.US_KEYBOARD;
//			keyboard_class = AssetTool.getCurrentLibClass("Left_Big_Keyboard");
			keyboard_class = MaterialManage.getInstance().en_meterial
			super();			
			
		}
		override protected function addToStageHandler(event:Event):void
		{
			super.addToStageHandler(event);
			var shiftUI:Sprite = (mainUI.getChildByName("shiftBtn") as Sprite);
			shiftUI.visible = flagBig;
		}
		
		override protected function enterChar(i:int):void
		{
			if(flagBig){
				if(96<i && i<123)
					i-=32;
			}
			super.enterChar(i);
		}
		
		
		
		override protected function enterSpecial(i:int,name:String=''):void
		{
			super.enterSpecial(i);
			
			if(i==1){//切换大小写
				flagBig = !flagBig;
				var shiftUI:Sprite = (mainUI.getChildByName("shiftBtn") as Sprite);
				shiftUI.visible = flagBig;
			}
		}
		
		
		
	}
}