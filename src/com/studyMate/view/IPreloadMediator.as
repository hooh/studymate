package com.studyMate.view
{
	import com.studyMate.model.vo.PushViewVO;

	public interface IPreloadMediator
	{
		function prepare(vo:PushViewVO):void;
	}
}