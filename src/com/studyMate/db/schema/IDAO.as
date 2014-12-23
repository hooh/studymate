package com.studyMate.db.schema
{
	public interface IDAO
	{
		
		function findAll():Array;
		
		function insert(_data:Object):void;
		
		function update(_data:Object):void;
		
		function deleteItem(_data:Object):void;
	}
}