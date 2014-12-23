package com.studyMate.module.classroom
{
	import com.studyMate.global.Global;

	public class CroomVO
	{
		public var crid:String;//教室标识
		public var crname:String;//房间名称
		public var crdes:String;//房间描述
		public var tid:String;//老师标识
		public var sid:String;//学生标识
		public var qtype:String;//题目类型
		public var qids:String;//问题标识串
		public var coperid:String;//创建人
		public var ctime:String;//创建时间
		public var stime:String;//开始时间
		public var crstat:String;//教室状态(D-未辅导、U-已辅导)
		public var cqid:String;//当前题目标识
		
		public var startDate:Date;
		public var surplusTips:String//剩余提醒
		
		public function CroomVO(arr:Array)
		{
			crid = arr[1];
			crname = arr[2];
			crdes = arr[3];
			tid = arr[4];
			sid = arr[5];
			qtype = arr[6];
			qids = arr[7];
			coperid = arr[8];
			ctime = arr[9];
			stime = arr[10];
			crstat = arr[11];
			cqid = arr[12];
			
			var year:String = stime.substr(0,4);
			var month:String = stime.substr(4,2);
			var day:String = stime.substr(6,2);
			var hours:String = stime.substr(8,2);
			var minutes:String = stime.substr(10,2);
			startDate = new Date(year,int(month)-1,day,hours,minutes);
			if(crstat == 'U'){				
				var amongMinutes:int = (startDate.time - Global.nowDate.time)/1000/60;//分钟
				
				if(amongMinutes<0){ 
					if(amongMinutes<-180){						
						surplusTips = '：辅导已超时,未确认'
					}else{
						surplusTips = ':已辅导'+(-amongMinutes)+'分钟';
					}
				}else if(amongMinutes<60){  //一小时内
					surplusTips = ':'+ amongMinutes+'分钟';
				}else if(amongMinutes<24*60){//一天内
					surplusTips = ":"+ int(amongMinutes/60)+'小时'+ int(amongMinutes%60)+'分';
				}else{
					surplusTips = '还有'+ int(amongMinutes/60/24)+'天';
				}
			}else{
				surplusTips = '确认辅导完毕';
			}
		}
	}
}