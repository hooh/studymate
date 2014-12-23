package com.mylib.game.charater.logic
{
	import com.greensock.TweenLite;
	import com.mylib.game.charater.PetDogMediator;
	import com.studyMate.world.controller.vo.LetCharaterWalkToCommandVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Vector3D;
	
	import soulwire.ai.Boid;
	
	import starling.display.DisplayObject;
	
	public class PetDogFollowAIMediator extends AbstractBoidMediator
	{
		private var dog:PetDogMediator;
		private var vector3D:Vector3D;
		private var inRange:Boolean;
		
		private var currentTime:Number;
		private var nextTime:Number;
		
		private var randomActions:Vector.<String>;
		public var target:DisplayObject;
		
		public function PetDogFollowAIMediator(mediatorName:String, dog:PetDogMediator,target:DisplayObject,viewComponent:Object=null)
		{
			this.dog = dog;
			this.target = target;
			vector3D = new Vector3D();
			super(mediatorName, viewComponent);
			
			randomActions = Vector.<String>([PetDogMediator.BREATHE,PetDogMediator.LIEDOWN,PetDogMediator.NORMALSIDE,PetDogMediator.REST,PetDogMediator.SHOUT,PetDogMediator.SIT]);
			
		}
		
		
		override public function onRegister():void
		{
			
			_config = {
				minForce:1,
				maxForce:3,
				minSpeed:2,
				maxSpeed:7,
				minWanderDistance:100.0,
				maxWanderDistance:300.0,
				minWanderRadius:100.0,
				maxWanderRadius:300.0,
				minWanderStep:0.1,
				maxWanderStep:0.9,
				boundsRadius:100,
				numBoids:120,
				bounds:dog.range
			};
			
			createBoid();
			
			currentTime=0;
			nextTime=0;
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			
		}
		
		
		
		override protected function updateBoid(boid:Boid, index:int, time:Number):void
		{
			// Add some wander to keep things interesting
//			boid.wander();
			
			if(!target){
				freeAction(time,boid);
				return;
			}
			
			vector3D.x = target.x-30;
			vector3D.y = target.y;
			
			
			var speed:Number = (vector3D.x-dog.view.x)*0.01;
			
			if(speed<0){
				speed*=-1;
			}
			
			
			if(speed<0.2){
				
				if(!inRange){
					nextTime = 0;
					randomAction();
				}
				
				
				inRange = true;
			}else if(speed>2){
				
				if(inRange){
					
					boid.x = dog.view.x;
					boid.y = dog.view.y;
					TweenLite.killTweensOf(dog.view);
					
				}
				
				inRange = false;
			}
			
			if(inRange){
				freeAction(time,boid);
			}else{
				
				if(speed>4){
					boid.maxSpeed = _config.maxSpeed;
				}else if(speed<4){
					boid.maxSpeed = _config.maxSpeed*speed*0.25;
				}
				
				if(vector3D.x!=vector3D.x||vector3D.y!=vector3D.y){
					return;
				}
				
				boid.arrive(vector3D,100);
				
				if(boid.velocity.lengthSquared>5){
					dog.run()
				}else{
					dog.walk();
				}
				
				boid.update();
				boid.render();
			}
			
			
			
		}
		
		
		private function freeAction(time:Number,boid:Boid):void{
			
			currentTime +=time;
			
			
			if(currentTime>nextTime){
				currentTime = 0;
				nextTime = 3+Math.random()*5;
				
				
				if(Math.random()>0.5){
					dog.walk();
					
					var xx:int = dog.view.x+Math.random()*150-50;
					var yy:int = dog.view.y+Math.random()*50-25;
					
					if(xx<dog.range.x){
						xx = dog.range.x;
					}else if(xx > dog.range.right){
						xx = dog.range.right;
					}
					
					if(yy<dog.range.top){
						yy = dog.range.top;
					}
					
					if(yy>dog.range.bottom){
						yy = dog.range.bottom;
					}
					
					sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(dog,xx,yy,30,walkCompleteHandle));
				}else{
					
					randomAction();
					
					
				}
			}
			
		}
		
		private function walkCompleteHandle():void{
			randomAction();
		}
		
		private function randomAction():void{
			var actionIdx:int = Math.random()*randomActions.length;
			
			if(actionIdx==randomActions.length){
				actionIdx = randomActions.length-1;
			}
			
			dog.action(randomActions[actionIdx]);
			
		}
		
		override protected function createBoid():Boid
		{
			var boid : Boid = new Boid();
			
			setProperties(boid);
			
			boid.renderData = dog.view;
			
			boid.edgeBehavior = Boid.EDGE_BOUNCE;
			
			_boids.push(boid);
			boid.renderCompleteHandle= renderHandle;
			
			return boid;
		}
		
		private function renderHandle(boid:Boid):void{
			
			
			if(boid.oldPosition.x>boid.position.x&&dog.dirX!=-1){
				dog.dirX=-1;
			}else if(boid.oldPosition.x<boid.position.x&&dog.dirX!=1){
				dog.dirX=1;
			}
			
		}

		
		
	}
}