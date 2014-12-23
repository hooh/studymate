package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.fishGame.Animal;
	import com.mylib.game.fishGame.WanderFish1;
	import com.mylib.game.fishGame.Circle;
	import com.mylib.game.fishGame.FlockFish;
	import com.mylib.game.fishGame.FollowFish;
	import com.mylib.game.fishGame.LeaderFish;
	import com.mylib.game.fishGame.Obstacle;
	import com.mylib.game.fishGame.ai.IBoid;
	import com.mylib.game.fishGame.ai.Path;
	import com.mylib.game.fishGame.ai.PathBoid;
	import com.studyMate.global.Global;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class FishBowlMediator extends Mediator
	{
		public static const NAME:String = "FishBowlMediator";
		private var obstacles:Vector.<Obstacle>;
		
		private var clickCircle:Circle;
		public var range:Rectangle;
		private var p1:Point;
		private var p2:Point;
		private var shoal:Vector.<IBoid>;
		private var fish:Vector.<Animal>;
		private var wanderFish:WanderFish1;
		private var flock:Vector.<IBoid>;
		private var flock2:Vector.<IBoid>;
		private var flock3:Vector.<IBoid>;
		
		public function FishBowlMediator(holder:Sprite,range:Rectangle=null)
		{
			this.range = range;
			p1 = new Point;
			p2 = new Point;
			super(NAME, holder);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRegister():void
		{
			sendNotification(CoreConst.HIDE_STARUP_INFOR);
			fish = new Vector.<Animal>;
			var leader:LeaderFish;
			leader = new LeaderFish(range.x,range.y);
			view.addChild(leader.view);
			
			leader.pathBoid.path = generatePath();
			
			leader.start();
			
			leader.pathBoid.addEventListener(PathBoid.ARRIVED_EVENT,leaderArrivedHandle);
			
			fish.push(leader);
			
			shoal = new Vector.<IBoid>;
			flock = new Vector.<IBoid>;
			flock2 = new Vector.<IBoid>;
			flock3 = new Vector.<IBoid>;
			
			obstacles = new Vector.<Obstacle>;
			
			clickCircle = new Circle(1346,247,60);
			
			obstacles.push(clickCircle);
			
			shoal.push(leader.boid);
			
			leader.pathBoid.obstacles = obstacles;
			
			if(view.stage)
			view.stage.addEventListener(TouchEvent.TOUCH,touchHandle);
			
			var followFish:FollowFish;
			for (var i:int = 0; i < 14; i++) 
			{
				followFish = new FollowFish(range.x,range.y);
				followFish.followBoid.leader = leader.boid;
				fish.push(followFish);
				followFish.start();
				shoal.push(followFish.boid);
				followFish.followBoid.allBoids = shoal;
				view.addChild(followFish.view);
				followFish.followBoid.obstacles = obstacles;
			}
			
			var flockFish:FlockFish;
			for (var j:int = 0; j < 8; j++) 
			{
				flockFish = new FlockFish(Math.random()*range.width+range.x,Math.random()*range.height+range.y,(Math.random() * 8) - 4,(Math.random() * 8) - 4,range,"fish/fish_07");
				fish.push(flockFish);
				flockFish.start();
				flock.push(flockFish.boid);
				flockFish.flockBoid.separationDis = 100;
				flockFish.flockBoid.allBoids = flock;
				
				view.addChild(flockFish.view);
			}
			
			for (j = 0; j < 5; j++) 
			{
				flockFish = new FlockFish(Math.random()*range.width+range.x,Math.random()*range.height+range.y,(Math.random() * 4) - 2,(Math.random() * 4) - 2,range,"fish/fish_06");
				fish.push(flockFish);
				flockFish.start();
				flockFish.flockBoid.alignmentWeight = 0.3;
				flockFish.flockBoid.cohesionWeigh = 0.6;
				flockFish.flockBoid.separationWeight = 0.7;
				flockFish.flockBoid.speed = 2;
				flockFish.flockBoid.separationDis = 50;
				
				flock2.push(flockFish.boid);
				flockFish.flockBoid.allBoids = flock2;
				
				view.addChild(flockFish.view);
			}
			
			for (j = 0; j < 6; j++) 
			{
				flockFish = new FlockFish(Math.random()*range.width+range.x,Math.random()*range.height+range.y,(Math.random() * 6) - 3,(Math.random() * 6) - 3,range,"fish/fish_08");
				fish.push(flockFish);
				flockFish.start();
				flockFish.flockBoid.alignmentWeight = 0.3;
				flockFish.flockBoid.cohesionWeigh = 0.2;
				flockFish.flockBoid.separationWeight = 0.5;
				flockFish.flockBoid.speed = 2.5;
				flockFish.flockBoid.separationDis = 30;
				
				flock3.push(flockFish.boid);
				flockFish.flockBoid.allBoids = flock3;
				
				view.addChild(flockFish.view);
			}
			
			
			
			
			wanderFish = new WanderFish1(100,100,range);
			fish.push(wanderFish);
			view.addChild(wanderFish.view);
			wanderFish.start();
			
		}
		
		private function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.BEGAN);
			
			if(touch){
				
				touch.getLocation(view,p1);
				
				if(p1.x<range.left){
					return;
				}else if(p1.x>range.right){
					return;
				}
				
				if(p1.y<range.top){
					return;
				}else if(p1.y>range.bottom){
					return;
				}
				
				
				clickCircle.center.x = clickCircle.x = p1.x;
				clickCircle.center.y = clickCircle.y = p1.y;
				
				
				
			}
			
			
			
		}		
		
		
		
		
		private function leaderArrivedHandle(event:Event):void{
			(event.target as PathBoid).path = generatePath();
			(event.target as PathBoid).currentNode = 0;
			if(Global.stageWidth *0.5<(event.target as PathBoid).position.x){
				(event.target as PathBoid).path.nodes = (event.target as PathBoid).path.nodes.reverse();
			}
		}
		
		private function generatePath():Path{
			var _path:Path = new Path(70);
			var maxPathNodes :int = 8;
			var i:int;
			for (i = 0; i < maxPathNodes; i++) {
				var node :Vector3D = new Vector3D(range.width * i/maxPathNodes + range.x, range.height * Math.random() * 0.8 + range.y);
				_path.addNode(node);
			}
			
			return _path;
			
		}
		
		
		
		override public function onRemove():void
		{
			super.onRemove();
			if(view.stage)
			view.stage.removeEventListener(TouchEvent.TOUCH,touchHandle);
			
			for (var i:int = 0; i < fish.length; i++) 
			{
				fish[i].stop();
				fish[i].view.dispose();
			}
			
			
			
		}
		
	}
}