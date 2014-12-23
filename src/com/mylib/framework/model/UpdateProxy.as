package com.mylib.framework.model
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.DBTool;
	import com.studyMate.global.Global;
	import com.studyMate.global.OSType;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.UpdateListVO;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public final class UpdateProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "UpdateProxy";
		/**
		 *是否需要更新数据库 
		 */		
		public var isDBUpdate:Boolean;
		/**
		 *是否需要更新apk 
		 */		
		public var isAPKUpdate:Boolean;
		public var fileSets:Vector.<UpdateListItemVO>;
		
		public var completeNotice:String;
		public var completeNoticeParameters:Object;
		public var updateMode:Boolean;
		
		public function UpdateProxy(_updateMode:Boolean=false)
		{
			updateMode = _updateMode;
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			
			
			
			
		}
		
		
		public function updateAllAssets():void{
			/*isDBUpdate = false;
			isAPKUpdate = false;
			install = true;
			sendNotification(ApplicationFacade.LOADING_INIT_PROCESS);
			updateNext();*/
		}
		
		
		public function updateFileSet(arr:Vector.<UpdateListItemVO>):void{
			fileSets = arr;
			
			for each (var i:UpdateListItemVO in arr) 
			{
				if(i.type=="db"){
					var db:DataBaseProxy = DBTool.proxy;
					db.close();
				}
			}
			
			updateNext();
		}
		
		public function updateByVO(vo:UpdateListVO):void{
			updateFileSet(vo.list);
			
			
			
			
			
		}
		
		
		
		
		/*private function filterAssets(item:AssetsLib, index:int, array:Array):Boolean{
			
			if(item.type=="asset"){
				return true;
			}
			
			return false;
			
		}*/
		
		
		
		public function updateNext():void{
			
			var db:DataBaseProxy = DBTool.proxy;
			
			doUpdateNext();
		}
		
		private function doUpdateNext():void{
			var db:DataBaseProxy = DBTool.proxy;
			var lib:UpdateListItemVO = getOutDateAsset();
			
			
			if(lib){
				sendNotification(CoreConst.LOADING_INIT_PROCESS);
				sendNotification(CoreConst.REMOTE_FILE_LOAD,new RemoteFileLoadVO(lib.wfname,Global.localPath+lib.wfname,CoreConst.UPDATE_SINGLE_FILE_COMPLETE,lib,lib));
			}else{
				fileSets = null;
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;//队列下载完成最后再黑屏
				sendNotification(CoreConst.LOADING_CLOSE_PROCESS);
				sendNotification(CoreConst.DISABLE_CANCEL_DOWNLOAD);
				sendNotification(completeNotice,completeNoticeParameters);
				
			}
			
		}
		
		
		
		
		
		private function getOutDateAsset():UpdateListItemVO{
			
			var file:File;
			for each (var i:UpdateListItemVO in fileSets) 
			{
				if(i.isUpdate){
					continue;
				}
				
				if(updateMode){
					file = Global.document.resolvePath("tmpEDU/"+Global.localPath+i.wfname+"."+i.version+".tmp");
				}else{
					file = Global.document.resolvePath(Global.localPath+i.wfname);
				}
				//这里检查文件版本号
				/*if(!i.hasLoaded||(!file.exists&&!i.hasLoaded)){
					return i;	
				}*/
				
				if(!i.hasLoaded||!file.exists){
					
					//主程序文件本地和服务器存放路径不同 所以不判断其文件是否存在
					//@@win
					if(i.wfname==Global.appName&&Global.OS==OSType.ANDROID){
						
					}else if(i.wfname==Global.appName&&i.hasLoaded){
					
					}else{
						return i;	
					}
					
				}
				
			}
			return null;
			
		}
		
		
		
		
	}
}