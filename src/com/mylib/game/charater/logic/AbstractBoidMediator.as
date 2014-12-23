package com.mylib.game.charater.logic
{
	
	import flash.geom.Vector3D;
	
	import soulwire.ai.Boid;
	
	import starling.display.Sprite;
	
	public class AbstractBoidMediator extends RunnerMediator
	{
		protected var _config : Object = {
			minForce:3.0,
			maxForce:6.0,
			minSpeed:1,
			maxSpeed:3,
			minWanderDistance:10.0,
			maxWanderDistance:30.0,
			minWanderRadius:5.0,
			maxWanderRadius:20.0,
			minWanderStep:0.1,
			maxWanderStep:0.9,
			boundsRadius:30,
			numBoids:120
		};
		
		protected var _boids : Vector.<Boid> = new Vector.<Boid>();
		
		
		public function AbstractBoidMediator(mediatorName:String, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function onRegister():void
		{
			
			
		}
		
		
		
		
		
		protected function createBoids(count : int):void
		{
			for (var i : int = 0;i < count; i++)
			{
				createBoid();
			}
		}
		
		protected function createBoid() : Boid
		{
			var boid : Boid = new Boid();
			
			setProperties(boid);
//			boid.renderData = boid.createDebugShape(Math.random() * 0xFFFFFF, 4.0, 2.0);
			
			_boids.push(boid);
//			view.addChild(boid.renderData);
			
			return boid;
		}
		
		
		protected function setProperties(boid : Boid) : void
		{
			boid.edgeBehavior = Boid.EDGE_BOUNCE;
			boid.maxForce = random(_config.minForce, _config.maxForce);
			boid.maxSpeed = random(_config.minSpeed, _config.maxSpeed);
			boid.wanderDistance = random(_config.minWanderDistance, _config.maxWanderDistance);
			boid.wanderRadius = random(_config.minWanderRadius, _config.maxWanderRadius);
			boid.wanderStep = random(_config.minWanderStep, _config.maxWanderStep);
			boid.boundsRadius = _config.boundsRadius;
			boid.boundsCentre = new Vector3D(200, 200, 0.0);
			boid.bounds = _config.bounds;
			
			if(boid.x == 0 && boid.y == 0)
			{
				boid.x = boid.boundsCentre.x + random(-100, 100);
				boid.y = boid.boundsCentre.y + random(-100, 100);
				
				var vel : Vector3D = new Vector3D(random(-2, 2), random(-2, 2), random(-2, 2));
				boid.velocity.incrementBy(vel);
			}
		}
		
		
		protected function random( min : Number, max : Number = NaN ) : Number
		{
			if ( isNaN(max) )
			{
				max = min;
				min = 0;
			}
			
			return Math.random() * ( max - min ) + min;
		}
		
		protected function updateBoid(boid : Boid, index : int,time:Number) : void
		{
			// Override
		}
		
		
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function advanceTime(time:Number):void
		{
			for (var i : int = 0;i < _boids.length; i++)
			{
				updateBoid(_boids[i], i,time);
			}
			
			
			
			
		}
		
	}
}