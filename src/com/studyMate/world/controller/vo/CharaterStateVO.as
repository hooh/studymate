package com.studyMate.world.controller.vo
{
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	
	import flash.geom.Point;

	public class CharaterStateVO
	{
		public var location:Point;
		public var look:String;
		public var say:String;
		public var id:String;
		public var name:String;
//		public var profile:CharaterSuitsVO;
		public var dressList:String;
		
		public var level:int = 0;
		
		public function CharaterStateVO(id:String,name:String="",location:Point=null,say:String=null,look:String=null,_dressList:String="",_level:int=0)
		{
			this.id = id;
			this.name = name;
			this.location = location;
			this.say = say;
			this.look = look;
			this.dressList = _dressList;
			
			this.level = _level;
		}
	}
}