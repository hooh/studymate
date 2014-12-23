package myLib.myTextBase.Keyboard
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.AssetTool;
	import myLib.myTextBase.utils.KeyBoardConst;
	import myLib.myTextBase.utils.KeyboardType;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	/**
	 * 数字键盘
	 * @author wt
	 * 
	 */	
	internal class NumKeyboard extends KeyboardBase 
	{
		public function NumKeyboard()
		{
			this.type = KeyboardType.NUM_KEYBOARD;
//			keyboard_class = AssetTool.getCurrentLibClass("Left_Math_Keyboard");
			keyboard_class = MaterialManage.getInstance().math_meterial;
			super();
		}
		
		override protected function enterChar(i:int):void
		{
			super.enterChar(i);
			if(i==34 || i==39){//如果为'或者“则返回上一界面
				KeyBoardConst.current_Keyboard = KeyboardType.US_KEYBOARD;
				Facade.getInstance(CoreConst.CORE).sendNotification(KeyBoardConst.CHANGE_KEYBORD);				
			}			
		}
	}
}