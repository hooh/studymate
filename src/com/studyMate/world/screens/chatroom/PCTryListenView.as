package com.studyMate.world.screens.chatroom
{
	import com.studyMate.global.Global;
	import com.studyMate.world.component.weixin.interfaces.ITryListenView;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class PCTryListenView extends Sprite implements ITryListenView
	{
		private var playBtn:Button;
		private var pauseBtn:Button;
		private var cancelBtn:Button;
		private var sureBtn:Button;
		
		public function PCTryListenView()
		{
//			var quad:Quad = new Quad(Global.stageWidth,Global.stageHeight);
//			quad.alpha = 0.35;
//			this.addChild(quad);
			
			
			
			var bg1:Image = new Image(Assets.getWeixinTexture('tryListenBg'));
			this.addChild(bg1);
			
			cancelBtn = new Button(Assets.getWeixinTexture('cancelBtn'));
			cancelBtn.x = 83;
			cancelBtn.y = 218;
			this.addChild(cancelBtn);
			
			sureBtn = new Button(Assets.getWeixinTexture('sureBtn'));
			sureBtn.x = 315;
			sureBtn.y = 218;
			this.addChild(sureBtn);
			
			playBtn = new Button(Assets.getWeixinTexture('playAmrBtn'));
			playBtn.x = 265;
			playBtn.y = 92;
			playBtn.visible = false;
			this.addChild(playBtn);
			
			pauseBtn = new Button(Assets.getWeixinTexture('pauseAmrBtn'));
			pauseBtn.x = 266;
			pauseBtn.y = 92;
			this.addChild(pauseBtn);
			
			this.x = 540;
			this.y = 200;
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