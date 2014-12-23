package com.mylib.framework.controller
{
	import com.edu.EduAllExtension;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	
	public class StartupAppCommand extends SimpleCommand
	{
		public function StartupAppCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
				Global.initialized = true;
				
				
				var particles:XML = Assets.store["particles"];
				
				for (var i:int = 0; i < particles.children().length(); i++) 
				{
					Assets.store[String(particles.children()[i].@name)]=particles.children()[i];
				}
				
				
				if(TextField.getBitmapFont("mycomic")){
					TextField.unregisterBitmapFont("mycomic");
				}
				if(TextField.getBitmapFont("HK")){
					TextField.unregisterBitmapFont("HK");
				}
				if(TextField.getBitmapFont("HeiBMP")){
					TextField.unregisterBitmapFont("HeiBMP");
				}
				var bmf:BitmapFont = new BitmapFont(Assets.getAtlasTexture("MyComic_0"),Assets.store["MyComic"]);
				TextField.registerBitmapFont(bmf,"mycomic");
				
				var bmpfont:BitmapFont = new BitmapFont(Assets.getAtlas().getTexture("HuaKanBF_0"),Assets.store["HuaKanBF"]);
				TextField.registerBitmapFont(bmpfont,"HK");
				
				bmpfont = new BitmapFont(Assets.getAtlas().getTexture("hei_0"),Assets.store["hei"]);
				TextField.registerBitmapFont(bmpfont,"HeiBMP");
				
				facade.sendNotification(WorldConst.CREATE_CHARATER_TEXTURE);
				facade.sendNotification(WorldConst.SWITCH_FIRST_SCREEN);
			
				//唤醒eduserver，执行command.dat
				EduAllExtension.getInstance().launchAppExtension("com.eduonline.service","");
			
		}
		
	}
}