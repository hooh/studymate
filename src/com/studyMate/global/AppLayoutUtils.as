package com.studyMate.global
{
	import com.mylib.api.IMainView;
	
	import flash.display.Sprite;
	
	import starling.display.Sprite;

	public class AppLayoutUtils
	{
		public static var root:IMainView;
		
		public static function get cpuLayer():flash.display.Sprite{
			return root.cpuLayer;
		}
		public static function get gpuLayer():starling.display.Sprite{
			return root.gpuLayer;
		}
		
		public static function get uiLayer():starling.display.Sprite{
			return root.uiLayer;
		}
		
		public static function get gpuPopUpLayer():starling.display.Sprite{
			return root.gpuPopUpLayer;
		}
		
		
		
	}
}