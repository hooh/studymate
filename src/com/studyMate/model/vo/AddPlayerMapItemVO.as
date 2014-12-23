package com.studyMate.model.vo
{
	import com.studyMate.db.schema.IMapItemData;
	import com.studyMate.db.schema.IsoMap;

	public class AddPlayerMapItemVO
	{
		public var item:IMapItemData;
		public var map:IsoMap;
		public function AddPlayerMapItemVO(item:IMapItemData,map:IsoMap)
		{
			this.item = item;
			this.map = map;
		}
	}
}