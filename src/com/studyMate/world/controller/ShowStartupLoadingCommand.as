package com.studyMate.world.controller
{
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	
	import flash.display.MovieClip;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ShowStartupLoadingCommand extends SimpleCommand
	{
		public static var loading:MovieClip;
		
		
		override public function execute(notification:INotification):void
		{
			
			if(!loading&&AssetTool.hasLibClass("com.ui.startupLoading")){
				var c:Class = AssetTool.getCurrentLibClass("com.ui.startupLoading");
				loading = new c;
				loading.x = 700;
				loading.y = 220;
//				loading.x = 200
//				loading.y = 220;
			}
			
			if(loading){
				loading.play();
				loading.scaleX = Global.widthScale;
				loading.scaleY = Global.heightScale;
				Global.stage.addChild(loading);
				
			}
			
			
			
			
			
			
		}
		
	}
}