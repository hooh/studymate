package com.studyMate.model.vo
{
	import com.studyMate.world.component.IFlipPageRenderer;

	public class FlipPageData
	{
		
		public var pages:Vector.<IFlipPageRenderer>;
		
		
		public function FlipPageData(pages:Vector.<IFlipPageRenderer>)
		{
			this.pages = pages;
		}
	}
}