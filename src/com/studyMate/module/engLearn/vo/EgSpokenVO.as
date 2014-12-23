package com.studyMate.module.engLearn.vo
{
	import mx.utils.StringUtil;

	public class EgSpokenVO
	{
		public var title:String;//标题
		public var content:String;//内容
		public var WNum:String;//单词数
		public var assetsFlag:String='0';//0或-1代表没有素材
		public var assetsPath:String;//素材路径
		public var oralid:String;
		
		public function EgSpokenVO(arr:Array)
		{
			title = StringUtil.trim(arr[3]);
			content = arr[8];
			WNum = arr[4];
			assetsFlag = arr[5];
			assetsPath = arr[6];
			oralid = arr[2];				
		}
	}
}