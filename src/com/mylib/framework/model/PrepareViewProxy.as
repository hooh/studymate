package com.mylib.framework.model
{
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.view.ViewPrepareMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class PrepareViewProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "PrepareViewProxy";
		private var _views:Vector.<SwitchScreenVO>;
		private var prepareView:ViewPrepareMediator;
		public var currentIdx:int;
		
		public var isCaching:Boolean;
		
		
		public function PrepareViewProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		override public function onRegister():void
		{
			
			
		}
		
		
		public function set views(_v:Vector.<SwitchScreenVO>):void{
			_views = _v;
			currentIdx = 0;
		}
		
		public function get views():Vector.<SwitchScreenVO>{
			return _views;
		}
		
		
		
		public function doPrepare():void{
			trace("doPrepare");
			
			facade.removeMediator(ViewPrepareMediator.NAME);
			if(_views.length>currentIdx){
				var vo:SwitchScreenVO = _views[currentIdx];
				
				var mediator:ScreenBaseMediator = new vo.mediatorClass(vo.mediatorName);
				
				prepareView = new ViewPrepareMediator(mediator as Mediator);
				facade.registerMediator(prepareView);
				
				
				prepareView.sourceViewMediator = mediator as Mediator;
				
				currentIdx++;
				vo.mediator = mediator;
				mediator.prepare(vo);
				
			}else{
				//所有视图数据准备完毕
				currentIdx = 0;
				
//				doAssetsLoad();
				
				sendNotification(WorldConst.SCREEN_PREPARE_DATA_COMPLETE,_views);
				
				
			}
		}
		
		public function doAssetsLoad():void{
//			Starling.current.stop(true);
			if(_views.length>currentIdx){
				var vo:SwitchScreenVO = _views[currentIdx];
				var assetsProxy:AssetLibProxy = facade.retrieveProxy(ModuleConst.ASSET_LIB_PROXY) as AssetLibProxy;
				assetsProxy.completeNotice = WorldConst.SCREEN_ASSETS_LOADED;
				assetsProxy.completeNoticePara = vo;
				currentIdx++;
				assetsProxy.loadLibByViewId(vo.mediator.getMediatorName());
			}else{
				//assets ready
				var tempViews:Vector.<SwitchScreenVO> = _views;
				_views = null;
				sendNotification(WorldConst.SCREEN_PREPARE_COMPLETE,tempViews);
			}
			
			
		
		}
		
		
		
		
	}
}