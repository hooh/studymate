package
{
	import com.studyMate.module.game.GameFacade;
	
	import flash.display.Sprite;
	
	public class GameModule extends Sprite
	{
		public function GameModule()
		{
			GameFacade.getInstance();
		}
	}
}