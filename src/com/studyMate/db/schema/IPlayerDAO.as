package com.studyMate.db.schema
{
	public interface IPlayerDAO extends IDAO
	{
		function findPlayerByUsername(username:String):Player;
	}
}