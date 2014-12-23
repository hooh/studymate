package
{
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.world.WorldFacade;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class WorldModule extends Sprite
	{
		public function WorldModule()
		{
			
			if(Facade.hasCore(ModuleConst.WORLD)){
				Facade.removeCore(ModuleConst.WORLD);
			}
			
			new WorldFacade(ModuleConst.WORLD);
		}
	}
}