package com.mylib.game.card
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.IFighter;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.controller.vo.HeroFightVO;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.mylib.game.ui.IUpdateValue;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	
	import flash.utils.Dictionary;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	

	public class HeroFightManager extends Mediator
	{
		public static const NAME:String = "HeroFightManager";
		public static const FIGHT:String = NAME + "fight";
		public static const FIGHT_END:String = NAME + "fightEnd";
		public static const REGIST_UPDATE_VALUE:String = NAME + "registerUpdateValue";
		public static const UNREGIST_UPDATE_VALUE:String = NAME + "unregisterUpdateValue";
		public static const UPDATE_VALUE:String = NAME + "updateValue";
		public static const STOP:String = NAME + "stop";
		public static const GET_REWARD:String = NAME + "getReward";
		public static const GET_REWARD_REC:String = NAME + "getRewardRec";
		public static const REOPEN_BASEMENT:String = NAME + "reopenBasement";
		
		private var fightingData:Dictionary;
		private var fightingProcess:Dictionary;
		private var rewardProcess:Dictionary;
		
		public function HeroFightManager()
		{
			super(NAME);
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var hfvo:HeroFightVO;
			switch(notification.getName())
			{
				case FIGHT:
				{
					hfvo = notification.getBody() as HeroFightVO;
					startProcess(hfvo);
					break;
				}
				case STOP:{
					hfvo = notification.getBody() as HeroFightVO;
					stopProcess(hfvo);
					break;
				}
				case FIGHT_END:{
					hfvo = notification.getBody() as HeroFightVO;
					stopProcess(hfvo);
					delete fightingData[hfvo];
					delete fightingProcess[hfvo];
					
					rewardProcess[hfvo] = new RewardProcess(hfvo);
					
					
					
					break;
				}
				case REGIST_UPDATE_VALUE:{
					(fightingData[(notification.getBody() as Array)[0]] as Array).push((notification.getBody() as Array)[1]);
					break;
				}
				case UNREGIST_UPDATE_VALUE:{
					var idx:int = (fightingData[(notification.getBody() as Array)[0]] as Array).indexOf((notification.getBody() as Array)[1]);
					
					if(idx>=0){
						(fightingData[(notification.getBody() as Array)[0]] as Array).splice(idx,1);
					}
					
					
					
					break;
				}
				case UPDATE_VALUE:{
					
					var updateValues:Array = fightingData[notification.getBody()];
					var len:int = updateValues.length;
					for (var i:int = 0; i < len; i++) 
					{
						(updateValues[i] as IUpdateValue).update();
					}
					
					
					break;
				}
				case GET_REWARD:{
					hfvo = notification.getBody() as HeroFightVO;
					PackData.app.CmdIStr[0] = CmdStr.FIN_PLAYER_TASK;
					PackData.app.CmdIStr[1] = hfvo.taskId;
					PackData.app.CmdInCnt = 2;
					
					sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_REWARD_REC,[hfvo]));
					
					break;
				}
				case GET_REWARD_REC:{
					var dvo:DataResultVO = notification.getBody() as DataResultVO;
					
					if(!dvo.isErr){
						hfvo = dvo.para[0];
						(rewardProcess[hfvo] as RewardProcess).open();
					}
					
					
					
					
					break;
				}
				case REOPEN_BASEMENT:{
					hfvo = notification.getBody() as HeroFightVO;
					
					hfvo.basement.reputMoster(hfvo.monster);
					hfvo.basement.open();
					
					break;
				}
					
					
				default:
				{
					break;
				}
			}
		}
		
		private function startProcess(hfvo:HeroFightVO):void{
			
			
			for (var i:int = 0; i < hfvo.heros.length; i++) 
			{
				
				if(hfvo.heros[i].fighter){
					continue;
				}
				
				
				if(hfvo.heros[i].data.skeleton==SkeletonType.BMP){
					(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).charaterPool = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.BMP_FIGHTER_POOL) as ObjectPool;
				}else{
					(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).charaterPool = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.HUMAN_POOL) as ObjectPool;
				}
				
				
				
				
				var fighter:FighterControllerMediator;
				fighter = (Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy).object;
				fighter.setTo(-i*80,0);
				hfvo.heros[i].fighter = fighter;
				GlobalModule.charaterUtils.humanDressFun(fighter.charater,hfvo.heros[i].data.equiment);
				(fighter.charater as IFighter).attack = hfvo.heros[i].data.attack;
				
				
				hfvo.charaterHolder.addChild(fighter.charater.view);
				fighter.pause();
				fighter.fighter.attackRate = 2;
				fighter.charater.actor.stop();
				fighter.charater.view.visible = false;
			}
			
			
			
			
			var process:HeroFightProcess = new HeroFightProcess(hfvo);
			fightingData[hfvo]=[];
			fightingProcess[hfvo] = process;
			process.start();
			
			
		}
		
		private function stopProcess(hfvo:HeroFightVO):void{
			
			if(fightingProcess[hfvo]){
				(fightingProcess[hfvo] as HeroFightProcess).stop();
				(fightingProcess[hfvo] as HeroFightProcess).dispose();
			
			} 
			
			
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [FIGHT,FIGHT_END,REGIST_UPDATE_VALUE,UNREGIST_UPDATE_VALUE,UPDATE_VALUE,STOP,GET_REWARD,GET_REWARD_REC,REOPEN_BASEMENT];
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
			fightingData = new Dictionary(true);
			fightingProcess = new Dictionary(true);
			
			rewardProcess = new Dictionary(true);
			
			
		}
		
		
		
		
		
		
	}
}