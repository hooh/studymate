package com.studyMate.world.controller
{
	import com.mylib.api.IAssetLibProxy;
	import com.mylib.framework.model.AssetLibProxy;
	import com.studyMate.db.schema.AssetsLib;
	import com.studyMate.module.ModuleConst;
	
	import flash.display.Bitmap;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class RemoveGpuLibsCommand extends SimpleCommand implements ICommand
	{
		private var assetsProxy:IAssetLibProxy; 
		
		public function RemoveGpuLibsCommand()
		{
			super();
		}
		
		
		override public function execute(notification:INotification):void
		{
			//mediator id
			var mname:String = notification.getBody() as String;
			assetsProxy = facade.retrieveProxy(ModuleConst.ASSET_LIB_PROXY) as IAssetLibProxy;
			removeGpuViewLibs(mname);
		}
		
		public function removeGpuViewLibs(mname:String):void{
			var libs:Array;
			libs = assetsProxy.getLibByViewId(mname);
			
			if(libs){
				removeLibs(libs);
			}
		}
		
		public function removeLibs(libs:Array):void{
			
			var lib:AssetsLib;
			for (var i:int = 0; i < libs.length; i++) 
			{
				lib = libs[i];
				var idx:int = assetsProxy.newDomainLibs.indexOf(lib.path);
				
				if(idx>=0){
					assetsProxy.newDomainLibs.splice(idx,1);
					
					var assets:Object = Assets.store[lib.parameters];
					if(assets){
						
						if(assets is Bitmap){
							(assets as Bitmap).bitmapData.dispose();
						}
						
						delete Assets.store[lib.parameters];
						Assets.disposeTexture(lib.parameters);
					}
				}
				
				
			}
			
			
			
			
		}
		
	}
}