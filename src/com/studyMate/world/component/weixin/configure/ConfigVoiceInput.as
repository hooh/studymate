package com.studyMate.world.component.weixin.configure
{
	
	
	/**
	 * 配置语音聊天
	 * @author wt
	 */	
	public class ConfigVoiceInput
	{
		//语音文件夹
		public var folder:String = 'speech';//本地edu下的哪个目录存放语音
		public var autoDown:Boolean = true;//是否自动下载
		public var autoPlay:Boolean = false;//是否自动播放
		/**
		 *	插入语音的函数
		 *  参数必须是[file:File,totalTime:String]
		 * 	return VoiceVO类型或子类
		 *  
		 * 用法如： function insertVoiceHandler(file:File,totalTime:String='0'):MessageVO
		 */		
		public var inserVoiceFun:Function;
		
		public var voiceInputView:Class;//需继承IVoiceInputView;//语音输入的皮肤,必须传
		public var tryListenView:Class;//需继承ITryListenView;试听皮肤//不听可以不传
		public var dropDownView:Class;//下拉菜单
	}
}