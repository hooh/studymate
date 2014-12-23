package com.studyMate.world.component.SVGEditor.windows
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class SVGBasePannelMediator extends ScreenBaseMediator
	{
		public function SVGBasePannelMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		override public function onRemove():void
		{
			super.onRemove();
		}

		override public function onRegister():void
		{			
			super.onRegister();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case SVGConst.HIDE_PANEL:
					view.visible = false;
					break;
				case SVGConst.SHOW_PANEL:
					view.visible = true;
					break;
				default:					
					this.svg_handleNotification(notification);
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return svg_listNotificationInterests().concat([SVGConst.HIDE_PANEL,SVGConst.SHOW_PANEL]);
		}
		
		protected function svg_handleNotification(notification:INotification):void{
//			throw new Error("请子类实现SVGBasePannelMediator的该方法");
		}
		protected function svg_listNotificationInterests():Array{
//			throw new Error("请子类实现SVGBasePannelMediator的该方法");
			return [] ;
		}
		
		
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}