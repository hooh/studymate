package com.studyMate.world.model.vo
{
	public class BackgroundMusicVO
	{
		/**
		 * relid 关联id
		 * id 音乐id
		 * name 音乐名称
		 * path 音乐相对路径 
		 */
		public var relid:String; 
		public var id:String;
		public var name:String;
		public var path:String;
		
		public function BackgroundMusicVO(_id:String,_name:String,_path:String){
			id = _id;
			name = _name;
			path = _path;
		}
	}
}