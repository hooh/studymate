package zhen.guo.yao.components.flipbook
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	

	internal  class CheckPoint extends EventDispatcher
	{		
		private var _pageWidth:Number;//page的宽度
		private var _pageHeight:Number;//page的高度
		
		private var _rDown:Number;//下面半圆的半径
		private var _rUp:Number;//上面半圆的半径
		private var _startCorner:String;
		private var _cPoint:Point=new Point();//c点
		private var _dPoint:Point=new Point();//d点
		private var _bPoint:Point=new Point();//b点
		private var _aPoint:Point;//a点
		
		private var _targetPoint:Point = new Point();//松开鼠标时，此点为c点。tweenlite控制该点运动，c点跟随。
		
		private var _targetPageType:String;//目标页
		
		private var _pageAngle:Number;//角度 
		private var _lineAngle:Number;//两页书交线的角度
		private var _moving:Boolean = false;
		/**
		 * 构造函数
		 */
		public function CheckPoint():void
		{
			
		}
		/**
		 * 计算c点位置
		 * @param	mouse_X 鼠标所在的横坐标
		 * @param	mouse_Y 鼠标所在的纵坐标
		 * @param	cornerName 起始页脚的名称
		 */
		private function judgeCpointPosition(mouse_X:Number,mouse_Y:Number,cornerName:String):void
		{
			var cPointY:Number;
			
			//设置c点横坐标值
			if(mouse_X>=_pageWidth)//如果鼠标滑出书的右边
			{
				_cPoint.x=_pageWidth;
			}
			else if(mouse_X<=0)//如果鼠标滑出书的左边
			{
				_cPoint.x=0;
			}
			else
			{
				_cPoint.x=mouse_X;
			}
			
			//计算纵坐标
			if(cornerName==HotName.LEFT_DOWN||cornerName==HotName.RIGHT_DOWN)//如果点击的是下面两个热区
			{
				//计算c点纵坐标值
				if(mouse_Y>_pageHeight)//如果鼠标在书的下边的下方
				{
					cPointY=Math.sqrt(_rDown*_rDown-(_cPoint.x-_pageWidth/2)*(_cPoint.x-_pageWidth/2))+0;
					if(cPointY<mouse_Y)//如果在半圆外
					{
						_cPoint.y=cPointY;
					}
					else//如果在半圆内
					{
						_cPoint.y=mouse_Y;
					}
				}
				else//如果鼠标在书的下边的上方
				{
					cPointY=-Math.sqrt(_rUp*_rUp-(_cPoint.x-_pageWidth/2)*(_cPoint.x-_pageWidth/2))+_pageHeight;
					if(cPointY>mouse_Y)//如果在半圆外
					{
						_cPoint.y=cPointY;
					}
					else//如果在半圆内
					{
						_cPoint.y=mouse_Y;
					}
				}
			}
			else//如果点击的是上面的热区
			{
				//计算c点纵坐标值
				if(mouse_Y<0)//如果鼠标在书的下边的下方
				{
					cPointY=-Math.sqrt(_rDown*_rDown-(_cPoint.x-_pageWidth/2)*(_cPoint.x-_pageWidth/2))+_pageHeight;
					if(cPointY>mouse_Y)//如果在半圆外
					{
						_cPoint.y=cPointY;
					}
					else//如果在半圆内
					{
						_cPoint.y=mouse_Y;
					}
				}
				else//如果鼠标在书的下边的上方
				{
					cPointY=Math.sqrt(_rUp*_rUp-(_cPoint.x-_pageWidth/2)*(_cPoint.x-_pageWidth/2))+0;
					if(cPointY<mouse_Y)//如果在半圆外
					{
						_cPoint.y=cPointY;
					}
					else//如果在半圆内
					{
						_cPoint.y=mouse_Y;
					}
				}
			}
		}
		/**
		 * 计算c点和起点连线垂直平分线的斜率
		 * @param	cPoint c点
		 * @param	pointCorner 起点
		 * @return
		 */
		private function getK0(cPoint:Point,pointCorner:Point):Number
		{
			var disX:Number=pointCorner.x-cPoint.x;
			var disY:Number=pointCorner.y-cPoint.y;
			if(disX==0)
			{
				disX=0.0001
			}
			var k:Number=disY/disX;//c点和起点连线的斜率
			if(k==0)
			{
				k=0.0001;
			}
			
			_lineAngle = Math.atan2(pointCorner.y - cPoint.y, pointCorner.x - cPoint.x) * 180 / Math.PI;
			
			return -1*1/k;
		}
		protected function checkPageAngle(cPoint:Point, dPoint:Point):void
		{
			_pageAngle = Math.atan2(dPoint.y - cPoint.y, dPoint.x - cPoint.x) * 180 / Math.PI;
		}
		/**
		 * 计算d、b、a点坐标
		 * @param	mouse_X 鼠标所在的横坐标
		 * @param	mouse_Y 鼠标所在的纵坐标
		 * @param	cornerName 起始页脚的名称
		 */
		private function judgeOtherPointPosition(mouse_X:Number,mouse_Y:Number,cornerName:String):void
		{
			/*
			B:between
			C:c点
			S：StartCorner 起始角
			*/
			var pointBCS_X:Number;//c点和起点的中点的横坐标
			var pointBCS_Y:Number;//c点和起点的中点的纵坐标
			var k:Number;//垂直于c点和起点连线的直线的斜率
			var bPoint_X:Number//b点的横坐标
			var cx:Number;//a点（和起点在同一个书边的角的中点）的横坐标
			var cy:Number;//a点（和起点在同一个书边的角的中点）的纵坐标
			
			switch(cornerName)
			{
				case HotName.RIGHT_DOWN:
					//计算c点和起点页脚的中心点
					pointBCS_X=_cPoint.x+(_pageWidth-_cPoint.x)/2;
					pointBCS_Y=_cPoint.y+(_pageHeight-_cPoint.y)/2;
					//计算垂直于c点和起点连线的直线的斜率
					k=getK0(_cPoint,new Point(_pageWidth,_pageHeight));
					//计算d点坐标
					_dPoint.x=(_dPoint.y-pointBCS_Y)/k+pointBCS_X;
					_dPoint.y=_pageHeight;
					
					//计算b、a点
					bPoint_X=(0-pointBCS_Y)/k+pointBCS_X;//b点横坐标;
					if(bPoint_X>_pageWidth)//如果b点横坐标在横着的书边以外，则必点沿着竖着的树边走
					{
						_aPoint = null;
						
						//计算b点坐标
						_bPoint.x=_pageWidth;
						_bPoint.y=(_pageWidth-pointBCS_X)*k+pointBCS_Y;
					}
					else//如果b点横坐标在横着的书边以内，则b点沿着横着着的树边走
					{
						if (_aPoint == null)
						{
							_aPoint = new Point();
						}
						//计算a点坐标
						cx=(_pageWidth+0*k-k*pointBCS_Y+k*k*pointBCS_X)/(1+k*k);
						cy=k*(cx-pointBCS_X)+pointBCS_Y;
						_aPoint.x=2*cx-_pageWidth;
						_aPoint.y=2*cy-0;
						//计算b点坐标
						_bPoint.y=0;
						_bPoint.x=(0-pointBCS_Y)/k+pointBCS_X;
					}
					break;
				case HotName.LEFT_DOWN:
					//计算c点和起点页脚的中心点
					pointBCS_X=_cPoint.x+(0-_cPoint.x)/2;
					pointBCS_Y=_cPoint.y+(_pageHeight-_cPoint.y)/2;
					//计算垂直于c点和起点连线的直线的斜率
					k=getK0(_cPoint,new Point(0,_pageHeight));
				
					//计算d点坐标
					_dPoint.y=_pageHeight;
					_dPoint.x=(_dPoint.y-pointBCS_Y)/k+pointBCS_X;
					
					//计算b、a点
					bPoint_X=(0-pointBCS_Y)/k+pointBCS_X;//b点横坐标;
					if(bPoint_X<0)//如果b点横坐标在横着的书边以外，则必点沿着竖着的树边走
					{
						_aPoint = null;
						
						//计算b点坐标
						_bPoint.x=0;
						_bPoint.y=(0-pointBCS_X)*k+pointBCS_Y;
					}
					else//如果b点横坐标在横着的书边以内，则b点沿着横着着的树边走
					{
						if (_aPoint == null)
						{
							_aPoint = new Point();
						}
						
						//计算a点坐标
						cx=(0+0*k-k*pointBCS_Y+k*k*pointBCS_X)/(1+k*k);
						cy=k*(cx-pointBCS_X)+pointBCS_Y;
						_aPoint.x=2*cx-0;
						_aPoint.y=2*cy-0;
						//计算b点坐标
						_bPoint.y=0;
						_bPoint.x=(0-pointBCS_Y)/k+pointBCS_X;
					}
					break;
				case HotName.RIGHT_UP:
					//计算c点和起点页脚的中心点
					pointBCS_X=_cPoint.x+(_pageWidth-_cPoint.x)/2;
					pointBCS_Y=_cPoint.y+(0-_cPoint.y)/2;
					//计算垂直于c点和起点连线的直线的斜率
					k=getK0(_cPoint,new Point(_pageWidth,0));
					
					//计算d点坐标
					_dPoint.y=0;
					_dPoint.x=(_dPoint.y-pointBCS_Y)/k+pointBCS_X;
					
					
					
					//计算b、a点
					bPoint_X=(_pageHeight-pointBCS_Y)/k+pointBCS_X;//b点横坐标;
					if(bPoint_X>_pageWidth)//如果b点横坐标在横着的书边以外，则必点沿着竖着的树边走
					{
						_aPoint = null;
						
						//计算b点坐标
						_bPoint.x=_pageWidth;
						_bPoint.y=(_pageWidth-pointBCS_X)*k+pointBCS_Y;
					}
					else//如果b点横坐标在横着的书边以内，则b点沿着横着着的树边走
					{
						if (_aPoint == null)
						{
							_aPoint = new Point();
						}
						
						//计算a点坐标
						cx=(_pageWidth+_pageHeight*k-k*pointBCS_Y+k*k*pointBCS_X)/(1+k*k);
						cy=k*(cx-pointBCS_X)+pointBCS_Y;
						_aPoint.x=2*cx-_pageWidth;
						_aPoint.y=2*cy-_pageHeight;
						//计算b点坐标
						_bPoint.y=_pageHeight;
						_bPoint.x=(_pageHeight-pointBCS_Y)/k+pointBCS_X;
					}
					break;
				case HotName.LEFT_UP:
					//计算c点和起点页脚的中心点
					pointBCS_X=_cPoint.x+(0-_cPoint.x)/2;
					pointBCS_Y=_cPoint.y+(0-_cPoint.y)/2;
					//计算垂直于c点和起点连线的直线的斜率
					k=getK0(_cPoint,new Point(0,0));
					
					//计算d点坐标
					_dPoint.y=0;
					_dPoint.x=(_dPoint.y-pointBCS_Y)/k+pointBCS_X;
					
					//计算b、a点
					bPoint_X=(_pageHeight-pointBCS_Y)/k+pointBCS_X;//b点横坐标;
					if(bPoint_X<0)//如果b点横坐标在横着的书边以外，则必点沿着竖着的树边走
					{
						_aPoint = null;
						
						//计算b点坐标
						_bPoint.x=0;
						_bPoint.y=(0-pointBCS_X)*k+pointBCS_Y;
					}
					else//如果b点横坐标在横着的书边以内，则b点沿着横着着的树边走
					{
						if (_aPoint == null)
						{
							_aPoint = new Point();
						}
						
						//计算a点坐标
						cx=(0+_pageHeight*k-k*pointBCS_Y+k*k*pointBCS_X)/(1+k*k);
						cy=k*(cx-pointBCS_X)+pointBCS_Y;
						_aPoint.x=2*cx-0;
						_aPoint.y=2*cy-_pageHeight;
						//计算b点坐标
						_bPoint.y=_pageHeight;
						_bPoint.x=(_pageHeight-pointBCS_Y)/k+pointBCS_X;
					}
					break;
			}
			checkPageAngle(_cPoint, _dPoint);
		}
		/**
		 * 自动翻页过程中调用
		 */
		private function pageMovingHandler():void
		{
			checkPoints(_targetPoint.x, _targetPoint.y, _startCorner);
		}
		/**
		 * 翻页完毕后调用
		 */
		private function pageMoveCompleteHandler():void
		{
			_moving = false;
			
			var event:FlipCompleteEvent = new FlipCompleteEvent(FlipCompleteEvent.FLIP_COMPLETE);
			event.flipType = _targetPageType;
			dispatchEvent(event);
		}
		private function pageFirstMoveCompleteHandler():void
		{
			switch(_startCorner)
			{
				case HotName.RIGHT_DOWN:
				    TweenLite.to(_targetPoint, 0.5, {x:0, y:_pageHeight, ease:Circ.easeOut,onUpdate:pageMovingHandler,onComplete:pageMoveCompleteHandler });
				    break;
				case HotName.RIGHT_UP:
				    TweenLite.to(_targetPoint, 0.5, {x:0, y:0, ease:Circ.easeOut,onUpdate:pageMovingHandler,onComplete:pageMoveCompleteHandler });
				    break;
				case HotName.LEFT_DOWN:
				    TweenLite.to(_targetPoint, 0.5, {x:_pageWidth, y:_pageHeight, ease:Circ.easeOut,onUpdate:pageMovingHandler,onComplete:pageMoveCompleteHandler });
				    break;
				case HotName.LEFT_UP:
				    TweenLite.to(_targetPoint, 0.5, {x:_pageWidth, y:0, ease:Circ.easeOut,onUpdate:pageMovingHandler,onComplete:pageMoveCompleteHandler });
				    break;
			}
			
		}
		private function pageMoveToEdgeCompleteHandler():void
		{
			autoMoveToCorner2();//松开鼠标后，自动移动
		}
		/**
		 * 判断目标页是当前页、上一页还是下一页
		 */
		private function checkTargetPage():void
		{
			if (_startCorner == HotName.LEFT_DOWN || _startCorner == HotName.LEFT_UP)
			{
				if (_targetPoint.x > _pageWidth *0.1)
				{
					_targetPageType = FlipType.PREV;
				}
				else
				{
					_targetPageType = FlipType.CURRENT;
				}
			}
			else if (_startCorner == HotName.RIGHT_DOWN || _startCorner == HotName.RIGHT_UP)
			{
				if (_targetPoint.x < _pageWidth *0.9)
				{
					_targetPageType = FlipType.NEXT;
				}
				else
				{
					_targetPageType = FlipType.CURRENT;
				}
			}
		}
		private function autoMoveToEdge(xPoint:Number, yPoint:Number):void
		{
			TweenLite.to(_targetPoint, 0.3, {x:xPoint, y:yPoint, ease:Circ.easeIn,onUpdate:pageMovingHandler,onComplete:pageMoveToEdgeCompleteHandler });
		}
		/**
		 * 松开鼠标后，自动移动
		 */
		private function autoMoveToCorner2():void
		{
			var targetCorner:Point = new Point();
			
			switch(_startCorner)
			{
				case HotName.LEFT_UP:
				
				    if (_cPoint.x > _pageWidth*0.1)
					{
						targetCorner.x = _pageWidth;
						targetCorner.y = 0;						
					}
					else
					{
						targetCorner.x = 0;
						targetCorner.y = 0;
					}
				    break;
				case HotName.LEFT_DOWN:
				
				    if (_cPoint.x < _pageWidth *0.1)
					{
						targetCorner.x = 0;
						targetCorner.y = _pageHeight;
					}
					else
					{
						targetCorner.x = _pageWidth;
						targetCorner.y = _pageHeight;
					}
				    break;
				case HotName.RIGHT_UP:
				
				    if (_cPoint.x < _pageWidth *0.9)
					{
						targetCorner.x = 0;
						targetCorner.y = 0;
					}
					else
					{
						targetCorner.x = _pageWidth;
						targetCorner.y = 0;
					}
				    break;
				case HotName.RIGHT_DOWN:
				
				    if (_cPoint.x < _pageWidth *0.9)
					{
						targetCorner.x = 0;
						targetCorner.y = _pageHeight;
					}
					else
					{
						targetCorner.x = _pageWidth;
						targetCorner.y = _pageHeight;
					}
				    break;
			}

			TweenLite.to(_targetPoint, 0.5, {x:targetCorner.x, y:targetCorner.y, ease:Circ.easeOut,onUpdate:pageMovingHandler,onComplete:pageMoveCompleteHandler });
		}
		
		/*----------------------------------------------------------------------------------------------------------------------公共属性-----------------*/
		/**
		 * 角度
		 */
		public function get pageAngle():Number
		{
			return _pageAngle;
		}
		public function get lineAngle():Number
		{
			return _lineAngle;
		}
		/**
		 * c点
		 */
		public function get theCPoint():Point
		{
			return _cPoint;
		}
		/**
		 * d点
		 */
		public function get theDPoint():Point
		{
			return _dPoint;
		}
		/**
		 * a点
		 */
		public function get theAPoint():Point
		{
			return _aPoint;
		}
		/**
		 * b点
		 */
		public function get theBPoint():Point
		{
			return _bPoint;
		}
		/*----------------------------------------------------------------------------------------------------------------------公共方法-----------------*/
		/**
		 * 计算各个点
		 * @param	mouse_X 鼠标所在的横坐标
		 * @param	mouse_Y 鼠标所在的纵坐标
		 * @param	cornerName 起始页脚的名字
		 */
		public function checkPoints(mouse_X:Number,mouse_Y:Number,cornerName:String):void
		{
			_moving = true;
			_startCorner = cornerName;
			judgeCpointPosition(mouse_X,mouse_Y,cornerName);
			judgeOtherPointPosition(mouse_X, mouse_Y, cornerName);
			dispatchEvent(new Event(FlipEvent.MOVE));
		}
		/**
		 * 松开鼠标后自动移动
		 */
		public function autoFlipAferDrag():void
		{			
			_targetPoint.x = _cPoint.x;
			_targetPoint.y = _cPoint.y;
			
			checkTargetPage();//判断目标页是当前页、上一页还是下一页
			if (_targetPoint.y < 0&&((_startCorner == HotName.LEFT_UP && _targetPoint.x < _pageWidth / 2)||(_startCorner == HotName.RIGHT_UP && _targetPoint.x > _pageWidth / 2)))
			{
				autoMoveToEdge(_targetPoint.x, 0);
			}
			else if (_targetPoint.y > _pageHeight&&((_startCorner == HotName.LEFT_DOWN && _targetPoint.x < _pageWidth / 2)||(_startCorner == HotName.RIGHT_DOWN && _targetPoint.x > _pageWidth / 2)))
			{
				autoMoveToEdge(_targetPoint.x, _pageHeight);
			}
			else
			{
				autoMoveToCorner2();//松开鼠标后，自动移动
			}
		}
		/**
		 * 调用该方法将全自动翻页
		 * @param	dir 翻页方向
		 */
		public function autoFlip(cornerName:String):void
		{			
			var targetPoint:Point = new Point();
			switch(cornerName)
			{
				case HotName.LEFT_DOWN:
				    _targetPoint.x = 0;
			        _targetPoint.y = _pageHeight;
					targetPoint.x = 0+200;
					targetPoint.y = _pageHeight-200;
					_startCorner = HotName.LEFT_DOWN;
					_targetPageType = FlipType.PREV;
				    break;	
				case HotName.LEFT_UP:
				    _targetPoint.x = 0;
			        _targetPoint.y = 0;
					targetPoint.x = 0+200;
					targetPoint.y = 0+200;
					_startCorner = HotName.LEFT_UP;
					_targetPageType = FlipType.PREV;
				    break;		
				case HotName.RIGHT_DOWN:
				    _targetPoint.x = _pageWidth;
			        _targetPoint.y = _pageHeight;
					targetPoint.x = _pageWidth-200;
					targetPoint.y = _pageHeight-200;
					_startCorner = HotName.RIGHT_DOWN;
					_targetPageType = FlipType.NEXT;
				    break;	
				case HotName.RIGHT_UP:
				    _targetPoint.x = _pageWidth;
			        _targetPoint.y = 0;
					targetPoint.x = _pageWidth-200;
					targetPoint.y = 0+200;
					_startCorner = HotName.RIGHT_UP;
					_targetPageType = FlipType.NEXT;
				    break;		
			}
			TweenLite.to(_targetPoint, 0.3, {x:targetPoint.x, y:targetPoint.y, ease:Circ.easeIn,onUpdate:pageMovingHandler,onComplete:pageFirstMoveCompleteHandler });
			//TweenLite.to(_targetPoint, 1, {x:targetCorner.x, y:targetCorner.y, ease:Circ.easeOut,onUpdate:pageMovingHandler,onComplete:pageMoveCompleteHandler });
		}
		
		public function setSize(pageWidth:Number,pageHeight:Number):void
		{
			_pageWidth = pageWidth;
			_pageHeight = pageHeight;
			
			_rDown=Math.sqrt(_pageHeight*_pageHeight+(_pageWidth/2)*(_pageWidth/2));//下面半圆的半径;
			_rUp = _pageWidth / 2;// 上面半圆的半径
		}
		
		public function dispose():void{
			if(_targetPoint){
				TweenLite.killTweensOf(_targetPoint);
			}
		}
		
		public function get moving():Boolean
		{
			return _moving;
		}
	}
	
}