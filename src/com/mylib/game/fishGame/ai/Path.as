package com.mylib.game.fishGame.ai
{
	import flash.geom.Vector3D;

	public class Path
	{
		public var nodes :Vector.<Vector3D>;
		public var radius :Number
		
		public function Path(radius :Number) {
			this.nodes 	= new Vector.<Vector3D>();
			this.radius = radius;
		}
		
		public function addNode(node :Vector3D) :void {
			nodes.push(node);
		}
		
		public function getNodes() :Vector.<Vector3D> {
			return nodes;
		}
	}
}