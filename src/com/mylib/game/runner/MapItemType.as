package com.mylib.game.runner
{
	public class MapItemType
	{
		public static const BUCKET:uint = 1;
		public static const BUCKET2:uint = 2;
		public static const BUCKET3:uint = 3;
		public static const POOL:uint = 4;
		public static const DEAD_TREE:uint = 5;
		public static const DEAD_TREE2:uint = 6;
		public static const ROCK:uint = 7;
		
		public static const SPEEDUP:uint=50;
		public static const LEVEL:uint = 0;
		public static const ACCUP:uint = 60;
		public static const LEVEL_END:uint = 99;
		
		
		public static const items:Vector.<uint> = Vector.<uint>([BUCKET,BUCKET2,BUCKET3,POOL,DEAD_TREE,DEAD_TREE2,ROCK]); 
		
	}
}