package com.studyMate.world.screens.ui
{
	import starling.textures.Texture;

	public class MenuButtonVO
	{
		public var id:String;
		public var texture:Texture;
		public var panel:Class;
		public var clickFunction:Function;
		
		public function MenuButtonVO(id:String,texture:Texture,panel:Class=null,clickFunction:Function=null)
		{
			this.id = id;
			this.texture = texture;
			this.panel = panel;
			this.clickFunction = clickFunction;
		}
	}
}