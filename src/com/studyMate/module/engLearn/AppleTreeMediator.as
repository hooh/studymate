package com.studyMate.module.engLearn
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quad;
	import com.mylib.api.ICharaterUtils;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.model.HumanPoolProxy;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.LetCharaterWalkToCommandVO;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;

	internal class AppleTreeMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "AppleTreeMediator";
		private var tree:Image;
		private var fruits:Vector.<Image>;
		
		private var range:Rectangle;
		
		private var charater:IHuman; 
		
		private var doBeat:Boolean;
		
		private var currentFruit:Image;
		
		private var currentShakeFruit:Image;
		
		public static const SHAKE_LAST_ONE:String = NAME+"ShakeLastOne";
		public static const DROP_CURRENT:String = NAME+"DropCurrent";
		public static const GROW:String = NAME + "Grow";
		
		
		public function AppleTreeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRemove():void
		{
			fruits.length = 0;
			fruits = null;
			TweenLite.killTweensOf(charater.view);//LetCharaterWalkToCommand内部有调用
			TweenLite.killTweensOf(charater.look);
			TweenLite.killTweensOf(charater.beatHead);
			TweenLite.killTweensOf(currentFruit);
			TweenLite.killDelayedCallsTo(dropFruit);
			TweenLite.killDelayedCallsTo(dropNext);
			TweenMax.killTweensOf(currentShakeFruit);
			view.removeChildren(0,-1,true);
			
			
			var pool:HumanPoolProxy = facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy;
			pool.object = charater;
			
			super.onRemove();
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			// TODO Auto Generated method stub
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			
			switch(name)
			{
				case SHAKE_LAST_ONE:
				{
					shakeLastOne();
					break;
				}
				case DROP_CURRENT:{
					dropOne(currentFruit,notification.getBody());
					break;
				}
				case GROW:{
					growFruit(notification.getBody() as int);
					break;
				}
				default:
				{
					break;
				}
			}
			
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHAKE_LAST_ONE,DROP_CURRENT,GROW];
		}
		
		override public function onRegister():void
		{
			
			super.onRegister();
			
			tree = new Image(Assets.getEgAtlasTexture("word/BigTree"));
			
			view.addChild(tree);
			fruits = new Vector.<Image>;
			
			range = new Rectangle(60,52,292,205);
			
			
			var pool:HumanPoolProxy = facade.retrieveProxy(ModuleConst.HUMAN_POOL) as HumanPoolProxy;
			charater = pool.object;
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CHARATER_UTILS) as ICharaterUtils).configHumanFromDressList(charater as HumanMediator,Global.myDressList,new Rectangle());
			
	
			doBeat = true;
			
//			growFruit(20);
//			dropNext();
			view.addChild(charater.view);
			charater.view.y = 490;
			
			view.pivotX = tree.width>>1;
			view.pivotY = tree.height>>1;
			
			
		}
		
		
		private function growFruit(num:uint):void{
			
			var fruit:Image;
			for (var i:int = 0; i < num; i++) 
			{
				/*if(Math.random()>0.5){
					fruit = new Image(Assets.getEgAtlasTexture("word/apple2"));
					
				}else{*/
					fruit = new Image(Assets.getEgAtlasTexture("word/apple1"));
					
				//}
				
				view.addChild(fruit);
				fruit.x = range.x+ Math.random()*range.width;
				fruit.y = range.y+ Math.random()*range.height;
				
				if(Math.random()>0.5){
					fruit.scaleX = -1;
				}
				fruit.rotation = (Math.random()*20-20)/57.3;
				fruits.push(fruit);
				centerPivot(fruit);
				
			}
			
		}
		
		private function shakeFruit(fruitId:int):void{
			TweenMax.to(fruits[fruitId],0.12,{rotation:fruits[fruitId].rotation-0.3,x:fruits[fruitId].x+5,y:fruits[fruitId].y+3,yoyo:true,repeat:999});
		}
		
		private function dropFruit(fruitId:int):void{
			
			TweenLite.killTweensOf(fruits[fruitId]);
			
			
			if(doBeat){
				TweenLite.to(fruits[fruitId],0.4,{y:400,onComplete:throwFruit,onCompleteParams:[fruitId],ease:Quad.easeIn});
				TweenLite.delayedCall(0.2,charater.beatHead);
			}else{
				TweenLite.to(fruits[fruitId],0.4,{y:400,onComplete:dropHandle,onCompleteParams:[fruitId],ease:Quad.easeIn});
				TweenLite.delayedCall(0.6,charater.look,["bigSmile"]);
				TweenLite.delayedCall(1.6,charater.look,[HumanMediator.FACE_NORMAL]);
				
			}
			
			
			
			
		}
		
		private function throwFruit(fruit:Image):void{

			TweenLite.to(fruit,2,{physics2D:{velocity:300, angle:240, gravity:600},onComplete:dropHandle,onCompleteParams:[fruit]});
			
		}
		
		private function dropHandle(fruit:Image):void{

			fruit.removeFromParent(true);
		}
		
		
		
		private function rollFruit(fruitId:int):void{
			TweenLite.to(fruits[fruitId],3,{rotation:fruits[fruitId].rotation+3,x:fruits[fruitId].x+30,ease:Quad.easeOut});
			TweenMax.to(fruits[fruitId],0.5,{y:fruits[fruitId].y+10,overwrite:0,ease:Elastic.easeOut});
		}
		
		
		private function processDrop(fruitId:int):void{
			
			shakeFruit(fruitId);
			
			if(Math.random()>0.5){
				
				doBeat = true;
			}else{
				doBeat = false;
			}
			
			TweenLite.delayedCall(3,dropFruit,[fruitId]);
			
			TweenLite.delayedCall(6,dropNext);
			
			charater.walk();
			sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(charater,fruits[fruitId].x,NaN,1,walkCompleteHandle));
			
		}
		
		private function walkCompleteHandle():void{
			charater.idle();
		}
		
		private var dropIdx:int=0;
		
		private function dropNext():void{
			
			if(dropIdx<fruits.length){
				processDrop(dropIdx);
				dropIdx++;
			}else{
				growFruit(20);
				dropNext();
			}
			
		}
		
		public function shakeOne(fruit:Image):void{
			currentShakeFruit = fruit;
			TweenMax.to(fruit,0.12,{rotation:fruit.rotation-0.3,x:fruit.x+5,y:fruit.y+3,yoyo:true,repeat:999});
			
			charater.walk();
			sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(charater,fruit.x,NaN,1,walkCompleteHandle));
		}
		
		public function dropOne(fruit:Image,doBeat:Boolean):void{
			
			if(!fruit){
				return;
			}
			
			TweenLite.killTweensOf(fruit);
			
			this.doBeat = doBeat;
			if(doBeat){
				TweenLite.to(fruit,0.4,{y:400,onComplete:throwFruit,onCompleteParams:[fruit],ease:Quad.easeIn});
				TweenLite.delayedCall(0.2,charater.beatHead);
			}else{
				TweenLite.to(fruit,0.4,{y:400,onComplete:dropHandle,onCompleteParams:[fruit],ease:Quad.easeIn});
				TweenLite.delayedCall(0.6,charater.look,["bigSmile"]);
				TweenLite.delayedCall(1.6,charater.look,[HumanMediator.FACE_NORMAL]);
				
			}
		}
		
		public function shakeLastOne():void{
			
			if(fruits.length>0){
				currentFruit = fruits.pop();
				shakeOne(currentFruit);
			}
			
			
		}
		
		
		
		
		
		
		
		
	}
}