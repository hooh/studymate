package com.studyMate.module.engLearn
{
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.engLearn.vo.TestLearnVO;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;

	internal class RATE_ReadBGMediator extends ReadBGMediator
	{
		public static const NAME:String = "RATE_ReadBGMediator";
		public static const QUIT:String = NAME + "QUIT";
		
		public function RATE_ReadBGMediator(viewComponent:Object=null)
		{
			super(viewComponent);
			mediatorName = NAME;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case QUIT:
					var item:TestLearnVO = prepareVO.data.item as TestLearnVO;
					item.rate = '正确率 :'+notification.getBody();
					if(CacheTool.has(TestLearnListMediator.NAME,'ListCollection')){
						var listCollection:ListCollection =  CacheTool.getByKey(TestLearnListMediator.NAME,"ListCollection") as ListCollection;
						listCollection.updateItemAt(listCollection.getItemIndex(item));
					}
					listCollection = null;
					return;
					break;
			}
			super.handleNotification(notification);
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(QUIT);
		}
		
		override protected function showGpuMediator():void
		{
			this.backHandle = function():void{
				sendNotification(ReadCPUMediator.yesAbandonHandler);
			};
				
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RATE_ReadCPUMediator,prepareVO,SwitchScreenType.SHOW)]);//cpu层显示
		}
		
		
	}
}