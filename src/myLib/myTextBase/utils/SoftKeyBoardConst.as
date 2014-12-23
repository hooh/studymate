package myLib.myTextBase.utils
{
	/**
	 *
	 * @author wangtu
	 * 创建时间: 2014-8-15 上午11:20:05
	 * 
	 */	
	public class SoftKeyBoardConst
	{
		//键盘切换消息
		public static const NAME:String = "softKeyboard";
		//		public static const USE_SOFTKEYBOARD:String = NAME + "USE_SOFTKEYBOARD";//使用软键盘
		public static const RESET_SORFTKEYBOARD:String = NAME + "reset_softkeyboard";//复位软键盘设置
		public static const USE_KEYBOARD_CHINESE:String = NAME+"useKeyboardChinese";
		public static const HAS_KEYBOARD:String = NAME+"hasSoftKeyboard";//屏幕有键盘
		public static const NO_KEYBOARD:String = NAME+"noSoftKeyboard";//屏幕没有键盘
		public static const KEYBOARD_HASBG:String = NAME+"KeyboardHasBG";//默认黑色，要改变背景色则传如颜色值:sendNotification(WorldConst.KEYBOARD_HASBG,0x123456);
		public static const INSERT_CHINESE:String = NAME +"insertChinese";//插入中文，实现模糊搜索。传入[“你好”,"蚂蚁"]
		public static const USE_SIMPLE_KEYBOARD:String = NAME +"useSimpleKeyboard";//是否使用简单键盘，传入boolean,true或false
		public static const USE_ASPECT_KEYBOARD:String = NAME + "useAspectKeyboard";//使用方向键盘
		public static const HIDE_SOFTKEYBOARD:String = NAME+ "hideSoftKeyboard";//隐藏软键盘
	}
}