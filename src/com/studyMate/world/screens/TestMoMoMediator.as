package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.component.MOMOBmpProxy;
	import com.studyMate.world.screens.component.vo.MoMoSp;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class TestMoMoMediator extends ScreenBaseMediator
	{
		public static const NAME:String = 'TestMoMoMediator';
		
		public function TestMoMoMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);	
		}
		
		override public function onRegister():void
		{
			var momoproxy:MOMOBmpProxy = new MOMOBmpProxy();
			facade.registerProxy(momoproxy);
			
			var sp:MoMoSp = momoproxy.chatboxL('dfsdf','19871209','ad所发生的福娃地方',false);
			sp.x = 100;
			view.addChild(sp);
			
			var sp1:MoMoSp = momoproxy.chatboxL('dfsdf','19871209','path url',false,'voice');
			sp1.x = 100;
			sp1.y = 200;
			view.addChild(sp1);
			
			super.onRegister();
		}
		
		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
	}
}