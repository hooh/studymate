package com.studyMate.model.vo
{
	

	public final class SaveTempFileVO
	{
		public var nativePath:String;
		public var remoteFileLoadVO:RemoteFileLoadVO;
		
		
		
		public function SaveTempFileVO(nativePath:String=null,remoteFileLoadVO:RemoteFileLoadVO=null)
		{
			this.nativePath = nativePath;
			this.remoteFileLoadVO = remoteFileLoadVO;
		}
	}
}