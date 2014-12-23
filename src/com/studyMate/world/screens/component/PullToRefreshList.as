package com.studyMate.world.screens.component
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.model.vo.PlaySoundEffectVO;
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class PullToRefreshList extends Sprite
	{
		private var juggler:Juggler;
		private var loading:MovieClip;
		private var scroller:ScrollContainer;
		private var layout:VerticalLayout;
		public function PullToRefreshList()
		{
			super();
			
			//Starling.current.root.stage.color = 0xdadada;
			
			//loading
			juggler = Starling.juggler;
			initHeadHolder();
//			initBottomHolder();
			
			
			layout = new VerticalLayout();
			layout.gap = 2;
//			layout.manageVisibility = true;
			scroller = new ScrollContainer;
			scroller.layout = layout;
			scroller.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			scroller.verticalScrollPolicy =  Scroller.SCROLL_POLICY_ON;
			scroller.paddingBottom = 40;
			scroller.clipContent = false;
			/*scroller.snapScrollPositionsToPixels = true;*/
			addChild(scroller);
			initBottomHolder();
			scroller.addEventListener(Event.SCROLL,scrollHandle);
			scroller.addEventListener(TouchEvent.TOUCH,touchHandle);
		}
		public function set setWidth(value:Number):void{
			scroller.width = value;
		}
		public function set setHeight(value:Number):void{
			scroller.height = value;
		}
		
		
		
		private var headHolder:Sprite;
		private var arrow:Image;
		private var pushTipSp:Sprite;
		private var downTips:Image;
		private var upTips:Image;
		private var loadingTips:Image;
		private function initHeadHolder():void{
			headHolder = new Sprite;
			headHolder.y = -50;
			addChild(headHolder);
			
			//arrow
			arrow = new Image(Assets.getPullToFresh("arrow_down"));
			centerPivot(arrow);
			arrow.x = 30;
			arrow.y = 25;
			headHolder.addChild(arrow);
			
			
			loading = new MovieClip(Assets.getPullToFreshAtlas().getTextures("loading_"),12);
			centerPivot(loading);
			loading.x = 30;
			loading.y = 25;
			loading.visible = false;
			headHolder.addChild(loading);
			
			pushTipSp = new Sprite;
			headHolder.addChild(pushTipSp);
			
			//tips
			downTips = new Image(Assets.getPullToFresh("downTips"));
			downTips.x = 127;
			downTips.y = 12;
			downTips.visible = true;
			upTips = new Image(Assets.getPullToFresh("upTips"));
			upTips.x = 127;
			upTips.y = 12;
			upTips.visible = false;
			pushTipSp.addChild(downTips);
			pushTipSp.addChild(upTips);
			
			loadingTips = new Image(Assets.getPullToFresh("loadingTips"));
			loadingTips.x = 142;
			loadingTips.y = 12;
			loadingTips.visible = false;
			headHolder.addChild(loadingTips);
			
			var lastTips:Image = new Image(Assets.getPullToFresh("lastTips"));
			lastTips.x = 113;
			lastTips.y = 30;
			headHolder.addChild(lastTips);
			
		}
		private var bottomHolder:Sprite;
		private var moreTips:Image;
		private var bottomLoadTips:Image;
		private var bottomLoading:MovieClip;
		private function initBottomHolder():void{
			bottomHolder = new Sprite;
			bottomHolder.y = 0;
			bottomHolder.visible = false;
			addChild(bottomHolder);
			
			moreTips = new Image(Assets.getPullToFresh("moreTips"));
			centerPivot(moreTips);
			moreTips.x = 160;
			moreTips.y = 20;
			bottomHolder.addChild(moreTips);
			
			bottomLoadTips = new Image(Assets.getPullToFresh("loadingTips"));
			centerPivot(bottomLoadTips);
			bottomLoadTips.x = 160;
			bottomLoadTips.y = 20;
			bottomLoadTips.visible = false;
			bottomHolder.addChild(bottomLoadTips);
			
			bottomLoading = new MovieClip(Assets.getPullToFreshAtlas().getTextures("loading_"),12);
			centerPivot(bottomLoading);
			bottomLoading.x = 290;
			bottomLoading.y = 20;
			bottomLoading.visible = false;
			bottomHolder.addChild(bottomLoading);
		}
		private var bottomY:Number;
		private var hasMore:Boolean = false;
		private function setBottomHolderY(val:Number=0):void{
			if(scroller){
//				scroller.validate();
//				scroller.viewPort.validate();
//				trace("底部高度："+scroller.viewPort.height);
				
				if(_useBottomMore){
					bottomHolder.y = bottomY = scroller.viewPort.height;
					bottomVisible = bottomHolder.y > 400 ? true : false;
				}
				
			}
			
		}
		
		
		
		private function set tipsVisible(_val:Boolean):void{
			downTips.visible = _val;
			upTips.visible = !_val;
		}
		private function set topTipsSpVisible(_val:Boolean):void{
			pushTipSp.visible = _val;
			loadingTips.visible = !_val;
		}
		private function set bottomTipsSpVisible(_val:Boolean):void{
			moreTips.visible = _val;
			bottomLoadTips.visible = !_val;
		}
		
		
		
		
		//性能优化——手动处理item显示
		private function setItemVisible(p:Number):void{
			if(!scroller)	return;
			
			var _p:Number = p-scroller.paddingTop;
			
			var item:DisplayObject;
			for (var i:int = 0; i < scroller.numChildren; i++) 
			{
				item = scroller.getChildAt(i);
				//如果上移的item下边缘超过了可视范围，则隐藏
				if(item.visible && _p > (item.y+item.height)){
					item.visible = false;
					
					//return 注释会增加运算
//					return;
				}else if(!item.visible && _p <= (item.y+item.height) && item.y <= (_p + scroller.height+scroller.paddingBottom)){
					item.visible = true;
					
//					return;
				}else if(item.visible && item.y > (_p + scroller.height+scroller.paddingBottom)){
					item.visible = false;
					
//					return;
				}
			}
			
		}
		
		private var lastPosition:Number = 0;
		private var position:Number;
		private function scrollHandle(e:Event):void{
			position = (e.target as Scroller).verticalScrollPosition;
//			trace("ver位置："+position);
			setItemVisible(position);
			//往下拉才移动loading容器
			if(isLoading){
				headHolder.y = -position;
				bottomHolder.y = 50+bottomY-position;
				return;
			}else{
				headHolder.y = -50-position;
				bottomHolder.y = bottomY-position;
			}
			
			//上拉处理
			/*if(position >= scroller.maxVerticalScrollPosition+10){
				trace("改变了");
				
			}*/
			
			

			//下拉处理
			if(position > -50){
				tipsVisible = true;
				TweenLite.to(arrow,0.15,{rotation:0});
				
				//从越界返回，播声音
				if(lastPosition <= -50){
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("release",10));
				}
			}else{	//下拉超过边界
				tipsVisible = false;
				TweenLite.to(arrow,0.15,{rotation:-Math.PI});
				
				//第一次越界，播声音
				if(lastPosition > -50){
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("pull",10));
				}
			}
			lastPosition = position;
			
			
			
		}
		private var isLoading:Boolean = false;
		private function touchHandle(e:TouchEvent):void{
			var touch:Touch = e.getTouch(this);				
			if(touch){
				if(touch.phase==TouchPhase.BEGAN){
//					isLoading = false;
					
				}else if(touch.phase==TouchPhase.MOVED){
					
				}else if(touch.phase==TouchPhase.ENDED){
					//超过边界，请求刷新
					if(_usePullRefresh && !isLoading && position < -50 ){
						
						
						
						//触发刷新
						startRefresh();
					}
					
					//上拉处理
					if(_useBottomMore && hasMore && position >= scroller.maxVerticalScrollPosition+15){
						
						
						startLoad();
					}
					
				}
				
				
			}	
		}
		
		
		//刷新
		public function startRefresh():void{
			
			
			isLoading = true;
			arrow.visible = false;
			topTipsSpVisible = false;
			
			loading.visible = true;
			juggler.add(loading);
			
			scroller.verticalScrollPosition = -1;	//处理列表较少item时，下拉刷新无法显示提示
			scroller.paddingTop = 50;
			/*scroller.clipContent = false;*/
			
		}
		public function endRefresh():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.PLAY_EFFECT_SOUND,new PlaySoundEffectVO("newMessagetoast",10));
			
			scroller.paddingTop = 0;
			/*scroller.clipContent = true;*/
			
//			TweenLite.to(scroller,0.2,{verticalScrollPosition:0});
			scroller.verticalScrollPosition = -1;	//处理空列表是，下拉刷新无法回退到0位置
			setItemVisible(0);
			
			loading.visible = false;
			juggler.remove(loading);
			
			isLoading = false;
			arrow.visible = true;
			topTipsSpVisible = true;
			tipsVisible = true;
			lastPosition = 0;
		}
		
		//开始加载
		public function startLoad():void{
			trace("改变了");
			
			bottomTipsSpVisible = false;
			bottomLoading.visible = true;
			juggler.add(bottomLoading);
		}
		public function eduLoad():void{
			numShowPage++;
			
			bottomTipsSpVisible = true;
			bottomLoading.visible = false;
			juggler.remove(bottomLoading);
			
		}
		
		public function set bottomVisible(val:Boolean):void{
			bottomHolder.visible = hasMore = val;
			scroller.paddingBottom = val ? 40 : 0;
		}
		
		/**
		 * 是否 使用下拉刷新 
		 */		
		private var _usePullRefresh:Boolean = true;
		/**
		 * 是否 使用上拉加载 
		 */		
		private var _useBottomMore:Boolean = true;
		public function set usePullRefresh(val:Boolean):void{
			_usePullRefresh = val;
			headHolder.visible = val;
			
		}
		public function set useBottomMore(val:Boolean):void{
			_useBottomMore = val;
			bottomVisible = val;
		}
		
		//当前显示页数
		public var numShowPage:int = 1;
		
		public function renderItem():void{
//			trace("收到了！"+scroller.verticalScrollPosition);
//			setItemVisible(scroller.verticalScrollPosition);
			//刷新item显示
			
		}
		public function get verPosition():Number{
			if(!scroller) return 0;
			return scroller.maxVerticalScrollPosition;
		}
		public function set verPosition(val:Number):void{
			if(scroller){
				scroller.verticalScrollPosition = val;
			}
		}
		
		
		public function addItem(_item:DisplayObject):void{
			if(scroller){
				scroller.addChild(_item);
				setBottomHolderY();
			}
		}
		public function addItemAt(_item:DisplayObject, index:int):void{
			if(scroller){
				scroller.addChildAt(_item, index);
				setBottomHolderY();
			}
		}
		public function removeItemAt(index:int, dispose:Boolean=false):void{
			if(scroller){
				scroller.removeChildAt(index,dispose); 
				setBottomHolderY();
			}
		}
		public function removeAllItem():void{
			if(scroller){
				scroller.removeChildren(0,-1,true);
			}
		}
		public function getItemAt(index:int):DisplayObject{
			if(scroller){
				return scroller.getChildAt(index);
			}
			return null;
		}
		public function get numItem():int{
			if(scroller){
				return scroller.numChildren;
			}
			return 0;
		}
		public function setItemIdx(item:DisplayObject, idx:int):void{
			if(scroller){
				scroller.setChildIndex(item, idx);
				//刷新scroller显示
				scroller.scrollToPosition(0,scroller.verticalScrollPosition+1,0.1);
				
			}
		}
		
		public function scrollToPosition(hPoistion:Number, vPosition:Number, duration:Number=0):void{
			if(scroller){
				scroller.scrollToPosition(hPoistion,vPosition,duration);
			}
		}
		
		
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
//			Starling.current.root.stage.color = 0xffffff;
			
			juggler.remove(loading);
			
			removeChildren(0,-1,true);
		}
		
		
		
		
	}
}