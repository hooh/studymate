package com.studyMate.model.vo
{
	import flash.display.DisplayObjectContainer;

	public class DictionaryVO
	{
		public var word:String;
		public var holder:DisplayObjectContainer;
		public function DictionaryVO(_word:String,_holder:DisplayObjectContainer)
		{
			this.word = _word;
			this.holder = _holder;
		}
	}
}