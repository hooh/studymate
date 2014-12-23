package com.studyMate.world.screens.talkingbook
{
	import com.studyMate.world.component.BookPicture;
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.component.LazyLoad;
	import com.studyMate.world.component.flipPage.IFlipPageRendererExtends;
	import com.studyMate.world.events.ItemLoadEvent;
	
	import flash.display.Bitmap;
	
	import mycomponent.DrawBitmap;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	/**
	 * note
	 * 2014-7-11下午4:39:52
	 * Author wt
	 *
	 */	
	
	public class TalkBookPage extends Sprite implements IFlipPageRendererExtends
	{
		public static const row:int = 7;//行
		public static const col:int = 3;//列		
		public static const leftSpace:int =82;//左边距
		public static const topSpace:int =66;//上边距
		public static const rowgap:int =163;//行间隔
		public static const colgap:int = 216;//列间隔
		
		public var pageNum:int;
		public var bookVec:Vector.<BookPicture>;
		public var totalPage:int;
		private var lazyLoad:LazyLoad;
		private var index:int=0;
		private var imgHolder:Sprite;
		
		public function TalkBookPage(pageNum:int,bookVec:Vector.<BookPicture>,totalPage:int)
		{
			this.pageNum = pageNum;
			this.bookVec = bookVec;
			this.totalPage = totalPage;
			
		}
		
		public function get view():DisplayObject
		{
			return this;
		}
		
		public function clearLoad():void{
			index = 0;
			if(lazyLoad){				
				lazyLoad.removeEventListener(ItemLoadEvent.ITEM_LOAD_COMPLETE,itemLoadCompleteHandler);//加载成功侦听
				lazyLoad.removeEventListener(ItemLoadEvent.ITEM_LOAD_FAILD,itemLoadFaildHandler);//加载失败或者数组元素为空
				lazyLoad.clear();
				lazyLoad = null;
			}
			if(imgHolder){
				imgHolder.removeFromParent(true);
			}
		}
		
		public function startLoad():void{
			if(imgHolder) imgHolder.removeFromParent(true);
			imgHolder = new Sprite();
			this.addChild(imgHolder);
			var arr:Array = [];
			for(var i:int=0;i<bookVec.length;i++){
				arr.push(bookVec[i].facePath);
			}
			lazyLoad = new LazyLoad(arr);//延迟加载
			lazyLoad.addEventListener(ItemLoadEvent.ITEM_LOAD_COMPLETE,itemLoadCompleteHandler);//加载成功侦听
			lazyLoad.addEventListener(ItemLoadEvent.ITEM_LOAD_FAILD,itemLoadFaildHandler);//加载失败或者数组元素为空
		}
		
		override public function dispose():void
		{
			disposePage();
			super.dispose();
		}
		
		
		public function disposePage():void
		{
			index = 0;
			if(lazyLoad){				
				lazyLoad.removeEventListener(ItemLoadEvent.ITEM_LOAD_COMPLETE,itemLoadCompleteHandler);//加载成功侦听
				lazyLoad.removeEventListener(ItemLoadEvent.ITEM_LOAD_FAILD,itemLoadFaildHandler);//加载失败或者数组元素为空
				lazyLoad.clear();
				lazyLoad = null;
			}
			removeChildren(0,-1,true);
		}
		
		public function displayPage():void
		{
			for(var i:int=0;i<bookVec.length;i++){				
				var bg:Image = new Image(Assets.talkingbookTexture("small_Book_Face"));
				bg.x = ((int)(i%row))*rowgap + leftSpace - 640;
				bg.y = ((int)(i/row))%col*colgap + topSpace - 381;
				this.addChild(bg);
			}			
		}
		
		private function itemLoadCompleteHandler(event:ItemLoadEvent):void{
			if(index>bookVec.length-1) index=0;
			var bitmap:Bitmap = new DrawBitmap(event.Item,131,162);
			var bookBtn:BookItem = new BookItem(bookVec[index],bitmap);
			bookBtn.x = ((int)(index%row))*rowgap + leftSpace -640;
			bookBtn.y = ((int)(index/row))%col*colgap + topSpace - 381;
			
			imgHolder.addChild(bookBtn);
			index++
		}
		private function itemLoadFaildHandler(event:ItemLoadEvent):void{
			if(index>bookVec.length-1) index=0;
			var bookBtn:BookItem = new BookItem(bookVec[index],null);
			bookBtn.x = ((int)(index%row))*rowgap + leftSpace - 640;
			bookBtn.y = ((int)(index/row))%col*colgap + topSpace - 381;
			imgHolder.addChild(bookBtn);
			index++;
		}
	}
}