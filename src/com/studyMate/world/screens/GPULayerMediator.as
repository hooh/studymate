package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.text.TextField;

	public class GPULayerMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "GPULayerMediator";
		private var vo:SwitchScreenVO;
		
		public function GPULayerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			
			var textfield:TextField = new TextField(200,100,vo.data as String);
			
			view.addChild(textfield);
			
			textfield.x = 200;
			textfield.y = 200;
			
			
			
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		public function get view():Sprite{
			
			return getViewComponent() as Sprite;
		}
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
	}
}