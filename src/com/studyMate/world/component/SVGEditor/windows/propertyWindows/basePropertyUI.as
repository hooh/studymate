package com.studyMate.world.component.SVGEditor.windows.propertyWindows
{
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.world.component.SVGEditor.data.EditSVGVO;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditBase;
	import com.studyMate.world.component.SVGEditor.utils.SVGPropertyType;
	
	import flash.events.Event;
	
	public class basePropertyUI extends PropertyUI implements IPropertyUI
	{
		
		public function basePropertyUI()
		{
			type = SVGPropertyType.baseProperty;
			super();
		}
		

		
		override protected function addToStageHandler(event:Event):void
		{
			var baseClass:Class = AssetTool.getCurrentLibClass("baseProperty");
			mainUI = new baseClass;
			addChild(mainUI);
						
			super.addToStageHandler(event);
			
		}	
		
		override public function get propertyObject():EditSVGVO
		{
			return null;
		}
		
		override public function updateData(value:IEditBase):void
		{
			
		}
		
	}
}