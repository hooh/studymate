package com.mylib.framework.controller
{
	import com.mylib.api.IAssetLibProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.db.schema.AssetsLib;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.ModuleUtils;
	import com.studyMate.world.screens.CleanCpuMediator;
	import com.studyMate.world.screens.CleanGpuMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SwitchModuleMediator extends Mediator
	{
		public static const NAME:String = "SwitchModuleMediator";
		private var switchingVOs:Array;
		
		
		public function SwitchModuleMediator()
		{
			super(NAME);
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CoreConst.SWITCH_MODULE:
				{
					sendNotification(WorldConst.SET_MODAL,true);
					if(switchingVOs){
						throw new IllegalOperationError("a module is loading, error");
						return;
					}
					
					switchingVOs = notification.getBody() as Array;
					
					
					var assetLibProxy:IAssetLibProxy = facade.retrieveProxy(ModuleConst.ASSET_LIB_PROXY) as IAssetLibProxy;
					
					
					var libs:Vector.<String> = new Vector.<String>;
					for (var j:int = 0; j < switchingVOs.length; j++) 
					{
						
						var assetlibs:Array = assetLibProxy.getLibByViewId((switchingVOs[j] as SwitchScreenVO).mediatorClass);
						
						
						if(assetlibs){
							for (var i:int = 0; i < assetlibs.length; i++) 
							{
								var item:AssetsLib = assetlibs[i];
								
								if(item.type=="module"){
									
									if(CONFIG::ARM){
										libs.push(Global.document.resolvePath(Global.localPath+"module/"+item.path).url);
									}else{
										libs.push(File.applicationDirectory.resolvePath(item.path).url);
									}
									
									
								}
							}
						}
					}
					
					sendNotification(CoreConst.LOAD_MODULES,libs);
					
					
					
					break;
				}
				case CoreConst.LOAD_MODULES_COMPLETE:{
					
					
					for (var k:int = 0; k < switchingVOs.length; k++) 
					{
						if(switchingVOs[k].mediatorClass is String){
							switchingVOs[k].mediatorClass = ModuleUtils.getModuleClass((switchingVOs[k] as SwitchScreenVO).mediatorClass);
						}
					}
					var t:Array = switchingVOs;
					switchingVOs = null;
					sendNotification(WorldConst.SET_MODAL,false);
					sendNotification(WorldConst.SWITCH_SCREEN,t);
					
					
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreConst.SWITCH_MODULE,CoreConst.LOAD_MODULES_COMPLETE];
		}
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		
	}
}