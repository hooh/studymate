package com.studyMate.world.screens.component.drawGetWord
{
	import fl.controls.Button;
	
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class BottomUI extends Sprite
	{
		private var preBtn:Button;
		private var nextBtn:Button;
		private var selectHolder:Sprite;
		
		private var bar1:Bars1;
		
		private var gap:int=70;//间距
		private var totalPage:int;
		private var _currentPage:int=0;
		
		private var loader:Loader;
		private var title:String;
		
		public function BottomUI(num:int,title1:String="hello")
		{
			
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			
			preBtn = new Button();
			preBtn.label = "上一页";
			this.addChild(preBtn);
			nextBtn = new Button();
			nextBtn.label = "下一页";
			nextBtn.x = 1200;
			this.addChild(nextBtn);
			selectHolder = new Sprite();
			selectHolder.x = 500;
			this.addChild(selectHolder);
			
			preBtn.addEventListener(MouseEvent.CLICK,preHandler);
			nextBtn.addEventListener(MouseEvent.CLICK,nextHandler);
			selectHolder.addEventListener(MouseEvent.CLICK,selectHandler);	
			
			page(num);
			title = title1;
			
		}
		
		public function page(num:int):void{
			totalPage = num;
			for(var i:int = 0;i<totalPage;i++){
				var bar:Bars = new Bars();
				bar.x = i*gap;
				bar.name = String(i);
				selectHolder.addChild(bar);
			}
			bar1 = new Bars1();
			bar1.mouseEnabled = false;
			bar1.mouseEnabled = false;
			selectHolder.addChild(bar1);
			selectHolder.x = 640-(selectHolder.width>>1);
		}
		
		public function addPage():void{
			totalPage++;
			while(selectHolder.numChildren){
				selectHolder.removeChildAt(0);
			}
			for(var i:int = 0;i<totalPage;i++){
				var bar:Bars = new Bars();
				bar.x = i*gap;
				bar.name = String(i);
				selectHolder.addChild(bar);
			}
			bar1 = new Bars1();
			bar1.mouseEnabled = false;
			bar1.mouseEnabled = false;
			bar1.x = (i-1)*gap;
			selectHolder.addChild(bar1);
			selectHolder.x = 640-(selectHolder.width>>1);
			
			_currentPage = totalPage-1;
		}
		
		private function nextHandler(event:MouseEvent):void{
			if(_currentPage<totalPage-1){
				_currentPage++;
				bar1.x = _currentPage*gap;
				
				sendInfo();
			}
			
		}
		
		private function preHandler(event:MouseEvent):void{
			if(_currentPage>0){
				_currentPage--;
				bar1.x = _currentPage*gap;
				
				sendInfo();
			}
			
		}
		
		private function selectHandler(event:MouseEvent):void{
			var i:int = int(event.target.name);
			if(_currentPage != i){
				_currentPage = i;
				bar1.x = _currentPage*gap;;
				
				sendInfo();
				
			}
			
		}
		
		private function sendInfo():void{			
			this.dispatchEvent(new DataEvent(DataEvent.DATA,false,false,String(_currentPage)));
			/*if(title==null) return;
			if(loader){
				
			}else{
				loader = new Loader();
				stage.addChildAt(loader,0);
			}
			loader.unload();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			loader.load(new URLRequest("Picture/"+title+"/img"+currentPage+".png"));*/
			
			
			
		}
		protected function completeHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			trace("奇怪");
			loader.x = 640-(loader.width>>1);
			loader.y = 384-(loader.height>>1);
		}
		
		private function addToStageHandler(event:Event):void
		{
			this.x = 0;
			this.y = 716;
			sendInfo();
		}

		public function get currentPage():int
		{
			return _currentPage;
		}

		public function set currentPage(value:int):void
		{
			_currentPage = value;
			bar1.x = _currentPage*gap;
		}
		
		
	}
}
import flash.display.Sprite;

class Bars extends Sprite{
	public function Bars(){
		this.graphics.beginFill(0x345214);
		this.graphics.drawCircle(0,0,30);
		this.graphics.endFill();
	}	
}
class Bars1 extends Sprite{
	public function Bars1(){
		this.graphics.beginFill(0);
		this.graphics.drawCircle(0,0,30);
		this.graphics.endFill();
	}	
}