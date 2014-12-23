package com.studyMate.world.animation
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.ai.HeroGoAI;
	import com.mylib.game.model.FightCharaterPoolProxy;
	import com.studyMate.global.Global;
	import com.studyMate.module.GlobalModule;
	import com.studyMate.module.ModuleConst;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class PlaneAni extends Sprite implements IAnimatable
	{
		private var pool:FightCharaterPoolProxy;
		private var fighter1:FighterControllerMediator;
		private var plane:Plane1;
		private var vy:Vector3D;
		private var jungle:Juggler;
		private var randomTime:Number;
		private var va:Number;
		
		private var bg:Image;
		private var p:Point;
		
		private var cloudPool:Vector.<ScrollCloud>;
		
		private var clouds:Vector.<ScrollCloud>;
		
		private var cloudTime:Number;
		
		
		public function PlaneAni()
		{
			if(!Facade.getInstance(CoreConst.CORE).hasProxy(ModuleConst.FIGHT_CHARATER_POOL)){
				pool = new FightCharaterPoolProxy(true);
				Facade.getInstance(CoreConst.CORE).registerProxy(pool);
				pool.init();
			}else{
				pool = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.FIGHT_CHARATER_POOL) as FightCharaterPoolProxy;
			}
			Starling.current.stage.color = 0xadd9f4;
			fighter1 = pool.object;
			fighter1.setTo(100,60);
			GlobalModule.charaterUtils.humanDressFun(fighter1.charater,Global.myDressList);
			fighter1.decision =  new HeroGoAI(new Point(100,60),null);
			fighter1.start();
			
			
			p = new Point;
			
			
			jungle = new Juggler();
			
			Starling.juggler.add(jungle);
			
			jungle.add(this);
			
			plane = new Plane1(jungle);
			
			plane.addChildAt(fighter1.charater.view,0);
			
			plane.x = 180;
			
			plane.scaleX = plane.scaleY = 0.5;
			
			addChild(plane);
			
			x = 364;
			y = 265;
			
			vy = new Vector3D(0,0.2);
			randomTime = 0;
			va = 0;
			cloudTime = 0;
			
			
			bg = new Image(Assets.getTexture("citybg",1,true));
//			bg.pivotX = bg.width*0.5;
			
			bg.y = 0;
			
			this.clipRect = new Rectangle(0,0,540,200)
			
			
			
			addChildAt(bg,0);
			
			cloudPool = new Vector.<ScrollCloud>;
			
			
			for (var i:int = 0; i < 2; i++) 
			{
				for (var j:int = 1; j < 5; j++) 
				{
					var img:ScrollCloud;
					img = new ScrollCloud(Assets.getRAnimationTexture("animation/cloud"+j));
					img.pivotX = img.width*0.5;
					img.pivotY = img.height*0.5;
					cloudPool.push(img);
				}
			}
			
			
			clouds = new Vector.<ScrollCloud>;
			clouds.push(getCloud());
			clouds.push(getCloud());
			clouds.push(getCloud());
			
			for (var k:int = 0; k < clouds.length; k++) 
			{
				clouds[k].x = 100+Math.random()*300;
				clouds[k].y = 40+Math.random()*100;
				addChild(clouds[k]);
			}
			
			
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			pool.object=fighter1;
			
			Assets.disposeTexture("citybg");
			
			Starling.juggler.remove(jungle);
			
			for (var i:int = 0; i < cloudPool.length; i++) 
			{
				cloudPool[i].dispose();
			}
			
			
			
		}
		
		
		private function getCloud():ScrollCloud{
			
			var cloud:ScrollCloud;
			if(cloudPool.length){
			cloud = cloudPool.splice(Math.random()*cloudPool.length,1)[0];
			cloud.speed = Math.random()+0.1;}
			
			return cloud;
			
		}
		
		
		
		
		public function advanceTime(time:Number):void
		{
			plane.y+=vy.y;
			
			randomTime+=time;
			
			if(randomTime>0.5){
				randomTime = 0;
				va = 0.02-Math.random()*0.04;
			}
			
			vy.y +=va;
			va*=0.9;
			
			if(plane.y>150){
				
				vy.y = -0.2;
				
			}else if(plane.y<30){
				
				vy.y = 0.2;
			}
			
			
			for (var i:int = 0; i < 4; i++) 
			{  
				p = bg.getTexCoords(i,p);  
				p.x += 5 * .0002;
				bg.setTexCoords(i, p);    
			}
			
			for (var j:int = 0; j < clouds.length; j++) 
			{
				
				clouds[j].x -=clouds[j].speed;
				
				
				if(clouds[j].x<-60){
					clouds[j].removeFromParent();
					cloudPool.push(clouds.splice(clouds.indexOf(clouds[j]),1)[0]);
				}
				
			}
			
			if(cloudTime>1){
				cloudTime = 0;
				var newCloud:ScrollCloud = getCloud();
				
				if(newCloud){
					addChild(newCloud);
					clouds.push(newCloud);
					newCloud.x = 600;
					newCloud.y = 40+Math.random()*160;
				}
				
				
				
			}
			cloudTime+=time;
			
			
			
			
		}
		
	}
}