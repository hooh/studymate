package com.mylib.game.fishGame.ai
{
	import com.mylib.game.fishGame.Circle;
	import com.mylib.game.fishGame.Obstacle;
	
	import flash.geom.Vector3D;
	
	public class FollowBoid implements IBoid
	{
		
		public  var maxForce 			:Number = 5.4;
		public  var maxVelocity 		:Number = 3;
		
		public  var leaderBehindDist	:Number = 30;
		public  var leaderSightRedius	:Number = 30;
		
		// Separation
		public  var maxSeparation 		:Number = 2.0;
		public  var separationRadius 	:Number = 50;
		
		// Wander
		public  var circleDistance 	:Number = 6;
		public  var circleRadius 		:Number = 8;
		public  var angleChange 		:Number = 1;
		
		private var _position 	:Vector3D;
		private var _velocity 	:Vector3D;
		public var desired 		:Vector3D;
		public var ahead 		:Vector3D;
		public var behind 		:Vector3D;
		public var steering 	:Vector3D;
		public var mass			:Number;
		public var wanderAngle	:Number;
		
		public var leader:IBoid;
		public var allBoids:Vector.<IBoid>;
		
		public static const MAX_AVOID_AHEAD	 	:Number = 100;
		public static const AVOID_FORCE	 		:Number = 350;
		
		public var avoidance:Vector3D;
		
		public var ahead2:Vector3D;
		
		public var obstacles:Vector.<Obstacle>;
		
		
		
		public function FollowBoid(posX :Number, posY :Number, totalMass :Number)
		{
			position 	= new Vector3D(posX, posY);
			velocity 	= new Vector3D(-1, -2);
			desired	 	= new Vector3D(0, 0); 
			steering 	= new Vector3D(0, 0); 
			ahead 		= new Vector3D(0, 0); 
			behind 		= new Vector3D(0, 0); 
			avoidance 	= new Vector3D(0, 0); 
			mass	 	= totalMass;
			wanderAngle = 0; 
			
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
		
		
		private function collisionAvoidance() :Vector3D {
			var tv :Vector3D = velocity.clone();
			tv.normalize();
			tv.scaleBy(MAX_AVOID_AHEAD * velocity.length / maxVelocity);
			
			ahead = position.clone().add(tv);
			
			var mostThreatening :Obstacle = null;
			
			for (var i:int = 0; i < obstacles.length; i++) {
				var obstacle :Obstacle = obstacles[i];
				var collision :Boolean = lineIntersecsCircle(position, ahead, obstacle as Circle);
				
				if (collision && (mostThreatening == null || distance(position, obstacle) < distance(position, mostThreatening))) {
					mostThreatening = obstacle;
				}
			}
			
			if (mostThreatening != null) {
//				alpha = 0.4; // make the boid a little bit transparent to indicate it is colliding
				avoidance.x = ahead.x - mostThreatening.center.x;
				avoidance.y = ahead.y - mostThreatening.center.y; 
				avoidance.normalize();
				avoidance.scaleBy(AVOID_FORCE);
			} else {
//				alpha = 1; // make the boid opaque to indicate there is no collision.
				avoidance.scaleBy(0); // nullify the avoidance force
			}
			
			return avoidance;
		}
		
		private function lineIntersecsCircle(position :Vector3D, ahead :Vector3D, c :Circle) :Boolean {
			var tv :Vector3D = velocity.clone();
			tv.normalize();
			tv.scaleBy(MAX_AVOID_AHEAD * 0.5 * velocity.length / maxVelocity);
			
			ahead2 = position.clone().add(tv);
			return distance(c, ahead) <= c.radius || distance(c, ahead2) <= c.radius || distance(c, this.position) <= c.radius;
		}
		
		
		// Link: http://gamedev.tutsplus.com/tutorials/implementation/the-three-simple-rules-of-flocking-behaviors-alignment-cohesion-and-separation/
		private function separation() :Vector3D {
			var force :Vector3D = new Vector3D();
			var neighborCount :int = 0;
			
			for (var i:int = 0; i < allBoids.length; i++) {
				var b:IBoid = allBoids[i];
				
				if (b != this && distance(b.position, position) <= separationRadius) {
					force.x += b.position.x - this.position.x;
					force.y += b.position.y - this.position.y;
					neighborCount++;
				}
			}
			
			if (neighborCount != 0) {
				force.x /= neighborCount;
				force.y /= neighborCount;
				
				force.scaleBy( -1);
			}
			
			force.normalize();
			force.scaleBy(maxSeparation);
			
			return force;
		}
		
		private function followLeader(leader:IBoid) :Vector3D {
			var tv 		:Vector3D 	= leader.velocity.clone();
			var force 	:Vector3D	= new Vector3D();
			
			tv.normalize();
			tv.scaleBy(leaderBehindDist);
			
			ahead = leader.position.clone().add(tv);
			
			tv.scaleBy(-1);
			behind = leader.position.clone().add(tv);
			
			if (isOnLeaderSight(leader, ahead)) {
				force = force.add(evade(leader));
				force.scaleBy(1.8); // make evade force stronger...
			} else {
			}
			
			force = force.add(arrive(behind, 50));
			force = force.add(separation());
			
			return force;
		}
		
		private function isOnLeaderSight(leader:IBoid, leaderAhead :Vector3D) :Boolean {
			return distance(leaderAhead, position) <= leaderSightRedius || distance(leader.position, position) <= leaderSightRedius;
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
			
		}
		
		
		
		public function update():void {
			steering.scaleBy(0);
			customBehavior();
			if(leader){
				steering = steering.add(followLeader(leader));
			}
			if(obstacles&&obstacles.length>0){
				steering = steering.add(collisionAvoidance());
			}
			
			truncate(steering, maxForce);
			steering.scaleBy(1 / mass);
			
			velocity = velocity.add(steering);
			truncate(velocity, (!leader ? maxVelocity * (0.3 + Math.random() * 0.5) : maxVelocity));
			
			position = position.add(velocity);
			
		}
	}
}