package com.studyMate.world.screens.view
{
	import com.greensock.TweenLite;
	
	import fl.controls.Button;
	import fl.controls.Slider;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class VideoPlayerView extends Sprite
	{
		public var controlRec:Sprite;
		public var videoRec:Sprite;
		public var playBtn:Button;
		public var pauseBtn:Button;
		public var nextBtn:Button;
		public var preBtn:Button;
		public var stopBtn:Button;
		public var volumeSlider:Slider;
		public var positionSlider:Slider;
		public var positionText:TextField;
		public var sumTimeText:TextField;
		public var nameOfVideoText:TextField;
		private var _hideControlRec:Boolean = false;
		
		public function VideoPlayerView()
		{
			videoRec = new Sprite();
			videoRec.graphics.beginFill(0);
			videoRec.graphics.drawRect(0,0,1280,768);
			videoRec.graphics.endFill();
			this.addChild(videoRec);
			videoRec.x = 0;
			videoRec.y = 0;
			
			controlRec = new Sprite();
			controlRec.graphics.beginFill(0xCCCCCC,0.5);
			controlRec.graphics.drawRect(0,0,1280,200);
			controlRec.graphics.endFill();
			this.addChild(controlRec);
			controlRec.x = 0;
			controlRec.y = 568;
			
			playBtn = new Button();
			playBtn.label = "播放";
			controlRec.addChild(playBtn);
			playBtn.x = 50;
			playBtn.y = 50;
			
			pauseBtn = new Button();
			pauseBtn.label = "暂停";
			pauseBtn.visible = false;
			controlRec.addChild(pauseBtn);
			pauseBtn.x = 50;
			pauseBtn.y = 50;
			
			preBtn = new Button();
			preBtn.label = "上一首";
			controlRec.addChild(preBtn);
			preBtn.x = 200;
			preBtn.y = 50;
			
			nextBtn = new Button();
			nextBtn.label = "下一首";
			controlRec.addChild(nextBtn);
			nextBtn.x = 350
			nextBtn.y = 50;
			
			stopBtn = new Button();
			stopBtn.label = "停止";
			controlRec.addChild(stopBtn);
			stopBtn.x = 500;
			stopBtn.y = 50;
			
			volumeSlider = new Slider();
			volumeSlider.width = 200;
			volumeSlider.maximum = 2;
			volumeSlider.value = 1;
			volumeSlider.snapInterval = 0.05;
			controlRec.addChild(volumeSlider);
			volumeSlider.x = 1000;
			volumeSlider.y = 55;
			
			var positionSp:Sprite = new Sprite();
			positionSp.graphics.beginFill(0xEDEDED);
			positionSp.graphics.drawEllipse(-1,-4,2,8);
			positionSp.graphics.endFill();
			
			positionSlider = new Slider();
			positionSlider.width = 1000;
			positionSlider.maximum = 100;
			positionSlider.value = 0;
			positionSlider.snapInterval = 0.1;
			positionSlider.setStyle("thumbUpSkin",positionSp);
			positionSlider.setStyle("thumbDownSkin",positionSp);
			positionSlider.setStyle("thumbOverSkin",positionSp);
			controlRec.addChild(positionSlider);
			positionSlider.x = 140;
			positionSlider.y = 15;
			
			positionText = new TextField();
			positionText.text = "00:00:00";
			positionText.textColor = 0xffffff;
			controlRec.addChild(positionText);
			positionText.height = 16;
			positionText.width = 50;
			positionText.x = 85;
			positionText.y = 10;
			
			sumTimeText = new TextField();
			sumTimeText.text = "00:00:00";
			sumTimeText.textColor = 0xffffff;
			controlRec.addChild(sumTimeText);
			sumTimeText.height = 16;
			sumTimeText.width = 50;
			sumTimeText.x = 1145;
			sumTimeText.y = 10;
			
			nameOfVideoText = new TextField();
			controlRec.addChild(nameOfVideoText);
			nameOfVideoText.text = "在线教育---视频播放器";
			nameOfVideoText.textColor = 0xffffff;
			nameOfVideoText.height = 20;
			nameOfVideoText.width = 250;
			nameOfVideoText.x = 700;
			nameOfVideoText.y = 50;
		}

		public function get hideControlRec():Boolean
		{
			return _hideControlRec;
		}

		public function set hideControlRec(value:Boolean):void
		{
			_hideControlRec = value;
			if(hideControlRec){
				TweenLite.to(controlRec, 0.8 , {y:768});
			}else{
				TweenLite.to(controlRec, 0.8, {y:568});
			}
		}

	}
}