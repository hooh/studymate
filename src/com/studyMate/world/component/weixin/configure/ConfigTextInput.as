package com.studyMate.world.component.weixin.configure
{
	
	

	/**
	 * 配置文字聊天
	 * @author wt
	 * 
	 */	
	public class ConfigTextInput
	{
		public var textInputView:Class;//ITextInputView;//文字输入的皮肤
		
		//图片文件夹
		public var imgfolder:String = 'userImg';//本地edu下的哪个目录存放图片
		public var dropDownView:Class;//下拉菜单
		/**
		 * 发送文字的函数
		 * 参数必须是[mtext:String]
		 * return VoiceVO类型或子类
		 * 
		 * 如function insertTextHandler(mtxt:String):MessageVO
		 */		
		public var  insertTextFun:Function;//插入文字的函数，参数必须是[mtext:String],返回Voice类型或子类
		
		
		
		/**
		 *	插入语音的函数
		 *  参数必须是[file:File]
		 * 	return VoiceVO类型或子类
		 * 用法如： function insertImgFun(file:File):MessageVO
		 */		
		public var insertImgFun:Function;//插入图片的函数，参数必须是文件夹
	}
}