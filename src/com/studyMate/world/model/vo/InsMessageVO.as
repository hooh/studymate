package com.studyMate.world.model.vo
{
	public class InsMessageVO
	{
		public var mesid:String;
		public var sedid:String;
		public var sedcode:String;
		public var recid:String;
		public var reccode:String;
		public var sedtime:String;
		public var mess:String;
		
		public var hasRead:Boolean = false;
		
		public function InsMessageVO(_mesid:String,_sedid:String,_sedcode:String,_recid:String,
									 _reccode:String,_sedtime:String,_mess:String)
		{
			mesid = _mesid;
			sedid = _sedid;
			sedcode = _sedcode;
			recid = _recid;
			reccode = _reccode;
			sedtime = _sedtime;
			mess = _mess;
			
		}
	}
}