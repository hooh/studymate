package com.studyMate.view.component.myScroll {
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.ThrowPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.studyMate.global.Global;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.utils.getTimer;
	
	TweenPlugin.activate([ThrowPropsPlugin]);
	
	/**
	 * AS3 Scroll 组件滚动，可以根据滚动对象的大小而自动识别为垂直滚动、竖直滚动或自由滚动
	 * 
	 * 常见用法及属性、方法请参考以下内容
	 * 
	 *  var scroll:Scroll = new Scroll();
	 *	scroll.x = 0;
	 *	scroll.y = 10;
	 *	scroll.width = 700;
	 *	scroll.height = 450;			
	 *	var sp:Sprite = setupTextField(700,2300,20);
	 *	scroll.viewPort = sp;
	 *	scroll.pageScrollingEnabled = true;
	 *	this.addChild(scroll);
	 * 
	 *  sp.width = 500;
	 * 	sp.scale = 2;
	 *  scroll.update();//刷新属性
	 * 	
	 * 
	 * 属性
	 * @ viewPort				需要滚动的容器，接收DisplayObjectContainer及其继承类
	 * @ x						显示 x坐标
	 * @ y						显示 y坐标
	 * @ width					显示 宽度
	 * @ height					显示 高度
	 * @ pageScrollingEnabled	是否按页滚动，默认false按像素滚动
	 * @ page					当pageScrollingEnabled=true时，按页滚动，page等于当前页。首页等于0。
	 * @ totalPage				当pageScrollingEnabled=true时。（totalPage+1）代表总的页码数。
	 * @ state					滚动模式。水平：HORIZONTAL,垂直:VERTICAL,自动:AUTO
	 * @ delayTime				平滑滚动时间
	 * 
	 * 方法
	 *  @ update				当外部改变viewPort属性、位置、或其它变更时，需刷新页面时，请调用update
	 * 
	 * 事件
	 * scroll.addEventListener(Scroll.EFFECT_START,effectstart);  //滚动开始
	 * scroll.addEventListener(Scroll.EFFECT_END,effectend);	  //滚动结束
	 */ 
	
	
	
	public final class Scroll extends Sprite 
	{
		/**--------------------事件---------------------------*/
		public static const EFFECT_START:String = "EFFECT_START";
		public static const EFFECT_END:String = "EFFECT_END";
		
		/**--------------------类外部属性---------------------------*/
		private var _horizontalScrollPosition:Number;//水平滚动距离
		private var _verticalScrollPosition:Number;//垂直滚动距离
		private var _viewPort:DisplayObjectContainer; //要滚动的组件
		private var _pageScrollingEnabled:Boolean; //是否按页翻
		private var _width:Number=0; //scroll宽度,== 遮罩的宽度
		private var _height:Number=0; //scroll高度 == 遮罩的高度
		private var _page:int=0;//当前第0页
		private var _state:String = "AUTO";//当前状态，水平：HORIZONTAL,垂直:VERTICAL,自动:AUTO
		private var _delayTime:Number=0.5;//平滑滚动时间
		private var viewpPintX:Number=0;
		
		
		/**--------------------类内部部属性---------------------------*/
		private var blitMask:MyBlitMask;//遮罩,有viewPort则一定有该对象						
		private var _needUpdate:Boolean = false;		
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		private var _totalPage:int=0;
		
		private var t1:uint, t2:uint, y1:Number, y2:Number, x1:Number, x2:Number, xOverlap:Number, xOffset:Number, yOverlap:Number, yOffset:Number;
		/*private var t2:uint;
		private var xOffset:Number;
		private var xOverlap:Number;
		private var yOffset:Number;
		private var yOverlap:Number;
		private var x1:Number;
		private var x2:Number;
		private var y1:Number;
		private var y2:Number;*/				
		
		public function Scroll() {			
			this.addEventListener(Event.ADDED_TO_STAGE,addScrollHandler);			
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeScrollHandler);
		}				
		//添加到舞台
		
		
		private function addScrollHandler(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,addScrollHandler);
			ScrollChangeHandler();//scroll尺寸
			viewPortChangeHandler();//viewPort尺寸
		}
		//从舞台移除
		private function removeScrollHandler(e:Event):void{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removeScrollHandler);
			TweenLite.killTweensOf(_viewPort);
			blitMask.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownClick);			
			Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);//注册滑动			
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpClick,true);//注册松手,捕获，使其优先处理结束特效
			Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN,preventBlitMastListnener);//可以拦截starling的touchEvent，begin和move事件
			blitMask.dispose();
			
		}
		
		public function update():void{
			if(_viewPort){
				viewpPintX = _viewPort.x;
				blitMask.width = _width;
				blitMask.height = _height;
				viewPortChangeHandler();
				if(_viewPort.y < -viewPort.height-10){
					TweenLite.to(_viewPort,0.3,{y:0});
				}
				
				if(_state == "HORIZONTAL"){
					_page = int(-_viewPort.x/this._width);
				}else if(_state == "VERTICAL"){
					_page = int(-_viewPort.y/this._height);
				}
			}
		}
		/**
		 /*----------------------------------舞台变更-------------------------------------------*/
		//侦听scroll组件是尺寸变化(scroll添加到舞台后执行)
		private function ScrollChangeHandler(e:Event=null):void{
			if(_viewPort == null){
				throw new Error("addchild Scroll组件前请制定 viewPort对象");
			}else{
				_viewPort.addEventListener(Event.ADDED,viewPortChangeHandler,false,0,true);
				_viewPort.addEventListener(Event.REMOVED,viewPortChangeHandler,false,0,true);
				//_viewPort.addEventListener(Event.RENDER,viewPortRender);
				if(blitMask==null){
					blitMask = new MyBlitMask(_viewPort,0,0,_width,_height);
					//修复bug，点击拖动范围阻止一切事件的派发。
					blitMask.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownClick);
					blitMask.addEventListener(MouseEvent.MOUSE_MOVE,preventBlitMastListnener);
					blitMask.addEventListener(MouseEvent.MOUSE_UP,preventBlitMastListnener);
					blitMask.addEventListener(MouseEvent.MOUSE_OUT,preventBlitMastListnener);					
					blitMask.bitmapMode = false;
				}else{
					blitMask.width = _width;
					blitMask.height = _height;
				}								
				needUpdate = false;//还原,无需更新
			}
		}				
		
		protected function preventBlitMastListnener(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			event.preventDefault();
		}
		//侦听viewPort尺寸变化 。viewPort添加元素和删除元素的变更(viewPort添加到舞台后执行)
		private var a:Boolean,b:Boolean,c:Number,d:Number;
		private function viewPortChangeHandler(e:Event=null):void{
			if(_viewPort.width > this.width){
				_state = "HORIZONTAL";
				_totalPage = int(_viewPort.width/_width);
				a = true;
			}
			if(_viewPort.height > this.height){
				_state = "VERTICAL";
				_totalPage = int(_viewPort.height/_height);
				b = true;
			}
			if(a&&b){
				_state = "AUTO";
			}
			a = b = false;			
			//xOverlap = Math.max(0, _viewPort.width - this._width);//水平偏移差。
			//yOverlap = Math.max(0, _viewPort.height - this._height);//是否包含字内部，内部=0，外部=viewPort高度-scroll容器与的高度差
			c = _viewPort.width - this._width;
			xOverlap = c>0 ? c : 0;
			d =  _viewPort.height - this._height;
			yOverlap = d>0 ? d : 0;
			
			if(xOverlap==0 && yOverlap==0 && _viewPort.x>=0 && _viewPort.y>=0){
				if(blitMask.hasEventListener(MouseEvent.MOUSE_DOWN))
					blitMask.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownClick);				
			}else{
				blitMask.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownClick);
			}			
		}
		
		
		/**
		 /*----------------------------------鼠标事件集合-------------------------------------------*/
		private function mouseDownClick(e:MouseEvent):void{
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN,preventBlitMastListnener,false,8);//可以拦截starling的touchEvent，begin和move事件
			e.stopImmediatePropagation();
			e.preventDefault();
			////trace("鼠标点击");	
			TweenLite.killTweensOf(_viewPort);
			_viewPort.mouseChildren = true;
			
			x1 = x2 = _viewPort.x;
			xOffset = this.mouseX - _viewPort.x;
			y1 = y2 = _viewPort.y;
			yOffset = this.mouseY - _viewPort.y;
			t1 = t2 = getTimer();
			
			mouseDownX = this.mouseX;
			mouseDownY = this.mouseY;
			
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true,0,true);//注册滑动
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpClick,true,0,true);//注册松手,捕获，使其优先处理结束特效
		}
		private var setMouseEnable:Boolean=true;//true鼠标可用
		private function mouseMoveHandler(e:MouseEvent):void{////trace("鼠标滑动事件");	
			
			switch(_state){
				case "AUTO":
					if(Math.abs(this.mouseX-mouseDownX)<8 && Math.abs(this.mouseY-mouseDownY)<8  ){
						return;
					}
					xSpeed();
					ySpeed();
					break;
				case "HORIZONTAL":
					if(Math.abs(this.mouseX-mouseDownX)<10 ){
						return;
					}
					xSpeed();
					break;
				case "VERTICAL":
					if(Math.abs(this.mouseY-mouseDownY)<10 ){
						return;
					}
					ySpeed();
					break;
			}			
			if(setMouseEnable){
				setMouseEnable=false;
				_viewPort.mouseChildren = false;
			}
			
			if(!_pageScrollingEnabled){				
				var t:uint = getTimer();
				if(t-t2 > 200){
					x2 = x1;
					x1 = _viewPort.x;
					y2 = y1;
					t2 = t1;
					y1 = _viewPort.y;
					t1 = t;
				}
			}
			//e.updateAfterEvent();
			//i = (i ^ (i >> 31)) - (i >> 31);//返回整数取绝对值		
		}
		private function xSpeed():void{
			var x:Number = this.mouseX - xOffset;
			if(_pageScrollingEnabled){
				_viewPort.x = x;
			}
			if (x > 0) {
				_viewPort.x = (x + 0) >> 1;								
			} else if (x < 0 - xOverlap) {
				_viewPort.x = (x + 0 - xOverlap) >> 1;
			} else {
				_viewPort.x = x;
			}
		}
		private function ySpeed():void{
			var y:Number = this.mouseY - yOffset;// y = 偏移值+viewPort起始坐标
			if(_pageScrollingEnabled){
				_viewPort.y = y;
				return;
			}
			if(y > 0){//顶部,向下滚
				_viewPort.y = (y + 0) >> 1;//如果_viewPort的坐标超出边界，使其拖动只有一半距离								
			}else if(y < 0-yOverlap){//底部
				_viewPort.y = (y + 0 -yOverlap) >> 1;
			}else{//中部
				_viewPort.y = y;				
			}
		}
		
		private function mouseUpClick(e:MouseEvent):void{		
			Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN,preventBlitMastListnener);
			Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,true);
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpClick,true);
			//return;		
			//---------------按页滚动------------------------
			if(_pageScrollingEnabled && _state != "AUTO"){
				if(_state == "HORIZONTAL"){
					pageScollX();
				}else if(_state == "VERTICAL"){
					pageScrollY();
				}				
			}
				//---------------按像素滚动---------------------
			else{
				var time:Number;
				var xVelocity:Number;
				var yVelocity:Number;
				if(setMouseEnable){//点击事件。跳过move滚动，则不执行下面的了
					if(_viewPort.y > 0 || (_viewPort.y+_viewPort.height) < this._height || _viewPort.x>viewpPintX || (_viewPort.x+_viewPort.width)<(viewpPintX+_viewPort.width)){
						//trace("边界l呃呃呃呃呃呃呃呃呃呃了");
						time = (getTimer() - t2)* 0.001;
						xVelocity = (_viewPort.x - x2) / time;
						yVelocity = (_viewPort.y - y2) / time;
						TweenLite.to(_viewPort, 0.5, {throwProps:{ 
							y:{velocity:yVelocity, max:0, min:0-yOverlap,resistance:300},
							x:{velocity:xVelocity, max:0, min:0-xOverlap,resistance:300}},
							onComplete:tweenComplete,ease:Strong.easeOut});
					}
					return;
				}				
				time = (getTimer() - t2)* 0.001;
				if(_state == "HORIZONTAL"){
					xVelocity = (_viewPort.x - x2) / time;
					TweenLite.to(_viewPort, _delayTime, {throwProps:{ 					
						x:{velocity:xVelocity, max:0, min:0-xOverlap,resistance:300}},
						onComplete:tweenComplete,ease:Strong.easeOut});
				}else if(_state == "VERTICAL"){
					yVelocity = (_viewPort.y - y2) / time;				
					TweenLite.to(_viewPort, _delayTime, {throwProps:{ 
						y:{velocity:yVelocity, max:0, min:0-yOverlap,resistance:300}},
						onComplete:tweenComplete,ease:Strong.easeOut});
				}else{
					xVelocity = (_viewPort.x - x2) / time;
					yVelocity = (_viewPort.y - y2) / time;	
					TweenLite.to(_viewPort, _delayTime, {throwProps:{ 
						y:{velocity:yVelocity, max:0, min:0-yOverlap,resistance:300},
						x:{velocity:xVelocity, max:0, min:0-xOverlap,resistance:300}},
						onComplete:tweenComplete,ease:Strong.easeOut});
				}				
			}
			
			setMouseEnable = true;			
		}
		//水平方向按页滚动
		private function pageScollX():void{
			var xVelocity:Number = _viewPort.x - x2 ;
			
			if(xVelocity>0){//向右
				this.dispatchEvent(new Event(EFFECT_START));
				if(_page==0){
					TweenLite.to(_viewPort, _delayTime, {x:0,onComplete:tweenComplete});
				}else{
					_page--;
					TweenLite.to(_viewPort, _delayTime, {x:-_page*_width,onComplete:tweenComplete});							
				}						
				//trace("向右滚动,页面==="+page);
			}else if(xVelocity<0){//向左
				this.dispatchEvent(new Event(EFFECT_START));
				if(_page==_totalPage){
					//TweenLite.to(_viewPort, 0.5, {x:(-viewPort.width+_width),onComplete:tweenComplete});
					TweenLite.to(_viewPort, _delayTime, {x:-_page*_width,onComplete:tweenComplete});
				}else{
					_page++;
					TweenLite.to(_viewPort, _delayTime, {x:-_page*_width,onComplete:tweenComplete});
				}
				//trace("向左滚动,页面==="+page);
			}else{
				//trace("当前页面==="+page);
				TweenLite.to(_viewPort, _delayTime, {x:-_page*_width,onComplete:tweenComplete});		
			}
			//trace();
		}
		//垂直方向按页滚动
		private function pageScrollY():void{
			var yVelocity:Number = _viewPort.y - y2 ;
			//trace(yVelocity)
			if(yVelocity>0){//向下
				this.dispatchEvent(new Event(EFFECT_START));
				if(_page==0){
					TweenLite.to(_viewPort, _delayTime, {y:0,onComplete:tweenComplete});
				}else{
					_page--;
					TweenLite.to(_viewPort, _delayTime, {y:-_page*_height,onComplete:tweenComplete});							
				}						
				//trace("向下滚动,页面==="+page);
			}else if(yVelocity<0){//向上
				this.dispatchEvent(new Event(EFFECT_START));
				if(_page==_totalPage){
					//TweenLite.to(_viewPort, 0.5, {y:(-viewPort.height+_height),onComplete:tweenComplete});
					TweenLite.to(_viewPort, _delayTime, {y:-_page*_height,onComplete:tweenComplete});
				}else{
					_page++;
					TweenLite.to(_viewPort, _delayTime, {y:-_page*_height,onComplete:tweenComplete});
				}
				//trace("向上滚动,页面==="+page);
			}else{
				TweenLite.to(_viewPort, _delayTime, {y:-_page*_height,onComplete:tweenComplete});
			}
		}
		
		//暂时注释掉，开始滚动的时间
		/*private function tweenStart():void{
		//等待测试啊。。			
		if(_state == "HORIZONTAL"){
		if(_viewPort.x >=0 || (_viewPort.x+_viewPort.width)<=this._width){
		delayTime = 0.5;
		}else{
		delayTime = 0.5;
		}
		}else if(_state == "VERTICAL"){
		//trace("y的值 = "+(_viewPort.y - y2));
		if(_viewPort.y >=0 || (_viewPort.y+_viewPort.height) <= this._height){
		delayTime = 0.5;
		}else{
		delayTime = 0.5;
		}
		}
		}*/
		
		private function tweenComplete():void{
			//trace("滚动完毕");			
			if(blitMask){
				blitMask.bitmapMode = false;
			}
			this.dispatchEvent(new Event(EFFECT_END));
			_viewPort.mouseChildren = true;						
		}
		
		
		/**
		 /*----------------------------------属性设定-------------------------------------------*/		
		public function set viewPort(value:DisplayObjectContainer):void {
			if(_viewPort == value) return;
			if(_viewPort != null){//如果曾经有过
				throw new Error("请销毁viewPort和Scroll组件，另外重新建立");
			}
			_viewPort = value;
			super.addChild(_viewPort);	
			if(stage){
				needUpdate = true;
			}
		}
		override public function set width(value:Number):void {
			if(_width == value) return;
			_width = value;
			if(stage){
				needUpdate = true;
			}
		}
		override public function set height(value:Number):void {
			if(_height == value) return;
			_height = value;
			if(stage){
				needUpdate = true;
			}			
		}
		public function set pageScrollingEnabled(value:Boolean):void{
			if(_pageScrollingEnabled == value) return;
			_pageScrollingEnabled = value;
			/*if(stage){
			//needUpdate = true;
			}*/
		}
		public function set horizontalScrollPosition(value:Number):void{
			_viewPort.x = -value;
			_horizontalScrollPosition = value;
		}
		public function set verticalScrollPosition(value:Number):void{
			_viewPort.y = -value;
			_verticalScrollPosition = value;
		}
		public function set needUpdate(value:Boolean):void{
			if(_needUpdate == value) return;
			_needUpdate = value;
			if(_needUpdate){
				this.addEventListener(Event.RENDER,ScrollChangeHandler);
				if(stage!=null) stage.invalidate();
			}else{
				this.removeEventListener(Event.RENDER,ScrollChangeHandler);
			}			
		}
		public function set delayTime(value:Number):void{
			if(value>0){
				_delayTime = value;
			}			
		}
		public function set state(value:String):void
		{
			_state = value;
		}
		
		
		/**
		 /*----------------------------------属性获取-------------------------------------------*/
		public function get viewPort():DisplayObjectContainer {
			return _viewPort;
		}
		override public function get width():Number {
			return _width;
		}
		override public function get height():Number {
			return _height;
		}
		public function get pageScrollingEnabled():Boolean{
			return _pageScrollingEnabled;
		}
		
		public function get horizontalScrollPosition():Number{
			return -_viewPort.x;
		}
		public function get verticalScrollPosition():Number{
			return -_viewPort.y;
		}
		public function get needUpdate():Boolean{
			return _needUpdate;
		}
		override public function addChild(child:DisplayObject):DisplayObject{
			throw new Error("Scroll组件请不要使用addChild，请使用.viewPort=");
		}

		public function get page():int{
			return _page;
		}
		public function get state():String{
			return _state;
		}
		public function get totalPage():int{
			return _totalPage;
		}		
	}
}
