package com.studyMate.world.screens
{
	import com.studyMate.global.Global;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class FlipDaoHangMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "FlipDaoHangMediator";
		private var total:uint;
		private var _index:uint;
		private var spriteBaseX:Number;
		private var spriteY:Number = 0;
		private var indexSign:Image;
		private var otherSign:Image;
		
		public function FlipDaoHangMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function set index(value:uint):void
		{
			_index = value;
			indexSign.x = spriteBaseX + _index * 19;
		}

		override public function prepare(vo:SwitchScreenVO):void{
			total = vo.data as uint;
			spriteBaseX = (Global.stageWidth - total * 19) / 2 + 3;
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void{
			for(var i:int = 0; i < total; i++){
				otherSign = new Image(Assets.getAtlasTexture("flip/other"));
				otherSign.x = spriteBaseX + i * 19;
				view.addChild(otherSign);
			}
			indexSign = new Image(Assets.getAtlasTexture("flip/index"));
			indexSign.x = spriteBaseX;
			view.addChild(indexSign);
		}
		
		override public function listNotificationInterests():Array{
			return [WorldConst.UPDATE_FLIP_PAGE_INDEX,WorldConst.UPDATE_FLIP_DAOHANG];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()){
				case WorldConst.UPDATE_FLIP_PAGE_INDEX : 
					index = notification.getBody() as uint;
					break;
				case WorldConst.UPDATE_FLIP_DAOHANG : 
					total = notification.getBody() as uint;
					spriteBaseX = (Global.stageWidth - total * 19) / 2 + 3;
					resetDaoHang();
					break;
			}
		}
		
		private function resetDaoHang():void{
			view.removeChildren(0,-1,true);
			for(var i:int = 0; i < total; i++){
				otherSign = new Image(Assets.getAtlasTexture("flip/other"));
				otherSign.x = spriteBaseX + i * 19;
				view.addChild(otherSign);
			}
			if(total != 0){
				indexSign = new Image(Assets.getAtlasTexture("flip/index"));
				indexSign.x = spriteBaseX;
				view.addChild(indexSign);
			}
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}
		
		override public function onRemove():void{
			super.onRemove();
			view.removeChildren(0,-1,true);
			view.dispose();
		}
	}
}