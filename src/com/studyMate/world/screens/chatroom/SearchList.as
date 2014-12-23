package com.studyMate.world.screens.chatroom
{
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.text.TextFormat;
	
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	public class SearchList extends List
	{
		public function SearchList()
		{
			super();
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 75;
			layout.paddingBottom = 75;
			this.layout = layout;
			this.allowMultipleSelection = false;
			this.itemRendererType = SearchListItemRender;
			
			this.verticalScrollPolicy =  Scroller.SCROLL_POLICY_ON;
			
			this.addEventListener(FeathersEventType.SCROLL_COMPLETE,scrollComplete);
		}
		private function scrollComplete(e:Event):void{
			var nowPos:Number = this.verticalScrollPosition;
			var div:int = nowPos/75;
			var rem:int = nowPos%75;
			
			//没移动到75倍数，自动对齐
			if(rem != 0){
				if(rem >= 33){
					this.scrollToPosition(0, ((div+1)*75),0.5);
					
				}else{
					this.scrollToPosition(0, (div*75),0.5);
					
				}
			}
		}
		
		
		public function updateData(data:Array):void{
			
			var dataList:ListCollection = getListCollection(data);
			initBitmapFont(dataList);
			
			this.dataProvider = dataList;
			
		}
		
		private function getListCollection(list:Array):ListCollection{
			var listcollection:ListCollection = new ListCollection;
			
			for (var i:int = 0; i < list.length; i++) 
			{
				listcollection.push(list[i]);
			}
			return listcollection;
		}
		
		
		
		
		
		//初始化位图字体
		public function initBitmapFont(_dataList:ListCollection):void{
			var len:int = _dataList.length;
			var _vo:RelListItemSpVO;
			var str:String = '';
			for(var i:int=0;i< len;i++){
				_vo = (_dataList.data[i] as RelListItemSpVO);
				str += (_vo.realName + _vo.school);
			}
			if(str!=''){
				BitmapFontUtils.dispose();
				
				str += "\%.0123456789男女";
				var assets:Vector.<DisplayObject> = new Vector.<DisplayObject>;
				var bmp:Bitmap = Assets.getTextureAtlasBMP(Assets.store["ChatViewTexture"],Assets.store["ChatViewXML"],"chatRoom/addFriendBtn");
				bmp.name = "addFriendBtn";
				assets.push(bmp);
				
				var ui:Shape = new Shape();
				ui.graphics.clear();
				ui.graphics.beginFill(0xeeeeee,0);
				ui.graphics.drawRect(0,0,1111,75);
				ui.graphics.lineStyle(1,0xffffff,0);
				ui.graphics.moveTo(0,75);
				ui.graphics.lineTo(1111,75);
				var bmd:BitmapData = new BitmapData(1111,76,true,0);
				bmd.draw(ui);
				bmp = new Bitmap(bmd);
				bmp.name = 'bg';
				assets.push(bmp);
				
				ui.graphics.clear();
				ui.graphics.beginFill(0xdedede);
				ui.graphics.drawRect(0,0,1111,75);
				ui.graphics.lineStyle(1,0xd2d2d2);
				ui.graphics.moveTo(0,75);
				ui.graphics.lineTo(1111,75);
				bmd = new BitmapData(1111,75,true,0);
				bmd.draw(ui);
				bmp = new Bitmap(bmd);
				bmp.name = 'bg2';
				assets.push(bmp);
				
				var tf:TextFormat = new TextFormat("HeiTi",26,0x7f6342,true);
//				tf.letterSpacing = -2;
				BitmapFontUtils.init(str,assets,tf,null,false);
			}
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
			
			this.removeEventListener(FeathersEventType.SCROLL_COMPLETE,scrollComplete);
		}
		
		
	}
}