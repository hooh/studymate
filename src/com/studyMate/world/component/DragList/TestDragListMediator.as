package com.studyMate.world.component.DragList
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class TestDragListMediator extends ScreenBaseMediator
	{
		
		private var list:DragFeatherList;
		
		public function TestDragListMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super('TestDragListMediator', viewComponent);
		}
		
		
		
		override public function onRegister():void
		{
			view.stage.color = 0x62DFF7;
			list = new DragFeatherList();
			list.x = 10;
			list.y = 200;
			list.width = 250;
			list.height = 300;
			view.addChild( list );
			
			var groceryList:ListCollection = new ListCollection(
				[
					{ text: "Milk" },
					{ text: "Eggs" },
					{ text: "Bread" },
					{ text: "Chicken" },
				]);
			list.dataProvider = groceryList;
			list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "text";
				return renderer;
			};
			list.addEventListener(PullToRefreshList.PULL_TO_REFRESH_EVENT, listPullToRefreshHandler);
			
			list.addEventListener( Event.CHANGE, list_changeHandler );
			
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			var index:int;
			var item:Object;
			switch(event.keyCode){
				case Keyboard.UP:					
					index = list.selectedIndex;
					if(index>0){
						item = list.selectedItem;
						list.dataProvider.removeItem(item);
						list.dataProvider.addItemAt(item,index-1);
						list.selectedItem = item;
					}
					break;
				case Keyboard.DOWN:
					index = list.selectedIndex;
					if(index<list.dataProvider.length-1){
						item = list.selectedItem;
						list.dataProvider.removeItem(item);
						list.dataProvider.addItemAt(item,index+1);
						list.selectedItem = item;
					}
					break;
			}
		}
		private function listPullToRefreshHandler(event:Event):void
		{
			list.removeEventListener(PullToRefreshList.PULL_TO_REFRESH_EVENT, listPullToRefreshHandler);			
			if (event.data == "old")
				getOldData();
			else
				getData();			
			list.addEventListener(PullToRefreshList.PULL_TO_REFRESH_EVENT, listPullToRefreshHandler);
		}
		
		private function getData():void{
			var data:Array =
				[
					{
						text: String.fromCharCode(Math.round(Math.random()*26)+65)
					}
				];			
			//list.dataProvider = new ListCollection(_data);			
			list.appendNewData(new ListCollection(data));
		}
		private function getOldData():void{
			var data:Array =
				[
					{
						text: String.fromCharCode(Math.round(Math.random()*26)+65)
					}
				];			
			list.appendOldData(new ListCollection(data));
		}
		
		
		private function list_changeHandler( event:Event ):void
		{
			var list:DragFeatherList = DragFeatherList( event.currentTarget );
			var item:Object = list.selectedItem;
			trace('select');
//			list.selectedItem = list.dataProvider.getItemAt(1);
		}
		
		
		
		override public function onRemove():void{
			super.onRemove();			
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
	}
}