package com.mylib.api
{
	public interface IConfigProxy{
		function getValue(key:String):String;
		
		function updateValue(key:String, value:Object):void;
		
		function hasUser(user:String):Boolean;
		
		function addUser(user:String):void;
		
		function deleteUser(user:String):void;
		
		function getValueInUser(key:String):String;
		
		function updateValueInUser(key:String,value:Object):void;
		
		function getUserConfig(user:String):String;
		
		function updateUserConfig(user:String, value:String):void;
	}
}