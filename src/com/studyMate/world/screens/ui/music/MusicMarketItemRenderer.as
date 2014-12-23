package com.studyMate.world.screens.ui.music
{	
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.screens.MusicMarketMediator;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class MusicMarketItemRenderer extends FeathersControl implements IListItemRenderer
	{
		public function MusicMarketItemRenderer()
		{
			super();
			
		}
		
		protected var titleLabel:TextField;
		private var authorLabel:TextField;
		private var glodLabel:TextField;
		private var goldIcon:Image;
		private var buyBtn:Button;
		private var bg:Quad;
		
		private const defaultAlpha:Number=0.25;
		private const setAlpha:Number = 0.1;
		
		
		protected var _index:int = -1;
		
		public function get index():int
		{
			return this._index;
		}
		
		public function set index(value:int):void
		{
			if(this._index == value)
			{
				return;
			}
			this._index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _owner:List;
		
		public function get owner():List
		{
			return List(this._owner);
		}
		
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _data:Object;
		
		public function get data():Object
		{
			return this._data;
		}
		
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _isSelected:Boolean;
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			if(value){	
				
				this.bg.alpha=setAlpha;				
			}else{
				this.bg.alpha=defaultAlpha;		
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
		
		override protected function initialize():void
		{
			if(!this.titleLabel)
			{
				this.bg = new starling.display.Quad(880,56,0xFFFFFF);
				this.bg.alpha = defaultAlpha;
				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
				//this.bg.touchable=false;
				this.addChild(this.bg);
				this.titleLabel = new TextField(380,40,"","HeiTi",23,0xFFFFFF);
				this.titleLabel.hAlign = HAlign.LEFT;
				this.titleLabel.x = 60;
				this.titleLabel.y = 12;
				this.titleLabel.touchable = false;
				this.authorLabel = new TextField(162,40,"","HeiTi",23,0xFFFFFF);
				this.authorLabel.hAlign = HAlign.LEFT;
				this.authorLabel.autoScale = true;
				this.authorLabel.touchable = false;
				this.authorLabel.x = 440;
				this.authorLabel.y = 12;
				this.glodLabel = new TextField(80,40,"","HeiTi",23,0x333333);
				this.glodLabel.touchable = false;
				this.glodLabel.hAlign = HAlign.LEFT;
				this.glodLabel.x = 620;
				this.glodLabel.y = 12;
				this.glodLabel.height = 40;
				this.addChild(this.titleLabel);
				this.addChild(this.authorLabel);
				this.addChild(this.glodLabel);
				
				goldIcon = new Image( Assets.getMusicSeriesTexture("GlodIcon"));
				goldIcon.x = 668;
				goldIcon.y = 14;
				this.addChild(goldIcon);				
			}
		}
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this.bg);				
			if(touch && touch.phase == TouchPhase.ENDED){				
					isSelected = true;					
				
			}			
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			//const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			//var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			
			if(dataInvalid)
			{
				this.commitData();
			}

		}
		
		protected function autoSizeIfNeeded():Boolean
		{
			return false;
		}
		
		protected function commitData():void
		{
			if(this._data)
			{
				var markItemSpVO:MusicMarketItemVO = this._data as MusicMarketItemVO;
				this.titleLabel.text = markItemSpVO.goodsName;
				if(markItemSpVO.author==""){
					this.authorLabel.text = "佚名";
				}else{					
					this.authorLabel.text = markItemSpVO.author;
				}
				this.glodLabel.text = markItemSpVO.goodsCost;
				
				this.removeChild(this.buyBtn);
				if(markItemSpVO.hasBuy!="0"){
					this.buyBtn=new Button(Assets.getMusicSeriesTexture("yesBuyTxtIcon"));
					this.buyBtn.touchable = false;
					this.addChild(buyBtn);
				}else{
					this.buyBtn=new Button(Assets.getMusicSeriesTexture("buyBtn"));					
					this.addChild(this.buyBtn);
					this.buyBtn.addEventListener(Event.TRIGGERED,buyHandler);
					if(markItemSpVO.enable){
						this.buyBtn.enabled = true;
					}else{
						this.buyBtn.enabled = false;
					}
				}
				this.buyBtn.x = 790;
				this.buyBtn.y = 8;	
				
				if(!this._isSelected){					
					this.bg.alpha=defaultAlpha;
				}
			}
			else
			{
				this.titleLabel.text = "";
				this.authorLabel.text = "";
			}
		}
		
		
		private function buyHandler(event:Event):void{
			isSelected = true;
			Facade.getInstance(CoreConst.CORE).sendNotification(MusicMarketMediator.RECIVE_BUY_BUTTON,this._data);
		}

	}
}