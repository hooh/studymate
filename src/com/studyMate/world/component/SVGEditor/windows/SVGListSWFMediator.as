package com.studyMate.world.component.SVGEditor.windows
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import fl.controls.List;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	

	/**
	 * swf标签面板。以显示swf标签为主
	 * @author wt
	 * 
	 */	
	public class SVGListSWFMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SVGListSWFMediator";
		
		private var listElement:List;
		private var dp:DataProvider;
		
		public function SVGListSWFMediator(viewComponent:Object=null)
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
			text.text = "SWF原件列表";
			view.addChild(text);
			listElement = new List();		
			listElement.y = 30;
			listElement.height = 500;
			view.addChild(listElement);
			
			
			dp = new DataProvider();
			listElement.dataProvider = dp;
			listElement.addEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
		}
		
		protected function itemClickHandler(e:ListEvent):void
		{
			var item:Object = e.item;
//			trace("Label: " + item.label);
			SVGConst.currentTool = SVGConst.CREAT_SWFIMAGE_TOOL;
			sendNotification(SVGConst.CREAT_NEW_ELEMENT,item.label);
			
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case SVGConst.LOAD_SWF://清空列表
					dp.removeAll();
					break;
				case SVGConst.LOAD_SWF_COMPLETE:
					var item:Vector.<String> = notification.getBody() as Vector.<String>;
					if(item){
						for(var i:int=0;i<item.length;i++){							
							dp.addItem({label:item[i]});
						}
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{			
			return [SVGConst.LOAD_SWF_COMPLETE,SVGConst.LOAD_SWF];
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
	}
}