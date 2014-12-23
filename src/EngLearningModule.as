package
{
	import com.studyMate.module.engLearn.EngLearningFacade;
	
	import flash.display.Sprite;
	
	public class EngLearningModule extends Sprite
	{
		public function EngLearningModule()
		{
			EngLearningFacade.getInstance();
		}
	}
}