package com.studyMate.world.model.vo
{
	public class NPCRawDataVO
	{
		public var name:String;
		public var property:String;
		public var roleClass:String
		public var state:String;
		public var id:String;
		public var equiments:String;
		public var hp:String;
		public var skeleton:String;
		public var ai:String;
		public var scale:String;
		
		public function NPCRawDataVO(id:String="",name:String="",equiments:String="",roleClass:String="",hp:String="",state:String="",skeleton:String="",ai:String="",scale:String="",property:String="")
		{
			this.id = id;
			this.name = name;
			this.equiments = equiments;
			this.property = property;
			this.roleClass = roleClass;
			this.hp = hp;
			this.state = state;
			this.skeleton = skeleton;
			this.ai = ai;
			this.scale = scale;
				
		}
	}
}