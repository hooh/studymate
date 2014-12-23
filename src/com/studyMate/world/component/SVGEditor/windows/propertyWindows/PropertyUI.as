package com.studyMate.world.component.SVGEditor.windows.propertyWindows
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.component.SVGEditor.data.EditSVGVO;
	import com.studyMate.world.component.SVGEditor.product.display.EditSVGBase;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditBase;
	import com.studyMate.world.component.SVGEditor.windows.SVGPropertiesPanelMediator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class PropertyUI extends Sprite implements IMediator,IPropertyUI
	{
		public static const NAME:String = "PropertyUI";
		
		protected var mainUI:Sprite;
		
		public function get propertyObject():EditSVGVO
		{
//			trace(type);
			throw new Error("请PropertyUI子类实现属性赋值方法");
		}
		
		private var _type:String;
		
		public function PropertyUI()
		{
			addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,removeStageHandler);
		}
		
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}
		protected function addToStageHandler(event:Event):void
		{
			Facade.getInstance(CoreConst.CORE).registerMediator(this);
		}

		protected function removeStageHandler(event:Event):void
		{
			mainUI.removeChildren();
			this.removeChildren();
			mainUI = null;
			Facade.getInstance(CoreConst.CORE).removeMediator(NAME);
		}
		
		/*protected function editSvg():IEditBase{
			return (Facade.getInstance(CoreConst.CORE).retrieveMediator(SVGPropertiesPanelMediator.NAME) as SVGPropertiesPanelMediator).editSVGBase;
		}*/
		// 刷新属性面板。单机相应的编辑对象后后刷新属性面板
		public function updateData(value:IEditBase):void{
			throw new Error("请PropertyUI子类实现刷新赋值方法");
		}
		
		
		public function setViewComponent(viewComponent:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private var multitonKey:String;
		public function initializeNotifier(key:String):void
		{
			multitonKey = key;
		}
		
		public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification( notificationName, body, type );
		}
		
		
		public function getMediatorName():String
		{
			return NAME;
		}
		
		public function getViewComponent():Object
		{
			return this;
		}
		
		public function handleNotification(notification:INotification):void
		{
			
		}
		
		public function listNotificationInterests():Array
		{
			return [];
		}
		
		public function onRegister():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function onRemove():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
	}
}