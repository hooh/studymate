package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	
	import flash.display.Sprite;
	
	import fmath.LatexFormula;
	import fmath.UrlUtils;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	

	public class TestFormulaScreen extends ScreenBaseMediator
	{
		public static const NAME:String = "TestFormulaScreen";
		
		
		public function TestFormulaScreen(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
		override public function onRegister():void
		{
			UrlUtils.setUrlFontsRelativeToSwfRoot(Global.document.resolvePath(Global.localPath+"font/").url);
			view.graphics.beginFill(0xff0000);
			view.graphics.drawRect(100,100,100,100);
			var l:String = "$a^2 = b^2 + c^2$";
			var latex:LatexFormula = new LatexFormula();
			latex.getStyle_M().setMathML_mathsize(40);
			latex.drawImage_M(l, callbackFunct);
		}
		
		private function callbackFunct(r:LatexFormula):void{
			var pannel:Sprite = r.getSprite_M();
			view.addChild(pannel);
			pannel.x = (550-pannel.width)/2;
			pannel.y = (400-pannel.height)/2;
		}
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
	}
}