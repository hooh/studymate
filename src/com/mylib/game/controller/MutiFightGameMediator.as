package com.mylib.game.controller
{
	import com.byxb.extensions.starling.display.StretchImage;
	import com.mylib.game.fightGame.FightGameMediator;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MutiFightGameMediator extends Mediator implements IMediator, IMutiOLManager
	{
		public static const NAME:String = "MutiFightGameMediator";
		
		
		public function MutiFightGameMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [];
		}
		
		
		
		
		
		public function setData(_mutiData:String):void
		{
			trace("这一共有 "+ _mutiData + "条挑战记录");
			
			//发送提醒
			if(_mutiData != ""){
				if(facade.retrieveMediator(FightGameMediator.NAME)){
					
					(facade.retrieveMediator(FightGameMediator.NAME) as FightGameMediator).updateGameList();
//					(facade.retrieveMediator(FightGameMediator.NAME) as FightGameMediator).updateTips(_mutiData);
					
					
				}else
					sendNotification(WorldConst.REMIND_FIGHT_GAME,true);
				
				
			}else{
				if(facade.retrieveMediator(FightGameMediator.NAME))
//					(facade.retrieveMediator(FightGameMediator.NAME) as FightGameMediator).updateTips("0");
					;
				else
					sendNotification(WorldConst.REMIND_FIGHT_GAME,false);
				
				
			}
		}

		public function isReady(_param:*):Boolean
		{
			
			if(1)
				return true;
			else
				return false;
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
	}
}