package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import de.maxdidit.hardware.font.HardwareFont;
	import de.maxdidit.hardware.font.events.FontEvent;
	import de.maxdidit.hardware.font.parser.OpenTypeParser;
	import de.maxdidit.hardware.text.starling.FiretypeStarlingTextField;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;

	public class TestTypeMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "TestTypeMediator";
		
		public function TestTypeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
			
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
			
			var openTypeParser:OpenTypeParser = new OpenTypeParser();
			
			openTypeParser.loadFont("font/MSYH.TTF").addEventListener(FontEvent.FONT_PARSED, handleFontParsed);;
			
			
			
		}
		
		private function handleFontParsed(e:FontEvent):void 
		{
			var text:FiretypeStarlingTextField = new FiretypeStarlingTextField();
			text.font=e.font;
			text.text = "This text has been rendered in <format color='0xFFFF0000'>Starling</format> via <format color='0xFFFF6611'>firetype</format>.";
			text.x = 100;
			text.y = 100;
			text.width = 300;
			text.color = 0xFF666666;
			view.addChild(text);
			
			
			
		}
		
	}
}