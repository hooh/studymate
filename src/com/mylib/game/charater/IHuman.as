package com.mylib.game.charater
{
	import com.mylib.game.charater.item.FeelingFrame;
	import com.mylib.game.charater.item.SpeakFrame;
	
	import starling.display.Button;

	public interface IHuman extends ICharater
	{
		//与状态无关
		function sit():void;
		function speak():void;
		function look(face:String):void;
		function say(frame:SpeakFrame):void;
		function feel(frame:FeelingFrame):void;
		function beatHead():void;
		
		function menu(btn:Vector.<Button>):void;
		
		//与状态有关
		
	}
}