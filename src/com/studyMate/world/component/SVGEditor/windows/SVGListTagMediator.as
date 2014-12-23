package com.studyMate.world.component.SVGEditor.windows
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import fl.controls.List;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class SVGListTagMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SVGListTagMediator";
		private var listElement:List;
		private var dp:DataProvider;
		
		public function SVGListTagMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			listElement.removeEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
			dp = null;
			super.onRemove();
		}
		
		override public function onRegister():void
		{
			var text:TextField = new TextField();
			text.text = "标签列表";
			view.addChild(text);
			listElement = new List();		
			listElement.y = 30;
			listElement.height = 500;
			view.addChild(listElement);
			
			
			dp = new DataProvider();
			listElement.dataProvider = dp;
			listElement.addEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
			
		//	view.addEventListener(MouseEvent.CLICK,viewClickHandler);
		}
		/*protected function viewClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}*/
		protected function itemClickHandler(e:ListEvent):void
		{
			if(SVGConst.isEditState){
				sendNotification(SVGConst.UPDATE_SVG_DOCUMENT);
			}else{
				var item:Object = e.item;
//				trace("Label: " + item.label);
			
//				trace (item.id);
				sendNotification(SVGConst.SELECT_TAG,item.id)
				
			}
		}
		
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case SVGConst.CHANGE_TAG://清空列表
					dp.removeAll();
					var xmlList:XMLList = SVGConst.svgXML.children();
					var child:XML;
					var idStr:String;
					for each(child in xmlList){
						idStr = child.@id;
						dp.addItem({label:child.name().localName,id:idStr});
					}
					break;
				case SVGConst.CLEAR_ALL_ELEMENT:
					dp.removeAll();
					break;				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			
			return [SVGConst.CHANGE_TAG,SVGConst.CLEAR_ALL_ELEMENT];
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
	}
}