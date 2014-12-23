package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * 
	 * @author Desment
	 * list是feathers.controls.List组件，可给该组件设置皮肤
	 * refreshTips和loadTips是feathers.controls.Button组件，可给该组件设置皮肤
	 * 
	 */	
	public class LoadableList extends Sprite
	{
		public var list:List;
		public var refreshTips:Button;
		public var loadTips:Button;
		
		/**
		 * 刷新事件 
		 */		
		public static const REFRESH_EVENT:String = "LoadableListRefreshEvent";
		
		/**
		 * 加载事件 
		 */		
		public static const LOAD_EVENT:String = "LoadableListLoadEvent";
		
		public function LoadableList(){
			super();
			
			list = new List();
			list.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			list.dataProvider = new ListCollection();
			this.addChild(list);
			
			refreshTips = new Button();
			refreshTips.touchable = false;
//			refreshTips.y = -40;
			this.addChild(refreshTips);
			
			loadTips = new Button();
			loadTips.touchable = false;
			loadTips.y = list.height;
			this.addChild(loadTips);
			
			refreshAble = true;
			loadAble = true;
			addEventListeners();
			defaultTheme();
		}

		/**
		 * 加载提示在高度外的显示内容 
		 */		
		private var _laodTipsHeightOutLabel:String;
		public function get laodTipsHeightOutLabel():String
		{
			return _laodTipsHeightOutLabel;
		}

		public function set laodTipsHeightOutLabel(value:String):void
		{
			_laodTipsHeightOutLabel = value;
		}

		/**
		 * 加载提示在高度内的显示内容 
		 */		
		private var _loadTipsHeightInLabel:String;
		public function get loadTipsHeightInLabel():String
		{
			return _loadTipsHeightInLabel;
		}

		public function set loadTipsHeightInLabel(value:String):void
		{
			_loadTipsHeightInLabel = value;
			loadTips.label = value;
		}

		/**
		 * 刷新提示在高度外的显示内容
		 */		
		private var _refreshTipsHeightOutLabel:String;
		public function get refreshTipsHeightOutLabel():String
		{
			return _refreshTipsHeightOutLabel;
		}

		public function set refreshTipsHeightOutLabel(value:String):void
		{
			_refreshTipsHeightOutLabel = value;
		}
		
		/**
		 * 刷新提示在高度内的显示内容
		 */		
		private var _refreshTipsHeightInLabel:String;
		public function get refreshTipsHeightInLabel():String
		{
			return _refreshTipsHeightInLabel;
		}

		public function set refreshTipsHeightInLabel(value:String):void
		{
			_refreshTipsHeightInLabel = value;
			refreshTips.label = value;
		}

		/**
		 * 设置是否可刷新 
		 */		
		private var _refreshAble:Boolean;
		public function get refreshAble():Boolean{
			return _refreshAble;
		}

		public function set refreshAble(value:Boolean):void{
			_refreshAble = value;
			if(value){
				refreshTips.visible = true;
				list.addEventListener(FeathersEventType.END_INTERACTION, listEndInterHandler);
			}else{
				refreshTips.visible = false;
				list.removeEventListeners(FeathersEventType.END_INTERACTION);
			}
		}

		/**
		 * 设置是否可加载 
		 */		
		private var _loadAble:Boolean;
		public function get loadAble():Boolean{
			return _loadAble;
		}

		public function set loadAble(value:Boolean):void{
			_loadAble = value;
			if(value){
				loadTips.visible = true;
				list.addEventListener(FeathersEventType.SCROLL_COMPLETE, listScrollCompleteHandler);
			}else{
				loadTips.visible = false;
				list.removeEventListeners(FeathersEventType.SCROLL_COMPLETE);
			}
		}
		
		/**
		 * 设置list组件的dataProvider
		 */		
		public function setListData(array:Array):void{
			if(array == null) return;
			list.dataProvider = new ListCollection(array);
			/*if(refreshAble){
				TweenLite.to(refreshTips, 0.7, {y:-refreshTips.height});
			}*/
		}
		
		/**
		 * 向list组件中添加item
		 */		
		public function addListData(array:Array):void{
			if(array == null) return;
			for(var i:int = 0; i < array.length; i++){
				list.dataProvider.push(array[i]);
			}
			if(array.length > 0){
				TweenLite.to(list, 0.6, {verticalScrollPosition: list.verticalScrollPosition + 20});
			}
			if(loadAble){
//				loadTips.y = list.height;
				TweenLite.to(loadTips, 0.7, {y:list.height});
			}
		}
		
		override public function set height(value:Number):void{
			super.height = value;
			list.height = value;
			loadTips.y = value;
		}
		
		override public function set width(value:Number):void{
			super.width = value;
			list.width = value;
			refreshTips.width = value;
			loadTips.width = value;
		}
		
		private function addEventListeners():void{
			list.addEventListener(Event.SCROLL, listScrollHandler);
		}
		
		private function defaultTheme():void{
			refreshTipsHeightInLabel = "下拉即可更新...";
			refreshTipsHeightOutLabel = "松开立即更新...";
			loadTipsHeightInLabel = "加载中...";
		}
		
		private function listScrollHandler(event:Event):void{
			var position:Number = list.verticalScrollPosition;
			if(position <= 0){
				refreshTips.y = Math.abs(position) - 40;
				if(refreshTips.y > 0){
					refreshTips.label = refreshTipsHeightOutLabel;
				}else{
					refreshTips.label = refreshTipsHeightInLabel;
				}
			}else if(position >= list.maxVerticalScrollPosition){
				loadTips.y = list.height - list.verticalScrollPosition + list.maxVerticalScrollPosition;
			}
		}
		
		private function listScrollCompleteHandler():void{
			if(list.verticalScrollPosition >= list.maxVerticalScrollPosition){
				this.dispatchEventWith(LoadableList.LOAD_EVENT);
				if(loadAble){
//					list.verticalScrollPosition = list.maxVerticalScrollPosition + 40;
					loadTips.y = list.height - loadTips.height;
				}
			}
		}
		
		private function listEndInterHandler():void{
			if(list.verticalScrollPosition + 40 < 0){
				this.dispatchEventWith(LoadableList.REFRESH_EVENT);
				/*if(refreshAble){
//					list.verticalScrollPosition = -40;
					refreshTips.y = 0;
				}*/
			}
		}
		
	}
}