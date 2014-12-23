package com.studyMate.world.component.AndroidGame
{
	import com.greensock.loading.display.ContentDisplay;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.FlipPageData;
	import com.studyMate.world.component.IFlipPageRenderer;
	import com.studyMate.world.component.AndroidGame.GameMarket.GameMarketPage;
	import com.studyMate.world.screens.FlipPageMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MyGameScroller extends Sprite
	{
		
		private var imglistloader:ImageListLoader;
		private var list:Vector.<AndroidGameVO>;
		
		
		private var itemList:Vector.<AndroidGameVO> = new Vector.<AndroidGameVO>;
		private var pages:Vector.<IFlipPageRenderer>;
		
		public var currentDownItem:MyGameItem;
		
		public function MyGameScroller(_list:Vector.<AndroidGameVO>,_holder:Sprite)
		{
			list = _list;

			
			/*for(var i:int=0;i<50;i++){
				list.push(list[0]);
				
			}*/
			
			addEventListener(Event.ADDED_TO_STAGE, showBusy);
			
		}
		private var busyHolder:BusyHolder;
		private function showBusy():void{
			removeEventListener(Event.ADDED_TO_STAGE, showBusy);
			
			if(list.length > 0){
				
				busyHolder = new BusyHolder();
				parent.addChild(busyHolder);
				
				
				var totalPage:int = list.length/21+1;
				if(list.length%21 == 0)
					totalPage--;
				
				pages = new Vector.<IFlipPageRenderer>(totalPage);
				for(var i:int=0;i<totalPage;i++)
					pages[i]=new MyGamePage();
				
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
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.ANDROIDGAME_ICON_LOADED);
					
					trace("@VIEW:AndroidGameShowMediator:");
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
				
				
				var idx:int = int(itemIdx/21);
				itemIdx++;
				
				if(idx > 1)
					(pages[idx] as MyGamePage).addItem(gameVo,false);
				else
					(pages[idx] as MyGamePage).addItem(gameVo);
				
			}else{
				
//				trace("加入失败："+idx + "因为："+e.text);
				
			}
		}
		
		
		//显示删除按钮
		public function displayDelBtn(_isshow:Boolean):void{
			if(pages){
				
				for(var i:int=0;i<pages.length;i++){
					
					
					(pages[i] as MyGamePage).showDel(_isshow);
					
					
					
				}
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