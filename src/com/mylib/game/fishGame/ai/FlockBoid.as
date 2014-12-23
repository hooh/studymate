package com.mylib.game.fishGame.ai
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	public class FlockBoid implements IBoid
	{
		private var _position 	:Vector3D;
		private var _velocity 	:Vector3D;
		private var _align:Point;
		private var _cohesion:Point;
		private var _separation:Point;
		private var _wall:Point;
		public var allBoids:Vector.<IBoid>;
		public var range:Rectangle;
		private var vp:Point;
		
		public var alignmentWeight:Number=0.4;
		public var cohesionWeigh:Number=0.4;
		public var separationWeight:Number=0.6;
		public var speed:Number = 4;
		
		public var separationDis:int = 200;
		
		
		
		public function FlockBoid(posX :Number, posY :Number,vx:Number,vy:Number,_range:Rectangle)
		{
			position 	= new Vector3D(posX, posY);
			velocity 	= new Vector3D(vx, vy);
			vp = new Point(vx, vy);;
			
			_align = new Point;
			_cohesion = new Point;
			_separation = new Point;
			_wall = new Point;
			range = _range;
		}
		
		public function update():void
		{
			compute();
			computeWallAvoidance();
			
			
			vp.x += _align.x * alignmentWeight + _cohesion.x * cohesionWeigh + _separation.x * separationWeight;
			vp.y += _align.y * alignmentWeight + _cohesion.y * cohesionWeigh + _separation.y * separationWeight;
			
			vp.x += _wall.x * 0.1;
			vp.y += _wall.y * 0.1;
			vp.normalize(speed);
			
			velocity.x = vp.x;
			velocity.y = vp.y;
			
			position.x +=velocity.x;
			position.y +=velocity.y;
			
		}
		
		
		public function compute():void 
		{
			var neighborCount:uint = 0;
			var agent:IBoid;
			
			_align.x = _align.y = 0;
			_cohesion.x = _cohesion.y = 0;
			_separation.x = _separation.y = 0;
			
			for(var i:int=0;i<allBoids.length;i++) 
			{
				agent = allBoids[i];
				if (agent != this)
				{
					if (distance(agent.position,this.position) < separationDis)
					{
						_align.x += agent.velocity.x;
						_align.y += agent.velocity.y;
						
						_cohesion.x += agent.position.x;
						_cohesion.y += agent.position.y;
						
						_separation.x += agent.position.x - position.x;
						_separation.y += agent.position.y - position.y
						
						neighborCount++;
					}
					
				}
				
			}
			if (neighborCount == 0)
				return;
			
			_align.x /= neighborCount;
			_align.y /= neighborCount;
			_align.normalize(1);
			
			_cohesion.x /= neighborCount;
			_cohesion.y /= neighborCount;
			_cohesion.setTo(_cohesion.x-position.x,_cohesion.y-position.y);
			_cohesion.normalize(1);
			
			_separation.x /= neighborCount;
			_separation.y /= neighborCount;
			_separation.x *= -1;
			_separation.y *= -1;
			_separation.normalize(1);
			
		}
		
		public function computeWallAvoidance():void 
		{
			_wall.x = _wall.y = 0;
			if (position.x < range.left)
			{
				_wall.x = 10;
			}else if (position.x > range.right)
			{
				_wall.x = -10;
			}
			if (position.y < range.top)
			{
				_wall.y = 10;
			}else if (position.y > range.bottom-50)
			{
				_wall.y = -10;
			}
		}
		
		
		
		private function distance(a:Vector3D, b :Vector3D) :Number {
			return Math.sqrt((a.x - b.x) * (a.x - b.x)  + (a.y - b.y) * (a.y - b.y));
		}
		
		
		public function get position():Vector3D
		{
			return _position;
		}
		
		public function set position(value:Vector3D):void
		{
			_position = value;
		}
		
		public function getAngle(vector:Vector3D):Number
		{
			return Math.atan2(vector.y, vector.x);
		}
		
		public function get velocity():Vector3D
		{
			return _velocity;
		}
		
		public function set velocity(value:Vector3D):void
		{
			_velocity = value;
		}
	}
}