package com.studyMate.model.vo
{
	import com.studyMate.db.schema.Item;

	public class InitialMapToolCellVO
	{
		public var itemData:Item;
		public var rotation:int;
		
		public function InitialMapToolCellVO(itemData:Item,rotation:int=0)
		{
			this.itemData = itemData;
			this.rotation = rotation;
		}
	}
}