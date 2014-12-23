package com.studyMate.module.engLearn
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.engLearn.vo.TestLearnVO;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	internal class RATE_WordLearningBGMediator extends WordLearningBGMediator
	{
		public static const QUIT:String = NAME + "QUIT";
		public static const NAME:String = "RATE_WordLearningBGMediator";
		
		public function RATE_WordLearningBGMediator(viewComponent:Object=null)
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
				sendNotification(WordLearningTXTMediator.yesAbandonHandler);
			}
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RATE_WordLearningTextMediator,dataSetArr,SwitchScreenType.SHOW)]);//cpu层显示		
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;
			PackData.app.CmdIStr[0] = CmdStr.OBTAIN_WORD_FOR_BROWSE;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			trace("当前rrl = "+vo.data.rrl.toString());
			PackData.app.CmdIStr[2] = vo.data.rrl.toString();
			PackData.app.CmdInCnt = 3;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(RECEIVE_DATA));
			//Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);						
		}
		
		
	}
}