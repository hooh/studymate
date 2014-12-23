package com.studyMate.module.engLearn.vo
{
	
	/**
	 * 朗读数据结构
	 * 2014-10-20上午10:44:45
	 * Author wt
	 *
	 */	
	
	public class ReadAloudVO
	{			
		public var rankid:String;//唯一标识该录音
		public var LEA:String;//层级阶段
		public var usSentence:String;//英文
		public var cnSentence:String;//中文
		public var soundPath:String;//语音路径
		public var starttime:uint;
		public var durtime:uint;
		
		public var fsize:uint;
		
		public function ReadAloudVO(source:Array=null)
		{
			if(source){				
				rankid = source[1];
				usSentence = source[2];
				cnSentence = source[3];
				starttime = uint(source[4]);
				durtime = uint(source[5])-starttime;
				
				fsize = source[6];
			}
		}
		
		
		
	}
}