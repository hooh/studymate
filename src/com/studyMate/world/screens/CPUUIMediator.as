package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class CPUUIMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "CPUUIMediator";
		private var vo:SwitchScreenVO;
		
		public function CPUUIMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
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
			
			/*var button:Sprite;
			
			button = new Sprite();
			view.addChild(button);
			button.graphics.beginFill(0x0000ff);
			button.graphics.drawRect(0,0,80,40);
			button.x = 100;
			
			button.addEventListener(MouseEvent.CLICK,pushHandle);
			
			button = new Sprite();
			view.addChild(button);
			button.graphics.beginFill(0xff00ff);
			button.graphics.drawRect(0,0,80,40);
			button.x = 300;
			
			button.addEventListener(MouseEvent.CLICK,popHandle);*/
			
			var textfield:TextField = new TextField();
			
			view.addChild(textfield);
			
			textfield.x = 400;
			textfield.y = 400;
			
			
			
			
			textfield.text = vo.data as String;
			
			
			
			
		}
		
		protected function popHandle(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			sendNotification(WorldConst.POP_SCREEN);
		}
		
		protected function pushHandle(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
		}
		
	}
}