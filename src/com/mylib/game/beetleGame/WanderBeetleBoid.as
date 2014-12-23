package com.mylib.game.beetleGame
{
	import com.mylib.game.fishGame.ai.IBoid;
	
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	public class WanderBeetleBoid implements IBoid
	{
		public  var maxForce 			:Number = 0;
		public  var maxVelocity 		:Number = 0.1;


		// Wander
		public  var circleDistance 	:Number = 10;
		public  var circleRadius 		:Number = 5;
		public  var angleChange 		:Number = 1;
		
		private var _position 	:Vector3D;
		private var _velocity 	:Vector3D;
		public var desired 		:Vector3D;
		public var ahead 		:Vector3D;
		public var behind 		:Vector3D;
		public var steering 	:Vector3D;
		public var mass			:Number;
		public var wanderAngle	:Number;

		public var range:Rectangle;
		
		public function WanderBeetleBoid(posX :Number, posY :Number, totalMass :Number,range:Rectangle)
		{
			position 	= new Vector3D(posX, posY);
			velocity 	= new Vector3D(0.1, 0.1);
			desired	 	= new Vector3D(0, 0); 
			steering 	= new Vector3D(0, 0); 
			ahead 		= new Vector3D(0, 0); 
			behind 		= new Vector3D(0, 0); 
			mass	 	= totalMass;
			wanderAngle = 1; 
			this.range = range;
			truncate(velocity, maxVelocity);
		}
		
		public function get velocity():Vector3D
		{
			return _velocity;
		}
		
		public function set velocity(value:Vector3D):void
		{
			_velocity = value;
		}
		
		public function get position():Vector3D
		{
			return _position;
		}
		
		public function set position(value:Vector3D):void
		{
			_position = value;
		}
		
		private function seek(target :Vector3D, slowingRadius :Number = 0) :Vector3D {
			var force :Vector3D;
			var distance :Number;
			
			desired = target.subtract(position);
			
			distance = desired.length;
			desired.normalize();
			
			if (distance <= slowingRadius) {
				desired.scaleBy(maxVelocity * distance/slowingRadius);
			} else {
				desired.scaleBy(maxVelocity);
			}
			
			force = desired.subtract(velocity);
			
			return force;
		}
		
		private function arrive(target :Vector3D, slowingRadius :Number = 200) :Vector3D {
			return seek(target, slowingRadius);
		}
		
		private function flee(target :Vector3D) :Vector3D {
			var force :Vector3D;
			
			desired = position.subtract(target);
			desired.normalize();
			desired.scaleBy(maxVelocity);
			
			force = desired.subtract(velocity);
			
			return force;
		}
		
		private function evade(target:IBoid) :Vector3D {
			var distance :Vector3D = target.position.subtract(position);
			
			var updatesNeeded :Number = distance.length / maxVelocity;
			
			var tv :Vector3D = target.velocity.clone();
			tv.scaleBy(updatesNeeded);
			
			var targetFuturePosition :Vector3D = target.position.clone().add(tv);
			
			return flee(targetFuturePosition);
		}
		
		protected function wander() :Vector3D {
			var wanderForce :Vector3D, circleCenter:Vector3D, displacement:Vector3D;
			
			circleCenter = velocity.clone();
			circleCenter.normalize();
			circleCenter.scaleBy(circleDistance);
			
			displacement = new Vector3D(0, -1);
			displacement.scaleBy(circleRadius);
			
			setAngle(displacement, wanderAngle);
			wanderAngle += Math.random() * angleChange - angleChange * .5;
			
			wanderForce = circleCenter.add(displacement);
			
			
			return wanderForce;
		}
		


		private function distance(a :Vector3D, b :Vector3D) :Number {
			return Math.sqrt((a.x - b.x) * (a.x - b.x)  + (a.y - b.y) * (a.y - b.y));
		}
		
		public function truncate(vector :Vector3D, max :Number) :void {
			var i :Number;
			
			i = max / vector.length;
			i = i < 1.0 ? i : 1.0;
			
			vector.scaleBy(i);
		}
		
		public function getAngle(vector :Vector3D) :Number {
			return Math.atan2(vector.y, vector.x);
		}
		
		public function setAngle(vector :Vector3D, value:Number):void {
			var len :Number = vector.length;
			vector.x = Math.cos(value) * len;
			vector.y = Math.sin(value) * len;
		}
		
		protected function customBehavior():void{
			
			if (position.x >= range.right ) {
				position.x = range.right;
				velocity.x*=-1;
			}else if(position.x < range.left){
				position.x = range.left;
				velocity.x*=-1;
			}
			
			if(position.y >= range.bottom){
				position.y = range.bottom;
				velocity.y*=-1;
				
			}else if(position.y < range.top){
				position.y = range.top;
				velocity.y*=-1;
			}
			steering.incrementBy(wander());
		}
		
		
		
		public function update():void {
//			steering.scaleBy(0);
			customBehavior();

			
			truncate(steering, maxForce);
			steering.scaleBy(1 / mass);
			
			velocity = velocity.add(steering);
			
			position = position.add(velocity);
			
		}
	}
	
}