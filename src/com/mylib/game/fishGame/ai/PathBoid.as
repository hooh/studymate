package com.mylib.game.fishGame.ai
{
	import com.mylib.game.fishGame.Obstacle;
	
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import starling.events.EventDispatcher;
	
	public class PathBoid extends EventDispatcher implements IBoid
	{
		
		public static const ARRIVED_EVENT:String = "arrived";
		
		
		public static const MAX_VELOCITY 		:Number = 3;
		public static const MAX_FORCE 			:Number = MAX_VELOCITY * 3;		
		
		private var _position 	:Vector3D;
		private var _velocity 	:Vector3D;
		public var maxVelocity 	:Number;
		public var desired 		:Vector3D;
		public var steering 	:Vector3D;
		public var mass			:Number;
		public var path			:Path;
		public var currentNode	:int;
		
		
		public static const MAX_AVOID_AHEAD	 	:Number = 100;
		public static const AVOID_FORCE	 		:Number = 350;
		
		public var avoidance:Vector3D;
		
		public var ahead2:Vector3D;
		
		public var obstacles:Vector.<Obstacle>;
		
		
		public function PathBoid(posX :Number, posY :Number, totalMass :Number)
		{
			
			position 	= new Vector3D(posX, posY);
			velocity 	= new Vector3D(-1, -2);
			desired	 	= new Vector3D(0, 0); 
			steering 	= new Vector3D(0, 0); 
			mass	 	= totalMass;
			path		= null;
			currentNode	= 0;
			
			maxVelocity = MAX_VELOCITY * (0.8 + Math.random() * 0.2);
			
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

		private function seek(target :Vector3D) :Vector3D {
			var force :Vector3D;
			
			desired = target.subtract(position);
			desired.normalize();
			desired.scaleBy(maxVelocity);
			
			force = desired.subtract(velocity);
			
			return force;
		}
		
		private function pathFollowing() :Vector3D {
			var target 	:Vector3D = null;
			
			if (path != null) {
				var nodes :Vector.<Vector3D> = path.getNodes();
				
				target = nodes[currentNode];
				
				if (distance(position, target) <= path.radius) {
					currentNode += 1;
					
					if (currentNode >= nodes.length) {
						currentNode = nodes.length - 1;
						dispatchEventWith(ARRIVED_EVENT,false,this);
						
					}
				}
			}
			
			return target != null ? seek(target) : new Vector3D();
		}
		
		private function distance(a :Object, b :Object) :Number {
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
		
		public function update():void {
			//steering = seek(Game.mouse);
			steering = pathFollowing();
			
			truncate(steering, MAX_FORCE);
			steering.scaleBy(1 / mass);
			
			velocity = velocity.add(steering);
			truncate(velocity, maxVelocity);
			
			position = position.add(velocity);
			
		}
		
		
		
	}
}