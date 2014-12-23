package com.studyMate.model.vo
{
	import flash.filesystem.File;

	public final class LicenseVO
	{
		public var file:File;
		public var hexserial:String;
		public var macid:String;
		public var regmac:String;
		
		public function LicenseVO(file:File=null,macid:String="",hexserial:String="",regmac:String="")
		{
			this.file = file;
			this.hexserial = hexserial;
			this.regmac = regmac;
			this.macid = macid;
		}
	}
}