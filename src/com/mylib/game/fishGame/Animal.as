package com.mylib.game.fishGame
{
	import com.mylib.game.fishGame.ai.IBoid;
	
	import flash.geom.Vector3D;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	public class Animal implements ILive
	{
		protected var _view:DisplayObject;
		protected var _boid:IBoid;
		
		public function Animal(_view:DisplayObject,_boid:IBoid)
		{
			this._view = _view;
			this._boid = _boid;
		}
		
		public function get view():DisplayObject
		{
			return _view;
		}
		
		public function set view(value:DisplayObject):void
		{
			_view = value;
		}
		
		public function get boid():IBoid
		{
			return _boid;
		}
		
		public function set boid(value:IBoid):void
		{
			_boid = value;
		}
		
		public function render():void
		{
			var position:Vector3D = _boid.position;
			
			view.x = position.x;
			view.y = position.y;
			
//			var degree:Number = (180 * boid.getAngle(boid.velocity)) / Math.PI;
			
			var angle:Number = boid.getAngle(boid.velocity);
			if(boid.velocity.x>0&&view.scaleX>0){
				view.scaleX = -1;
			}else if(boid.velocity.x<0){
				
				if(view.scaleX<0){
					view.scaleX = 1;
				}
				angle -=Math.PI;
			}
			
			view.rotation = angle;
			
			
		}
		
		
		
		public function start():void
		{
			if(!Starling.juggler.contains(this)){
				Starling.juggler.add(this);
			}
			
		}
		
		public function stop():void
		{
			if(Starling.juggler.contains(this)){
				Starling.juggler.remove(this);
			}
		}
		
		public function advanceTime(time:Number):void
		{
			_boid.update();
			render();
			
		}
		
	}
}