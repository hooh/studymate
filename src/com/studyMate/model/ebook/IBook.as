package com.studyMate.model.ebook
{
	import flash.display.DisplayObject;

	public interface IBook
	{
		function getPage(pageIdx:int,type:String):DisplayObject;
		
		
		
	}
}