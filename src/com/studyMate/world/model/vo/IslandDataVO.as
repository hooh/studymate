package com.studyMate.world.model.vo
{
	public class IslandDataVO
	{
		public var name:String;
		public var description:String;
		public var texture:String;
		public var price:int;
		public var exploreTime:int;
		public var type:String;
		public var status:String;
		public var taskNum:int;
		public var id:int;
		public var attribute:int;
		
		public function IslandDataVO(name:String,description:String,texture:String,price:int,exploreTime:int,taskNum:int=3,type:String="n",status:String="a",attribute:int=1)
		{
			this.name = name;
			this.description = description;
			this.texture = texture;
			this.price = price;
			this.exploreTime = exploreTime;
			this.taskNum = taskNum;
			this.type = type;
			this.status = status;
			this.attribute = attribute;
		}
		
		public function toString():String{
			return "name:"+name+"\ndescription:"+description+"\ntexture:"+texture+"\nprice:"+price+"\nexploreTime:"+exploreTime+"\ntaskNum:"+taskNum+"\ntype:"
				+type+"\nstatus:"+status+"\nattribute:"+attribute+"\nid:"+id;
		}
		
		public function clone():IslandDataVO{
			return new IslandDataVO(name,description,texture,price,exploreTime,taskNum,type,status,attribute);
		}
		
		
	}
}