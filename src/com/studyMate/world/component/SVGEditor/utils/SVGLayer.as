package com.studyMate.world.component.SVGEditor.utils
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.component.SVGEditor.windows.SVGDrawCanvasMediator;
	import com.studyMate.world.component.SVGEditor.windows.SVGEditCanvasMediator;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class SVGLayer
	{
	
		
		public static function  get svgDrawCanvasView():Sprite{
			return (Facade.getInstance(CoreConst.CORE).retrieveMediator(SVGDrawCanvasMediator.NAME).getViewComponent() as Sprite);
		}
		
		public static function get svgEditCanvasView():Sprite{
			return (Facade.getInstance(CoreConst.CORE).retrieveMediator(SVGEditCanvasMediator.NAME).getViewComponent() as Sprite);
		}
	}
}