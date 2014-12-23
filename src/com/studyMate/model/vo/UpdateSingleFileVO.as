package com.studyMate.model.vo
{
	import com.studyMate.db.schema.AssetsLib;

	public final class UpdateSingleFileVO
	{
		public var lib:IFileVO;
		
		public function UpdateSingleFileVO(lib:IFileVO)
		{
			this.lib = lib;
		}
	}
}