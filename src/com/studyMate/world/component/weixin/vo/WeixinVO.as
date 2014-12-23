package com.studyMate.world.component.weixin.vo
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.component.weixin.SpeechConst;
	import com.studyMate.world.component.weixin.VoiceState;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class WeixinVO
	{
		public var core:String;
		
		public var id:String;        // #记录标识
		public var sedid:String;       // #发送人
		public var sedname:String;   // #发送者姓名
		public var sedtime:String;   // #发送时间
		public var minf:String;//附加信息(录音时长等单位秒)
		public var owner:Boolean = true;//是否是自己发送
		
		public var mtype:String ='text';      // #聊天类型(text,voice,pic,write);
		public var mtxt:*  = '';         // #聊天文本内容(7k)*/voice的话传递的是一个路径	或者 图片路径,画图板传递的是byteArray二进制数据		
		public var hasRead:Boolean;//是否已经看过		
		public var isTeacher:Boolean;
		
		
		
		
		public var voiceState:int = VoiceState.defaultState;				
		public function set updateUIState(voiceState:int):void{
			if(this.voiceState == voiceState) return;
			this.voiceState = voiceState;
			if(voiceState == VoiceState.playState){
				hasRead = true;
			}
			Facade.getInstance(core).sendNotification(SpeechConst.UPDATE_UI_STATE,this);
		}
	}
}