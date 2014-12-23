package com.studyMate.world.screens.ui.music
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.ExchangeMusicMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	
	import feathers.controls.Check;
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
	
	public class ExchangeItemRenderer extends FeathersControl implements IListItemRenderer
	{
		public function ExchangeItemRenderer()
		{
			super();
		}
		private var checkButton:Check;
		protected var titleLabel:TextField;
		private var authorLabel:TextField;
		private var sizeLabel:TextField;
		private var timeLabel:TextField;
		private var goldIcon:Image;
		private var buyBtn:Button;
		private var bg:Quad;
		
		private const defaultAlpha:Number=0.45;
		private const setAlpha:Number = 1;
		
		private var canPlayBoo:Boolean;
		private var mouseDownX:Number;
		private var mouseDownY:Number;
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
				
				this.bg = new starling.display.Quad(852,50,0x0a4475);
				this.bg.alpha = defaultAlpha;							
				//this.bg.touchable=false;
				this.addChild(this.bg);
				
				checkButton = new Check();
				checkButton.x = 15;
				checkButton.y = 15;
				checkButton.visible = false;
				this.addChild(checkButton);
				
				this.titleLabel = new TextField(240,48,"","HeiTi",16,0xFFFFFF);
				this.titleLabel.hAlign = HAlign.LEFT;
				this.titleLabel.autoScale = true;
				this.titleLabel.x = 66;
				//this.titleLabel.y = 12;
				this.titleLabel.touchable = false;
				
				this.authorLabel = new TextField(160,48,"","HeiTi",16,0xFFFFFF);
				this.authorLabel.hAlign = HAlign.LEFT;
				this.authorLabel.autoScale = true;
				this.authorLabel.touchable = false;
				this.authorLabel.x = 306;
				//this.authorLabel.y = 12;
				
				this.sizeLabel = new TextField(80,48,"","HeiTi",16,0xFFFFFF);
				this.sizeLabel.touchable = false;
				this.sizeLabel.hAlign = HAlign.LEFT;
				this.sizeLabel.x = 470;
				//this.sizeLabel.y = 12;
				
				this.timeLabel = new TextField(80,48,"","HeiTi",16,0xFFFFFF);
				this.timeLabel.touchable = false;
				this.timeLabel.hAlign = HAlign.LEFT;
				this.timeLabel.x = 590;
				
				this.addChild(this.titleLabel);
				this.addChild(this.authorLabel);
				this.addChild(this.sizeLabel);
				this.addChild(this.timeLabel);
				
			}
		}
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);	
			var pos:Point;
			if(touch && touch.phase == TouchPhase.BEGAN){
				pos = touch.getLocation(this);   
				mouseDownX = pos.x;
				mouseDownY = pos.y;
				canPlayBoo = true;
			}else if(touch && touch.phase == TouchPhase.MOVED){
				pos = touch.getLocation(this);  
				if(Math.abs(pos.x-mouseDownX)>10 || Math.abs(pos.y-mouseDownY)>10  ){
					canPlayBoo = false;
				}
			}else if(touch && touch.phase == TouchPhase.ENDED){
				var baseClass:MusicBaseClass = this._data as MusicBaseClass;
				if(canPlayBoo ){					
					isSelected = true;
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AlertMusicTypeMediator,this._data,SwitchScreenType.SHOW)]);
				}

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
				var changeItemVO:ExchangeItemVO = this._data as ExchangeItemVO;
				this.titleLabel.text = changeItemVO.Name;
				this.authorLabel.text = changeItemVO.authorStr;
				this.sizeLabel.text = String(int(changeItemVO.size)>>10)+"kb";
				this.timeLabel.text = changeItemVO.totalTime;
//				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
				
				if(ExchangeMusicMediator.isEdit){
					checkButton.visible = true;										
					checkButton.addEventListener( Event.CHANGE, check_changeHandler );
				}else{
					checkButton.visible = false;
				}
				if(changeItemVO.isSelected){
					checkButton.isSelected = true;
				}else{
					checkButton.isSelected = false;
				}
				
				if(!this._isSelected){					
					this.bg.alpha=defaultAlpha;
				}
			}
			
		}
		
		private function check_changeHandler():void
		{
			var changeItemVO:ExchangeItemVO = this._data as ExchangeItemVO;
//			checkButton.isSelected = !checkButton.isSelected ;
			if(checkButton.isSelected){
				changeItemVO.isSelected = true;
			}else{
				changeItemVO.isSelected = false;
			}
		}
	}
}