package com.studyMate.world.component.SVGEditor.windows.propertyWindows
{
	import com.mylib.framework.utils.AssetTool;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	import fl.controls.ColorPicker;
	import com.studyMate.world.component.SVGEditor.utils.SVGPropertyType;
	
	/**
	 * 铅笔属性面板
	 * @author wt
	 * 
	 */	
	public class PenPropertyUI extends PropertyUI
	{		
		private var strokeInput:TextField;
		private var strokeFill:ColorPicker;
		private var fill:ColorPicker;
		private var xInput:TextField;
		private var yInput:TextField;		
			
		public function PenPropertyUI()
		{
			type = SVGPropertyType.penProperty;
			super();
		}
		


		override protected function addToStageHandler(event:Event):void
		{
			var baseClass:Class = AssetTool.getCurrentLibClass("SVGPropertyPen");
			mainUI = new baseClass;
			addChild(mainUI);
			
			strokeInput = mainUI.getChildByName("strokeInput") as TextField;
			strokeFill = mainUI.getChildByName("strokeFill") as ColorPicker;
			fill = mainUI.getChildByName("fill") as ColorPicker;
			xInput = mainUI.getChildByName("xInput") as TextField;
			yInput = mainUI.getChildByName("yInput") as TextField;
			
			super.addToStageHandler(event);
			//strokeInput.addEventListener(KeyboardEvent.KEY_DOWN,strokeKeyDownHandler);
		}		
		
		/*protected function strokeKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER){
				if(_editSVGBase){
					_editSVGBase.x= int(txtX.text);
					
				}
			}
		}*/
		
	}
}