package com.studyMate.world.model.vo
{
	import starling.display.Image;

	public class PromiseVO
	{
		public var proid:String;
		public var sid:String;
		public var parname:String;
		public var gold:String;
		public var rwcontent:String;
		public var sdate:String;
		public var status:String;
		public var fdate:String;
		public var rwstatus:String;
		public var rwdate:String;
		public var hasImage:Boolean;
		public var imageURL:String;
		public var image:Image;
		
		public function PromiseVO(proid:String,sid:String,parname:String,gold:String, 
								  rwcontent:String,sdate:String,status:String,fdate:String,
								  rwstatus:String = "N",rwdate:String=""){
			this.proid = proid;
			this.sid = sid;
			this.parname = parname;
			this.gold = gold;
			this.rwcontent = rwcontent;
			this.sdate = sdate;
			this.status = status;
			this.fdate = fdate;
			this.rwstatus = rwstatus;
			this.rwdate = rwdate;
			hasImage = false;
		}
	}
}