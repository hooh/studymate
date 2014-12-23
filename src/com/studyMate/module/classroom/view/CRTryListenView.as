package com.studyMate.module.classroom.view
{
	import com.studyMate.global.Global;
	import com.studyMate.world.component.weixin.interfaces.ITryListenView;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class CRTryListenView extends Sprite implements ITryListenView
	{
		private var playBtn:Button;
		private var pauseBtn:Button;
		private var cancelBtn:Button;
		private var sureBtn:Button;
		
		public function CRTryListenView()
		{
			var quad:Quad = new Quad(Global.stageWidth,Global.stageHeight);
			quad.alpha = 0.35;
			this.addChild(quad);
			
			var bg1:Image = new Image(Assets.getWeixinTexture('tryListenBg'));
			bg1.x = 617;
			bg1.y = 239;
			this.addChild(bg1);
			
			cancelBtn = new Button(Assets.getWeixinTexture('cancelBtn'));
			cancelBtn.x = 700;
			cancelBtn.y = 454;
			this.addChild(cancelBtn);
			
			sureBtn = new Button(Assets.getWeixinTexture('sureBtn'));
			sureBtn.x = 931;
			sureBtn.y = 454;
			this.addChild(sureBtn);
			
			playBtn = new Button(Assets.getWeixinTexture('playAmrBtn'));
			playBtn.x = 880;
			playBtn.y = 328;
			playBtn.visible = false;
			this.addChild(playBtn);
			
			pauseBtn = new Button(Assets.getWeixinTexture('pauseAmrBtn'));
			pauseBtn.x = 881;
			pauseBtn.y = 330;
			this.addChild(pauseBtn);
		}
		
		public function get pauseDisplayObject():DisplayObject
		{
			return pauseBtn;
		}
		
		public function get playDisplayObject():DisplayObject
		{
			return playBtn;
		}
		
		public function get sureDisplayObject():DisplayObject
		{
			return sureBtn;
		}
		
		public function get cancelDisplayObject():DisplayObject
		{
			return cancelBtn;
		}
	}
}