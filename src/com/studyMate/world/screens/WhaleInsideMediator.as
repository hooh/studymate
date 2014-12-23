package com.studyMate.world.screens
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.CharaterUtils;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.component.ZhengQiJiMediator;
	import com.studyMate.world.screens.effects.Bubbles1;
	import com.studyMate.world.screens.effects.SwimWater;
	import com.studyMate.world.screens.talkingbook.TalkingBookMediator;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.graphics.Fill;
	import starling.display.graphics.Stroke;
	import starling.display.shaders.vertex.RippleVertexShader;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class WhaleInsideMediator extends ScreenBaseMediator
	{
		
		public static const NAME:String = "WhaleInsideMediator";
		private var charater:HumanMediator;
		private var humanPool:HumanPoolProxy;
		private var walkRange:Rectangle;
		private var bubbles:Bubbles1;
		private var swimwaterL:SwimWater;
		private var swimwaterR:SwimWater;
		private var stopBoo:Boolean;
		
		private var bookImg:Image;
		private var personInfoImg:Image;
		private var feidieImg:Image;
		private var flowerImg:Image;
		private var holder:Sprite;
		private var chibang_left:Image;
		private var chibang_Right:Image;
		private var tempArr:Array = [];

		
		public function WhaleInsideMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}
		override public function onRegister():void{	
			var bg:Quad = new Quad(WorldConst.stageWidth, WorldConst.stageHeight);
			bg.setVertexColor(0,0x3CB4C1);
			bg.setVertexColor(1,0x3CB4C1);
			bg.setVertexColor(2,0xAEE0E5);
			bg.setVertexColor(3,0xAEE0E5);			
			view.addChild(bg);
			
			for (var i:int = 0; i < 8; i++) {//显示后退的树木效果
				tweenDot(getNewDot(), Math.random()*8);
			}
			
			for(i=0;i<2;i++){//鱼儿
				var fish_L:Image = new Image(Assets.getWhaleInsideTexture("ui/fish_L"+i));
				view.addChild(fish_L);
				tweenFishL(fish_L,Math.random()*7,-200);
				
				var fish_R:Image = new Image(Assets.getWhaleInsideTexture("ui/fish_R"+i));
				view.addChild(fish_R);
				tweenFishL(fish_R,Math.random()*7,1480);
				
				tempArr.push(fish_L);
				tempArr.push(fish_R);
			}
			
			bubbles = new Bubbles1();//气泡
			bubbles.y = 760;
			view.addChild(bubbles);
			bubbles.start();
			
			chibang_left = new Image(Assets.getWhaleInsideTexture("ui/chibang_L"));//鲸鱼翅膀
			chibang_left.touchable = false;
			chibang_left.x = 110;
			chibang_left.y = 506;
			chibang_left.pivotX = chibang_left.width;
			
			chibang_Right = new Image(Assets.getWhaleInsideTexture("ui/chibang_R"));//鲸鱼翅膀
			chibang_Right.touchable = false;
			chibang_Right.x = 1182;
			chibang_Right.y = 506;
			
			
			var img:Image = new Image(Assets.getWhaleInsideTexture("bg/InsideBG"));//鲸鱼内部
			img.touchable = false;
			img.y = -38;
			img.touchable = false;
			holder = new Sprite();
			holder.addChild(chibang_left);
			holder.addChild(chibang_Right);
			holder.addChild(img);
			view.addChild(holder);	
			TweenMax.to(chibang_left,2,{scaleX:0.8,yoyo:true,repeat:99999});
			TweenMax.to(chibang_Right,2,{scaleX:0.8,yoyo:true,repeat:99999});
			TweenMax.to(holder,1,{y:-10,yoyo:true,repeat:99999,ease:Linear.easeNone});
			
			
			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ZhengQiJiMediator,null,SwitchScreenType.SHOW,holder,718,64)]);//蒸汽机
			
			bookImg = new Image(Assets.getWhaleInsideTexture("ui/bookShelf"));//书架
			bookImg.x = 336;
			bookImg.y = 164;
//			bookImg.addEventListener(TouchEvent.TOUCH,enterBookShelf);
			holder.addChild(bookImg);
			
			personInfoImg = new Image(Assets.getWhaleInsideTexture("ui/personInfo"));//个人信息
			personInfoImg.x = 922;
			personInfoImg.y = 266;
			personInfoImg.addEventListener(TouchEvent.TOUCH,enterPersonInfo);
			holder.addChild(personInfoImg);
			
			feidieImg = new Image(Assets.getWhaleInsideTexture("ui/feiDie"));//飞碟
			feidieImg.x = 977;
			feidieImg.y = 207;
//			feidieImg.addEventListener(TouchEvent.TOUCH,enterGame);
			holder.addChild(feidieImg);
			
			flowerImg = new Image(Assets.getWhaleInsideTexture("ui/flower"));//花盆，进入测试界面
			flowerImg.x = 1037;
			flowerImg.y = 315;
			flowerImg.addEventListener(TouchEvent.TOUCH,enterLaboratory);						
			holder.addChild(flowerImg);
			
			var videoImg:Image = new Image(Assets.getWhaleInsideTexture("ui/video"));//视频资源
			videoImg.x = 450;
			videoImg.y = 210;
//			videoImg.addEventListener(TouchEvent.TOUCH,enterVideoRes);						
			holder.addChild(videoImg);
			
			
			var pathHolder:Sprite = new Sprite();
			holder.addChild(pathHolder);
			walkRange = new Rectangle(210,350,870,175);
			facade.registerMediator(new MyCharaterControllerMediator(pathHolder,walkRange));
			humanPool = facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy;
			charater = humanPool.object;
			GlobalModule.charaterUtils.configHumanFromDressList(charater,Global.myDressList,walkRange);
			charater.view.alpha = 1;
			charater.view.x = 250;
			charater.view.y = 440;
			holder.addChild(charater.view);			
			sendNotification(WorldConst.ADD_MYCHARATER_CONTROL,charater);
			sendNotification(WorldConst.UPDATE_PLAYER_MAP,"whaleInside");
			sendNotification(WorldConst.UPDATE_PLAYER_CHARATER,charater);	
			
			
			var w:Number = view.stage.stageWidth;
			var h:Number = 160;
			var waterColorTop:uint = 0x08acff;
			var waterColorBottom:uint = 0x0073ad;
			var waterColorSurface:uint = 0xc6e5f5;
			
			var waterHeight:Number = 80;
			var waterFill:Fill = new Fill();
			waterFill.addVertex(0, waterHeight, waterColorTop,0.3 );
			waterFill.addVertex(w, waterHeight, waterColorTop,0.3 );
			waterFill.addVertex(w, h, waterColorBottom,0 );
			waterFill.addVertex(0, h, waterColorBottom,0 );
			view.addChild(waterFill);
			
			var waterSurfaceThickness:Number = 20;
			var waterSurfaceStroke:Stroke = new Stroke();
			waterSurfaceStroke.material.vertexShader = new RippleVertexShader();
			
			for ( i = 0; i < 50; i++ )
			{
				var ratio:Number = i / 49;
				waterSurfaceStroke.addVertex( ratio * w, waterHeight + waterSurfaceThickness*0.25, waterSurfaceThickness, waterColorSurface, 0.8, waterColorTop, 0.3);
			}
			view.addChild(waterSurfaceStroke);
			
			
			swimwaterL = new SwimWater();
			swimwaterL.start();
			view.addChild(swimwaterL);
			swimwaterL.x = 160;
			swimwaterL.y = 80;
			
			swimwaterR = new SwimWater();
			swimwaterR.start();
			view.addChild(swimwaterR);
			swimwaterR.x = view.stage.stageWidth-160;
			swimwaterR.y = 80;
			swimwaterR.scaleX = -1;
			
			
			trace("@VIEW:WhaleInsideMediator:");
		}
		
		override public function onRemove():void{
			stopBoo = true;
			TweenMax.killAll(true);
			TweenMax.killDelayedCallsTo(tweenFishL);
			TweenMax.killDelayedCallsTo(tweenDot);
			for(var i:int=0;i<tempArr.length;i++){
				var obj:DisplayObject = tempArr[i];
				TweenMax.killTweensOf(obj);
				obj = null;
			}
			tempArr.length = 0;
			tempArr = null;
			TweenMax.killTweensOf(chibang_left);
			TweenMax.killTweensOf(chibang_Right);
			TweenMax.killTweensOf(holder);
			
			
			bubbles.dispose();
			bubbles = null;
			swimwaterL.dispose();
			swimwaterR.dispose();
			swimwaterL = null;
			swimwaterR = null;
			bookImg.removeEventListener(TouchEvent.TOUCH,enterBookShelf);
			personInfoImg.removeEventListener(TouchEvent.TOUCH,enterPersonInfo);			
			flowerImg.removeEventListener(TouchEvent.TOUCH,enterLaboratory);
			feidieImg.removeEventListener(TouchEvent.TOUCH,enterGame);
			
			
			holder.removeChildren(0,-1,true);
			
			
			view.removeChildren(0,-1,true);
			facade.removeMediator(MyCharaterControllerMediator.NAME);
			(facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy).object = charater;
			
			super.onRemove();
		}
		
		/**-------------------显示海底世界。z轴后退效果---------------------*/
		private var flag:int=-1;
		private var currentState:int = -1;
		private function tweenDot(dot:Image, delay:Number):void {
			if(stopBoo){
				return;
			}
			currentState *= flag;
			dot.x = 640;
			dot.y = 560;	
			dot.alpha = 0.3;
			dot.scaleX = 0.1*currentState;
			dot.scaleY = 0.1;//scaleX:1.5*currentState,scaleY:1.5,//getRandom(200, 340)
			TweenMax.to(dot,10, {alpha:1,scaleX:1.5*currentState,scaleY:1.5,physics2D:{velocity:-80, angle:270+currentState*60}, delay:delay, onComplete:tweenDot, onCompleteParams:[dot, 0]});
		}		
		private function getNewDot():Image {//海底植物
			var i:int =  Math.floor(Math.random()*3);
			var bgTree1:Image = new Image(Assets.getWhaleInsideTexture("ui/bg_Tree"+i));//地面回退动画。造成视觉前进效果
			bgTree1.pivotX = bgTree1.width>>1;
			bgTree1.pivotY = bgTree1.height>>1;
			view.addChild(bgTree1);
			tempArr.push(bgTree1);
			return bgTree1;
		}		
		
		private function tweenFishL(dot:Image, delay:Number,toX:int):void{
			if(stopBoo){				
				return;
			}
			dot.x = 640;
			dot.pivotX = dot.width>>1;
			dot.pivotY = dot.height>>1;
			dot.y = Math.random()*700+70;	
			dot.alpha = 0.3;
			dot.scaleX = 0.1;
			dot.scaleY = 0.1;
			TweenMax.to(dot,10,{alpha:1,scaleX:1,scaleY:1,x:toX,delay:delay, onComplete:tweenFishL, onCompleteParams:[dot, 0,toX]});
		}
		
		
		private function enterGame(event:TouchEvent):void
		{
			//进入游戏
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.ENDED){
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AndroidGameMediator)]);
//					sendNotification(WorldConst.HIDE_MAIN_MENU);
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AndroidGameShowMediator)]);
					
					sendNotification(WorldConst.HIDE_MAIN_MENU);
					sendNotification(WorldConst.HIDE_LEFT_MENU);
				}
			}
			
		}
		
		private function enterLaboratory(event:TouchEvent):void
		{
			//进入测试界面
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.ENDED){
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(LaboratoryMediator)]);
				}
			}
			
		}
		
		private function enterVideoRes(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.ENDED){
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ResTableMediator)]);
				}
			}
		}
		
		
		private function enterPersonInfo(event:TouchEvent):void
		{
			// 进入个人信息界面
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.ENDED){
					/*sendNotification(WorldConst.SHOW_PERSONALINFO);*/
				}
			}
		}
		
		private function enterBookShelf(event:TouchEvent):void
		{
			// 进入书架
			var touchPoint:Touch = event.getTouch(event.target as DisplayObject);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.ENDED){					
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BookshelfNewView2Mediator),new SwitchScreenVO(CleanGpuMediator)]);		
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TalkingBookMediator),new SwitchScreenVO(CleanCpuMediator)]);

				}
			}
		}
		

		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			//prepareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);						
		}
	}
}