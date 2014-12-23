package com.studyMate.module.game
{
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.game.gameEditor.DressMarketManagerMediator;
	import com.studyMate.module.game.gameEditor.GameTaskEditorMediator;
	import com.studyMate.module.game.gameEditor.HouseEditorMediator;
	import com.studyMate.module.game.gameEditor.IslandEditorMediator;
	import com.studyMate.module.game.gameEditor.NPCEditorMediator;
	import com.studyMate.module.game.gameEditor.NPCValueEditorPanel;
	import com.studyMate.world.screens.TestModuleMediator;
	import com.studyMate.world.screens.TestRunerGameMediator;
	import com.studyMate.world.screens.UnderWorldMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class GameFacade extends Facade
	{
		
		
		
		public function GameFacade(key:String)
		{
			super(key);
		}
		
		override protected function initializeController():void
		{
			// TODO Auto Generated method stub
			super.initializeController();
		}
		
		override protected function initializeFacade():void
		{
			super.initializeFacade();
			
			UnderWorldMediator;
			TestModuleMediator;
			
			HouseEditorMediator;
			NPCEditorMediator;
			NPCValueEditorPanel;
			GameTaskEditorMediator;
			IslandEditorMediator;
			
			DressRoomMediator;
			DressMarketMediator;
			DressMarketManagerMediator;
			
			TestRunerGameMediator;
			
			
		}
		
		override protected function initializeModel():void
		{
			// TODO Auto Generated method stub
			super.initializeModel();
		}
		
		public static function getInstance():void{
			
			if(!Facade.hasCore(ModuleConst.GAME)){
				new GameFacade(ModuleConst.GAME);
			}
			
			
		}
		
		
		
		
	}
}