package com.studyMate.world.component.SVGEditor.windows.propertyWindows
{
	import com.studyMate.world.component.SVGEditor.data.EditSVGVO;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditBase;
	

	public interface IPropertyUI 
	{
		
//		function editSvg():EditSVGBase
		function get type():String;
		function set type(value:String):void;
		function get propertyObject():EditSVGVO;
		function updateData(value:IEditBase):void;
	}
}