package com.studyMate.world.screens.wordcards
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class WordCardStateMachineMediator extends ScreenBaseMediator
	{
		
		private const NAME:String = "WordCardStateMachineMediator";
		public function WordCardStateMachineMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function  get viewClass():Class
		{
			return WordCardStateMachineView;
		}
		
		public function get view():WordCardStateMachineView
		{
			return getViewComponent()as WordCardStateMachineView
		}
		
		override public function onRegister():void
		{
			
		}
	}
}