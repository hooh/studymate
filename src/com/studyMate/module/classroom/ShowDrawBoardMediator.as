package com.studyMate.module.classroom
{
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.world.component.weixin.vo.WeixinVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import starling.display.Sprite;
	
	
	/**
	 * 画图板显示功能(只显示对方通知要画的数据)
	 * 2014-6-12下午3:37:24
	 * Author wt
	 *
	 */	
	
	public class ShowDrawBoardMediator extends DrawBaseMediator
	{		
		public function ShowDrawBoardMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super("ShowDrawBoardMediator", viewComponent);
		}
		
		override public function onRemove():void{
			super.onRemove()
		}
		override public function onRegister():void{			
			super.onRegister();
			AppLayoutUtils.cpuLayer.setChildIndex(canvas,0);
	
		}
		
				
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case CRoomConst.EVENT_OTHER_DRAWBOARD:
					var weixinVO:WeixinVO = notification.getBody() as WeixinVO;
					drawBoardHander(weixinVO);
					break;
				case CRoomConst.CLEAR_DRAWBOARD:
					clearSelfDraw();
					break;
			}
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [CRoomConst.EVENT_OTHER_DRAWBOARD,CRoomConst.CLEAR_DRAWBOARD];
		}
		// 对方通知清理自己的数据
		override public function clearSelfDraw():void{
			canvas.graphics.clear();
			_commands.length = 0;
			tempCommands.length = 0;
			DustbinManage.hasOtherData = false;
			
		}
		//对方通知清理全部
		override public function clearAllDraw():void{
			sendNotification(CRoomConst.CLEAR_DRAWBOARD);
		}
		
		override public function addDraw():void
		{
			DustbinManage.hasOtherData = true;
		}
		
		
		override public function get viewClass():Class{
			return Sprite
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}

		
	}
}