package com.mylib.game.fishGame
{
	public class Circle extends Obstacle
	{
		public var radius :Number;
		public function Circle(posX :Number, posY :Number, r :Number)
		{
			super(x, y);
			radius = r;
			x = posX;
			y = posY;
			
			center.x = x;
			center.y = y;
			
		}
	}
}