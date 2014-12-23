package com.studyMate.view.component.myRadioButton
{
	internal interface IRadioButtonGroup
	{
		//订阅 
		function registerGoup(bo:MyRadioButton):void;
		//群组
		function set groupName(groupName:String):void;
	}
}