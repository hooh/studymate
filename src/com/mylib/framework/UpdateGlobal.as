package com.mylib.framework
{
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.UpdateListVO;
	
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	public class UpdateGlobal
	{
		public static const INSTALL:String = "install";
		public static const COMMIT:String = "commit";
		public static const LATEST:String = "latest";
		public static const DOWNLOADING:String = "downLoading";
		
		public static const UPDATE_FILE_PATH:String = "tmpEDU/updateInfor.by";
		public static const CONFIG_KEY:String = "updateState";
		
		public static var updateListVO:UpdateListVO;
		public static var updateListMap:Dictionary;
		
		
		public static var fixList:UpdateListVO;
		
		
		public static function getTempFile(itemVO:UpdateListItemVO):File{
			return Global.document.resolvePath("tmpEDU/"+Global.localPath+itemVO.path+"."+itemVO.version+".tmp");
		}
		
	}
}