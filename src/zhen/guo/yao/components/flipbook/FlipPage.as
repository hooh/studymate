package zhen.guo.yao.components.flipbook 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	//import zhen.guo.yao.GC;
	//import zhen.guo.yao.components.flipbook.FlipEvent;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class FlipPage extends Sprite 
	{
		private var _checkPoint:CheckPoint;//判断各点坐标
		public var _page:Page;//负责加载
		public var _hot:Hot; //四个热区
		
		private var _staticPageMask:StaticMask;//不动的页面的遮罩
		private var _dragedPageMask:DragedMask;//被拖动的页面的遮罩
		private var _downShadowMask:ShadowMask;//跟随移动的阴影的遮罩
		private var _upShadowMask:DragedMask;//跟随移动的阴影的遮罩
		
		private var _halfPage:HalfPage;//被拖动的半页
		
		private var _upShadow:Shadow;//跟随移动的c点方向的阴影
		private var _downShadow:Shadow;//跟随移动的页脚方向的阴影
		private var _staticShadow:Shadow;//翻页完毕后显示的阴影
		
		private var _shadowManager:ShadowManager;
		private var _dragedHalfPageContainer:Sprite;
		private var _allPageContainer:Sprite;
		
		private var _pageWidth:Number=0;//页面宽度
		private var _pageHeight:Number=0;//页面高度
		
		private var _canBeDraged:Boolean = false;//是不是能被拖动
		
		public var pages:Array;
		
		/**
		 * 构造函数
		 * @param	pageWidth 页面宽度
		 * @param	pageHeight 页面高度
		 * @param	hotWidth 热区宽度
		 */
		public function FlipPage(pageWidth:Number,pageHeight:Number,hotWidth:Number=50) :void
		{
			init(pageWidth,pageHeight,hotWidth);
		}
		//页面宽度、页面高度、热区宽度
		private function init(pageWidth:Number,pageHeight:Number,hotWidth:Number):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			
			_pageWidth = pageWidth;
			_pageHeight = pageHeight;
			
			_checkPoint = new CheckPoint();
			_checkPoint.setSize(pageWidth, pageHeight);
			_checkPoint.addEventListener(FlipEvent.MOVE, moveHandler);//翻页过程中
			_checkPoint.addEventListener(FlipCompleteEvent.FLIP_COMPLETE, flipComHandler);//翻页完毕
			
			_page = new Page();
			_page.addEventListener(ContainerReadyEvent.READY, readyHandler);//页面预备好了
			_page.addEventListener(LoadProgressEvent.LOAD_PROGRESS, loadProgressHandler);//页面加载中
			_page.addEventListener(LoadErrorEvent.LOAD_ERROR, loadErrorHandler);//页面加载中
			
			_staticPageMask = new StaticMask();
			_dragedPageMask = new DragedMask();
			_upShadowMask = new DragedMask();
			
			_staticPageMask.mouseEnabled=false;
			_dragedPageMask.mouseEnabled=false;
			_upShadowMask.mouseEnabled=false;
			
			_allPageContainer = new Sprite();
			_dragedHalfPageContainer = new Sprite();
			_dragedHalfPageContainer.mask = _dragedPageMask;
			_allPageContainer.mask = _staticPageMask;
			
			_halfPage = new HalfPage(pageWidth, pageHeight,_dragedHalfPageContainer,_allPageContainer);
			
			//设置阴影
			_downShadowMask = new ShadowMask();
			_downShadowMask.mouseEnabled=false;
			_downShadowMask.creat(_pageWidth, _pageHeight);
			_upShadow = new Shadow();
			_upShadow.mouseEnabled=false;
			_upShadow.creat(_pageWidth, _pageHeight, false);
			_downShadow = new Shadow();
			_downShadow.mouseEnabled=false;
			_downShadow.creat(_pageWidth, _pageHeight, false);
			_staticShadow = new Shadow();
			_staticShadow.mouseEnabled=false;
			_staticShadow.creat(_pageWidth, _pageHeight, true);
			//设置不动的阴影的坐标
			_staticShadow.x = _pageWidth / 2;
			_staticShadow.y = _pageHeight / 2;
			_downShadow.mask = _downShadowMask ;
			_upShadow.mask = _upShadowMask ;
			
			//_downShadowMask.visible=false
			
			_shadowManager = new ShadowManager();
			_shadowManager.upShadow = _upShadow;
			_shadowManager.downShadow = _downShadow;
			_shadowManager.staticShadow = _staticShadow;
			
			_hot = new Hot(pageWidth, pageHeight, hotWidth);
			_hot.showHot = Hot.RIGHT;
			_hot.addEventListener(HotEvent.PRESSED, hotPressedHandler);//在热区按下
			_hot.addEventListener(HotEvent.RELEASED, hotReleasedHandler);//在热区按下后松开
			_hot.addEventListener(HotEvent.DRAGED, hotDragedHandler);//在热区按下后并拖动
			
			
			addChild(_staticPageMask);
			addChild(_dragedPageMask);
			addChild(_downShadowMask);
			addChild(_upShadowMask);
			
			addChild(_page);
			addChild(_staticShadow);
			addChild(_allPageContainer);
			addChild(_downShadow);
			addChild(_dragedHalfPageContainer);
			addChild(_upShadow);
			
			addChild(_hot);
		}
		
		protected function removeFromStageHandler(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			if(_page){
				_page.removeEventListener(ContainerReadyEvent.READY, readyHandler);//页面预备好了
				_page.removeEventListener(LoadProgressEvent.LOAD_PROGRESS, loadProgressHandler);//页面加载中
				_page.removeEventListener(LoadErrorEvent.LOAD_ERROR, loadErrorHandler);//页面加载中
			}
			if(_hot){
				_hot.removeEventListener(HotEvent.PRESSED, hotPressedHandler);//在热区按下
				_hot.removeEventListener(HotEvent.RELEASED, hotReleasedHandler);//在热区按下后松开
				_hot.removeEventListener(HotEvent.DRAGED, hotDragedHandler);//在热区按下后并拖动
			}
			this.removeChildren();
			pages = null;
			if(_checkPoint){
				_checkPoint.removeEventListener(FlipEvent.MOVE, moveHandler);//翻页过程中
				_checkPoint.removeEventListener(FlipCompleteEvent.FLIP_COMPLETE, flipComHandler);//翻页完毕
				_checkPoint.dispose();
			}
		}
		//运动过程中
		private function moveHandler(evn:Event):void
		{
			_dragedPageMask.draw(_checkPoint.theCPoint, _checkPoint.theDPoint, _checkPoint.theBPoint, _checkPoint.theAPoint);//调整遮罩
			_upShadowMask.draw(_checkPoint.theCPoint, _checkPoint.theDPoint, _checkPoint.theBPoint, _checkPoint.theAPoint);//调整遮罩
			_staticPageMask.draw(_pageWidth, _pageHeight, _hot.pressedHotName, _checkPoint.theDPoint, _checkPoint.theBPoint, _checkPoint.theAPoint);//调整遮罩
			_halfPage.onDrag(_checkPoint.theCPoint, _checkPoint.pageAngle, _hot.pressedHotName);//调整运动的半页的状态
			_shadowManager.setShadow(_checkPoint.theDPoint, _checkPoint.theBPoint, _checkPoint.lineAngle);//调整阴影状态
			
			_hot.showHot = Hot.NULL;//隐藏所有热区
		}
		//翻页完毕
		private function flipComHandler(evn:FlipCompleteEvent):void
		{
			_page.flipCompleteHandler(evn.flipType);
			_halfPage.free();
			if (_page.isEnd || _page.isStart)
			{
				_shadowManager.flipCompleteHandler(evn.flipType,true);
			}
			else
			{
				_shadowManager.flipCompleteHandler(evn.flipType);
			}
			_dragedPageMask.clear();
			_staticPageMask.clear();
			
			if (_page.isStart)//如果是第一页
			{
				_hot.showHot = Hot.RIGHT;//只显示右边的两个热区
			}
			else if (_page.isEnd)//如果是最后一页
			{
				_hot.showHot = Hot.LEFT;//只显示左边的两个热区
			}
			else
			{
				_hot.showHot = Hot.ALL;//热区全部显示
			}
			
			var event:FlipCompleteEvent = new FlipCompleteEvent(FlipCompleteEvent.FLIP_COMPLETE);
			event.flipType = evn.flipType;
			dispatchEvent(event);
			
			//GC.gc();
		}
		//页面准备好了
		private function readyHandler(evn:ContainerReadyEvent):void
		{
			var event:ContainerReadyEvent = new ContainerReadyEvent(ContainerReadyEvent.READY);
			if (evn.containerType == ContainerReadyEvent.JUMP_NEXT || evn.containerType == ContainerReadyEvent.NEXT)
			{
				event.containerType = ContainerReadyEvent.NEXT;
			}
			else if (evn.containerType == ContainerReadyEvent.JUMP_PREV || evn.containerType == ContainerReadyEvent.PREV)
			{
				event.containerType = ContainerReadyEvent.PREV;
			}
			else if (evn.containerType == ContainerReadyEvent.COVER)
			{
				event.containerType = ContainerReadyEvent.COVER;
			}
			dispatchEvent(event);
		}
		//加载过程中
		private function loadProgressHandler (evn:LoadProgressEvent):void
		{
			var _loadProgressEvent:LoadProgressEvent = new LoadProgressEvent(LoadProgressEvent.LOAD_PROGRESS);
			_loadProgressEvent.per = evn.per;
			dispatchEvent(_loadProgressEvent);
		}
		//加载错误
		private function loadErrorHandler(evn:LoadErrorEvent):void
		{
			var event:LoadErrorEvent = new LoadErrorEvent(LoadErrorEvent.LOAD_ERROR);
			event.pageURL = evn.pageURL;
			dispatchEvent(event);
		}
		//在热区上按下
		private function hotPressedHandler(evn:HotEvent):void
		{
			if (evn.hotName == HotName.LEFT_DOWN || evn.hotName == HotName.LEFT_UP)
			{
				if (_page.prevPage)//如果上一页准备好了
				{
					_page.loadingType = "";
					_page.closeLoader();
					
					_canBeDraged = true;
					_halfPage.addAllPage(_page.prevPage, "left");//生成半页
				}
				else
				{
					_canBeDraged = false;
				}
			}
			else if (evn.hotName == HotName.RIGHT_DOWN || evn.hotName == HotName.RIGHT_UP)
			{
				if (_page.nextPage)
				{
					_page.loadingType = "";
					_page.closeLoader();
					
					_canBeDraged = true;
					_halfPage.addAllPage(_page.nextPage, "right");
				}
				else
				{
					_canBeDraged = false;
				}
			}
			var event:HotEvent = new HotEvent(HotEvent.PRESSED);
			event.hotName = evn.hotName;
			dispatchEvent(event);
		}
		//在热区上按下并松开
		private function hotReleasedHandler(evn:HotEvent):void
		{
			if (_canBeDraged)
			{
				if (_hot.draged)//如果移动过
				{
					_checkPoint.autoFlipAferDrag();
				}
				else//如果没有移动过
				{
					_checkPoint.autoFlip(_hot.pressedHotName);
				}
				_canBeDraged = false;
				
				var event:HotEvent = new HotEvent(HotEvent.RELEASED);
				event.hotName = evn.hotName;
				dispatchEvent(event);
			}
		}
		//在热区上按下并且拖动
		private function hotDragedHandler(evn:HotEvent):void
		{
			if (_canBeDraged)
			{
				_checkPoint.checkPoints(mouseX, mouseY, _hot.pressedHotName);
				var event:HotEvent = new HotEvent(HotEvent.DRAGED);
				event.hotName = evn.hotName;
				dispatchEvent(event);
			}
		}
		
		/*---------------------------------------------------------------------------------------------方法-------------------*/
		/**
		 * 调用该方法开始加载
		 * @param	array 存放页面路径数组
		 */
		public function load(array:Array):void
		{
			pages = _page.pageArray = array;
			_page.loadCover();
		}
		
		/**
		 * 按页面的索引加载 把页码作为数据传给每个页面
		 * @param _total 页面个数
		 * 
		 */		
		public function loadByPageIndex(_total:uint):void{
			
			var arr:Array = [];
			for (var i:int = 1; i <=_total+1; i++) 
			{
				arr.push(i);
			}
			load(arr);
			
		}
		
		
		
		
		
		/**
		 * 翻到下一页
		 */
		public function next():void
		{
			if (!_checkPoint.moving)//如果没有动
			{
				if (_page.currentPage != null)//如果当前容器不为空（如果封面已经加载完了）
				{
					if (_page.nextPage!=null)//如果下一页准备好了
					{
						_page.loadingType = "";
						_page.closeLoader();
						_canBeDraged = true;
						
						//moveHandler侦听器中需要用到该属性。
						//在点击按钮翻页时，设置该属性，模拟鼠标点击hot
						_hot.pressedHotName = HotName.RIGHT_DOWN;
						
						_halfPage.addAllPage(_page.nextPage, "right");//绘制被拖动的bitmap
						_checkPoint.autoFlip(HotName.RIGHT_DOWN);//开始翻页
					}
					else
					{
						_page.loadingType = "next";
						if (_page.nextLoaderClosed)
						{
							_page.loadNext();
						}
					}
				}
			}			
		}
		/**
		 * 翻到上一页
		 */
		public function prev():void
		{
			if (!_checkPoint.moving)
			{
				if (_page.currentPage != null)//如果当前容器不为空（如果封面已经加载完了）
				{
					if (_page.prevPage != null )//如果上一页准备好了
					{
						_page.loadingType = "";
						_page.closeLoader();
						_canBeDraged = true;
						
						//moveHandler侦听器中需要用到该属性。
						//在点击按钮翻页时，设置该属性，模拟鼠标点击hot
						_hot.pressedHotName = HotName.LEFT_DOWN;

						_halfPage.addAllPage(_page.prevPage, "left");//绘制被拖动的bitmap
						_checkPoint.autoFlip(HotName.LEFT_DOWN);//开始翻页
					}
					else
					{
						_page.loadingType = "prev";
						if (_page.prevLoaderClosed)
						{
							_page.loadPrev();
						}
					}
				}
			}
		}
		/**
		 * 跳转页面
		 * @param	n 要跳转到的页面的序号
		 */
		public function goTo(n:uint):void
		{
			if (n < _page.pageCount)//如果小于总数量
			{
				if (!_checkPoint.moving)//如果当前没有动
				{
					if (_page.currentPage != null)//如果当前容器不为空（如果封面已经加载完了）
					{
						if (n != _page.currentPageIndex)//如果不是当前页
						{
							if (n == _page.currentPageIndex + 1)//如果是下一页
							{
								next();
							}
							else if (n == _page.currentPageIndex - 1)//如果是上一页
							{
								prev();
							}
							else
							{
								_page.closeLoader();
								_page.jump(n);
							}
						}
					}
				}
			}
		}
		
		public function gotoPage(n:uint):void
		{
			if (n < _page.pageCount)//如果小于总数量
			{
				if (!_checkPoint.moving)//如果当前没有动
				{
					if (_page.currentPage != null)//如果当前容器不为空（如果封面已经加载完了）
					{
						if (n != _page.currentPageIndex)//如果不是当前页
						{
//							if (n == _page.currentPageIndex + 1)//如果是下一页
//							{
//								next();
//							}
//							else if (n == _page.currentPageIndex - 1)//如果是上一页
//							{
//								prev();
//							}
//							else
//							{
								_page._currentPageContainer.removeChildAt(0);
								if(_page._nextPageContainer.numChildren == 1)
									_page._nextPageContainer.removeChildAt(0);
								
								if(_page._prevPageContainer.numChildren == 1)
									_page._prevPageContainer.removeChildAt(0);
								_page._currentPageContainer.addChild(PageUtils.getPage(n+1));
								_page._nextPageContainer.addChild(PageUtils.getPage(n+2));
								_page._prevPageContainer.addChild(PageUtils.getPage(n));
								_page._currentPageIndex = n;
								
								if (_page._currentPageIndex < _page.pageCount - 1)
								{
									_page._nextLoaderClosed = false;
									_page.nextLoadComHandler(_page._currentPageIndex + 1);
								}
	
								if (_page._currentPageIndex > 0)
								{
									_page._prevLoaderClosed = false;	
									_page.prevLoadComHandler(_page._currentPageIndex - 1);
								}
								
								if (_page.isStart)//如果是第一页
								{
									_hot.showHot = Hot.RIGHT;//只显示右边的两个热区
								}
								else if (_page.isEnd)//如果是最后一页
								{
									_hot.showHot = Hot.LEFT;//只显示左边的两个热区
								}
								else
								{
									_hot.showHot = Hot.ALL;//热区全部显示
								}

//							}
						}
					}
				}
			}
		}
		
		/*----------------------------------------------------------------------------------------------属性--------------------*/
		/**
		 * 翻页完毕后是否显示中间阴影
		 */
		public function set showShadowOnFlipComplete(show:Boolean):void
		{
			_shadowManager.showShadowOnFlipComplete = show;
		}
		public function get showShadowOnFlipComplete():Boolean
		{
			return _shadowManager.showShadowOnFlipComplete;
		}
		/**
		 * 当前页序号。从0开始
		 */
		public function get currentPageIndex():uint
		{
			return _page.currentPageIndex;
		}
		/**
		 * 总页数
		 */
		public function get pageCount():uint
		{
			return _page.pageCount;
		}
		/**
		 * 当前页的引用
		 */
		public function get currentPage():DisplayObject
		{
			return _page.currentPage;
		}
		/**
		 * 下一页的引用
		 */
		public function get nextPage():DisplayObject
		{
			return _page.nextPage;
		}
		/**
		 * 上一页的引用
		 */
		public function get prevPage():DisplayObject
		{
			return _page.prevPage;
		}
		/**
		 * 热区透明度
		 */
		public function set hotAlpha(a:Number):void
		{
			_hot.hotAlpha = a;
		}
		public function get hotAlpha():Number
		{
			return _hot.hotAlpha;
		}
	}

}