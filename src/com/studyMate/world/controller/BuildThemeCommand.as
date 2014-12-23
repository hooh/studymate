package com.studyMate.world.controller
{
	import com.studyMate.global.UITheme;
	
	import flash.display.Bitmap;
	
	import feathers.themes.MetalWorksMobileTheme;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import starling.core.Starling;
	
	public class BuildThemeCommand extends SimpleCommand
	{
		
		public function BuildThemeCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			try
			{
				if(UITheme.theme){
					UITheme.theme.dispose();
				}
				
				
				if(!Assets.recoverThemeBMPD){
					Assets.recoverThemeBMPD = (Assets.store["metalworks"] as Bitmap).bitmapData.clone();
				}
				
				if(!Assets.recoverThemeXML){
					Assets.recoverThemeXML = Assets.store["metalworksXML"];
				}
				
				if(!Assets.store["metalworks"]){
					Assets.store["metalworks"]=new Bitmap(Assets.recoverThemeBMPD.clone());
				}
				
				if(!Assets.store["metalworksXML"]){
					Assets.store["metalworksXML"]=Assets.recoverThemeXML;
				}
				
				
				MetalWorksMobileTheme.ATLAS_IMAGE = Assets.store["metalworks"];
				MetalWorksMobileTheme.ATLAS_XML = Assets.store["metalworksXML"];
				UITheme.theme = new MetalWorksMobileTheme(Starling.current.stage);
				
				
			} 
			catch(error:Error) 
			{
				trace("BuildThemeCommand Error!");
			}
			
		}
		
	}
}