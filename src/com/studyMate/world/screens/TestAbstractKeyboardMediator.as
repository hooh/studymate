package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import myLib.myTextBase.TextFieldHasKeyboard;
	
	import flash.text.TextFormat;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;

	public class TestAbstractKeyboardMediator extends ScreenBaseMediator
	{
		
		private var txt:TextFieldHasKeyboard;
		public function TestAbstractKeyboardMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super("TestAbstractKeyboardMediator", viewComponent);
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRegister():void
		{
			var tf:TextFormat = new TextFormat("HeiTi",28);
			AppLayoutUtils.gpuLayer.stage.color = 0xEEEEEE;
			txt =  new TextFieldHasKeyboard();
			txt.width = 600;
			txt.height = 200;
			txt.x = 500;
			txt.y = 300
			txt.border = true;
			txt.defaultTextFormat = tf;
			txt.embedFonts = true;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.text = "Mrs.Goody couldn't sleep. She got up and turned on the light. Her dog woke up and thought it was time to get up. A moment later";
			Global.stage.addChild(txt);
			sendNotification(WorldConst.USE_ASPECT_KEYBOARD,true);
		}
		
		override public function onRemove():void{
			Global.stage.removeChild(txt);
		}
		
	}
}