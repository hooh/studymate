package com.studyMate.world.model.vo
{
	import flash.utils.ByteArray;
	

	public class CharaterSuitsVO
	{
		
		public var equipments:Vector.<SuitEquipmentVO>;
		public var bones:Object;
		public var sex:String;
		
		public function CharaterSuitsVO()
		{
			equipments = new Vector.<SuitEquipmentVO>;
			bones={};
		}
		
		public function addEquip(_e:SuitEquipmentVO):void{
			equipments.push(_e);
		}
		
		public function clone():CharaterSuitsVO{
			
			var byte:ByteArray = new ByteArray();
			byte.writeObject(this);
			byte.position = 0;
			var o:Object = byte.readObject();
			
			return CharaterSuitsVO(o) ;
			
		}
		
		
	}
}