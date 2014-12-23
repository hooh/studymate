package com.studyMate.world.component.weixin.interfaces
{
	import starling.display.DisplayObject;

	/**
	 * 聊天下拉菜单  
	 * 目前包含拍照，分享面板等
	 * @author wt
	 * 
	 */	
	public interface IDropDownView
	{
		//拍照按钮
		function get cameraDisplayObject():DisplayObject;
		//分享面板按钮
		function  get shareBoardplayObject():DisplayObject;
	}
}