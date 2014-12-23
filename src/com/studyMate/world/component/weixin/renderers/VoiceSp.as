package com.studyMate.world.component.weixin.renderers
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	import flash.geom.Rectangle;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import com.studyMate.world.component.weixin.VoiceState;
	
	/**
	 * 聊天的语音的UI
	 * @author wt
	 * 
	 */	
	internal class VoiceSp extends Sprite
	{
		public static const WEIXINUI_CLICK:String = 'WEIXIN_CLICK_wt';
		
		public var path:String;			//服务器真实下载的相对路径
		public var direction:String;	//左侧语音(L)，还是右侧语音(R)
		public var bgWidth:Number;
		private var _state:int=-1;			//当前状态
		
//		private var _isPlaying:Boolean;
		
		public var bgBtn:Scale9Image;
		private var soudImg:Image;
		private var soundMov:MovieClip;
		private var loadImg:Image;
		private var dotImg:Image;//标记是否已读
		private var timeTxt:TextField;
		private var hold:Sprite;
		
		public function VoiceSp(url:String,direction='L')
		{
			this.path = url;
			this.direction = direction;
			loadImg = new Image(Assets.getWeixinTexture('loading'));
			loadImg.pivotX = loadImg.width>>1;
			loadImg.pivotY = loadImg.height>>1;
			
			dotImg = new Image(Assets.getWeixinTexture('dot'));
			timeTxt = new TextField(50,27,'','HeiTi',14,0x567210,true);
			timeTxt.hAlign = HAlign.LEFT;
			
			if(direction=='L'){
				leftLayout();
			}else{				
				rightLayout();
			}
			this.addChild(bgBtn);
			this.addChild(timeTxt);
			hold = new Sprite();
			this.addChild(hold);			
		}

		public function set state(value:int):void
		{
			if(_state==value) return;
			_state = value;			
			switch(_state){
				case VoiceState.defaultState:
					defaultState();
					break;
				case VoiceState.loadingState:
					loadingState();
					break;
				case VoiceState.playState:
					playState();
					break;
			}
		}

		public function get state():int
		{
			return _state;
		}
		
		public function set hasRead(boo:Boolean):void{
			if(boo || this.direction == 'R'){
				dotImg.removeFromParent();				
			}else{
				if(!dotImg.parent)
					this.addChild(dotImg);
			}
		}
		
		public function set soundTime(value:String):void{
			if(value!=null) timeTxt.text = value+'"';
			bgWidth = 370*Circ.easeOut.getRatio(Number(value)/60);
			bgWidth = bgWidth>100 ? bgWidth : 100;
			this.bgBtn.width = bgWidth;
			
//			trace('bgBtn.width',Circ.easeOut.getRatio(Number(value)/20));
			
			timeTxt.y = 18;
			dotImg.y = 25;
			loadImg.y = 30;
		}
		
		public function layout():void{
			if(direction=='L'){
				timeTxt.x = bgWidth + 8 ;				
				soudImg.x = soundMov.x = 29;
				soudImg.y = soundMov.y = 16;
				
				loadImg.x = dotImg.x = bgWidth + 40;
			}else{
				this.bgBtn.x = 58;					
				timeTxt.x = 22;
				soudImg.x = soundMov.x = bgWidth + 16;
				soudImg.y = soundMov.y = 16;
				
				loadImg.x = dotImg.x = 0;
			}
		}

		private function leftLayout():void{
			var minRect:Rectangle = new Rectangle(84,34,2,1);
			bgBtn = new Scale9Image(new Scale9Textures(Assets.getWeixinTexture('leftBg'),minRect));
			soundMov = new MovieClip(Assets.getWeixinAtlas().getTextures('Lsound'),2);
			soudImg =new Image(Assets.getWeixinTexture('Lsound_03'));

		}
		private function rightLayout():void{
			var minRect1:Rectangle = new Rectangle(72,34,2,1);
			bgBtn = new Scale9Image(new Scale9Textures(Assets.getWeixinTexture('rightBg'),minRect1));			
			soundMov = new MovieClip(Assets.getWeixinAtlas().getTextures('Rsound'),2);
			soudImg =new Image(Assets.getWeixinTexture('Rsound_03'));

		}
		
		//左右选框切换
		public function adjustDirection(direction:String):void{
			if(this.direction==direction) return;
			this.direction = direction
			if(bgBtn) bgBtn.removeFromParent(true);
			if(soundMov) soundMov.removeFromParent(true);
			if(soudImg) soudImg.removeFromParent(true);
			_state = -1;
			if(this.direction=='L'){//左改右
				leftLayout();
			}else{//右侧改左侧
				rightLayout();
			}
			this.addChildAt(bgBtn,0);
		}

		override public function dispose():void
		{
			TweenMax.killTweensOf(loadImg);
			if(Starling.juggler.contains(soundMov)){
				Starling.juggler.remove(soundMov);
			}
			if(dotImg) dotImg.removeFromParent(true);	
			super.dispose();
		}
		
		
		//播放状体
		private function playState():void{
			bgBtn.touchable = true;
			TweenMax.killTweensOf(loadImg);
			hold.removeChildren();
			hold.addChild(soundMov);
			soundMov.play();
			if(!Starling.juggler.contains(soundMov)){
				Starling.juggler.add(soundMov);
			}
		}
		//加载状态
		private function loadingState():void{	
			TweenMax.killTweensOf(loadImg);	
			if(Starling.juggler.contains(soundMov)){
				Starling.juggler.remove(soundMov);
			}
			bgBtn.touchable = false;
			hold.removeChildren();
			hold.addChild(loadImg);
			hold.addChild(soudImg);
			TweenMax.to(loadImg,3,{rotation:Math.PI,repeat:int.MAX_VALUE});
		}
		//静止状态
		private function defaultState():void{
			bgBtn.touchable = true;
			TweenMax.killTweensOf(loadImg);
			if(Starling.juggler.contains(soundMov)){
				Starling.juggler.remove(soundMov);
			}
			
			hold.removeChildren();
			hold.addChild(soudImg);
		}
	}
}