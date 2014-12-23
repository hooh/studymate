package com.studyMate.model.vo
{
	public class TimeLimitVo
	{
		public var sid:String;
		
		
		/**
		 * 开始时间 
		 */		
		public var sdate:Date;
		
		/**
		 * 结束日期 
		 */		
		public var edate:Date;
		
		/**
		 * 最后5分钟提醒 
		 */		
		public var hadl5Tip:Boolean = false;
		
		
		/**
		 * 退出提醒 
		 */		
		public var hadexitTip:Boolean = false;
		
		/**
		 * 
		 * @param _sdate	开始时间
		 * @param _edate	结束时间
		 * 
		 */		
		public function TimeLimitVo(_sdate:Date, _edate:Date)
		{
			this.sdate = _sdate;
			this.edate = _edate;
			
		}
		
	}
}