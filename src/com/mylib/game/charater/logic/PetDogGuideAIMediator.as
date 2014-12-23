package com.mylib.game.charater.logic
{
	import com.mylib.game.charater.PetDogMediator;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import soulwire.ai.Boid;
	
	import starling.display.DisplayObject;

	public class PetDogGuideAIMediator extends AbstractBoidMediator
	{
		
		public var target:DisplayObject;
		private var dog:PetDogMediator;
		private var currentTime:Number;
		private var nextTime:Number;
		
		//在这个范围内认为是接近了
		private var closeRange:Rectangle;
		private var awayRange:Rectangle;
		private var point:Point;
		private var guideStep:int;
		private var location:Point;
		
		private var isArrived:Boolean;
		private var vector3D:Vector3D;
		private var nextPoint:Point;
		
		private var rangeHalfEdge:int;
		private var awayRangeHalfEdge:int;
		private var isSeeding:Boolean;
		
		
		public function PetDogGuideAIMediator(mediatorName:String, dog:PetDogMediator,_location:Point,_target:DisplayObject, viewComponent:Object=null)
		{
			this.dog = dog;
			this.target = target;
			rangeHalfEdge = 100;
			closeRange = new Rectangle(0,0,rangeHalfEdge*2,rangeHalfEdge*2);
			awayRange = new Rectangle(0,0,closeRange.width*3,closeRange.height*3);
			awayRangeHalfEdge = awayRange.width*0.5;
			point = new Point;
			nextPoint = new Point;
			vector3D = new Vector3D();
			guideStep = 200;
			location = _location;
			super(mediatorName, viewComponent);
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
		
		override protected function updateBoid(boid:Boid, index:int, time:Number):void
		{
			closeRange.x = dog.view.x-rangeHalfEdge;
			closeRange.y = dog.view.y-rangeHalfEdge;
			awayRange.x = dog.view.x - awayRangeHalfEdge;
			awayRange.y = dog.view.y - awayRangeHalfEdge;
			var dir:int = location.x>target.x?1:-1;
			
			if(awayRange.contains(target.x,target.y)){
				
				if(closeRange.contains(target.x,target.y)){
					
					
					var distance:int = location.x - dog.view.x;
					var distanceAbs:int = distance>0?distance:-distance;
					var tx:int;
					if(distanceAbs<10){
						dog.lieDown();
					}else{
						
							
						if(distanceAbs<guideStep){
							tx = location.x;
						}else{
							
							tx = dog.view.x+guideStep*dir;
						}
						
						vector3D.setTo(tx,location.y,0);
						isSeeding = true;
						runRender(boid);
						
					}
					
					
				}else{
					
					if(isSeeding){
						var df:Number = vector3D.x-dog.view.x;
						if(df<5&&df>-5){
							
							if((dir>0&&dog.view.x<target.x)||(dir<0&&dog.view.x>target.x)){
								vector3D.setTo(dog.view.x+guideStep*dir,location.y,0);
							}else{
								isSeeding = false;
							}
							
						}
						
						runRender(boid);
					}else{
						if(dog.dirX!=-dir){
							dog.dirX = -dir;
						}
						dog.shout();
					}
					
					
				}
				
				
			}else{
				
					
				
				vector3D.setTo(target.x+dir*(awayRangeHalfEdge-5),target.y,0);
				
				
				runRender(boid);
				
				
			}
			
			
			
			
		}
		
		
		private function runRender(boid:Boid):void{
			if(vector3D.x!=vector3D.x||vector3D.y!=vector3D.y){
				return;
			}
			
			
			if(boid.velocity.lengthSquared>5){
				dog.run()
			}else{
				dog.walk();
			}
			
			boid.arrive(vector3D);
			boid.update();
			boid.render();
		}
		
		
		private function findNextPoint():void{
			
			
			
			
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