package com.studyMate.world.screens
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	
	public class OceanMapMediator extends ScreenBaseMediator
	{
		public static var NAME:String = "OceanMapMediator";
		
		private static var worldMediatorVO:SwitchScreenVO;
		
		public function OceanMapMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
			/*var w:WorldMediator = new WorldMediator(new World());
			facade.registerMediator(w);
			view.addChild(w.view);*/
			
//			c = new ChapterSeleterMediator(new ChapterSeleter);
//			facade.registerMediator(c);
			//c = new ChapterSeleter;
//			view.addChild(c.view);
			
//			sendNotification(WorldConst.INIT_TASKLIST);
			
			
			
			if(createCharaterOrNot())
				sendNotification(WorldConst.SHOW_PERSONALINFO,"true");
			else{
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WorldMediator,null,SwitchScreenType.SHOW,view)]);
				
				if(guideOrNot()){
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(GuideMediator,null,SwitchScreenType.SHOW,view)]);//暂时注释掉帮助
				}else{
					sendNotification(WorldConst.GUIDE_END);
					//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MonthTaskInfoMediator,null,SwitchScreenType.SHOW,view)]);
				}
			}
		}
		
		private function guideOrNot():Boolean{
			var configProxy:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var selfGuideVer:String = configProxy.getValueInUser("guideVersion");
			try{
				var airVersionFile:File = Global.document.resolvePath(Global.localPath+"Guide.ver");
				var stream:FileStream = new FileStream();
				stream.open(airVersionFile,FileMode.READ);
				var sysGuideVer:String = stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
			}catch(error:Error){
				return false;
			}
			if(sysGuideVer == selfGuideVer) return false;
			configProxy.updateValueInUser("guideVersion",sysGuideVer);
			return true;
		}
		private function createCharaterOrNot():Boolean{
			var configProxy:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var hasCreate:String = configProxy.getValueInUser("hasCreate");
			if(hasCreate)
				return false;
			else{
				configProxy.updateValueInUser("hasCreate","true");
				return true;
			}
			
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			sendNotification(WorldConst.HIDE_LEFT_MENU);
			super.onRemove();
			//facade.removeMediator(WorldMediator.NAME);
			//facade.removeMediator(ChapterSeleterMediator.NAME);
			view.removeChildren(0,-1,true);
			view.dispose();
			
			//facade.removeProxy(ActorRandomActionProxy.NAME);
			
			
		}
		
		override public function handleNotification(notification:INotification):void {
			switch(notification.getName()){
				case WorldConst.GUIDE_END : 
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WorldMediator,null,SwitchScreenType.SHOW,view)]);
					sendNotification(WorldConst.SWITCH_SCREEN, [new SwitchScreenVO(ChapterSeleterMediator,8,SwitchScreenType.SHOW,view)]);
					
					sendNotification(WorldConst.SHOW_MAIN_MENU);
					sendNotification(WorldConst.SHOW_LEFT_MENU);
					
					break;
			}
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function listNotificationInterests():Array{
			return [WorldConst.GUIDE_END];
		}
		
	}
}