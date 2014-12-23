package myLib.myTextBase.Keyboard
{
	import com.mylib.framework.utils.AssetTool;
	import myLib.myTextBase.utils.KeyboardType;
	
	import flash.events.Event;

	/**
	 * 简易键盘
	 * @author wt
	 * 
	 */	
	internal class SimpleKeyboard extends KeyboardBase
	{
		public function SimpleKeyboard()
		{

			this.type = KeyboardType.SIMPLE_KEYBOARD;
//			keyboard_class = AssetTool.getCurrentLibClass("Simple_Keyboard");
			keyboard_class = MaterialManage.getInstance().simple_meterial;
			super();
		}
		
		override protected function addToStageHandler(event:flash.events.Event):void
		{
			super.addToStageHandler(event);
			mainUI.y -=40;
		}
		
		
		override public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			mainUI.graphics.clear();
			mainUI.graphics.beginFill(_backgroundColor,0.8);
			if(MaterialManage.getInstance().useBigSize){
				mainUI.graphics.drawRect(1010-56,0,mainUI.width,mainUI.height);
			}else{				
				mainUI.graphics.drawRect(1010,0,mainUI.width,mainUI.height);
			}
			mainUI.graphics.endFill();
		}
	}
}