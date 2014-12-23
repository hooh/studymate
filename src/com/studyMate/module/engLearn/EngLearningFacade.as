package com.studyMate.module.engLearn
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.classroom.ListClassRoomMediator;
	import com.studyMate.module.classroom.UploadSpeechCRCommand;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.wordcards.UnrememberWordCardMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	
	public class EngLearningFacade extends Facade
	{
//		private var coreFacade:IFacade;
		public function EngLearningFacade(key:String)
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
			
			TaskListMediator;
			IndexTestLearnMediator;
			FastLearnMediator;
			TaskListSpokenMeidator;
			ListClassRoomMediator;
			UnrememberWordCardMediator;
		}
		
		override protected function initializeModel():void
		{
			// TODO Auto Generated method stub
			Facade.getInstance(CoreConst.CORE).registerCommand(WorldConst.UPLOAD_SPEECHCR_INIT,UploadSpeechCRCommand);

			super.initializeModel();
		}
		
		public static function getInstance():void{
			
			if(!Facade.hasCore(ModuleConst.ENGLEARNING)){
				new EngLearningFacade(ModuleConst.ENGLEARNING);
			}
			
			
		}
	}
}