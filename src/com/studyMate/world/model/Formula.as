package com.studyMate.world.model
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.model.vo.FormulaVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	
	public class Formula extends Sprite implements IMediator
	{
		public static var STATIC_ID:int = 1;
		private var _formula:String;
		private var id:String;
		
		public function Formula()
		{
			super();
			id = "Formula" + STATIC_ID.toString();
			STATIC_ID += 1;
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
		public function get formula():String
		{
			return _formula;
		}

		public function set formula(value:String):void
		{
			_formula = value;
			var formulaVo:FormulaVO = new FormulaVO(id);
			formulaVo.formula = value;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_FORMULA_IMAGE, formulaVo);
		}

		public function getMediatorName():String
		{
			return id;
		}
		
		public function getViewComponent():Object
		{
			return null;
		}
		
		public function setViewComponent(viewComponent:Object):void
		{
		}
		
		public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case WorldConst.GET_FORMULA_IMAGE :
					var vo:FormulaVO = notification.getBody() as FormulaVO;
					if(id == vo.id){
						addChild(vo.bmp);
						var e:Event = new Event(Event.COMPLETE);
						dispatchEvent(e);
					}
					break;
			}
		}
		
		public function listNotificationInterests():Array
		{
			return [WorldConst.GET_FORMULA_IMAGE];
		}
		
		public function onRegister():void
		{
		}
		
		public function onRemove():void
		{
		}
		
		protected function addedHandler(event:Event):void
		{
			Facade.getInstance(CoreConst.CORE).registerMediator(this);
		}
		
		protected function removedHandler(event:Event):void
		{
			Facade.getInstance(CoreConst.CORE).removeMediator(this.getMediatorName());
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
	}
}