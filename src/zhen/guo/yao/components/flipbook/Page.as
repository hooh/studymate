package zhen.guo.yao.components.flipbook 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	internal class Page extends Sprite 
	{
		private var _pageArray:Array;//page数组
		public  var _currentPageIndex:uint = 0;//当前页序号
		private var _taretPageIndex:uint = 0;
		private var _pageCount:uint = 0;//总页数
		private var _isJump:Boolean = false;//是不是跳转
		private var _targetPageType:String;
		
		private var _nextPageloader:Sprite = new Sprite();
		private var _prevPageloader:Sprite = new Sprite();
		private var _currentPageLoader:Sprite = new Sprite();
		
		public  var _nextPageContainer:Sprite = new Sprite();
		public  var _prevPageContainer:Sprite = new Sprite();
		public  var _currentPageContainer:Sprite = new Sprite();
		
		//因为在本地测试的时候loader.close不能停止，所以设置一下三个属性标记loader状态
		private var _currentLoaderClosed:Boolean = true;
		public  var _nextLoaderClosed:Boolean = true;
		public  var _prevLoaderClosed:Boolean = true;
		
		public function Page() :void
		{
			addChild(_currentPageContainer);
			
			_currentPageLoader.name = "current";
			_nextPageloader.name = "next";
			_prevPageloader.name = "prev";
			
			/*_currentPageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, currentLoadComHandler);
			_nextPageloader.contentLoaderInfo.addEventListener(Event.COMPLETE, nextLoadComHandler);
			_prevPageloader.contentLoaderInfo.addEventListener(Event.COMPLETE, prevLoadComHandler);*/
			
			/*_currentPageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, currentLoadProHandler);
			_nextPageloader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, nextLoadProHandler);
			_prevPageloader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, prevLoadProHandler);
			
			_currentPageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, currentLoadErrHandler);
			_nextPageloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, nextLoadErrHandler);
			_prevPageloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, prevLoadErrHandler);*/
		}
		private function currentLoadComHandler(idx:uint):void
		{
			if (!_currentLoaderClosed)
			{
				if (_targetPageType=="jump_next")
				{
					if (_nextPageContainer.numChildren != 0)
					{
						_nextPageContainer.removeChildAt(0);
					}
					_nextPageContainer.addChild(PageUtils.getPage(idx));
					
					var event:ContainerReadyEvent = new ContainerReadyEvent(ContainerReadyEvent.READY);
					event.containerType = ContainerReadyEvent.JUMP_NEXT;
					dispatchEvent(event);
				}
				else if(_targetPageType=="jump_prev")
				{
					if (_prevPageContainer.numChildren != 0)
					{
						_prevPageContainer.removeChildAt(0);
					}
					_prevPageContainer.addChild(PageUtils.getPage(idx));
					
					var event2:ContainerReadyEvent = new ContainerReadyEvent(ContainerReadyEvent.READY);
					event2.containerType = ContainerReadyEvent.JUMP_PREV;
					dispatchEvent(event2);
				}
				else if (_targetPageType == "cover")
				{
					_currentPageContainer.addChild(PageUtils.getPage(idx,"c"));
					
					var event3:ContainerReadyEvent = new ContainerReadyEvent(ContainerReadyEvent.READY);
					event3.containerType = ContainerReadyEvent.COVER;
					dispatchEvent(event3);
					
					//_nextPageloader.load(new URLRequest(_pageArray[_currentPageIndex + 1]));
					_nextLoaderClosed = false;
					nextLoadComHandler(_currentPageIndex + 1);
				}
				_currentLoaderClosed = true;
				_targetPageType = null;
			}
		}
		public function nextLoadComHandler(idx:uint):void
		{
			if (!_nextLoaderClosed)
			{
				if (_nextPageContainer.numChildren == 0)
				{
					_nextPageContainer.addChild(PageUtils.getPage(idx+1));
					
					var event:ContainerReadyEvent = new ContainerReadyEvent(ContainerReadyEvent.READY);
					event.containerType = ContainerReadyEvent.NEXT;
					dispatchEvent(event);
				}
				else
				{
					//throw new Error("容器不为空");
				}
				if (_targetPageType == "next")
				{
					_targetPageType = null;
				}
				_nextLoaderClosed = true;
			}
		}
		public function prevLoadComHandler(idx:uint):void
		{
			if (!_prevLoaderClosed)
			{
				if (_prevPageContainer.numChildren == 0)
				{
					_prevPageContainer.addChild(PageUtils.getPage(idx+1));
					
					var event:ContainerReadyEvent = new ContainerReadyEvent(ContainerReadyEvent.READY);
					event.containerType = ContainerReadyEvent.PREV;
					dispatchEvent(event);
				}
				else
				{
					//throw new Error("容器不为空");
				}
				_prevLoaderClosed = true;
				if (_targetPageType == "prev")
				{
					_targetPageType = null;
				}
			}
		}
		private function closeCurrent():void
		{
			_currentLoaderClosed = true;
			try
			{
				//_currentPageLoader.close();
			}
			catch (err:Error)
			{
							
			}
		}
		private function closeNext():void
		{
			_nextLoaderClosed = true;
			try
			{
				//_nextPageloader.close();
			}
			catch (err:Error)
			{
							
			}
		}
		private function closePrev():void
		{
			_prevLoaderClosed = true;
			try
			{
				//_prevPageloader.close();
			}
			catch (err:Error)
			{
							
			}
		}
		
		private function currentLoadProHandler(evn:ProgressEvent):void
		{
			if (_targetPageType == "jump_next" || _targetPageType == "jump_prev"||_targetPageType == "cover")
			{
				var _loadProgressEvent:LoadProgressEvent = new LoadProgressEvent(LoadProgressEvent.LOAD_PROGRESS);
				_loadProgressEvent.per = evn.bytesLoaded / evn.bytesTotal;
				dispatchEvent(_loadProgressEvent);
			}
		}
		private function nextLoadProHandler(evn:ProgressEvent):void
		{
			if (_targetPageType == "next" )
			{
				var _loadProgressEvent:LoadProgressEvent = new LoadProgressEvent(LoadProgressEvent.LOAD_PROGRESS);
				_loadProgressEvent.per = evn.bytesLoaded / evn.bytesTotal;
				dispatchEvent(_loadProgressEvent);
			}
		}
		private function prevLoadProHandler(evn:ProgressEvent):void
		{
			if ( _targetPageType == "prev")
			{
				var _loadProgressEvent:LoadProgressEvent = new LoadProgressEvent(LoadProgressEvent.LOAD_PROGRESS);
				_loadProgressEvent.per = evn.bytesLoaded / evn.bytesTotal;
				dispatchEvent(_loadProgressEvent);
			}
		}
		private function currentLoadErrHandler(evn:IOErrorEvent):void
		{
			dispatchLoadErrorEvent(_pageArray[_taretPageIndex])
		}
		private function nextLoadErrHandler(evn:IOErrorEvent):void
		{
			dispatchLoadErrorEvent(_pageArray[_currentPageIndex + 1])
		}
		private function prevLoadErrHandler(evn:IOErrorEvent):void
		{
			dispatchLoadErrorEvent(_pageArray[_currentPageIndex - 1])
		}
		private function dispatchLoadErrorEvent(pageURL:String):void
		{
			var event:LoadErrorEvent = new LoadErrorEvent(LoadErrorEvent.LOAD_ERROR);
			event.pageURL = pageURL;
			dispatchEvent(event);
		}
		/*------------------------------------------------------------------------------------------------------------------------*/
		public function closeLoader():void
		{
			closeCurrent();
			closeNext();
			closePrev();
		}
		//public function next
		//目标页不是当前页、当前页下一页、当前页上一页是调用
		public function jump(index:uint):void
		{
			_isJump = true;
					
			_taretPageIndex = index;
			if (index > _currentPageIndex)
			{
				_targetPageType = "jump_next";
			}
			else if (index < _currentPageIndex)
			{
				_targetPageType = "jump_prev";
			}
			_currentLoaderClosed = false;
			currentLoadComHandler(index);
		}
		//加载第一页
		public function loadCover():void
		{
			_targetPageType = "cover";
			_taretPageIndex = 0;
			_currentLoaderClosed = false;
			currentLoadComHandler(1);
		}
		public function loadNext():void
		{
			if (!isEnd)
			{
				_nextLoaderClosed = false;
				nextLoadComHandler(_currentPageIndex + 1);
			}
		}
		public function loadPrev():void
		{
			if (!isStart)
			{
				_prevLoaderClosed = false;
				prevLoadComHandler(_currentPageIndex - 1);
			}
		}
		//翻页完毕后调用，如果留在了当前页，则不调用：next,prev
		//更换三个容器中内容的位置
		public function flipCompleteHandler(type:String):void
		{
			switch(type)
			{
				case FlipType.PREV:
				    //处理下一页容器
				    if (_nextPageContainer.numChildren == 1)
					{
						_nextPageContainer.removeChildAt(0);
					}
					
					//处理当前页容器
					if (_isJump)
					{
						_currentPageContainer.removeChildAt(0);
					}
					else
					{
						_nextPageContainer.addChild(_currentPageContainer.getChildAt(0));
					}
					_currentPageContainer.addChild(_prevPageContainer.getChildAt(0));
					
					//更新当前页序号
					if (_isJump)
					{
						_currentPageIndex = _taretPageIndex;
					}
					else
					{
						_currentPageIndex--;
					}
					
					//判断加载
					if (_currentPageIndex > 0)
					{
						_prevLoaderClosed = false;
						prevLoadComHandler(_currentPageIndex - 1);
					}
					if (_isJump)
					{
						if (_currentPageIndex < _pageCount - 1)
						{
							_nextLoaderClosed = false;
							nextLoadComHandler(_currentPageIndex + 1);
						}
					}
				    break;
				case FlipType.NEXT:
				    //处理上一页容器
				    if (_prevPageContainer.numChildren == 1)
					{
						_prevPageContainer.removeChildAt(0);
					}
					
					//处理当前页容器
					if (_isJump)
					{
						_currentPageContainer.removeChildAt(0);
					}
					else
					{
						_prevPageContainer.addChild(_currentPageContainer.getChildAt(0));
					}
					_currentPageContainer.addChild(_nextPageContainer.getChildAt(0));
					
					//更新当前页序号
					if (_isJump)
					{
						_currentPageIndex = _taretPageIndex;
					}
					else
					{
						_currentPageIndex++;
					}
					
					//判断加载
					if (_currentPageIndex < _pageCount - 1)
					{
						_nextLoaderClosed = false;
						nextLoadComHandler(_currentPageIndex + 1);
					}
					if (_isJump)
					{
						if (_currentPageIndex > 0)
						{
							_prevLoaderClosed = false;
							prevLoadComHandler(_currentPageIndex - 1);
						}
					}
				    break;
				case FlipType.CURRENT:
				    //当拖动翻页鼠标按下时，所有loader都被close了。当松开鼠标时，如果还是留在当前页，要继续加载
				    if (prevPage == null)//如果上一页没准备号
					{
						if (!isStart)//如果不是第一页
						{
							loadPrev()
						}
					}
					if (nextPage == null)
					{
						if (!isEnd)
						{
							loadNext();
						}
					}
			}
			_isJump = false;
		}
		
		/*----------------------------------------------------------------------------------------------------*/
		//当前序号
		//翻页完毕后更新
		public function get currentPageIndex():uint
		{
			return _currentPageIndex;
		}
		//翻页完毕后更新
		public function get pageCount():uint
		{
			return _pageCount;
		}
		//page数组
		public function set pageArray(array:Array):void
		{
			_pageArray = array;
			_pageCount = _pageArray.length;
		}
		public function get pageArray():Array
		{
			return _pageArray;
		}
		
		//当前是不是第一页
		public function get isStart():Boolean
		{
			if (_currentPageIndex == 0)
			{
				return true;
			}
			return false;
		}
		//当前是不是最后一页
		public function get isEnd():Boolean
		{
			if (_currentPageIndex == _pageCount - 1)
			{
				return true;
			}
			return false;
		}
		//设置调度加载类型
		public function set loadingType(type:String):void
		{
			_targetPageType = type;
		}
		//获得当前页引用
		public function get currentPage():DisplayObject
		{
			if (_currentPageContainer.numChildren == 1)
			{
				return _currentPageContainer.getChildAt(0);
			}
			return null;
		}
		//获得下一页引用
		public function get nextPage():DisplayObject
		{
			if (_nextPageContainer.numChildren == 1)
			{
				return _nextPageContainer.getChildAt(0);
			}
			return null;
		}
		//获得上一页引用
		public function get prevPage():DisplayObject
		{
			if (_prevPageContainer.numChildren == 1)
			{
				return _prevPageContainer.getChildAt(0);
			}
			return null;
		}
		//下一页是否被停止
		public function get nextLoaderClosed():Boolean
		{
			return _nextLoaderClosed;
		}
		//前一页是否被停止
		public function get prevLoaderClosed():Boolean
		{
			return _prevLoaderClosed;
		}
		//当前loader是否被停止
		public function get currentLoaderClosed():Boolean
		{
			return _currentLoaderClosed;
		}
	}

}