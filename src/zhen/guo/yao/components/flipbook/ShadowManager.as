package zhen.guo.yao.components.flipbook
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	internal  class ShadowManager extends Sprite
	{
		private var _shadowMask:Sprite;
		private var _upShadow:Shadow;
		private var _downShadow:Shadow;
		private var _staticShadow:Shadow;
		
		private var _alpha:Number = 0.3;//阴影透明度
		private var _showShadowOnFlipComplete:Boolean = false;//翻页完毕后是否显示阴影
		
		public function ShadowManager():void
		{

		}
		//翻页过程中调整阴影状态
		//d点、b点、角度
		public function setShadow(dPoint:Point,bPoint:Point,rotation:Number):void
		{
			_upShadow.visible = true;
			_upShadow.x = (bPoint.x + dPoint.x) / 2;
			_upShadow.y = (dPoint.y + bPoint.y) / 2;
			_upShadow.rotation = rotation;
			
			_downShadow.visible = true;
			_downShadow.x = (bPoint.x + dPoint.x) / 2;
			_downShadow.y = (dPoint.y + bPoint.y) / 2;
			_downShadow.rotation = rotation;
			
		}
		//翻页完毕后调用
		//type:翻页结果
		public function flipCompleteHandler(type:String,forceHideShadow:Boolean=false):void
		{
			_upShadow.visible = false;
			_downShadow.visible = false;
			if (forceHideShadow)
			{
				if (_staticShadow.alpha != 0)
				{
					_staticShadow.alpha = _alpha;
					TweenLite.to(_staticShadow, 0.5, { alpha:0, ease:Circ.easeOut } );
				}
			}
			else
			{
				if (_showShadowOnFlipComplete)
				{
					_staticShadow.alpha = _alpha;
				}
				else
				{
					switch(type)
					{
						//如果没有留在当前页
						case FlipType.PREV:
						case FlipType.NEXT:	
							_staticShadow.alpha = _alpha;
							TweenLite.to(_staticShadow, 0.5, { alpha:0, ease:Circ.easeOut } );
							break;
					}
				}
			}
		}
		
		public function set upShadow(shadow:Shadow):void
		{
			_upShadow = shadow;
			_upShadow.visible = false;
			_upShadow.alpha = _alpha;
		}
		public function set downShadow(shadow:Shadow):void
		{
			_downShadow = shadow;
			_downShadow.visible = false;
			_downShadow.alpha = _alpha;
		}
		public function set staticShadow(shadow:Shadow):void
		{
			_staticShadow = shadow;
			_staticShadow.alpha = 0;
		}
		//翻页完毕后是不是显示阴影
		public function set showShadowOnFlipComplete(show:Boolean):void
		{
			_showShadowOnFlipComplete = show;
		}
		public function get showShadowOnFlipComplete():Boolean
		{
			return _showShadowOnFlipComplete;
		}
	}
}