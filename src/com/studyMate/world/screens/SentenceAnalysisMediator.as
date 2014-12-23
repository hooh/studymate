package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.component.drawGetWord.BaseAnalysisUI;
	import com.studyMate.world.screens.component.drawGetWord.BottomUI;
	
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;


	public class SentenceAnalysisMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SentenceAnalysisMediator";
		
		private var prepareVO:SwitchScreenVO;
		private var screenHolder:Sprite;
		private var bottomUI:BottomUI;
		private var screenArr:Array=[];
		
		public function SentenceAnalysisMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void{	
			screenHolder = new Sprite();
			view.addChild(screenHolder);
			
			bottomUI = new BottomUI(1);
			bottomUI.addEventListener(DataEvent.DATA,selectPageHandler);
			view.addChild(bottomUI);
			
			var baseUI:BaseAnalysisUI = new BaseAnalysisUI();
			screenHolder.addChild(baseUI);			
			baseUI.addEventListener(DataEvent.DATA,testhandler);			
			
			screenArr.push(screenHolder);
		}
		
		private function testhandler(e:DataEvent):void{
			var sp:BaseAnalysisUI = e.currentTarget as BaseAnalysisUI;
			var index:int = sp.parent.getChildIndex(sp);
			index++;
			if(screenArr[index]==null){
				var baseUI:BaseAnalysisUI = new BaseAnalysisUI(e.data);
				screenHolder.addChild(baseUI);	
				baseUI.x = index*1280;
				screenArr.push(screenHolder);
				bottomUI.addPage();
				baseUI.addEventListener(DataEvent.DATA,testhandler);
			}
			
			TweenLite.to(screenHolder,1,{x:-(index)*1280});
			bottomUI.currentPage = index;
			trace(sp.parent.getChildIndex(sp));
			trace("接收 : "+e.data.toString());
		}
		
		private function selectPageHandler(e:DataEvent):void{
			TweenLite.killTweensOf(screenHolder);
			TweenLite.to(screenHolder,1,{x:-int(e.data)*1280});
		}
		
		
		
		override public function onRemove():void{		
			super.onRemove();
		}
		
		
		
		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;			
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);															
		}
	}
}