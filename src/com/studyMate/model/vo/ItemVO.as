package com.studyMate.model.vo
{
	public class ItemVO
	{
		
		/**
		 *序号 
		 */
		public var id:uint=0;
		/**
		 *是否做过 
		 */
		public var isCheck:Boolean = false;
		/**
		 *做对则算完成，否则算没完成 
		 */
		public var isComplete:Boolean = false;
		/**
		 *用户输入答案 
		 */
		public var userAnswer:String="";
		/**
		 *标准答案 
		 */
		public var standardAnswer:String="";
		/**
		 *对则R，错则E  
		 */
		public var ROE:String;
		
		/**
		 *答案和理由的答对情况[true,false],[true,true],[false,true],[false,false] 
		 */
		public var ANR:Array;
		
		/**
		 *是不是一个单词 （单词界面使用，有时会收到LEA01非单词类型）
		 */
		public var isWord:Boolean;
		
		public var wordId:String;
		
		public function ItemVO(_id:uint)
		{
			this.id = _id;
		}
	}
}