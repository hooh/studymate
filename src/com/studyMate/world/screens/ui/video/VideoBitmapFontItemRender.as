package com.studyMate.world.screens.ui.video
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.screens.ResTableMediator;
	import com.studyMate.world.screens.ui.QueueDownMediator;
	
	import feathers.controls.Label;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class VideoBitmapFontItemRender extends BaseListItemRenderer
	{
		public function VideoBitmapFontItemRender()
		{
			super();
		}
		
		private var titleLabel:Label;
		
		override public function dispose():void
		{
			this.removeChildren(0,-1,true);
			super.dispose();
		}
		
		private var timeLabel:Label;
		private var sizeLabel:Label;
		private var _downNumTxt:Label;
		private var delBtn:Button;
		private var downBtn:Button;
		private var playBtn:Button;
		
		private var canPlayBoo:Boolean;
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		private var bg:Image;
		private var bg2:Image;
		
		private const defaultAlpha:Number=0.1;
		private const setAlpha:Number = 0.3;
		
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			if(value){					
				bg2.visible = true;
			}else{
				bg2.visible = false;
			}
			
		}
		
		override protected function initialize():void
		{
			if(!this.titleLabel)
			{

				bg = new Image(BitmapFontUtils.getTexture('bgQuad_00000'));
				this.addChild(bg);
				bg2 = new Image(BitmapFontUtils.getTexture('bgQuad2_00000'));
				bg2.touchable = false;
				bg2.visible = false;
				this.addChild(bg2);
				
				this.titleLabel = BitmapFontUtils.getLabel();
				this.titleLabel.touchable = false;
				this.titleLabel.setSize(280,50);
				this.titleLabel.y = 10;

				this.timeLabel = BitmapFontUtils.getLabel();
				this.timeLabel.x = 330;
				this.timeLabel.touchable = false;
				this.timeLabel.setSize(80,50);
				this.timeLabel.y = 10;
				
				this.sizeLabel = BitmapFontUtils.getLabel();
				this.sizeLabel.x = 516;
				this.sizeLabel.touchable = false;
				this.sizeLabel.setSize(150,50);
				this.sizeLabel.y = 10;
				
				this.delBtn = new Button(BitmapFontUtils.getTexture("parents/del_Resource_icon_00000"));
				this.delBtn.x = 656;
				this.delBtn.y = 10;
				this.delBtn.addEventListener(Event.TRIGGERED,delTouchHandler);
				
				
				
				this.addChild(this.titleLabel);
				this.addChild(this.timeLabel);
				this.addChild(this.sizeLabel);
				this.addChild(this.delBtn);	
				
				
				this.playBtn = new Button(BitmapFontUtils.getTexture("parents/play_Resource_icon_00000"));
				this.playBtn.x = 756;
				this.playBtn.y = 10;
				this.addChild(this.playBtn);
				
				this.downBtn =  new Button(BitmapFontUtils.getTexture("parents/down_Resource_icon_00000"));
				this.downBtn.x = 756;
				this.downBtn.y = 10;
				this.addChild(this.downBtn);
				
				this._downNumTxt = BitmapFontUtils.getLabel();
				_downNumTxt.setSize(100,48);
				this._downNumTxt.x = 726;
				this._downNumTxt.y = 10;
				this.addChild(this._downNumTxt);				
				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
			}
		}
		
		override protected function commitData():void
		{
			if(this._data)
			{
				var baseClass:VideoBaseClass = this._data as VideoBaseClass;
				this.titleLabel.text = baseClass.Name.substr(0,20);
				this.sizeLabel.text = baseClass.size.substr(0,20);
				this.timeLabel.text = baseClass.totalTime.substr(0,20);
				
				this.playBtn.visible =false;
				this.downBtn.visible = false;
				this._downNumTxt.visible = false;
				if(baseClass.hasSource || baseClass.downPercent=="100%"){
					this.playBtn.visible = true;
					this.playBtn.addEventListener(Event.TRIGGERED,playTouchHandler);					
				}else if(baseClass.downPercent=="-1"){
					this.downBtn.visible = true;
					this.downBtn.addEventListener(Event.TRIGGERED,downTouchHandler);
				}else if(!baseClass.hasSource && baseClass.downPercent!="100%"){
					this._downNumTxt.visible = true;
					this._downNumTxt.text = baseClass.downPercent.substr(0,20);
				}							
			}
		}
		
		
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this.bg);				
			if(touch && touch.phase == TouchPhase.ENDED){				
				isSelected = true;									
			}		
		}
		
		private function playTouchHandler(event:Event):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(ResTableMediator.PLAY_TRIGGERED,this._data);
		}
		private function delTouchHandler(event:Event):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(ResTableMediator.DEL_TRIGGERED,this._data);
		}		
		private function downTouchHandler(event:Event):void{
			var baseClass:VideoBaseClass = this._data as VideoBaseClass;
			baseClass.downPercent="0%";
			this.downBtn.visible =false;
			this._downNumTxt.visible = true;
			this._downNumTxt.text = baseClass.downPercent;
			
			var _itemVideo:UpdateListItemVO = new UpdateListItemVO(baseClass.downId,baseClass.path,"BOOK",baseClass.version);
			if(Facade.getInstance(CoreConst.CORE).hasMediator(QueueDownMediator.NAME)){
				(Facade.getInstance(CoreConst.CORE).retrieveMediator(QueueDownMediator.NAME) as QueueDownMediator).addDownQueue(_itemVideo,baseClass)
			}
		}
	}
}


