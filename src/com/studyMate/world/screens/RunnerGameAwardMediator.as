package com.studyMate.world.screens
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.runner.RunnerAwardVO;
	import com.mylib.game.runner.RunnerGameConst;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.screens.effects.StarEff;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class RunnerGameAwardMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "RunnerGameAwardMediator";
		
		private var eff:StarEff;
		
		private var score:TextField;
		private var record:TextField;
		
		private var bg:Image;
		
		private var chartBtn:Button;
		private var restartBtn:Button;
		private var vo:SwitchScreenVO;
		private var awardVo:RunnerAwardVO;
		
		private var updateScoreArr:Array;
		
		private var newRecord:Image;
		
		private var badge:Image;
		
		private var tilteIdx:Array = [5000];
		
		public function RunnerGameAwardMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		
		override public function onRemove():void
		{
			eff.dispose();
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
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case RunnerGameConst.SHOW_REWARD:
				{
					view.visible = true;
					
					bg.x = bg.y =0;
					score.x = 3;
					score.y = 13;
					eff.x = 20;
					eff.y = 20;
//					restartBtn.x = 0;
//					restartBtn.y = 120;
					restartBtn.x = 70;
					restartBtn.y = 150;
//					chartBtn.x = -90;
//					chartBtn.y = 120;
					chartBtn.x = -70;
					chartBtn.y = 150;
//					record.x = -100;
//					record.y = 26;
					record.x = 133;
					record.y = 83;
					
					newRecord.x = 600;
					newRecord.y = -1000;
					
					
					view.addChild(bg);
					bg.scaleX = bg.scaleY = 0;
					awardVo = notification.getBody() as RunnerAwardVO;
					
					//生成徽章
					var badgeTexture:Texture;
					if(awardVo.scoreNum < 20000){
						badgeTexture = Assets.getRunnerGameTexture("badge/1");
						
					}else{
						
						var level:int;
						var currentDis:int = 0;
						
						while(currentDis<awardVo.scoreNum){
							currentDis+=10000+1000*level;
							level++;
						}
						
						if(level>11){
							level=11;
						}
						
						badgeTexture = Assets.getRunnerGameTexture("badge/"+level);
					}
					if(badge)
					{
						badge.dispose();
						badge = null;
					}
					badge = new Image(badgeTexture);
					badge.y = -1000;
					
					
					TweenMax.to(bg, 1, {scaleX:1, scaleY:1,delay:1, ease:Elastic.easeOut});
					TweenLite.delayedCall(1,showEffect);
					
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		private function showEffect():void{
			eff.clear();
			view.addChild(eff);
			
			
			view.addChild(score);
			centerPivot(score);
			score.text = "0";
			score.scaleX = score.scaleY = 0;
			TweenLite.delayedCall(1.4,eff.start,[1.5]);
			TweenLite.to(score,1,{scaleX:1, scaleY:1,delay:1, ease:Elastic.easeOut});
			
			
			
			updateScoreArr = [0];
			
			
			TweenLite.to(updateScoreArr,1,{endArray:[awardVo.scoreNum],delay:0.5,onUpdate:updateScore});
			
			
			
			view.addChild(restartBtn);
			centerPivot(restartBtn);
			restartBtn.scaleX = restartBtn.scaleY = 0;
			TweenLite.to(restartBtn,1,{scaleX:1, scaleY:1,delay:1, ease:Elastic.easeOut});
			
			view.addChild(chartBtn);
			centerPivot(chartBtn);
			chartBtn.scaleX = chartBtn.scaleY = 0;
			TweenLite.to(chartBtn,1,{scaleX:0.9, scaleY:0.9,delay:1, ease:Elastic.easeOut});
			
			view.addChild(badge);
			TweenLite.to(badge,0.3,{delay:1, x:-182, y:-33, ease:Linear.easeNone});
			
			//新纪录
			if(awardVo.recordNum < awardVo.scoreNum)
			{
				view.addChild(newRecord);
				TweenLite.to(newRecord,0.3,{delay:1, x:140, y:-150, ease:Linear.easeNone});
				
				record.text = int(awardVo.scoreNum) + " m";
			}else{
				record.text = int(awardVo.recordNum) + " m";
				
			}
			
			view.addChild(record);
			centerPivot(record);
			record.scaleX = score.scaleY = 0;
			TweenLite.to(record,1,{scaleX:1, scaleY:1,delay:1, ease:Elastic.easeOut});
		}
		
		private function updateScore():void{
			score.text = int(updateScoreArr[0]).toString();
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [RunnerGameConst.SHOW_REWARD];
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			view.visible = false;
			
			score = new starling.text.TextField(235,80,"","en35BS",65,0xffffff);
			score.hAlign = HAlign.RIGHT;
			
			record = new TextField(200, 28, "", "", 20, 0x703200, true);
			record.hAlign = HAlign.LEFT;
			
			bg = new Image(Assets.getRunnerGameTexture("awardBG"));
			bg.pivotX = bg.width*0.5;
			bg.pivotY = bg.height*0.5;
			
			newRecord = new Image(Assets.getRunnerGameTexture("newRecordIcon"));
			
			
			
			view.x = Global.stageWidth*0.5;
			view.y = Global.stageHeight*0.5-100;
			
			
			eff = new StarEff;
			
			
			restartBtn = new Button(Assets.getRunnerGameTexture("restart"));
			restartBtn.addEventListener(Event.TRIGGERED,restartHandle);
			
			chartBtn = new Button(Assets.getRunnerGameTexture("chartBtn"));
			chartBtn.addEventListener(Event.TRIGGERED,chartBtnHandle);
		}
		
		private function restartHandle():void
		{
			
			eff.stop(true);
			view.removeChildren();
			
			
			
			sendNotification(RunnerGameConst.RESTART);
			
			
			
		}
		
		private function chartBtnHandle():void{
			
//			eff.stop(true);
//			view.removeChildren();
			
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RunnerGameChartMediator)]);
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RunnerGameChartMediator,null,SwitchScreenType.SHOW,null)]);
			
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
		
		
	}
}