package com.studyMate.world.component.weixin.interfaces
{
	import starling.display.DisplayObject;

	/**
	 * 语音输入接口
	 * @author wt
	 * 
	 */	
	public interface IVoiceInputView extends IInputBase
	{
		//录音对象
		function get recordDisplayObject():DisplayObject;
		//切换到文字输入对象
		function get switchTextInputDisplayObject():DisplayObject;
		//启动试听界面提示对象
		function get startListenDisplayObject():DisplayObject;
		//开始录音状态
		function startRecordState():void;
		//结束录音状态
		function endRecordState():void;
		
	}
}