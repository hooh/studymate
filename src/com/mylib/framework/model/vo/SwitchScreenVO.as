package com.mylib.framework.model.vo
{
	import com.studyMate.world.screens.ScreenBaseMediator;
	

	public class SwitchScreenVO
	{
		public var data:Object;
		public var mediatorClass:*;
		/**
		 *push pop show 
		 */		
		public var type:uint;
		public var holder:*;
		public var index:int;
		public var x:int;
		public var y:int;
		public var newDomain:Boolean;
		
		public var mediator:ScreenBaseMediator;
		public var view:*;
		public var mediatorName:String;
		
		
		
		public function SwitchScreenVO(mediatorClass:*=null,
									 data:Object = null,
									 type:uint=1,
									 holder:*=null,
									 x:int=0,
									 y:int=0,
									 index:int=-1,mediatorName:String=null)
		{
			this.data = data;
			this.mediatorClass = mediatorClass;
			this.type = type;
			this.holder = holder;
			this.index= index;
			this.x = x;
			this.y = y;
			this.mediatorName = mediatorName;
		}
	}
}