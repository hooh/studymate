package com.studyMate.world.screens.component
{
	import com.greensock.TweenMax;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.controller.vo.EnableScreenCommandVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.effects.StarPartical;
	
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class SysRewardCartoonMediator extends ScreenBaseMediator
	{
		
		public static const NAME:String = "SysRewardCartoonMediator";
		private var beginBox:Image;
		private var endBox:Image;
		private var endBoxCap:Image;
		private var endBoxCap2:Image;
		private var star:StarPartical;
		//private var rewardPaper:RewardPaper;
		private var textfield:TextField;
		private var holder:Sprite;
		//private var bgTexture:Texture;
		private var preData:SwitchScreenVO;
		
		public function SysRewardCartoonMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
			if(star)
				star.dispose();
//			rewardPaper.dispose();
//			Starling.current.stage.touchable = true;
			
			TweenMax.killTweensOf(beginBox);
			TweenMax.killTweensOf(endBoxCap);
			TweenMax.killTweensOf(endBoxCap2);
			TweenMax.killTweensOf(textfield);
		//	bgTexture.dispose();
			view.removeChildren(0,-1,true);
			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(true));
			super.onRemove();
		}
		
		override public function onRegister():void{	
			sendNotification(WorldConst.ENABLE_GPU_SCREENS, new EnableScreenCommandVO(false, NAME));
			holder = new Sprite();
			holder.touchable = false;
			view.addChild(holder);
			
//			Starling.current.stage.touchable = false;			
			
			//bgTexture = Assets.getTexture("awardBg");
			/*var bg:Image = new Image( Assets.getTexture("awardBg"));
			bg.alpha = 0.5;
			bg.pivotX = bg.width>>1;
			bg.pivotY = bg.height>>1;
			bg.x = Global.stageWidth>>1;
			bg.y = 300;
			bg.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			holder.addChild(bg);*/
//			TweenMax.to(bg,15,{rotation:Math.PI*2,repeat:int.MAX_VALUE,ease:Linear.easeNone});
			addToStageHandler();
		}
		
		private function addToStageHandler():void
		{
			// TODO Auto Generated method stub
			beginBox = new Image(Assets.getEgAtlasTexture("word/beginBox"));//盒子 
			beginBox.pivotX = beginBox.width>>1;
			beginBox.pivotY = beginBox.height>>1;
			beginBox.x = Global.stageWidth>>1;
			beginBox.y = 300;
			//beginBox.transformationMatrix.c = -0.2;
			beginBox.scaleX = 0.1;
			beginBox.scaleY = 0.1;
			holder.addChild(beginBox);
			
			endBoxCap2 = new Image(Assets.getEgAtlasTexture("word/endBoxCap2"));//盒子 盖
			endBoxCap2.pivotX = endBoxCap2.width>>1;
			endBoxCap2.y = 110;
			endBoxCap2.x = (Global.stageWidth>>1) -110;
			endBoxCap2.alpha = 0;
			
			star = new StarPartical(false);
			star.y = 300;
			star.x = 640;
			holder.addChild(star);	
			
			
			/*TweenLite.delayedCall(0.6,action);
			function action():void{
			//ease:Back.easeOut,
			}*/
			TweenMax.to(beginBox,0.4,{scaleX:1,scaleY:1,onComplete:Motion1});
		}
		
		private function stageClickHandler(e:MouseEvent = null):void{
			Starling.current.nativeStage.removeEventListener(MouseEvent.CLICK,stageClickHandler);
			if(textfield)
				textfield.visible = false;
			if(endBox){				
				TweenMax.to(endBox,0.4,{scaleX:0,scaleY:0,onComplete:endMotion});
			}else{
				endMotion();
			}
			
		}
		
		private function endMotion():void{
			preData.type = SwitchScreenType.HIDE;
			sendNotification(WorldConst.SWITCH_SCREEN,[preData]);
		}

		
		private function Motion1():void{
			star.start();
			//Motion2();
			TweenMax.to(beginBox,0.4,{scaleX:0.8,scaleY:0.8});
			TweenMax.to(beginBox,0.4,{scaleX:1,scaleY:1,delay:0.2,onComplete:Motion2});

		}
		
		private function Motion2():void{
			
			endBox = new Image(Assets.getEgAtlasTexture("word/endBox"));//盒子 
			endBox.pivotX = endBox.width>>1;
			endBox.pivotY = endBox.height>>1;
			endBox.y = 320;
			endBox.x = Global.stageWidth>>1;
			
			endBoxCap = new Image(Assets.getEgAtlasTexture("word/endBoxCap"));//盒子 盖
			endBoxCap.pivotX = endBoxCap.width>>1;
			endBoxCap.y = 76;
			endBoxCap.x = (Global.stageWidth>>1) -30;
			holder.addChild(endBox);
			holder.addChild(endBoxCap);
			//holder.addChild(endBoxCap2);
			holder.setChildIndex(star,holder.numChildren-1);
			endBoxCap.alpha = 0;
			TweenMax.to(beginBox,0.2,{alpha:0});			
			TweenMax.to(endBoxCap,0.2,{alpha:1,rotation:-0.3,onComplete:Motion3});
			
		}
		private function Motion3():void{
			
			TweenMax.to(endBoxCap,0.3,{alpha:0,x:endBoxCap.x -70,y:90});
			TweenMax.to(endBoxCap2,0.3,{alpha:1,yoyo:true,repeat:1});
			//+金币20\n+经验100
			//String(preData.data)
			var str:String = "";
			if(preData.data is Array)
				str = (preData.data as Array).join(":\n");
			textfield = new TextField(400,150,str,"HuaKanT",22,0x0066FF,true);
			textfield.x = (Global.stageWidth>>1)-200;
			textfield.y = 230;
			view.addChild(textfield);
			textfield.alpha = 0;
			TweenMax.to(textfield,3,{y:100,alpha:1});
			TweenMax.to(textfield,2,{alpha:1,delay:2,onComplete:registerEventListener});
			
		}
		
		private function registerEventListener():void{
			
			Starling.current.nativeStage.addEventListener(MouseEvent.CLICK,stageClickHandler);
			
			stageClickHandler();
		}
	

		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				
			}			
		}
		
		override public function listNotificationInterests():Array{
			return [];
		}
		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			preData = vo;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);						
		}
	}
}