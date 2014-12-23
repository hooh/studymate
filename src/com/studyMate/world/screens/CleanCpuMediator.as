package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class CleanCpuMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "CleanCpuMediator";
		
		
		public function CleanCpuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
	}
}