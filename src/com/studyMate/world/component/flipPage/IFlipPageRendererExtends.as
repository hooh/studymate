package com.studyMate.world.component.flipPage
{
	import com.studyMate.world.component.IFlipPageRenderer;
	
	public interface IFlipPageRendererExtends extends IFlipPageRenderer
	{
		function startLoad():void;
		function clearLoad():void;
	}
}