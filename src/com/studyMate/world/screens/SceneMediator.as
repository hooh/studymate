package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.HorizontalScrollerMediator;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;

	public class SceneMediator extends ScreenBaseMediator implements IScene
	{
		protected var _left:int;
		private var _camera:CameraSprite;
		
		public function set camera(_camera:CameraSprite):void
		{
			this._camera = _camera;
		}
		
		public function get camera():CameraSprite
		{
			// TODO Auto Generated method stub
			return _camera;
		}
		
		protected var _right:int;
		private var _x:int;
		
		
		public function SceneMediator(mediatorName:String=null, viewComponent:Object=null,camera:CameraSprite=null)
		{
			this.camera = camera;
			super(mediatorName, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get left():int
		{
			return _left;
		}
		
		public function set left(_int:int):void
		{
			_left = _int;
		}
		
		public function get right():int
		{
			return _right;
		}
		
		public function set right(_int:int):void
		{
			_right = _int;
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get width():int
		{
			return Math.abs(right-left);
		}
		
		
		public function pause():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function run():void
		{
			// TODO Auto Generated method stub
			
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		
	}
}