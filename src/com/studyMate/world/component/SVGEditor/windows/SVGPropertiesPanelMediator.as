package com.studyMate.world.component.SVGEditor.windows
{
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditBase;
	import com.studyMate.world.component.SVGEditor.utils.EditType;
	import com.studyMate.world.component.SVGEditor.utils.ToolType;
	import com.studyMate.world.component.SVGEditor.windows.propertyWindows.GraphicPropertyUI;
	import com.studyMate.world.component.SVGEditor.windows.propertyWindows.PropertyUI;
	import com.studyMate.world.component.SVGEditor.utils.SVGPropertyType;
	import com.studyMate.world.component.SVGEditor.windows.propertyWindows.TextPropertyUI;
	import com.studyMate.world.component.SVGEditor.windows.propertyWindows.basePropertyUI;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * 属性面板
	 * 界面内容可以动态切换
	 * @author wt
	 * 
	 */	
	public class SVGPropertiesPanelMediator extends SVGBasePannelMediator
	{
		public static const NAME:String = "SVGPropertiesPanelMediator";
		
		public var propertyUI:PropertyUI;	
		private var _editSVGBase:IEditBase;//当前选择
		
		public function SVGPropertiesPanelMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}		

		override public function onRemove():void{
			view.removeChildren();
			propertyUI = null;
			_editSVGBase = null;
			super.onRemove();
		}
		

		override public function onRegister():void{	
			propertyUI = new basePropertyUI();
			view.addChild(propertyUI);
			super.onRegister();						
		}
		
				
		override protected function svg_handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case SVGConst.PREPARE_CREAT_NEW:
					ToolTypePropertiesHandler();
					break;
				case SVGConst.PROPERTIES:	//根据接收的显示对象，决定显示面板以及面板中的属性参数									
					editSVGBase = notification.getBody() as IEditBase;
					break;				
			}
		}
		
		override protected function svg_listNotificationInterests():Array
		{
			return [SVGConst.PROPERTIES,SVGConst.PREPARE_CREAT_NEW];
		}
		
		public function ToolTypePropertiesHandler():void{
			switch(SVGConst.currentTool){
				case ToolType.CREAT_ELLIPSE_TOOL:
				case ToolType.CREAT_RECT_TOOL:
					changeToGraphicState();	
					break;
				case ToolType.CREAT_TEXT_TOOL:
					changeToTextState();
					break;
				case ToolType.CREAT_SWFIMAGE_TOOL:
				case ToolType.CREAT_MATH_TOOL:
					changeToBaseState();
					break;
			}
		}
		

		public function get editSVGBase():IEditBase
		{
			return _editSVGBase;
		}
		
		public function set editSVGBase(value:IEditBase):void
		{			
			_editSVGBase = value;
			if(_editSVGBase==null){
				changeToBaseState(); return;
			}
			switch(_editSVGBase.type){
				case EditType.text:				
					changeToTextState();					
					break;
				case EditType.ellipse:
				case EditType.rect:
					changeToGraphicState();					
					break;
				case EditType.image:
					changeToBaseState();
				default:
					changeToBaseState();
					
			}
			
			propertyUI.updateData(value);
			
			
			
		}		
		/**
		 * ---------------------各种模式---------------------------------------------------*/		 
		/*
		 * *---------------切换到初始模式------------------*/
		private function changeToBaseState():void{
			if(propertyUI.type != SVGPropertyType.baseProperty){				
				view.removeChildren();
				propertyUI = new basePropertyUI();
				view.addChild(propertyUI);
			}
		}
		/*
		 * *
		 *------------切换到文本属性模式-----------------------*/
		private function changeToTextState():void{
			if(propertyUI.type != SVGPropertyType.textProperty){				
				view.removeChildren();
				propertyUI = new TextPropertyUI();
				view.addChild(propertyUI);
			}
		}
		/*
		 * *---------------切换到绘图模式---------------------------*/
		private function changeToGraphicState():void{
			if(propertyUI.type != SVGPropertyType.GraphicProperty){				
				view.removeChildren();
				propertyUI = new GraphicPropertyUI();
				view.addChild(propertyUI);
			}
		}	
		/**------------------------------------------------------------------------*/
		
		
		
	}
}