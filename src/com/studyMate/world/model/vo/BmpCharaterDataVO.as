package com.studyMate.world.model.vo
{
	public class BmpCharaterDataVO
	{
		public var name:String;
		public var dressList:String;
		
		public function BmpCharaterDataVO(name:String,dressList:String)
		{
			this.name = name;
			this.dressList = dressList;
			
		}
		
		public function toString():String{
			return "name:"+name+"\ndressList:"+dressList;
		}
		
		public function clone():BmpCharaterDataVO{
			return new BmpCharaterDataVO(name,dressList);
		}
		
		
	}
}