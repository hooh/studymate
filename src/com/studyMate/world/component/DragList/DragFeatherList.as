package com.studyMate.world.component.DragList
{
	import com.studyMate.global.Global;
	
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.events.FeathersEventType;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class DragFeatherList extends PullToRefreshList
	{
		private var _isEdit:Boolean;
		private var direction:int;//鼠标手势的方向-1为向右滚，1为向左滚
		private var currentObj:DisplayObjectContainer;
		private var leftBtn:Button;
		private var rightBtn:Button;
		
		public function DragFeatherList()
		{
			super();
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
//			Global.stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE,touchMoveHandler);//手势滑动，平板可调试
			this.addEventListener(Event.CHANGE, list_changeHandler );
			
		}
		
		public function get isEdit():Boolean
		{
			return _isEdit;
		}

		public function set isEdit(value:Boolean):void
		{
			
			if(_isEdit == value) return;
			_isEdit = value;
			if(value){//编辑状态
				this.stopScrolling();
				
				this.removeEventListener(TouchEvent.TOUCH, scroller_touchHandler);
				if(this._touchBlocker)
				{
					this.removeRawChildInternal(this._touchBlocker, true);
					this._touchBlocker = null;
				}	
				
				Starling.current.stage.addEventListener(TouchEvent.TOUCH,stageTouchHandler);
			}else{//非编辑滚动状态	
				ableOther();
				direction = 0;
				Global.stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE,gestureSwipeHandler);//手势滑动
				this.startScroll();
				this.addEventListener(TouchEvent.TOUCH, scroller_touchHandler);
				if(currentObj){
					currentObj.removeEventListener(TouchEvent.TOUCH,soundHandler);
				}
				if(!this._touchBlocker)
				{
					this._touchBlocker = new Quad(100, 100, 0xff00ff);
					this._touchBlocker.alpha = 0;
					this._touchBlocker.visible = false;
					this.addRawChildInternal(this._touchBlocker);
				}
				
				Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageTouchHandler);
				this.selectedItem = null;				
			}
		}
		
		private function stageTouchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				trace('stage阻止！');
				e.stopImmediatePropagation();
				if(isEdit){
					isEdit = false;					
										
					
				}
			}
		}
		
		override public function dispose():void{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			Global.stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE,gestureSwipeHandler);//手势滑动，平板可调试

			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageTouchHandler);
			super.dispose();
			
		}
		
		//鼠标手势		
		private function gestureSwipeHandler(event:TransformGestureEvent):void{	
			if(event.offsetX == -1) { //显示右侧
				leftBookHandler();
				
			} else if(event.offsetX == 1) { //显示左侧
				rightBookHandler();				
				
			} 
		}
		
		//向左浏览
		private function leftBookHandler():void{
			trace('向←');
			if(direction==1) return;
			if(direction!=-1){
				enableOther();
			}
			direction = 1;
			
			isEdit = true;
			
			if(rightBtn==null){
				rightBtn = new Button();
				rightBtn.label = '右侧按钮';
			}
			rightBtn.removeFromParent();
			this.addChild(rightBtn);
			
			currentObj = ((this.selectedObj) as DisplayObjectContainer);
			currentObj.addChild(rightBtn);
			currentObj.addEventListener(TouchEvent.TOUCH,soundHandler);
			
			rightBtn.addEventListener(TouchEvent.TOUCH,soundHandler);		
			rightBtn.x = currentObj.width;
			selectedObj.x = -100;
		}
		
		//向右浏览
		private function rightBookHandler():void{
			trace('向→');
			if(direction==-1) return;
			if(direction!=1){
				enableOther();
			}
			direction = -1;
			isEdit = true;
			
			
			if(leftBtn==null){
				leftBtn = new Button();
				leftBtn.label = '左侧按钮';
			}
			leftBtn.removeFromParent();
			
			currentObj = ((this.selectedObj) as DisplayObjectContainer);
			currentObj.addChild(leftBtn);
			currentObj.addEventListener(TouchEvent.TOUCH,currentHandler);
			
			leftBtn.addEventListener(TouchEvent.TOUCH,soundHandler);		
			leftBtn.x = -100;
			selectedObj.x = 100;
		}
		private	var pos:Point = new Point();
		private var pos0:Point = new Point();
		private function currentHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);	
			if(touch && touch.phase == TouchPhase.BEGAN){
				pos0 =  touch.getLocation(this,pos0);
			}else if(touch && touch.phase == TouchPhase.MOVED){
				touch.getLocation(this,pos);
//				tipHolder.x = pos.x-pos0.x;
//				tipHolder.y = pos.y-pos0.y;
			}
		}		
		
		private function soundHandler(e:TouchEvent):void{			
			if(e.touches[0].phase=="ended"){
				e.stopImmediatePropagation();
				trace('点击事件获取');
			}		
		}

		private var currentPosition:Number;
		private function list_changeHandler():void
		{
			if(this.selectedItem){
//				if(selectedObj){
					Global.stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE,gestureSwipeHandler);//手势滑动，平板可调试
					currentPosition = this.verticalScrollPosition;
					this.addEventListener(FeathersEventType.SCROLL_COMPLETE,scrollCompleteHandler);
					
//					if(isEdit){
//						this.addEventListener(TouchEvent.TOUCH, scroller_touchHandler);
//						if(!this._touchBlocker)
//						{
//							this._touchBlocker = new Quad(100, 100, 0xff00ff);
//							this._touchBlocker.alpha = 0;
//							this._touchBlocker.visible = false;
//							this.addRawChildInternal(this._touchBlocker);
//						}
//						isEdit = false;
//					}
//				}				
			}			
		}
		
		private function scrollCompleteHandler():void
		{
			trace('滚动完毕');
			var num:Number = this.verticalScrollPosition - currentPosition;
//			if(num>90 || num<-90){
//				this.selectedItem = null;
//				Global.stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE,gestureSwipeHandler);//手势滑动，平板可调试
//			}
		}		
		
		
		//上移动
		private function upMoveHandler():void{
			var index:int;
			var item:Object;
			index = this.selectedIndex;
			if(index>0){
				item = this.selectedItem;
				this.dataProvider.removeItem(item);
				this.dataProvider.addItemAt(item,index-1);
				this.selectedItem = item;
			}
		}
		//下一栋
		private function downMoveHandler():void{
			var index:int;
			var item:Object;
			index = this.selectedIndex;
			if(index<this.dataProvider.length-1){
				item = this.selectedItem;
				this.dataProvider.removeItem(item);
				this.dataProvider.addItemAt(item,index+1);
				this.selectedItem = item;
			}
		}
				
		private function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);	
			if(touch && touch.phase == TouchPhase.ENDED){
				if(this.selectedItem){	
//					TweenLite.killDelayedCallsTo(startDrag);
					(selectedObj as DisplayObject).removeEventListener(TouchEvent.TOUCH,touchHandler);
				}
			}
			
			
		}
		
		
		//除了当前选择项目以外的禁止点击事件
		public function enableOther():void{
			if(this.selectedItem){
				var _container:Sprite = this.getChildAt(0) as Sprite;
				for(var i:int=0; i<_container.numChildren; i++){
					var tmp:IListItemRenderer = _container.getChildAt(i) as IListItemRenderer;
					if(tmp!=null && tmp.data!=this.selectedItem){
						tmp.touchable = false;
					}
				}
			}
		}
		
		public function ableOther():void{
			var _container:Sprite = this.getChildAt(0) as Sprite;
			for(var i:int=0; i<_container.numChildren; i++){
				_container.getChildAt(i).touchable = true;
//				var tmp:IListItemRenderer = _container.getChildAt(i) as IListItemRenderer;
//				if(tmp!=null)
//					tmp.touchable = true;				
			}
		}
		
		//当前选择的项目
		public function get selectedObj():IListItemRenderer{
			if(this.selectedItem){
				var _container:Sprite = this.getChildAt(0) as Sprite;
				for(var i:int=0; i<_container.numChildren; i++){
					var tmp:IListItemRenderer = _container.getChildAt(i) as IListItemRenderer;
					if(tmp!=null && tmp.data==this.selectedItem){
						return tmp;
					}
				}
			}
			return null;
		}
		
		
		//深度复制
		public function copy(value:Object):Object   
		{   
			var buffer:ByteArray = new ByteArray();   
			buffer.writeObject(value);   
			buffer.position = 0;   
			var result:Object = buffer.readObject();   
			return result;   
		}  
		
	}
}