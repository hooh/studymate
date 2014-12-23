package com.studyMate.world.screens.chatroom
{
	import com.studyMate.world.screens.component.PullToRefreshList;
	
	public class PersonList extends PullToRefreshList
	{
		
		/**
		 * 管理联系人目录展开的item 
		 */		
		public var showlist:Vector.<ShowRootVo> = new Vector.<ShowRootVo>;
		
		
		public function PersonList()
		{
			super();
		}
	}
}