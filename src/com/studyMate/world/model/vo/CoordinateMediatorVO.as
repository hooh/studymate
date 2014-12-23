package com.studyMate.world.model.vo
{
	import com.studyMate.world.screens.ICoordinateStyle;
	
	public class CoordinateMediatorVO{
		
		public var style:ICoordinateStyle;
		public var standItemVoList:Vector.<StandardItemsVO>;
		public var maxNumber:Number;

		public function CoordinateMediatorVO(_style:ICoordinateStyle,
											 _standItemVoList:Vector.<StandardItemsVO>,_maxNumber:Number)
		{
			style = _style;
			standItemVoList = _standItemVoList;
			maxNumber = _maxNumber;
		}
	}
}