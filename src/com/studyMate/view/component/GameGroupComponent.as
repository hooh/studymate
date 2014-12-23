package com.studyMate.view.component
{
	import flash.display.DisplayObject;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.core.SpriteVisualElement;

	public class GameGroupComponent extends Group
	{
		private var mySortGroup:MySortGroup;
		
		public function GameGroupComponent()
		{
			mySortGroup = new MySortGroup();
			//mySortGroup._addElement(img,this);
		}
		
		public function _addElement(img:DisplayObject):void{
			mySortGroup._addElement(img,this);
		}
	}
}