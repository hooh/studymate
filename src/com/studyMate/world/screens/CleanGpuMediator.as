package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	

	public class CleanGpuMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "CleanGpuMediator";
		
		public function CleanGpuMediator(viewCompent:Object=null)
		{
			super(NAME,viewCompent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			// TODO Auto Generated method stub
			return Sprite;
		}
		
	}
}