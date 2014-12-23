package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Sprite3D;

	public class TestSprite3D extends ScreenBaseMediator
	{
		public static const NAME:String = "TestSprite3D";
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
			
			
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRegister():void
		{
			var sprite:Sprite3D = new Sprite3D();
			var quad:Quad = new Quad(100, 100, 0xff00ff);
			sprite.addChild(quad);
			
			sprite.rotationX = Math.PI / 2; // rotate around the x axis
			sprite.rotationY = Math.PI / 2; // rotate around the y axis
			sprite.z = 20;                  // move further away from the camera
			
			sprite.y = 200;
			
			
			view.addChild(sprite);
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
		public function TestSprite3D(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
	}
}