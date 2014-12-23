package com.studyMate.model.vo
{
	public final class KnowledgeMapVO
	{
		
		/**
		 *类型 属于哪个科目 
		 */	
		public var type:String;
		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		public var process:uint;
		
		/**
		 * 
		 * @param _type 类型 属于哪个科目 
		 * @param _x
		 * @param _y
		 * @param _rotation 图片旋转的角度
		 * @param _process 进度
		 * 
		 */		
		public function KnowledgeMapVO(_type:String,_x:Number,_y:Number,_rotation:Number,_process:uint=0){
			
			type = _type;
			x = _x;
			y = _y;
			rotation = _rotation;
			process = _process;
			
		}
		
		
	}
}