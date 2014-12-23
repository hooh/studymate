package com.studyMate.world.screens.chatroom
{
	import flash.utils.Dictionary;

	public class FilterTree
	{
		
		private var data:Dictionary;
		
		private var _isLeaf:Boolean;
		
		/**
		 *是否是敏感词的词尾字，敏感词树的叶子节点必然是词尾字，父节点不一定是
		 */
		public var isEnd:Boolean = false;
		
		public var parent:FilterTree;
		
		public var value:String;
		
		public function FilterTree()
		{
			data = new Dictionary;
		} //end of Function
		
		public function getChild(name:String):FilterTree
		{
			return data[name];
		} //end of Function
		
		public function addChild(char:String):FilterTree
		{
			var node:FilterTree = new FilterTree;
			data[char] = node;
			node.value = char;
			node.parent = this;
			return node;
		} //end of Function
		
		public function getFullWord():String
		{
			var rt:String = this.value;
			var node:FilterTree = this.parent;
			while (node)
			{
				rt = node.value + rt;
				node = node.parent;
			} //end while
			return rt;
		}//end of Function
		
		/**
		 *是否是叶子节点
		 */
		public function get isLeaf():Boolean
		{
			var index:int = 0;
			for (var key:String in data)
			{
				index++;
			}
			_isLeaf =index == 0 
			return _isLeaf;
		}
	}
}