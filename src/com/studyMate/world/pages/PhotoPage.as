package com.studyMate.world.pages
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.world.component.IFlipPageRenderer;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class PhotoPage extends Sprite implements IFlipPageRenderer
	{
		public var photo:Image;
		
		public function PhotoPage(p:Image)
		{
			photo = p;
			trace("PHOTOPAGE");
			super();
		}
		
		public function get view():DisplayObject
		{
			return this;
		}
		
		public function disposePage():void
		{
			removeChildren(0,-1,true);
		}
		
		public function displayPage():void
		{
			addChild(photo);
			photo.x =  -photo.width/2; photo.y = -photo.height/2;
//			flatten();
		}
	}
}