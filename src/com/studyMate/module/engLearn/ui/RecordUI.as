package com.studyMate.module.engLearn.ui
{
	import com.edu.AMRMedia;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.module.engLearn.api.LearnConst;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * 录音模块
	 * 2014-10-23上午11:20:27
	 * Author wt
	 *
	 */	
	
	public class RecordUI extends Sprite
	{
		
		protected var recordStartBtn:Button;
		protected var recordStopBtn:Button;
		
		protected var playBtn:Button;
		protected var pauseBtn:Button;
		
		protected var rankid:String;
		
		protected var timeTxt:TextField;
		protected var recordTip:Image;
				
		public function RecordUI()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		private function addToStageHandler(e:starling.events.Event):void
		{
			playBtn = new Button(Assets.readAloudTexture('playBtn'));
			pauseBtn = new Button(Assets.readAloudTexture('pauseBtn'));
			recordStartBtn = new Button(Assets.readAloudTexture('startRecord'));
			recordStopBtn = new Button(Assets.readAloudTexture('stopRecord'));
			
			recordTip = new Image(Assets.readAloudTexture("recordTip"));
			recordTip.x = -660;
			recordTip.y = 140;
			this.addChild(recordTip);
			recordTip.touchable = false;
			recordTip.visible = false;
			
			recordStartBtn.y = 100
			recordStopBtn.y = 100;
			
			timeTxt = new TextField(100,37,'','HeiTi',14,0x00044F,true);
			timeTxt.x = 0;
			timeTxt.y = 185;
			this.addChild(timeTxt);
			timeTxt.touchable = false;
			
			this.addChild(recordStartBtn);
			this.addChild(recordStopBtn);
			this.addChild(playBtn);
			this.addChild(pauseBtn);
			
			recordStartBtn.addEventListener(starling.events.Event.TRIGGERED,startRecordHandler);
			recordStopBtn.addEventListener(starling.events.Event.TRIGGERED,stopRecordHandler);
			playBtn.addEventListener(starling.events.Event.TRIGGERED,playHandler);
			pauseBtn.addEventListener(starling.events.Event.TRIGGERED,pauseHandler);
			
			recordStopBtn.visible = false;
			playBtn.visible = false;
			pauseBtn.visible = false;
		}
		
		public function update(rankid:String):void{
			this.rankid = rankid;
			AMRMedia.getInstance().stopRecordAMR();//移除必须加的。
			
			var file:File = getRecordFile(rankid+'.amr');
			if(file.exists){
				playBtn.visible = true;
				pauseBtn.visible = false;								
			}else{
				playBtn.visible = false;
				pauseBtn.visible = false;	
			}
			recordStartBtn.visible = true;
			recordStopBtn.visible = false;
		}
				
		
		private function pauseHandler():void
		{
			playBtn.visible = true;
			pauseBtn.visible = false;	
			AMRMedia.getInstance().pauseAMR();
		}
		
		private function playHandler():void
		{
			var file:File = getRecordFile(rankid+'.amr');
			if(file.exists){
				playBtn.visible = false;
				pauseBtn.visible = true;	
				AMRMedia.getInstance().addEventListener(AMRMedia.PLAY_COMPLETE,playCompleteHandler);
				AMRMedia.getInstance().playAMR(file.nativePath);
			}
		}
		
		protected function playCompleteHandler(event:flash.events.Event):void
		{
			AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playCompleteHandler);
			playBtn.visible = true;
			pauseBtn.visible = false;	
		}
		
		private function stopRecordHandler():void
		{
			recordTip.visible = false;
			playBtn.visible = true;
			pauseBtn.visible = false;
			recordStartBtn.visible = true;
			recordStopBtn.visible = false;
			AMRMedia.getInstance().stopRecordAMR();
			playBtn.visible = true;
			stopTimer();
			
			Facade.getInstance(CoreConst.CORE).sendNotification(LearnConst.RECORD_STOP);
		}
		
		private function startRecordHandler():void
		{
			recordTip.visible = true;
			AMRMedia.getInstance().stopAMR();
			playBtn.visible = false;
			pauseBtn.visible = false;
			recordStartBtn.visible = false;
			recordStopBtn.visible = true;
			var file:File = getRecordFile(rankid+'.amr');
			AMRMedia.getInstance().RecordAMR(file.nativePath);
			startTimer();
			
			Facade.getInstance(CoreConst.CORE).sendNotification(LearnConst.RECORD_START);
		}
		
		private var count:int = 0;
		private function startTimer():void{
			timeTxt.text = '已录音'+count+'s';
			count++;
			TweenLite.delayedCall(1,startTimer);
		}
		private function stopTimer():void{
			TweenLite.killDelayedCallsTo(startTimer);
			timeTxt.text = '';
			count = 0;
		}
		
		
		
		override public function dispose():void
		{
			TweenLite.killDelayedCallsTo(startTimer);

			AMRMedia.getInstance().stopAMR();//移除必须加的。
			AMRMedia.getInstance().stopRecordAMR();//移除必须加的。
			AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playCompleteHandler);
			clear();
			super.dispose();
		}
		
		
		public function clear():void{
			var recordfile:File = Global.document.resolvePath(Global.localPath+"Market/readAloud");	
			if(recordfile.exists){
				var list:Array = recordfile.getDirectoryListing();
				for(var i:int=0;i<list.length;i++){
					if(list[i].exists){
						list[i].deleteFile();
					}
				}
			}
		}
		
		protected function getRecordFile(name:String):File{
			return Global.document.resolvePath(Global.localPath+'Market/readAloud/'+name);
		}
		
	}
}