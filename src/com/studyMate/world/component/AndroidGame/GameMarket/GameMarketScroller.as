package com.studyMate.world.component.AndroidGame.GameMarket
{
	import com.greensock.loading.display.ContentDisplay;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.FlipPageData;
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.component.AndroidGame.AndroidGameVO;
	import com.studyMate.world.component.AndroidGame.BusyHolder;
	import com.studyMate.world.component.AndroidGame.ImageListLoader;
	import com.studyMate.world.component.AndroidGame.ImglistLoadEvent;
	import com.studyMate.world.component.AndroidGame.MyGameItem;
	import com.studyMate.world.screens.FlipPageMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameMarketScroller extends Sprite
	{
		private var imglistloader:ImageListLoader;
		private var list:Vector.<AndroidGameVO>;
		
		
		private var itemList:Vector.<AndroidGameVO> = new Vector.<AndroidGameVO>;
		private var pages:Vector.<IFlipPageRenderer>;
		
		public var currentDownItem:MyGameItem;
		
		public function GameMarketScroller(_list:Vector.<AndroidGameVO>,_holder:Sprite)
		{
			list = _list;
			
			/*this.clipRect = new Rectangle(100,50,1080,620);*/
			
			addEventListener(Event.ADDED_TO_STAGE, showBusy);
		}
		
		private var busyHolder:BusyHolder;
		private function showBusy():void{
			
			if(list.length > 0){
				
				busyHolder = new BusyHolder();
				parent.parent.parent.addChild(busyHolder);
				
				
				var totalPage:int = list.length/25+1;
				if(list.length%25 == 0)
					totalPage--;
				
				pages = new Vector.<IFlipPageRenderer>(totalPage);
				for(var i:int=0;i<totalPage;i++)
					pages[i]=new GameMarketPage();
				
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(FlipPageMediator,new FlipPageData(pages),SwitchScreenType.SHOW,this)]);
				
				
				imglistloader = new ImageListLoader(list);
				imglistloader.addEventListener(ImglistLoadEvent.CHILDCOMPLETE,childComplete);
				imglistloader.addEventListener(ImglistLoadEvent.ONPROCESS,onProcess);
				
			}
			
		}
		
		
		
		
		private function onProcess(e:ImglistLoadEvent):void{
			
			if(busyHolder){
				
				busyHolder.updateProBar(e.target.progress);
				
				//加载完成
				if(e.target.progress == 1){
					busyHolder.removeFromParent(true);
				}
			}
			
		}
		
		private var itemIdx:int=0;
		private function childComplete(e:ImglistLoadEvent):void{
			if(e.target.content && e.target.vars){
				
				var loadedImage:ContentDisplay = e.target.content;
				
				var gameVo:AndroidGameVO = new AndroidGameVO;
				
				gameVo = e.target.vars.gamevo as AndroidGameVO;
				gameVo.bitmap = loadedImage.rawContent as Bitmap;
				
				itemList.push(gameVo);
				
				
				var idx:int = int(itemIdx/25);
				itemIdx++;
				
				if(idx > 1)
					(pages[idx] as GameMarketPage).addItem(gameVo, false);
				else
					(pages[idx] as GameMarketPage).addItem(gameVo);
				
				
			}else{
				
				trace("加入失败："+e.text);
				
			}
		}
		

		public function start():void{
			
			
			
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, showBusy);
			
			if(imglistloader){
				imglistloader.removeEventListener(ImglistLoadEvent.CHILDCOMPLETE,childComplete);
				imglistloader.removeEventListener(ImglistLoadEvent.ONPROCESS,onProcess);
				imglistloader.dispose();
			}
			
			
			
			
		}
	}
}