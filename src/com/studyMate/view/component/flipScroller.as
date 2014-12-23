package com.studyMate.view.component
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	
	import zhen.guo.yao.components.flipbook.FlipCompleteEvent;

	/**
	 *可以实现翻页效果的滚动菜单，使用 group 实现 scroller 功能
	 * @author JL
	 * 
	 */	
	public class flipScroller extends Group
	{
		private var FSScope:Rectangle = new Rectangle(); //滚动范围

		private var groupCount:int; //可视元素总个数
		private var pagePER:int; //每页的元素个数
		
		private var fsStartPosition:int; //触摸开始点
		private var fsMovePosition:int; //记录移动触摸的位置
		public  var fsPosition:int = 0; //flipScroller的位置X
		private var firstPage:Boolean = false; //是否为第一页
		private var lastPage:Boolean = false; //是否为最后一页
		private var countPage:int ; //总页数
		private var preFSPosition:Number; //滚动区域最远位置
		private var maxDistance:int = 0; //手势移动距离点击位置最远距离
		
		public  var currentPage:int = 0; //当前页码
		
	
		public function flipScroller()
		{
			
			init();
			
		}
		
		public function init():void{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			this.addEventListener(TouchEvent.TOUCH_BEGIN,FSTouchBegin);
			
			this.addEventListener(FlipCompleteEvent.FLIP_COMPLETE, flipComHandler);//翻页完毕
		}

		
		//翻页完毕
		private function flipComHandler(evn:FlipCompleteEvent):void
		{
			currentPage = (int)(fsPosition/-1280);
			
			var event:FlipCompleteEvent = new FlipCompleteEvent(FlipCompleteEvent.FLIP_COMPLETE);
			event.flipType = evn.flipType;
			dispatchEvent(event);

		}
		
		/**
		 * flipScroller中的Group元素，每一页为一个Group.
		 * @param _count 可视元素总个数
		 * @param _pagePER 每页元素个数
		 * @param _x 第一页横坐标
		 * @param _y 第一页纵坐标
		 * @param _width 第一页宽度
		 * @param _height 第一页高度
		 */
		public function setGroup(_count:int,_pagePER:int,_x:Number,_y:Number,_width:Number,_height:Number):void{
			groupCount = _count;
			pagePER = _pagePER;
			countPage = (int)(_count/_pagePER)+1;
			for(var i:int = 0 ; i < countPage ; i++){
				var groupPage:Group = new Group(); 
				groupPage.id = "gp"+i;
				//groupPage.x = i*(2*_x + _width) + 10;
				groupPage.x = i*(2*_x + _width);
				groupPage.y = _y;
				groupPage.width = _width;
				groupPage.height = _height;
				this.addElement(groupPage);
				
			}
			
		}
		
		/**
		 * 向flipScroller添加可视元素
		 * 容器内元素在每页从左到右、从上到下排序插入
		 * @param index 元素序号
		 * @param element 插入的可是元素
		 */
		public function _addElement(index:int,element:IVisualElement):void{
			var i:int = (int)(index/pagePER);
			//("gp"+i as Group).addElement(element);
			(this.getElementAt(i) as Group).addElement(element);
		}
		
		/**
		 * 设置flipScroller可滚动区域
		 * @param _x 可滚动区域最左端横坐标
		 * @param _y 可滚动区域最左端纵坐标
		 * @param _width 可滚动区域宽度
		 * @param _height 可滚动区域高度
		 */
		public function setFSScope(_x:Number,_y:Number,_width:Number,_height:Number):void{
			FSScope.x = _x;
			FSScope.y = _y;
			FSScope.width = _width;
			FSScope.height = _height;
		}
		
		/**
		 * 设置flipScroller开始触摸事件
		 */
		private function FSTouchBegin(event:TouchEvent):void{
			this.stage.frameRate=60;

			maxDistance = 0;
			fsStartPosition = this.stage.mouseX;
			fsMovePosition = fsStartPosition;
			if(this.x % 1280 == 0)
				fsPosition = this.x;
			
			if(this.x == 0 || fsPosition == 0){
				fsMovePosition = this.stage.mouseX;
				firstPage = true;
			}
			if(this.x == FSScope.x || fsPosition == FSScope.x){
				fsMovePosition = this.stage.mouseX;
				lastPage = true;
			}
			if(firstPage == false && lastPage == false){
				this.startTouchDrag(event.touchPointID,false,FSScope);
			}
			this.addEventListener(TouchEvent.TOUCH_MOVE,FSTouchMove);
			this.stage.addEventListener(TouchEvent.TOUCH_END,FSTouchEnd);

			
		}
		
		/**
		 * 设置flipScroller结束触摸事件
		 */
		private function FSTouchEnd(event:TouchEvent):void{
			
			firstPage = false;
			lastPage = false;
			this.mouseChildren = true;
			this.stage.removeEventListener(TouchEvent.TOUCH_END,FSTouchEnd);
			this.stopTouchDrag(event.touchPointID);
			this.removeEventListener(TouchEvent.TOUCH_MOVE,FSTouchMove);
			TweenLite.killTweensOf(this);
			var mtgcurNum:int = fsPosition/(-1280);
			
			//向左划动
//			if((this.stage.mouseX - fsStartPosition) <= -100){
			trace("最远距离："+maxDistance +"===离开位置："+this.stage.mouseX);
			if((maxDistance < 0) && ((this.stage.mouseX - fsStartPosition) < maxDistance * (3/4)) && (this.stage.mouseX - fsStartPosition) <= -100){
				if(fsPosition == FSScope.x){				
					TweenLite.to(this,1.5,{x:FSScope.x,ease:Quint.easeOut,onComplete:onFinishTween});
				}
				else{

					TweenLite.to((this.getElementAt(mtgcurNum) as Group),0.5,{alpha:0});  //当前页离开
					TweenLite.to((this.getElementAt(mtgcurNum+1) as Group),0.5,{alpha:1});  //右边页进入
					
					var a:int = fsPosition - 1280;
					fsPosition = a;
					TweenLite.to(this,1.5,{x:a,ease:Quint.easeOut,onComplete:onFinishTween});
				}
				
			} 
				//向右划动
//			else if((this.stage.mouseX - fsStartPosition) >= 100){
			else if((maxDistance > 0) && ((this.stage.mouseX - fsStartPosition) > maxDistance * (3/4)) && (this.stage.mouseX - fsStartPosition) >= 100){
				if(fsPosition == 0){
					TweenLite.to(this,1.5,{x:0,ease:Quint.easeOut,onComplete:onFinishTween});
				}
				else{
					TweenLite.to((this.getElementAt(mtgcurNum-1) as Group),0.5,{alpha:1});  //左边页进入
					TweenLite.to((this.getElementAt(mtgcurNum) as Group),0.5,{alpha:0});  //当前页离开
					
					var b:int = fsPosition + 1280;    
					fsPosition = b;
					TweenLite.to(this,1.5,{x:b,ease:Quint.easeOut,onComplete:onFinishTween});
				}
			}
			else{
				TweenLite.to((this.getElementAt(mtgcurNum) as Group),0.5,{alpha:1});
				TweenLite.to(this,1.5,{x:fsPosition,ease:Quint.easeOut,onComplete:onFinishTween});
			}

		}
		
		/**
		 * 设置flipScroller移动触摸事件
		 */
		private function FSTouchMove(event:TouchEvent):void{
			TweenLite.killTweensOf(this);
			if(Math.abs(this.stage.mouseX - fsStartPosition) > 20)
				this.mouseChildren = false;
			if(Math.abs(this.stage.mouseX - fsStartPosition) > Math.abs(maxDistance))
				maxDistance = this.stage.mouseX - fsStartPosition;
			var moveDirect:Number = this.stage.mouseX - fsMovePosition;
			if((firstPage && (this.stage.mouseX>fsStartPosition)) || (lastPage && (this.stage.mouseX <fsStartPosition))){
				this.stopTouchDrag(event.touchPointID);
				this.x += (30*moveDirect/(this.stage.mouseX+1));
				fsMovePosition = this.stage.mouseX;
			}else{

				var mtgcurNum:int = fsPosition/(-1280);
				if(mtgcurNum>=1)
					(this.getElementAt(mtgcurNum-1) as Group).alpha = (mtgcurNum)+(this.x/1280);
				
				if(moveDirect <= 0)
					(this.getElementAt(mtgcurNum) as Group).alpha = (mtgcurNum+1)+(this.x/1280);
				else
					(this.getElementAt(mtgcurNum) as Group).alpha = -(this.x/1280+(mtgcurNum-1));
				
//				if((mtgcurNum+2)<=3 && countPage != 1)
				if((mtgcurNum+2)<= countPage)
					(this.getElementAt(mtgcurNum+1) as Group).alpha = -((this.x/1280)+mtgcurNum);
				
				
				this.startTouchDrag(event.touchPointID,false,FSScope);
			}
			
			event.updateAfterEvent();
		}
		
		private function onFinishTween():void{
			if(this.stage != null)
				this.stage.frameRate=24;
		}
		
		

		
		
	}
}