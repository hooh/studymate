package com.mylib.framework.model.vo
{
	
	

	public class InstallListVO
	{
		public var packName:String;
		public var apkName:String;
		public var installType:String;
		
		
		public function InstallListVO(_packName:String,_apkName:String,_installType:String)
		{
			this.packName = _packName;
			this.apkName = _apkName;
			this.installType = _installType;
		}
	}
}