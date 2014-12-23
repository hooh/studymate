package com.studyMate.world.component.SVGEditor.windows.propertyWindows
{
	import com.lorentz.SVG.utils.SVGColorUtils;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.data.EditSVGVO;
	import com.studyMate.world.component.SVGEditor.data.PropertyVO;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditBase;
	import com.studyMate.world.component.SVGEditor.utils.EditType;
	import com.studyMate.world.component.SVGEditor.utils.SVGPropertyType;
	import com.studyMate.world.component.SVGEditor.utils.SVGUtils;
	import com.studyMate.world.component.SVGEditor.utils.ToolType;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import mx.utils.StringUtil;
	
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.events.ColorPickerEvent;
	
	public class GraphicPropertyUI extends PropertyUI implements IPropertyUI
	{
		
		
		private var shapeSelect:ComboBox;
		private var strokeInput:TextField;
		private var strokeFill:ColorPicker;
		private var fill:ColorPicker;
		private var xInput:TextField;
		private var yInput:TextField;	
		private var widthInput:TextField;
		private var heightInput:TextField;
		
		public function GraphicPropertyUI()
		{
			type = SVGPropertyType.GraphicProperty;
			super();
		}
		
		override protected function addToStageHandler(event:Event):void
		{
			var baseClass:Class = AssetTool.getCurrentLibClass("SVGPropertyGraphic");
			mainUI = new baseClass;
			addChild(mainUI);
			
			shapeSelect = mainUI.getChildByName("shapeSelect") as ComboBox;
			strokeInput = mainUI.getChildByName("strokeInput") as TextField;
			strokeFill = mainUI.getChildByName("strokeFill") as ColorPicker;
			fill = mainUI.getChildByName("fill") as ColorPicker;
			xInput = mainUI.getChildByName("xInput") as TextField;
			yInput = mainUI.getChildByName("yInput") as TextField;
			widthInput = mainUI.getChildByName("widthInput") as TextField;
			heightInput = mainUI.getChildByName("heightInput") as TextField;						
			shapeSelect.addEventListener(Event.CHANGE, shapeSelectHandler);
			super.addToStageHandler(event);
			
			initialize();
		}	
		
		protected function shapeSelectHandler(event:Event):void
		{
			switch(shapeSelect.selectedIndex){
				case 0:
					SVGConst.currentTool = ToolType.CREAT_RECT_TOOL;
					break;
				case 2:					
					SVGConst.currentTool = ToolType.CREAT_ELLIPSE_TOOL;
					break;
				case 3:
					SVGConst.currentTool = ToolType.CREAT_POLYGON_TOOL;					
					break;
			}
		}		
		
		override public function updateData(value:IEditBase):void{
			switch(value.type){
				case EditType.rect:
					shapeSelect.selectedIndex = 0;
					break;
				case EditType.ellipse:
					shapeSelect.selectedIndex = 2;
					break;
			}
			
			xInput.text = value.x.toString();
			yInput.text = value.y.toString();
			var colorStr:String = String(value.getAttribute("fill"));
			fill.selectedColor = SVGColorUtils.parseToUint(colorStr);
			if(value.hasAttribute("stroke-width")) strokeInput.text = String(value.getAttribute("stroke-width"));
			if(value.hasAttribute("stroke")){
				var strokeColor:String = String(value.getAttribute("stroke"));
				strokeFill.selectedColor = SVGColorUtils.parseToUint(strokeColor);
			}
			if(value.hasAttribute('width')) widthInput.text = String(value.getAttribute('width'));
			if(value.hasAttribute('height')) heightInput.text = String(value.getAttribute('height'));
		}
		
		
		private function initialize():void{	
			switch(SVGConst.currentTool){
				case ToolType.CREAT_RECT_TOOL:
					shapeSelect.selectedIndex = 0;
					break;
				case ToolType.CREAT_ELLIPSE_TOOL:
					shapeSelect.selectedIndex = 2;
					break;
				case ToolType.CREAT_POLYGON_TOOL:
					shapeSelect.selectedIndex = 3;
					break;

			}
			
			xInput.restrict = "0-9.";
			yInput.restrict = "0-9.";
			
			strokeInput.addEventListener(FocusEvent.FOCUS_OUT,strokeWidthFocusHandler);
			strokeInput.addEventListener(KeyboardEvent.KEY_DOWN,strokeWidthHandler,false,1)
			strokeFill.addEventListener(ColorPickerEvent.CHANGE,strokeFillChangeHandler);		
			fill.addEventListener(ColorPickerEvent.CHANGE,colorChangeHandler);			
			xInput.addEventListener(KeyboardEvent.KEY_DOWN,txtXKeyDownHandler,false,1);
			yInput.addEventListener(KeyboardEvent.KEY_DOWN,txtYKeyDownHandler,false,1);			
		}
		
		protected function strokeWidthFocusHandler(event:FocusEvent):void{
			var str:String = StringUtil.trim(strokeInput.text);
			sendNotification(SVGConst.PROPERTIES_CHANGE,new PropertyVO('stroke-width',str,1));
		}
		
		private function strokeWidthHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER){
				var str:String = StringUtil.trim(strokeInput.text);
				sendNotification(SVGConst.PROPERTIES_CHANGE,new PropertyVO('stroke-width',str,1));
			}
		}
		
		private function strokeFillChangeHandler(event:ColorPickerEvent):void
		{
			var str:String = "#" + event.target.hexValue ;
			sendNotification(SVGConst.PROPERTIES_CHANGE,new PropertyVO('stroke',str,1));
		}		
		
		private function colorChangeHandler(event:ColorPickerEvent):void
		{
			var str:String = "#" + event.target.hexValue ;
			sendNotification(SVGConst.PROPERTIES_CHANGE,new PropertyVO('fill',str,1));
		}		
		
		private function txtYKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER){
				
				var str:String = StringUtil.trim(yInput.text);
				sendNotification(SVGConst.PROPERTIES_CHANGE,new PropertyVO('y',str));
			}
		}
		
		private function txtXKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER){
				var str:String = StringUtil.trim(xInput.text);
				
				sendNotification(SVGConst.PROPERTIES_CHANGE,new PropertyVO('x',str));
			}
		}
		
		override public function get propertyObject():EditSVGVO
		{
			switch(shapeSelect.selectedItem.data){
				case EditType.rect:
				case EditType.ellipse:
					var editSVGVO:EditSVGVO = new EditSVGVO();
					if(strokeInput.text != ""){
//						editRectVO.strokeWidth = strokeInput.text;
//						editRectVO.strokeFill = '#'+strokeFill.hexValue;
						editSVGVO.styleDeclaration.setAttribute(SVGUtils.STROKE_WIDTH,strokeInput.text);
						editSVGVO.styleDeclaration.setAttribute(SVGUtils.STROKE,'#'+strokeFill.hexValue);
					}
//					editRectVO.color = '#'+fill.hexValue;
					editSVGVO.styleDeclaration.setAttribute(SVGUtils.FILL,'#'+fill.hexValue);
					return editSVGVO ;		
					break;
					
			}
			return null;		
		}

		
	}
}