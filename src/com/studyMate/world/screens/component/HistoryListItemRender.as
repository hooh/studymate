package com.studyMate.world.screens.component
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.List;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class HistoryListItemRender extends BaseListItemRenderer
	{
		
		public function HistoryListItemRender()
		{
			
		}
		
		override protected function commitData():void
		{
			if(this.data){
				this.txtName.text = String(this.data);
			}
			this.height = this.bg.height;
		}
		
		private var bg:Quad;
		private var background:Quad;
		private var txtName:TextField;
		private var btn:starling.display.Button;
		private var textures:Vector.<Texture>;
		override protected function initialize():void
		{
			
			textures = new Vector.<Texture>;
			
			var texture:Texture = Texture.fromBitmap(Assets.store["historyList"],false);
			textures.push(texture);
			this.background = new Image(texture);
			this.background.height = 68;
			this.background.width = 260;
			this.addChild(this.background);
			
			this.bg = new starling.display.Quad(260,68,0xF6DB90);
			this.bg.name = "bg"
			this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
			this.addChild(this.bg);
				
			this.txtName = new TextField(150,60,'',"HeiTi",22,0x604747,false);
			this.txtName.x = 10;
//			this.txtName.y = -5;
			this.txtName.height = 60;
			this.txtName.hAlign = HAlign.LEFT;
			this.txtName.touchable = false;
			this.addChild(this.txtName);
				
			texture =  Texture.fromBitmap(Assets.store["delHistoryBtn"],false);
			textures.push(texture);
			this.btn = new starling.display.Button(texture)
			this.btn.x = 220;
			this.btn.y = 18;
			this.btn.scaleX = 1.2;
			this.btn.scaleY = 1.2;
			this.addChild(this.btn);
			this.btn.addEventListener(Event.TRIGGERED,deleteHistoryHandler);
		}
		
		private function deleteHistoryHandler():void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DELHISTORYLOGIN,String(_data));		
		}
		
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this.bg);				
			if(touch && touch.phase == TouchPhase.ENDED){		
				isSelected = true;					
				
			}			
		}
		
		override public function get data():Object
		{
			return super.data;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		override public function get index():int
		{
			return super.index;
		}
		
		override public function set index(value:int):void
		{
			super.index = value;
		}
		
		
		override public function get isSelected():Boolean
		{
			return super.isSelected;
		}
		
		
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			if(value){	
				this.bg.alpha=1;				
			}else{
				this.bg.alpha=0;		
			}
		}
		
		override public function get owner():List
		{
			return super.owner;
		}
		
		override public function set owner(value:List):void
		{
			super.owner = value;
		}
		
		override public function dispose():void{
			for each (var i:Texture in textures) 
			{
				i.dispose();
			}
		}
		
	}
}


