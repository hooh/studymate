package com.studyMate.module.svg
{
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.component.SVGEditor.SVGMainMediator;
	import com.studyMate.world.component.SVGEditor.SVGShowMediator;
	import com.studyMate.world.screens.FormulaTestMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class SVGFacade extends Facade
	{
		public function SVGFacade(key:String)
		{
			super(key);
		}
		
		override protected function initializeFacade():void
		{
			super.initializeFacade();
			
			SVGMainMediator;
			SVGShowMediator;
			FormulaTestMediator;
		}
		
		
		
		public static function getInstance():void{
			
			if(!Facade.hasCore(ModuleConst.SVG)){
				new SVGFacade(ModuleConst.SVG);
			}
		}
		
	}
}