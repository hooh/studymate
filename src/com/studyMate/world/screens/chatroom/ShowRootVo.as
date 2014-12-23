package com.studyMate.world.screens.chatroom
{
	public class ShowRootVo
	{
		public var showItem:PersonListRootItem;
		public var showIdx:int;
		public var showLen:int;
		
		public function ShowRootVo( _showItem:PersonListRootItem, _showIdx:int=0, _showLen:int=0 )
		{
			showItem = _showItem;
			showIdx = _showIdx;
			showLen = _showLen;
			
		}
	}
}