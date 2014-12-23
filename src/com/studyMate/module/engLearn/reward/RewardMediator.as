package com.studyMate.module.engLearn.reward
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.engLearn.api.LearnConst;
	import com.studyMate.module.engLearn.reward.centerManLayer.RAnimationMediator;
	import com.studyMate.module.engLearn.reward.particalLayer.SnowParticle;
	import com.studyMate.module.engLearn.vo.RewardVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Sprite;
	
	
	/**
	 * note
	 * 2014-12-3上午10:32:02
	 * Author wt
	 *
	 */	
	
	public class RewardMediator extends ScreenBaseMediator
	{
		private var vo:SwitchScreenVO;

		private var startLevel:StarLevelUI;
		private var rewardVO:RewardVO;
		private var rewardVec:Vector.<IReward>
		
		public function RewardMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super("RewardMediator", viewComponent);
		}
		
		override public function onRemove():void{
			view.removeChildren(0,-1,true);
			while(rewardVec.length){
				rewardVec.pop().dispose();
			}
			sendNotification(LearnConst.HIDE_REWARD);
			super.onRemove();
		}
			
		override public function onRegister():void
		{
			startLevel = new StarLevelUI();
			view.addChild(startLevel);
			
			var backBtn:Button = new Button(Assets.getRewardTexture("backBtn"));
			var nextBtn:Button = new Button(Assets.getRewardTexture("nextBtn"));
			backBtn.x = 962;
			backBtn.y = 656;
			view.addChild(backBtn);
			
			nextBtn.x = 1082;
			nextBtn.y = 656;
			view.addChild(nextBtn);
			
			startLevel.showPlay(rewardVO);

			rewardVec = new Vector.<IReward>;
			var arr:Array = ReadConfigMov.getMov(rewardVO);//解析配置文件，返回组合数组
			var configClass:Class;
			while(arr.length){
				configClass = arr.shift();
				var obj:* = new configClass;
				if(obj is ScreenBaseMediator){
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(configClass,null,SwitchScreenType.SHOW,view)]);
				}else{
					view.addChild(obj);
					obj.touchable = false;
					
					rewardVec.push(obj);
				}
				//trace("constructor",configClass.prototype.constructor);
			}
			
			
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				
			}
		}
		
		override public function listNotificationInterests():Array{
			return [];
		}
		
		override public function prepare(vo:SwitchScreenVO):void{
			this.vo = vo;
			rewardVO = vo.data as RewardVO;
			rewardVO = new RewardVO();
			rewardVO.gold = 55;
			rewardVO.right = 26;
			rewardVO.total = 30;
			rewardVO.rrl = 'yy.W.02.001';
			rewardVO.time = 163;
			rewardVO.rate = 85;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}		
		override public function get viewClass():Class{
			return Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
	}
}