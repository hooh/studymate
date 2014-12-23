package com.studyMate.world.component
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.card.GameCharaterData;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.world.screens.component.NpcListItemRender;
	
	import flash.errors.IllegalOperationError;
	
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class MyNPCList extends List implements IMediator,IDataList
	{
		public static const NAME:String = "MyNPCList";
		
		private var playersData:Vector.<GameCharaterData>;
		
		public function MyNPCList()
		{
			super();
			
			width = 400;
			height = 300;
			itemRendererProperties.labelField ="name";
			
			itemRendererFactory = itemFactory;
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
		
		
		private function itemFactory():IListItemRenderer{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.accessoryFunction = itemFun;
			return renderer;
		}
		
		private function itemFun( item:GameCharaterData ):DisplayObject{
			var render:NpcListItemRender = new NpcListItemRender();
			render.data = item;
			return render;
			
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
			var dvo:DataResultVO;
			switch(notification.getName())
			{
				
				default:
				{
					break;
				}
			}
		}
		
		private function refreshList():void{
			
			if(!playersData){
				return;
			}
			
			var dataList:ListCollection = new ListCollection();
			for (var i:int = 0; i < playersData.length; i++) 
			{
				dataList.addItem(playersData[i]);
			}
			dataProvider = dataList;
			
			
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
		
		public function updateData():void{
			
		}
		
		public function updateDateByCplist(cpList:Vector.<GameCharaterData>):void{
			playersData = cpList.concat();
			
			refreshList();
		}
		
		public function setViewComponent(viewComponent:Object):void
		{
			if(viewComponent){
				throw IllegalOperationError("the view is fix");
			}
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