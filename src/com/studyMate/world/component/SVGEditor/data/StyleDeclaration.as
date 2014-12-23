package com.studyMate.world.component.SVGEditor.data
{
	internal class StyleDeclaration
	{
		public var _attributes:Object = {};
		
		public function StyleDeclaration()
		{
			
		}
		
		public function getAttribute(name:String):Object {
			return _attributes[name];
		}
		/**
		 * 设置属性
		 * @param name 属性名
		 * @param value 属性值
		 * 
		 */		
		public function setAttribute(name:String, value:Object):void {
			if(value==null) return;
			if(_attributes[name] != value){				
				_attributes[name] = value;
				
			}
		}
		
		/**
		 * 移除属性 
		 * @param name
		 * 
		 */		
		public function removeAttribute(name:String):void {
			delete _attributes[name];
		}
		
		/**
		 * 是否有属性 
		 * @param name
		 * @return 
		 * 
		 */		
		public function hasAttribute(name:String):Boolean {
			return name in _attributes;
		}
		
		/**
		 * 获取所有属性
		 */
		public function getAllAttribute():Vector.<String>{
			var keyStr:Vector.<String> = new Vector.<String>;
			for (var key:String in _attributes){
				keyStr.push(key);
			}
			return keyStr;
		}
	}
}