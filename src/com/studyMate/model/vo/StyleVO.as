package com.studyMate.model.vo
{
	import com.studyMate.model.AssetsDomain;
	import com.studyMate.model.AssetsType;

	public final class StyleVO implements IFileVO
	{
		private var _path:String;
		public var fonts:Array;
		
		
		public function StyleVO(path:String,fonts:Array=null)
		{
			this.path = path;
			this.fonts = fonts;
		}

		public function get path():String
		{
			return _path;
		}

		public function set path(value:String):void
		{
			_path = value;
		}
		
		public function get type():String{
			return AssetsType.STYLE;
		}
		
		public function get version():String{
			return "0";
		}
		
		public function get domain():String{
			return AssetsDomain.GLOBAL;
		}

	}
}