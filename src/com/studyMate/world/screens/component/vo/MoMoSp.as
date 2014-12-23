package com.studyMate.world.screens.component.vo
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class MoMoSp extends Sprite
	{
		public static const NAME:String = "MoMoSp";
		public static const PLAY_RECORD:String = NAME + "PlayRecord";
		public static const STOP_RECORD:String = NAME + "StopRecord";
		public static const DOWN_RECORD:String = NAME + "DownRecord";
		public static const MOMO_ADDURL:String = NAME + 'momoUrl';
		
		public var isRecord:Boolean;//如果是true ，代表是录音程序
		private var _faceMoive:MovieClip;
		public var url:String = "";
		public var flag:String = '';//R代表右侧的，L代表左侧的
		
		public function MoMoSp(value:String=null)
		{
			flag = value
		}
		//是否曾在播放
		public function get isPlay():Boolean
		{
			return _isPlay;
		}

		public function set faceMoive(value:MovieClip):void
		{
			_faceMoive = value;
			if(_faceMoive){
				url = _faceMoive.url;
//				_faceMoive.x = 80;
				_faceMoive.y = 20;
				_faceMoive.addEventListener(MouseEvent.CLICK,faceClickHandler);
				this.addChild(_faceMoive);
				Facade.getInstance(CoreConst.CORE).sendNotification(MOMO_ADDURL,[url,this]);//派发播放事件
			}
		}
		
		protected function faceClickHandler(event:MouseEvent):void
		{
			//检查语音文件是否存在
			if(checkLocalFile(url)){
				
				if(!_isPlay){
					playState();
					Facade.getInstance(CoreConst.CORE).sendNotification(PLAY_RECORD,[url,this]);//派发播放事件事件
					
				}else{
					defaultState();
					Facade.getInstance(CoreConst.CORE).sendNotification(STOP_RECORD);//派发停止播放状态
					
				}
				
			}else{
				//文件不存在，请求下载
				loadingState();
				Facade.getInstance(CoreConst.CORE).sendNotification(DOWN_RECORD,[url,this]);//派发下载
				
			}
			
		}
		
		private function checkLocalFile(_url:String):Boolean{
			
			var __url:String = Global.document.resolvePath(Global.localPath + "speech/" + _url.substring(_url.lastIndexOf("/")+1)).url;
			
			return new File(__url).exists;
			
		}
		
		
		
		
		private var _isPlay:Boolean;
		//播放状体
		public function playState():void{
			if(isRecord && _faceMoive){
				_isPlay = true;
				_faceMoive.gotoAndStop(3);
			}
		}
		
		
		//加载状态
		public function loadingState():void{
			if(isRecord && _faceMoive){
				_isPlay = false;
				_faceMoive.gotoAndStop(2);
			}
		}
		
		//静止状态
		public function defaultState():void{
			if(isRecord && _faceMoive){
				_isPlay = false;
				_faceMoive.gotoAndStop(1);
			}
		}
		
	}
}