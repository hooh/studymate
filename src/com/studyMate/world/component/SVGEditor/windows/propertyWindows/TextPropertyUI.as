package com.studyMate.world.component.SVGEditor.windows.propertyWindows
{
	import com.greensock.TweenLite;
	import com.lorentz.SVG.utils.SVGColorUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.data.EditSVGVO;
	import com.studyMate.world.component.SVGEditor.data.PropertyVO;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditBase;
	import com.studyMate.world.component.SVGEditor.utils.SVGPropertyType;
	import com.studyMate.world.component.SVGEditor.utils.SVGUtils;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import mx.utils.StringUtil;
	
	import fl.controls.ColorPicker;
	import fl.events.ColorPickerEvent;
	
	public class TextPropertyUI extends PropertyUI implements IPropertyUI
	{
				
		private var sizeInput:TextField;
		private var fill:ColorPicker;
		private var xInput:TextField;
		private var yInput:TextField;	
		private var widthInput:TextField;
		private var heightInput:TextField;
		
		private var colorStr:String;
		
		public function TextPropertyUI()
		{
			type = SVGPropertyType.textProperty;
			super();
		}
		
		override protected function removeStageHandler(event:Event):void
		{
			super.removeStageHandler(event);
			//TweenLite.killDelayedCallsTo(delayFill);
		}
		
		
		override protected function addToStageHandler(event:Event):void
		{
			super.addToStageHandler(event);
			var baseClass:Class = AssetTool.getCurrentLibClass("SVGPropertyText");
			mainUI = new baseClass;
			addChild(mainUI);
			
			sizeInput = mainUI.getChildByName("sizeInput") as TextField;
			fill = mainUI.getChildByName("colorPicker") as ColorPicker;
			xInput = mainUI.getChildByName("xInput") as TextField;
			yInput = mainUI.getChildByName("yInput") as TextField;
						

			initialize();
		}	
		override public function updateData(value:IEditBase):void{
			xInput.text = value.x.toString();
			yInput.text = value.y.toString();
			sizeInput.text = String(value.getAttribute('font-size'));
			colorStr = String(value.getAttribute("fill"));
			
			//TweenLite.killDelayedCallsTo(delayFill);
			//TweenLite.delayedCall(0.1,delayFill);						
			fill.selectedColor = SVGColorUtils.parseToUint(colorStr);			
		}
		
		/*private function delayFill():void{
			if(fill && fill.parent){
			}
		}*/

		
		private function initialize():void{			
			xInput.restrict = "0-9.";
			yInput.restrict = "0-9.";
			sizeInput.restrict = '0-9';
			sizeInput.addEventListener(FocusEvent.FOCUS_OUT,changeFontSizeHandler);
			sizeInput.addEventListener(KeyboardEvent.KEY_DOWN,fontSizeKeyDownHandler,false,1);
			sizeInput.text = '20';
			
			fill.selectedColor = 0;
			fill.addEventListener(ColorPickerEvent.CHANGE,colorChangeHandler);

			
			xInput.addEventListener(KeyboardEvent.KEY_DOWN,txtXKeyDownHandler,false,1);
			yInput.addEventListener(KeyboardEvent.KEY_DOWN,txtYKeyDownHandler,false,1);
												
		}
		

		private function colorChangeHandler(event:ColorPickerEvent):void{
			var str:String = "#" + event.target.hexValue ;
			sendNotification(SVGConst.PROPERTIES_CHANGE,new PropertyVO('fill',str,1));
		}		
		
		private function txtYKeyDownHandler(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ENTER){
				var str:String = StringUtil.trim(yInput.text);
				sendNotification(SVGConst.PROPERTIES_CHANGE,new PropertyVO('y',str));
			}
		}
		
		private function txtXKeyDownHandler(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ENTER){
				var str:String = StringUtil.trim(xInput.text);
				
				sendNotification(SVGConst.PROPERTIES_CHANGE,new PropertyVO('x',str));
			}
		}

		protected function fontSizeKeyDownHandler(event:KeyboardEvent):void{			
			if(event.keyCode == Keyboard.ENTER){
				changeFontSizeHandler();
			}
		}
		private function changeFontSizeHandler(event:FocusEvent = null):void{
			var str:String = StringUtil.trim(sizeInput.text);
			var size:int = int(str);
			if(size<5 || size>70){
				sendNotification(CoreConst.TOAST,new ToastVO("您设置的字体大小超出了限制"));
				return;	
			}
			sendNotification(SVGConst.PROPERTIES_CHANGE,new PropertyVO('font-size',str,1));
		}
		
		override public function get propertyObject():EditSVGVO
		{
			var editTextVO:EditSVGVO = new EditSVGVO();
			if(sizeInput.text!=""){
				editTextVO.styleDeclaration.setAttribute(SVGUtils.FONT_SIZE,sizeInput.text);
			}else{
				editTextVO.styleDeclaration.setAttribute(SVGUtils.FONT_SIZE,20);
			}
			editTextVO.styleDeclaration.setAttribute(SVGUtils.FILL,"#"+ fill.hexValue);
			return editTextVO;
		}
		
	}
}