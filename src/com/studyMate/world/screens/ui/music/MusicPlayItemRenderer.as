package com.studyMate.world.screens.ui.music
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.screens.MusicListPlayMediator;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.component.MusicPlayerMediator;
	import com.studyMate.world.screens.ui.QueueDownMediator;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class MusicPlayItemRenderer extends BaseListItemRenderer
	{
		public function MusicPlayItemRenderer()
		{
			super();
		}
		public static var isEdit:Boolean;
		
		private var holder:Sprite;//大容器
		private var titleLabel:TextField;
		private var authorLabel:TextField;
		private var sizeLabel:TextField;
		private var timeLabel:TextField;
		private var downBtn:Button;
		private var _downNumTxt:TextField;
		
		private var defaultBgIcon:Image;//默认背景音乐图标
		private var BgIcon:Image;//设定为背景音乐的图标
		private var delIcon:Image;
		private var delBtn:Button;
		
		private var canPlayBoo:Boolean;
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		private var bg:Quad;
		private var bg2:Quad;
				
						
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = true;
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
				this.holder = new Sprite();				
				this.addChild(this.holder);
				
				this.bg = new starling.display.Quad(748,48,0x0a4475);
				this.bg.alpha = 0.25;
				this.holder.addChild(this.bg);
				
				this.bg2 = new starling.display.Quad(748,48,0x0a4475);
				bg2.alpha = 0.65;
				bg2.visible = false;
				this.holder.addChild(this.bg);
				
				this.defaultBgIcon = new Image(Assets.getMusicSeriesTexture("flagBgBaseIcon"));				
				this.holder.addChild(this.defaultBgIcon);
				
				this.titleLabel = new TextField(230,48,"","HeiTi",16,0xFFFFFF);
				this.titleLabel.hAlign = HAlign.LEFT;
				this.titleLabel.autoScale = true;
				this.titleLabel.x = 46;
				this.titleLabel.touchable = false;
				
				this.authorLabel = new TextField(182,48,"","HeiTi",16,0xFFFFFF);
				this.authorLabel.hAlign = HAlign.LEFT;
				this.authorLabel.autoScale = true;
				this.authorLabel.touchable = false;
				this.authorLabel.x = 280;
				
				this.sizeLabel = new TextField(80,48,"","HeiTi",16,0xFFFFFF);
				this.sizeLabel.touchable = false;
				this.sizeLabel.hAlign = HAlign.LEFT;
				this.sizeLabel.x = 450;
				
				this.timeLabel = new TextField(80,48,"","HeiTi",16,0xFFFFFF);
				this.timeLabel.touchable = false;
				this.timeLabel.hAlign = HAlign.LEFT;
				this.timeLabel.x = 570;
				
				this.holder.addChild(this.titleLabel);
				this.holder.addChild(this.authorLabel);
				this.holder.addChild(this.sizeLabel);
				this.holder.addChild(this.timeLabel);	
								
				
				this.downBtn =  new Button(Assets.getMusicSeriesTexture("downBtn"));
				this.downBtn.x = 690;
				this.downBtn.y = 5;
				this.holder.addChild(this.downBtn);
				
				this._downNumTxt = new starling.text.TextField(100, 48, "0", "HeiTi", 14, 0);
				this._downNumTxt.x = 652;
				this.holder.addChild(this._downNumTxt);
				
				this.BgIcon = new Image(Assets.getMusicSeriesTexture("flagBgIcon"));
				this.BgIcon.touchable = false;					
				this.holder.addChild(this.BgIcon);
				
				this.delIcon = new Image(Assets.getMusicSeriesTexture("delCircleIcon"));
				this.delIcon.pivotX = 24;
				this.delIcon.pivotY = 24;
				this.delIcon.x = 24;
				this.delIcon.y = 24;
				this.delIcon.addEventListener(TouchEvent.TOUCH,delIconHandler);
				this.addChild(delIcon);
			}
		}

		override protected function commitData():void
		{
			if(this._data)
			{
				var baseClass:MusicBaseClass = this._data as MusicBaseClass;
				this.titleLabel.text = baseClass.Name;
				this.authorLabel.text = baseClass.author;
				this.sizeLabel.text = baseClass.size;//String(int(baseClass.size)>>10)+"kb";
				this.timeLabel.text = baseClass.totalTime;

				this.downBtn.visible = false;
				this._downNumTxt.visible = false;
				this.BgIcon.visible = false;
				this.delIcon.visible = false;
				if(this.delBtn){
					this.removeChild(this.delBtn);
//					this.delBtn = null;
				}
				
				if(!baseClass.hasSource && baseClass.downPercent=="-1"){
					this.downBtn.visible = true;
					this.downBtn.addEventListener(Event.TRIGGERED,downTouchHandler);
				}
				
				if(!baseClass.hasSource && baseClass.downPercent!="-1" && baseClass.downPercent!="100%"){
					this._downNumTxt.visible = true;
					this._downNumTxt.text = baseClass.downPercent;
				}				
				if(baseClass.isBgMusic!="0"){

					this.BgIcon.touchable = false;					
					this.BgIcon.visible = true;
				}
				
				if(MusicListPlayMediator.isEditBoo){	//是否在编辑				
					this.holder.x = 50;
					this.delIcon.visible = true;
					this.delIcon.addEventListener(TouchEvent.TOUCH,delIconHandler);
					this.holder.touchable = false;
				}else{
					this.holder.x = 0;
					this.holder.touchable = true;
				}
				/*
				if(!this._isSelected){					
					this.bg.alpha=0.25;
				}*/
				this.defaultBgIcon.addEventListener(TouchEvent.TOUCH,SetBgMusicHandler);
				this.bg.addEventListener(TouchEvent.TOUCH,BgTounchHandler);
			}
		}
		
		private function delIconHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				//e.stopImmediatePropagation();
				if(isEdit) return;
				changeState();
			}
		}
		private function changeState():void{			
			isEdit = false;
			if(this.delBtn){
				TweenLite.to(this.delIcon,0.2,{rotation:0});
				TweenLite.to(this.delBtn,0.2,{x:800,alpha:0,onComplete:delComplete});				
			}else{
				isEdit = true;
				TweenLite.to(this.delIcon,0.2,{rotation:-1.57});
				this.delBtn = new Button(Assets.getMusicSeriesTexture("delMusicBtn"));
				this.delBtn.addEventListener(TouchEvent.TOUCH,delBtnHandler);
				this.delBtn.x = 718;
				this.delBtn.y = 5;
				TweenLite.from(this.delBtn,0.2,{x:800,alpha:0,onComplete:registerStageListener});
				this.addChild(this.delBtn);								
			}
		}
		private function registerStageListener():void{
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,stageTounchHandler);
			
		}
		private function delComplete():void{
			this.removeChild(this.delBtn);			
//			this.delBtn = null;
		}
		
		private function stageTounchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				e.stopImmediatePropagation();
				Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageTounchHandler);
				if(isEdit){
					changeState();					
				}
			}
		}
		//删除歌曲
		private function delBtnHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				e.stopImmediatePropagation();
				
			 	Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.Del_Music,this._data);
			}
			
		}
		//设置背景音乐
		private function SetBgMusicHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
				e.stopImmediatePropagation();
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.Move_BgMusic,this._data);
			}
		}
		
		private function BgTounchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);	
			var pos:Point;
			if(touch && touch.phase == TouchPhase.BEGAN){
				//this.bg.alpha = 0.5;
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
				//this.bg.alpha = 0.25;
				var baseClass:MusicBaseClass = this._data as MusicBaseClass;
				if(canPlayBoo){
					if(baseClass.hasSource){
						Facade.getInstance(CoreConst.CORE).sendNotification(MusicPlayerMediator.SECECT_SOUNDS,baseClass);
						isSelected = true;						
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("该首音乐尚未下载完成,无法播放。"));
					}
				}
				/*if(_isSelected){
					this.bg.alpha = 0.65;
				}*/
			}
			
		}
		
		private function downTouchHandler(event:Event):void{
			var baseClass:MusicBaseClass = this._data as MusicBaseClass;
			baseClass.downPercent="0%";
			this.downBtn.visible = false;
			this._downNumTxt.visible = true;
			this._downNumTxt.text = baseClass.downPercent;
			
			var _itemVideo:UpdateListItemVO = new UpdateListItemVO(baseClass.downId,baseClass.path,"BOOK",baseClass.version);
			if(Facade.getInstance(CoreConst.CORE).hasMediator(QueueDownMediator.NAME)){
				(Facade.getInstance(CoreConst.CORE).retrieveMediator(QueueDownMediator.NAME) as QueueDownMediator).addDownQueue(_itemVideo,baseClass)
			}
		}
	}
}