package com.studyMate.module.classroom
{
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.weixin.vo.WeixinVO;
	

	public class MessageVO extends WeixinVO
	{
		
		public var crid:String;         // #房间标识
		public var qid:String;           // #题目标识

		public function MessageVO(arr:Array=null)
		{
			if(arr==null) return;
			id = arr[1];
			crid = arr[2];
			qid = arr[3];
			sedid = arr[4];
			sedname = arr[5];
			sedtime = arr[6];
			sedtime = sedtime.substr(0,4)+'-'+sedtime.substr(4,2)+'-'+sedtime.substr(6,2)+ " "+sedtime.substr(9,2)+':'+sedtime.substr(11,2)+':'+sedtime.substr(13);
			mtype = arr[7];
			minf = arr[8];
			mtxt = arr[9];
			
			if(mtype!='write'){
				mtxt = mtxt.readMultiByte(mtxt.length,"cn-gb");;
			}
			
			if(PackData.app.head.dwOperID.toString() == sedid){
				owner = true;				
			}else{
				owner = false;
			}
		}
	}
}