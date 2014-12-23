package com.studyMate.world.screens.ui.music
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.utils.BitmapFontUtils;
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
	
	public class MusicBitmapFontItemRender extends BaseListItemRenderer
	{
		public function MusicBitmapFontItemRender()
		{
			super();
		}
		public static var isEdit:Boolean;
		
		private var holder:Sprite;//大容器
		private var titleLabel:*;
		private var authorLabel:*;
		private var sizeLabel:*;
		private var timeLabel:*;
		private var downBtn:Button;
		private var _downNumTxt:*;
		
		private var defaultBgIcon:Image;//默认背景音乐图标
		private var BgIcon:Image;//设定为背景音乐的图标
		private var delCircleIcon:Image;
		private var delBtn:Button;
		
		private var canPlayBoo:Boolean;
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		private var bg:*;
		private var bg2:*;
		private var isBitmap:Boolean;
		
		
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
				if(BitmapFontUtils.isInit){
					isBitmap = true;
					this.holder = new Sprite();				
					this.addChild(this.holder);
					
					bg = new Image(BitmapFontUtils.getTexture('bgQuad_00000'));
					this.holder.addChild(this.bg);
					bg2 = new Image(BitmapFontUtils.getTexture('bgQuad2_00000'));
					bg2.touchable = false;
					bg2.visible = false;
					this.holder.addChild(bg2);
					
					this.defaultBgIcon = new Image(BitmapFontUtils.getTexture("flagBgBaseIcon_00000"));		
					this.defaultBgIcon.x = 10;
					this.defaultBgIcon.y = 10;
					this.holder.addChild(this.defaultBgIcon);
					
					this.titleLabel = BitmapFontUtils.getLabel();
					this.titleLabel.touchable = false;
					//				this.titleLabel.setSize(230,48);
					this.titleLabel.maxWidth = 230;
					this.titleLabel.x = 46;
					this.titleLabel.y = 10;
					
					this.authorLabel = BitmapFontUtils.getLabel();
					this.authorLabel.touchable = false;
					//				this.authorLabel.setSize(182,48);
					this.authorLabel.maxWidth = 182;
					this.authorLabel.x = 280;
					this.authorLabel.y = 10;
					
					this.sizeLabel = BitmapFontUtils.getLabel();
					this.sizeLabel.touchable = false;
					this.sizeLabel.setSize(80,48);
					this.sizeLabel.x = 450;
					this.sizeLabel.y = 10;
					
					this.timeLabel = BitmapFontUtils.getLabel();
					this.timeLabel.touchable = false;
					this.timeLabel.setSize(90,48);
					this.timeLabel.x = 570;
					this.timeLabel.y = 10;
					
					this.holder.addChild(this.titleLabel);
					this.holder.addChild(this.authorLabel);
					this.holder.addChild(this.sizeLabel);
					this.holder.addChild(this.timeLabel);	
					
					this.downBtn = new Button(BitmapFontUtils.getTexture('downBtn_00000'));
					this.downBtn.x = 690;
					this.downBtn.y = 5;
					this.holder.addChild(this.downBtn);
					
					this._downNumTxt = BitmapFontUtils.getLabel();
					this._downNumTxt.touchable = false;
					this._downNumTxt.setSize(100,48);
					this._downNumTxt.touchable = false;
					this._downNumTxt.x = 662;
					this._downNumTxt.y = 10;	
					this.holder.addChild(this._downNumTxt);
					
					this.BgIcon = new Image(BitmapFontUtils.getTexture('flagBgIcon_00000'));
					this.BgIcon.touchable = false;	
					this.BgIcon.x = 10;
					this.BgIcon.y = 10;
					this.holder.addChild(this.BgIcon);
					
					this.delCircleIcon = new Image(BitmapFontUtils.getTexture('delCircleIcon_00000'));
					this.delCircleIcon.pivotX = this.delCircleIcon.width>>1;
					this.delCircleIcon.pivotY = this.delCircleIcon.height>>1;
					this.delCircleIcon.x = 20;
					this.delCircleIcon.y = 20;
					this.addChild(delCircleIcon);
					
					this.delBtn = new Button(BitmapFontUtils.getTexture("delMusicBtn_00000"));
					this.delBtn.x = 718;
					this.delBtn.y = 5;
					this.addChild(delBtn);
				}else{
					isBitmap = false;
					this.holder = new Sprite();				
					this.addChild(this.holder);
					
					this.bg = new starling.display.Quad(748,48,0x0a4475);
					this.bg.alpha = 0.25;
					this.holder.addChild(this.bg);
					
					this.bg2 = new starling.display.Quad(748,48,0x0a4475);
					bg2.alpha = 0.65;
					bg2.visible = false;
					this.holder.addChild(this.bg2);
					
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
					
					this.delCircleIcon = new Image(Assets.getMusicSeriesTexture('delCircleIcon'));
					this.delCircleIcon.pivotX = this.delCircleIcon.width>>1;
					this.delCircleIcon.pivotY = this.delCircleIcon.height>>1;
					this.delCircleIcon.x = 20;
					this.delCircleIcon.y = 20;
					this.addChild(delCircleIcon);
					
					this.delBtn = new Button(Assets.getMusicSeriesTexture("delMusicBtn"));
					this.delBtn.x = 718;
					this.delBtn.y = 5;
					this.addChild(delBtn);
				}
				
				
				this.delCircleIcon.addEventListener(TouchEvent.TOUCH,delCircleIconHandler);
				this.delBtn.addEventListener(TouchEvent.TOUCH,delBtnHandler);
				this.defaultBgIcon.addEventListener(TouchEvent.TOUCH,SetBgMusicHandler);
				this.bg.addEventListener(TouchEvent.TOUCH,BgTounchHandler);
			}
		}
		
		override protected function commitData():void
		{
			if(this._data)
			{
				if(BitmapFontUtils.isInit && !isBitmap){
					this.removeChildren(0,-1,true);
					this.titleLabel = null;
					trace('创建新的界面');
					initialize();
				}
				var baseClass:MusicBaseClass = this._data as MusicBaseClass;
				this.titleLabel.text = baseClass.Name;
				this.authorLabel.text = baseClass.author;
				this.sizeLabel.text = baseClass.size;//String(int(baseClass.size)>>10)+"kb";
				this.timeLabel.text = baseClass.totalTime;

				this.delBtn.visible = false;
				if(isEdit){
					this.delCircleIcon.visible = true;
				}else{
					this.delCircleIcon.visible = false;
				}
				
				if(!baseClass.hasSource && baseClass.downPercent=="-1"){
					this.downBtn.visible = true;
					this.downBtn.addEventListener(Event.TRIGGERED,downTouchHandler);
				}else{
					this.downBtn.visible = false;
				}
				
				if(!baseClass.hasSource && baseClass.downPercent!="-1" && baseClass.downPercent!="100%"){
					this._downNumTxt.visible = true;
					this._downNumTxt.text = baseClass.downPercent;
				}else{
					this._downNumTxt.visible = false;
				}
				if(baseClass.isBgMusic!="0"){					
//					this.BgIcon.touchable = false;					
					this.BgIcon.visible = true;
				}else{
					this.BgIcon.visible = false;
				}
				
				if(MusicListPlayMediator.isEditBoo){	//是否在编辑				
					this.holder.x = 50;
					this.delCircleIcon.visible = true;
					this.delCircleIcon.rotation = 0;
					this.holder.touchable = false;
				}else{
					this.holder.x = 0;
					this.delCircleIcon.visible = false;
					this.holder.touchable = true;
				}
			}
		}
		
		private function delCircleIconHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase=="ended"){
//				isEdit = !isEdit;
//				if(isEdit) return;
				changeState();
			}
		}
		private function changeState():void{			
			isEdit = false;
			if(this.delBtn.visible){
				TweenLite.to(this.delCircleIcon,0.2,{rotation:0});
				TweenLite.to(this.delBtn,0.2,{x:800,onComplete:delComplete});				
			}else{
				isEdit = true;
				this.delBtn.x = 718;
				this.delBtn.visible = true;
				TweenLite.to(this.delCircleIcon,0.2,{rotation:-1.57});
				TweenLite.from(this.delBtn,0.2,{x:800,onComplete:registerStageListener});
			}
		}
		private function registerStageListener():void{
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,stageTounchHandler);
			
		}
		private function delComplete():void{
			this.delBtn.visible = false;
		}
		
		override public function dispose():void
		{
			super.dispose();
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageTounchHandler);
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
				this.delCircleIcon.rotation = 0;
//				this.delCircleIcon.removeEventListener(TouchEvent.TOUCH,delCircleIconHandler);
				Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageTounchHandler);
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
				if(canPlayBoo){
					if(baseClass.hasSource){
						Facade.getInstance(CoreConst.CORE).sendNotification(MusicPlayerMediator.SECECT_SOUNDS,baseClass);
						isSelected = true;						
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("该首音乐尚未下载完成,无法播放。"));
					}
				}
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

