package com.studyMate.world.component.SVGEditor.windows
{
	import com.greensock.TweenLite;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.myTagList.MyList;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditBase;
	import com.studyMate.world.component.SVGEditor.utils.ToolType;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import fl.controls.List;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * 标签面板和库面板
	 * @author wt
	 * 
	 */	
	public class SVGTagPanelMediator extends SVGBasePannelMediator
	{
		public static const NAME:String = "SVGTagPanelMediator";
		
		private var mainSp:Sprite;
		
		private var tagBtn:Sprite;
		private var swfBtn:Sprite;
		private var upBtn:Sprite;
		private var downBtn:Sprite;
		private var updateBtn:Sprite;
		private var loadBtn:Sprite;
		
		private var tagList:List;
		private var tagDp:DataProvider;
		
		private var swfList:List;
		private var swfDp:DataProvider;
		
		private var file:FileReference;
		
		
		public function SVGTagPanelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		override public function onRemove():void
		{
			TweenLite.killDelayedCallsTo(sendNotification);
			mainSp.removeChildren();
			view.removeChildren();
			super.onRemove();
		}		
		override public function onRegister():void
		{
			var pageClass:Class = AssetTool.getCurrentLibClass("SVGTagPannel");
			mainSp = new pageClass;
			view.addChild(mainSp);
			
			tagBtn = mainSp.getChildByName("tagBtn") as Sprite;
			swfBtn = mainSp.getChildByName("swfBtn") as Sprite;
			upBtn = mainSp.getChildByName("upBtn") as Sprite;
			downBtn = mainSp.getChildByName("downBtn") as Sprite;
			updateBtn = mainSp.getChildByName("updateSwf") as Sprite;
			loadBtn = mainSp.getChildByName("loadBtn") as Sprite;
			
			//tagList = mainSp.getChildByName("tagList") as List;
			swfList = mainSp.getChildByName("swfList") as List;
			
			tagList = new List();
			tagList.allowMultipleSelection = false;
			tagList.width = 158;
			tagList.height = 278;
			tagList.y = 35;
			mainSp.addChild(tagList);
						
			tagDp = new DataProvider();
			swfDp = new DataProvider();
			
			tagList.dataProvider = tagDp;
			swfList.dataProvider = swfDp;
			
			
			tagList.addEventListener(ListEvent.ITEM_CLICK,tageClickHandler);
			swfList.addEventListener(ListEvent.ITEM_CLICK,swfClickHandler);
			upBtn.addEventListener(MouseEvent.CLICK,upClickHandler);
			downBtn.addEventListener(MouseEvent.CLICK,downClickHandler);
			updateBtn.addEventListener(MouseEvent.CLICK,updateSwfClickHandler);
			loadBtn.addEventListener(MouseEvent.CLICK,loadSwfClickHandler);
			super.onRegister();									
		}
		
		protected function loadSwfClickHandler(event:MouseEvent):void
		{
			/*file = new FileReference();
			file.addEventListener(Event.SELECT, selectHandler);
			file.browse(getTypes());*/
			
			var file:File =Global.document.resolvePath(Global.localPath + "book/SVG_TEST.swf");
			if(file.exists){
				sendNotification(SVGConst.LOAD_SWF,file.url);//导入swf文件
			}
		}
		
		protected function selectHandler(event:Event):void
		{
			/*var file:FileReference = FileReference(event.target);
			
			trace("selectHandler: name=" + file.name );*/
			
		}
		private function getTypes():Array {
			var allTypes:Array = new Array(new FileFilter("swf文件", "*.swf"));
			return allTypes;
		}
		
		protected function updateSwfClickHandler(event:MouseEvent):void
		{
			sendNotification(SVGConst.UPDATE_SWF_LIBRARY);//刷新swf库
			
			
		}
		
		protected function downClickHandler(event:MouseEvent):void{
			var index:int = tagList.selectedIndex;
			if(index<tagList.length-1){
				var obj:Object = tagList.selectedItem;
				tagDp.removeItem(obj);
				tagDp.addItemAt(obj,index+1)
				tagList.selectedItem = obj;
//				trace("前",SVGConst.svgXML.toXMLString());
				var child:XML = SVGConst.svgXML.children()[tagList.length-1-index];
				delete SVGConst.svgXML.children()[tagList.length-1-index];
				SVGConst.svgXML.insertChildBefore(SVGConst.svgXML.children()[tagList.length-1-index-1],child);
//				trace("后",SVGConst.svgXML.toXMLString());
				TweenLite.killDelayedCallsTo(sendNotification);
				TweenLite.delayedCall(1,sendNotification,[SVGConst.UPDATE_SVG_DOCUMENT]);
			}
		}
		
		protected function upClickHandler(event:MouseEvent):void{
			var index:int = tagList.selectedIndex;
			if(index>0){
				var obj:Object = tagList.selectedItem;
				tagDp.removeItem(obj);
				tagDp.addItemAt(obj,index-1)
				tagList.selectedItem = obj;
//				trace("前",SVGConst.svgXML.toXMLString());
				var child:XML = SVGConst.svgXML.children()[tagList.length-1 - index];
				delete SVGConst.svgXML.children()[tagList.length-1 - index];
				SVGConst.svgXML.insertChildAfter(SVGConst.svgXML.children()[tagList.length-1-index],child);
//				trace("后",SVGConst.svgXML.toXMLString());
				TweenLite.killDelayedCallsTo(sendNotification);
				TweenLite.delayedCall(1,sendNotification,[SVGConst.UPDATE_SVG_DOCUMENT]);
			}
			
		}
						
		
		protected function swfClickHandler(e:ListEvent):void
		{
			SVGConst.currentTool = ToolType.CREAT_SWFIMAGE_TOOL;
			sendNotification(SVGConst.PREPARE_CREAT_NEW,e.item.label);							
		}

		protected function tageClickHandler(e:ListEvent):void
		{
			var item:Object = e.item;
			if(SVGConst.isEditState){
				sendNotification(SVGConst.UPDATE_SVG_DOCUMENT);
				isSelect = true;
				itemId = item.id;
				//TweenLite.killDelayedCallsTo(sendNotification);
				//TweenLite.delayedCall(0.5,sendNotification,[SVGConst.SELECT_TAG,item.id]);
			}else{				
				isSelect = false;
//				trace (item.id);
				sendNotification(SVGConst.SELECT_TAG,item.id);
			}			
		}
		private var isSelect:Boolean;
		private var itemId:String;
		private function delayTageClickHandler():void{
			if(isSelect){
				isSelect = false;
				sendNotification(SVGConst.SELECT_TAG,itemId);
			}
		}
		
		override protected function svg_handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case WorldConst.COMPLETE_ALL_FORMULA:
					trace("渲染结束");
					delayTageClickHandler();
					break;
				case SVGConst.LOAD_SWF_COMPLETE:
					swfDp.removeAll();
					var item:Vector.<String> = notification.getBody() as Vector.<String>;
					if(item){
						for(var i:int=0;i<item.length;i++){							
							swfDp.addItem({label:item[i]});
						}
					}
					sendNotification(SVGConst.UPDATE_SVG_DOCUMENT);
					break;
				
				case SVGConst.CHANGE_TAG://清空列表
					tagDp.removeAll();
					var xmlList:XMLList = SVGConst.svgXML.children();
					var child:XML;
					var idStr:String;
					for each(child in xmlList){
						idStr = child.@id;
						if(idStr!='')
							tagDp.addItemAt({label:child.name().localName+"("+idStr.substr(0,4)+")",id:idStr},0);
//						tagDp.addItem({label:child.name().localName+"("+idStr.substr(0,4)+")",id:idStr});
					}
					break;

				
				//------新建和修改对象时，标签栏也相应的高亮显示
				case SVGConst.CREAT_NEW_ELEMENT:
				case SVGConst.MODIFIY_ELEMENT:
					var editSvg:IEditBase = notification.getBody() as IEditBase;
					xmlList = SVGConst.svgXML.children();
					for(i=0;i<tagDp.length;i++){
						if(tagDp.getItemAt(i).id == editSvg.id){
							tagList.selectedIndex = i;
							break;						
						}						
					}
					editSvg = null;
					break;
			}
		}

		override protected function svg_listNotificationInterests():Array
		{
			return [SVGConst.CHANGE_TAG,
					SVGConst.CREAT_NEW_ELEMENT,
					SVGConst.MODIFIY_ELEMENT,
					WorldConst.COMPLETE_ALL_FORMULA,
					SVGConst.LOAD_SWF_COMPLETE];
		}
		
	
		
	}
}