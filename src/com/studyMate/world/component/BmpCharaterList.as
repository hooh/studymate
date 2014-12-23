package com.studyMate.world.component
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.model.vo.BmpCharaterDataVO;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.events.Event;
	
	public class BmpCharaterList extends List implements IMediator,IDataList
	{
		public static const NAME:String = "BmpCharaterList";
		
		
		public var bmpList:ListCollection;
		
		
		
		public function BmpCharaterList()
		{
			super();
			bmpList = new ListCollection();
			
			width = 400;
			height = 300;
			itemRendererProperties.labelField ="name";
			
			addEventListener(Event.ADDED_TO_STAGE,addHandle);
			addEventListener(Event.REMOVED_FROM_STAGE,removeHandle);
		}
		
		private function removeHandle(event:Event):void
		{
			Facade.getInstance(CoreConst.CORE).removeMediator(NAME);
		}
		
		private function addHandle(event:Event):void
		{
			
			Facade.getInstance(CoreConst.CORE).registerMediator(this);
			
			
			
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
			switch(notification.getName())
			{
				
			}
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
		
		public function setViewComponent(viewComponent:Object):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function updateData():void
		{
			
		}
		
		private function updateDataByVO(dateList:Vector.<BmpCharaterDataVO>):void{
			for(var i:int=0;i<dateList.length;i++){
				
				bmpList.push(dateList[i]);
			}
			
			dataProvider = bmpList;
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