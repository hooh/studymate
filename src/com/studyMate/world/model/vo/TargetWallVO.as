package com.studyMate.world.model.vo
{
	import com.studyMate.global.Global;

	public class TargetWallVO{
		public var targetId:String;
		public var pid:String;
		public var appellation:String;
		public var sid:String;
		public var startDate:String;
		public var endDate:String;
		public var rwType:String;
		public var rwDate:String;
		public var target:String;
		public var rwContent:String;
		public var isFinish:Boolean = false;
		public var isDead:Boolean = false;
		public var fullYear:String;
		public var fullMonth:String;
		public var fullDay:String;
		
		public function TargetWallVO(targetId:String,
									 pid:String,
									 appellation:String,
									 sid:String,
									 startDate:String,
									 endDate:String,
									 rwType:String,
									 rwDate:String,
									 target:String,
									 rwContent:String){
			this.targetId = targetId;
			this.pid = pid;
			this.appellation = appellation;
			this.sid = sid;
			this.startDate = startDate;
			this.endDate = endDate;
			this.rwType = rwType;
			this.rwDate = rwDate;
			this.target = target;
			this.rwContent = rwContent;
			if(this.rwDate != ""){ //完成时间不为空，已完成
				this.isFinish = true;
			}
			else{
				if(getNowTime() > this.endDate){
					this.isDead = true;
				}
			}
		}
		
		private function getNowTime():String{
			var date:Date = Global.nowDate;
			var dateString:String = date.fullYear.toString() + getFullString(date.month + 1) + getFullString(date.date);
			return dateString;
		}
		
		private function getFullString(m:Number):String{
			if(m < 10) return "0" + m.toString();
			else return m.toString();
		}
	}
}