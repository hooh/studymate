package zhen.guo.yao.components.flipbook 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	internal class HalfPage
	{
		private var _pageWidth:Number;
		private var _pageHeight:Number;
		
		private var _dragedHalfPage:Bitmap;
		private var _allPage:Bitmap;
		private var _bmdAll:BitmapData;
		private var _bmdHalf:BitmapData;
		
		private var _dragedHalfPageContainer:Sprite;
		private var _allPageContainer:Sprite;
		
		public function HalfPage(pageWidth:Number, pageHeight:Number,dragedHalfPageContainer:Sprite,allPageContainer:Sprite) 
		{
			_pageWidth = pageWidth;
			_pageHeight = pageHeight;
			_dragedHalfPageContainer = dragedHalfPageContainer
			_allPageContainer = allPageContainer;
		}
		//添加整个的page，并且生成半页
		public function addAllPage(page:DisplayObject,dir:String):void
		{
			_bmdAll = new BitmapData(_pageWidth, _pageHeight);
			_bmdAll.draw(page);
			_allPage = new Bitmap(_bmdAll);
			
			_bmdHalf = new BitmapData(_pageWidth / 2, _pageHeight);
			if (dir == "right")
			{
				_bmdHalf.copyPixels(_bmdAll, new Rectangle(0 , 0 , _pageWidth/2 , _pageHeight),new Point(0,0));
			}
			else if (dir == "left")
			{
				_bmdHalf.copyPixels(_bmdAll, new Rectangle(_pageWidth/2 , 0, _pageWidth/2, _pageHeight),new Point(0,0));
			}
			
			_dragedHalfPage = new Bitmap(_bmdHalf);
			_allPageContainer.addChild(_allPage);
			_dragedHalfPageContainer.addChild(_dragedHalfPage);
		}
		//释放内存
		public function free():void
		{
			if(_dragedHalfPage){
				if(_dragedHalfPageContainer.contains(_dragedHalfPage))
					_dragedHalfPageContainer.removeChild(_dragedHalfPage);
			}
			if(_allPage){
				if(_allPageContainer.contains(_allPage))
					_allPageContainer.removeChild(_allPage);
			}
			
			_dragedHalfPage = null;
			_allPage = null;
	
			if(_bmdAll)
				_bmdAll.dispose();
			if(_bmdHalf)
				_bmdHalf.dispose();
		}
		//拖动时，调整半页状态
		public function onDrag(cPoint:Point,angle:Number,pressedHotName:String):void
		{
			
			if(!_dragedHalfPageContainer||!_dragedHalfPage){
				return;
			}
			
			_dragedHalfPageContainer.x = cPoint.x;
			_dragedHalfPageContainer.y = cPoint.y;
			switch(pressedHotName)
			{
				case HotName.LEFT_UP:
					_dragedHalfPageContainer.rotation = angle+180;
					_dragedHalfPage.x = -1*_pageWidth/2;
					_dragedHalfPage.y = 0;
				    break;
				case HotName.LEFT_DOWN:
					_dragedHalfPageContainer.rotation = angle+180;
					_dragedHalfPage.x = -1*_pageWidth/2;
					_dragedHalfPage.y = -1*_pageHeight;
				    break;	
				case HotName.RIGHT_UP:
					_dragedHalfPageContainer.rotation = angle;
					_dragedHalfPage.x = 0;
					_dragedHalfPage.y = 0;
				    break;	
				case HotName.RIGHT_DOWN:
					_dragedHalfPageContainer.rotation = angle;
					_dragedHalfPage.x = 0;
					_dragedHalfPage.y = -1*_pageHeight;
				    break;	
			}
		}
	}

}