package com.mylib.framework.model
{
	import com.mylib.api.IAssetLibProxy;
	import com.mylib.api.ICacheProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.global.Global;
	import com.studyMate.model.AssetsDomain;
	import com.studyMate.model.AssetsType;
	import com.studyMate.model.vo.FileVO;
	import com.studyMate.model.vo.IFileVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	

	
	public final class AssetLibProxy extends Proxy implements IProxy,IAssetLibProxy
	{
		private var _libs:Vector.<String>;
		
		private var _newDomainLibs:Vector.<String>;
		
		
		/**
		 *正在加载的素材库 
		 */		
		private var loadingAssets:Array;
		private var totalNum:uint;
		private var loadingIdx:uint;
		
		private var _completeNotice:String;
		private var _completeNoticePara:Object;
		
		
		
		override public function onRegister():void
		{
			
			libs = new Vector.<String>;
			newDomainLibs = new Vector.<String>;
			
		}
		
		
		
		public function AssetLibProxy(data:Object=null)
		{
			super(ModuleConst.ASSET_LIB_PROXY, data);
		}
		
		public function loadLib(fileVO:FileVO):void{
			
			
			
				var lib:IFileVO = loadingAssets[loadingIdx];
				if((libs.indexOf(lib.path)<0&&lib.domain==AssetsDomain.GLOBAL)||(newDomainLibs.indexOf(lib.path)<0&&lib.domain==AssetsDomain.CHILD)||lib.domain==""){
					
					
					sendNotification(CoreConst.FILE_LOAD,fileVO);
				}else{
					
					
					
					loadNextLib();
				}
			
			
		}
		
		
		private function fileLoadHandler():void{
			
			
			
		}
		
		
		
		public function loadLibByViewId(vid:String):void{
			
			if(AssetTool.assetsMap.containsKey(vid)){
				var arr:Array = AssetTool.assetsMap.find(vid) as Array;
				if(arr.length>0){
					loadLibs(arr);
					return;
				}
			}
			sendNotification(completeNotice,completeNoticePara);
		}
		
		public function getLibByViewId(vid:String):Array{
			
			if(AssetTool.assetsMap.containsKey(vid)){
				var arr:Array = AssetTool.assetsMap.find(vid) as Array;
				if(arr.length>0){
					return arr;
				}
			}
			
			return null;
		}
		
		
		public function loadLibs(_libs:Array):void{
			
			loadingAssets = _libs;
			totalNum = loadingAssets.length;
			loadingIdx = 0;
			
			startLoadLibs();
			
			
		}
		
		
		
		
		private function startLoadLibs():void{
			
			sendNotification(WorldConst.SET_MODAL,true,"a");
			var fileName:String = Global.localPath+(loadingAssets[loadingIdx] as IFileVO).path;
			var file:FileVO = new FileVO(fileName,fileName,CoreConst.ASSETS_SAVE,"byte",true,0,-1,(loadingAssets[loadingIdx] as IFileVO).type,(loadingAssets[loadingIdx] as IFileVO).domain);
			
			if(file.type==AssetsType.XML||file.type==AssetsType.ATF){
				file.isLib = false;
			}
			
			file.parameters = loadingAssets[loadingIdx];
			loadLib(file);
			
		}
		
		public function loadNextLib():void{
			if(loadingIdx>=totalNum){
				loadingAssets=null;
				sendNotification(completeNotice,completeNoticePara);
				return;
			}
			
			var lfile:IFileVO = loadingAssets[loadingIdx] as IFileVO;
			
			if(lfile.domain==AssetsDomain.GLOBAL&&libs.indexOf(lfile.path)<0){
				libs.push(lfile.path);
			}else if(lfile.domain==AssetsDomain.CHILD&&newDomainLibs.indexOf(lfile.path)<0){
				newDomainLibs.push(lfile.path);
			}
			
			
			loadingIdx++;
			
			
			//如果全部素材加载完毕 发出完成通知
			if(loadingIdx>=totalNum){
				loadingAssets=null;
				sendNotification(WorldConst.SET_MODAL,false,"a");
				sendNotification(completeNotice,completeNoticePara);
				//completeNoticePara=null;
				//completeNotice = "";
				//completeNoticePara = null;
			}else{
				//继续加载下一个库
				startLoadLibs();
			}
			
			
			
		}

		/**
		 *加载成功后的消息通知 
		 */
		public function get completeNotice():String
		{
			return _completeNotice;
		}

		/**
		 * @private
		 */
		public function set completeNotice(value:String):void
		{
			_completeNotice = value;
		}

		/**
		 *通知的参数 
		 */
		public function get completeNoticePara():Object
		{
			return _completeNoticePara;
		}

		/**
		 * @private
		 */
		public function set completeNoticePara(value:Object):void
		{
			_completeNoticePara = value;
		}

		public function get libs():Vector.<String>
		{
			return _libs;
		}

		public function set libs(value:Vector.<String>):void
		{
			_libs = value;
		}

		public function get newDomainLibs():Vector.<String>
		{
			return _newDomainLibs;
		}

		public function set newDomainLibs(value:Vector.<String>):void
		{
			_newDomainLibs = value;
		}
		
		
		
	}
}