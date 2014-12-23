package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	import com.mylib.game.charater.logic.ai.CharaterControlAI;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.effects.Fish;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.graphics.Fill;
	import starling.display.graphics.Stroke;
	import starling.display.shaders.vertex.RippleVertexShader;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;

	public class PersonSpaceMediator extends ScreenBaseMediator
	{
		public static const NAME:String = 'PersonSpaceMediator';
		

		private var holder:Sprite;		
		private var bgToucher:Quad;
		private var range:Rectangle;
		private var guideCharter:IslanderControllerMediator;
		private var honourBtn:Button;
		private var fish:Fish;
		
		public function PersonSpaceMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRemove():void{
			
			TweenMax.killTweensOf(holder);
			bgToucher.removeEventListener(TouchEvent.TOUCH,enterRoomHandler);
			
			if(guideCharter.charater){
				guideCharter.pause();
				(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = guideCharter.charater;
				guideCharter.reset();
				guideCharter.charater = null;
				guideCharter.decision = null;
			}
			TweenLite.killTweensOf(guideCharter);
			TweenLite.killTweensOf(honourBtn);
			sendNotification(WorldConst.STOP_RANDOM_ACTION);
			fish.dispose();
			
			super.onRemove();
		}
		override public function onRegister():void
		{
			holder = new Sprite();
			
			
			var image:Image = new Image(Assets.getTexture("PersonSpace_Bg"));
			image.blendMode = BlendMode.NONE;
			image.touchable = false;
			view.addChild(image);	
			
			//鲸鱼
			var whale:Image = new Image(Assets.getTexture("PersonSpace_Whale"));
			whale.touchable = false;
			holder.addChild(whale);	
			view.addChild(holder);
			
			
			var grownBtn:Button = new Button(Assets.getPersonSpaceTexture('grownupBtn'));
			grownBtn.x = 1017;
			grownBtn.y = 404;
			holder.addChild(grownBtn);
			
			var mailBtn:Button = new Button(Assets.getPersonSpaceTexture('mailBtn'));
			mailBtn.x = 750;
			mailBtn.y = 308;
			holder.addChild(mailBtn);
			
			var promiseBtn:Button = new Button(Assets.getPersonSpaceTexture('promiseBtn'));
			promiseBtn.x = 561;
			promiseBtn.y = 341;
			holder.addChild(promiseBtn);
			
			var setBtn:Button = new Button(Assets.getPersonSpaceTexture('setBtn'));
			setBtn.x = 171;
			setBtn.y = 422;
			holder.addChild(setBtn);
			
			
			
			fish = new Fish;
			view.addChild(fish);
			fish.x = 200;
			fish.y=645;
			
			//波浪
			var w:Number = view.stage.stageWidth;
			var h:Number = 160;
			var waterColorTop:uint = 0x08acff;
			var waterColorBottom:uint = 0x0073ad;
			var waterColorSurface:uint = 0xc6e5f5;
			
			var waterHeight:Number = 545;
			var waterFill:Fill = new Fill();
			waterFill.addVertex(0, waterHeight, waterColorTop,0.3 );
			waterFill.addVertex(w, waterHeight, waterColorTop,0.3 );
			waterFill.addVertex(w, h, waterColorBottom,0 );
			waterFill.addVertex(0, h, waterColorBottom,0 );
			waterFill.touchable = false;
			view.addChild(waterFill);
			
			var waterSurfaceThickness:Number = 20;
			var waterSurfaceStroke:Stroke = new Stroke();
			waterSurfaceStroke.material.vertexShader = new RippleVertexShader();
			
			for (var i:int = 0; i < 50; i++ )
			{
				var ratio:Number = i / 49;
				waterSurfaceStroke.addVertex( ratio * w, waterHeight + waterSurfaceThickness*0.25, waterSurfaceThickness, waterColorSurface, 0.8, waterColorTop, 0.3);
			}
			waterSurfaceStroke.touchable = false;
			view.addChild(waterSurfaceStroke);
				
			//小人
			guideCharter = new IslanderControllerMediator("guideCharater",null,1);
			guideCharter.charater = (facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object;
			guideCharter.charater.view.alpha = 1;
			
			guideCharter.charater.velocity = 3.5;
			guideCharter.decision = new CharaterControlAI();
			guideCharter.fsm.changeState(AIState.IDLE);
			guideCharter.setTo(640,470);
			guideCharter.start();			
			GlobalModule.charaterUtils.configHumanFromDressList(guideCharter.charater,Global.myDressList,new Rectangle());
			holder.addChild(guideCharter.charater.view);
			
			bgToucher = new Quad(630,67);
			bgToucher.x = 322;
			bgToucher.y = 420;
			bgToucher.alpha = 0;
			holder.addChild(bgToucher);
			bgToucher.addEventListener(TouchEvent.TOUCH,enterRoomHandler);
			
			
			TweenMax.to(holder,1,{y:-10,yoyo:true,repeat:int.MAX_VALUE,ease:Linear.easeNone});
			
			
			honourBtn = new Button(Assets.getPersonSpaceTexture('Honour'));
			honourBtn.x = 1135;
			honourBtn.y = 526;
			view.addChild(honourBtn);
			TweenMax.to(honourBtn,0.7,{y:520,yoyo:true,repeat:int.MAX_VALUE,ease:Linear.easeNone});
			
			
			var cloud01:Image =new Image(Assets.getAtlasTexture("bg/engIsland_cloud01"));
			var cloud02:Image =new Image(Assets.getAtlasTexture("bg/engIsland_cloud02"));
			var range:Rectangle = new Rectangle(0,160,1280,80);
			sendNotification(WorldConst.RANDOM_ACTION,{displayObject:cloud01,holder:view,range:range,randomAction:false});
			sendNotification(WorldConst.RANDOM_ACTION,{displayObject:cloud02,holder:view,range:range,randomAction:false});
			
			
			grownBtn.addEventListener(Event.TRIGGERED,grownClickHandler);
			mailBtn.addEventListener(Event.TRIGGERED,mailClickHandler);
			promiseBtn.addEventListener(Event.TRIGGERED,promiseClickHandler);
			setBtn.addEventListener(Event.TRIGGERED,setClickHandler);
			honourBtn.addEventListener(Event.TRIGGERED,honourClickHandler);
		}
		
		private function honourClickHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HonourViewMediator)]);

		}
		
		private function setClickHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SystemSetMediator)]);

		}
		
		private function promiseClickHandler():void
		{
			var data:String = ShowProMediator.SHOW_ALL;
			if(Global.myPromiseInf == null){
				data = ShowProMediator.SHOW_ALL;
			}else if(Global.myPromiseInf.newFinishCount != 0){
				data = ShowProMediator.SHOW_FINISH;
			}else if(Global.myPromiseInf.unFinishCount != 0){
				data = ShowProMediator.SHOW_UNFINISH;
			}
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CleanCpuMediator),new SwitchScreenVO(ShowProMediator,data)]);
		}
		
		private function mailClickHandler():void
		{
//			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ShowMessageMediator,["A"],SwitchScreenType.SHOW, AppLayoutUtils.uiLayer)]);
		}
		
		private function grownClickHandler():void
		{
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MonthTaskInfoMediator,Global.player.operId,SwitchScreenType.SHOW,view.stage)]);

		}
		
		private function enterRoomHandler(e:TouchEvent):void
		{
			var touchPoint:Touch = e.getTouch(e.target  as DisplayObject);
			if(e.touches[0].phase=="ended"){
				guideCharter.go(touchPoint.globalX,touchPoint.globalY);
			}
		}		
		
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [];
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
	}
}