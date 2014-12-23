package com.studyMate.world.component.weixin.interfaces
{
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import starling.display.DisplayObject;

	public interface ITextInputView extends IInputBase
	{		
		
		function get input():TextFieldHasKeyboard;//输入键盘
		
		function useSoftKeyboardState():void;//切换到软键盘的状态
		
		function userSogouKeyboardState():void;//使用搜狗键盘的状态
		
		
		
		
		//切换语音的可视点击元素
		function get switchVoiceDisplayObject():DisplayObject;
		
		//表情可以点击元素
		function get faceDisplayObject():DisplayObject;
		
		//切换键盘按钮
		function get changeKeyboardDisplayobject():DisplayObject;
		
		
	}
}