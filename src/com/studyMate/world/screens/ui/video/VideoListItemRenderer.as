package com.studyMate.world.screens.ui.video
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.screens.ResTableMediator;
	import com.studyMate.world.screens.ui.QueueDownMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class VideoListItemRenderer extends BaseListItemRenderer
	{
		public function VideoListItemRenderer()
		{
			super();
		}
		
		private var titleLabel:TextField;
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			this.removeChildren(0,-1,true);
			super.dispose();
		}
		
		private var timeLabel:TextField;
		private var sizeLabel:TextField;
		private var delBtn:Button;
		private var downBtn:Button;
		private var playBtn:Button;
		private var _downNumTxt:TextField;
		
		private var canPlayBoo:Boolean;
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		private var bg:Quad;
		
		private const defaultAlpha:Number=0.1;
		private const setAlpha:Number = 0.3;
				
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
//			if(value){					
//				this.bg.alpha=setAlpha;				
//			}else{
//				this.bg.alpha=defaultAlpha;		
//			}
//			
		}
		
		override protected function initialize():void
		{
			if(!this.titleLabel)
			{
				this.bg = new starling.display.Quad(800,50,0x0a4475);
				this.bg.alpha=defaultAlpha;		
				this.addChild(this.bg);
				this.titleLabel = new TextField(280,50,"","HeiTi",18,0x666666);
				this.titleLabel.hAlign = HAlign.LEFT;
				this.titleLabel.autoScale = true;
				this.titleLabel.touchable = false;
				
				this.timeLabel = new TextField(80,50,"","HeiTi",18,0x666666);
				this.timeLabel.touchable = false;
				this.timeLabel.autoScale = true;
				this.timeLabel.hAlign = HAlign.LEFT;
				this.timeLabel.x = 330;
				
				this.sizeLabel = new TextField(150,50,"","HeiTi",18,0x666666);
				this.sizeLabel.touchable = false;
				this.sizeLabel.autoScale = true;
				this.sizeLabel.hAlign = HAlign.LEFT;
				this.sizeLabel.x = 516;			
				
				this.delBtn = new Button(Assets.getAtlasTexture("parents/del_Resource_icon"));
				this.delBtn.x = 656;
				this.delBtn.y = 10;
				this.delBtn.addEventListener(Event.TRIGGERED,delTouchHandler);
								
				this.addChild(this.titleLabel);
				this.addChild(this.timeLabel);
				this.addChild(this.sizeLabel);
				this.addChild(this.delBtn);	
				
				
				this.playBtn = new Button(Assets.getAtlasTexture("parents/play_Resource_icon"));
				this.playBtn.x = 756;
				this.playBtn.y = 10;
				this.addChild(this.playBtn);
				
				this.downBtn =  new Button(Assets.getAtlasTexture("parents/down_Resource_icon"));
				this.downBtn.x = 756;
				this.downBtn.y = 10;
				this.addChild(this.downBtn);
				
				this._downNumTxt = new starling.text.TextField(100, 48, "0", "HeiTi", 14, 0);
				this._downNumTxt.x = 726;
				this.addChild(this._downNumTxt);				
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
//				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
			}
		}
		
		
		private function TOUCHHandler(e:TouchEvent):void
		{
//			var touch:Touch = e.getTouch(this.bg);				
//			if(touch && touch.phase == TouchPhase.ENDED){		
			if(e.touches[0] && e.touches[0].phase=="ended"){
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