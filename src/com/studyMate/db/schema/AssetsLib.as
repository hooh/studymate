package com.studyMate.db.schema
{
	import com.studyMate.model.vo.IFileVO;

	public final class AssetsLib implements IFileVO
	{
		public var id:int;
		
		public function get domain():String
		{
			// TODO Auto Generated method stub
			return _domain;
		}
		
		public function set domain(value:String):void{
			_domain = value;
		}
		
		public function get type():String
		{
			// TODO Auto Generated method stub
			return _type;
		}
		
		public function set type(value:String):void{
			_type = value;
		}
		
		public function get version():String
		{
			// TODO Auto Generated method stub
			return _version;
		}
		
		public function set version(value:String):void{
			_version = value;
		}
		
		
		private var _path:String;
		
		private var _type:String;
		
		private var _version:String;
		
		public var parameters:String;
		
		private var _domain:String;
		
		
		
		public function get path():String
		{
			return _path;
		}

		public function set path(value:String):void
		{
			_path = value;
		}

	}
}