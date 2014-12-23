package com.studyMate.world.screens
{
	import com.edu.AMRMedia;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RemoteFileLoadVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.UpdateListItemVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.engLearn.vo.EgSpokenVO;
	import com.studyMate.world.screens.ui.JpgAlertMediator;
	import com.studyMate.world.screens.view.UserPerDataView;
	
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	
	import mx.utils.StringUtil;
	
	import akdcl.skeleton.Tween;
	
	import feathers.data.ListCollection;
	
	import myLib.myTextBase.utils.SoftKeyBoardConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	
	/**
	 * 查看用户最近上传amr语音和jpg图片
	 * 2014-12-8下午5:29:14
	 * Author wt
	 */	
	
	public class UserPerDataMediator extends ScreenBaseMediator
	{	
		private const USER_PERINFO:String = 'user_perInfo';
		private const DOWN_FILE:String = 'DOWN_FILE';
		private const GET_YYORal:String = "GET_yyOral";
		
		public static const ITEM_CLICK:String = 'itemClick';
		public static const JPGALERT_CLOSE:String = 'jpgAlertClose';
		private var listCollection:ListCollection;
		
		public function UserPerDataMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super("UserPerDataMediator", viewComponent);
		}
		
		override public function onRemove():void{
			TweenLite.killDelayedCallsTo(timeStart);
			AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playCompleteHandler);
			AMRMedia.getInstance().stopAMR();
			view.input.removeEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);
		}
		override public function onRegister():void
		{
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			Starling.current.stage.color = 0xFFFFFF;	
			view.input.addEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);		
			listCollection = new ListCollection();
			view.playList.dataProvider = listCollection;
		}
		
		protected function inputTXTKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == 13) {//回车	
				sendNotification(SoftKeyBoardConst.HIDE_SOFTKEYBOARD);
				var id:String = StringUtil.trim(view.input.text);
				if(id != ''){
					if(!Global.isLoading){
						view.input.removeEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);
						listCollection.removeAll();
						PackData.app.CmdIStr[0] = CmdStr.SELECT_FILE_LIST;
						PackData.app.CmdIStr[1] = '*';
						PackData.app.CmdIStr[2] = '*';
						PackData.app.CmdIStr[3] = id;
						PackData.app.CmdIStr[4] = "20140101";
						PackData.app.CmdIStr[5] = "YYYYMMDD"; 
						PackData.app.CmdInCnt = 6;	
						sendNotification(CoreConst.SEND_11,new SendCommandVO(USER_PERINFO));
					}
				}
			}	
		}
			
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName()){
				case USER_PERINFO:
					if(!result.isEnd && !result.isErr){
						var obj:Object = {};
						obj.date = PackData.app.CmdOStr[4];
						obj.path = PackData.app.CmdOStr[2];
						listCollection.push(obj);
					}else if(result.isEnd){
						AMRMedia.getInstance().stopAMR();
						view.input.addEventListener(KeyboardEvent.KEY_DOWN,inputTXTKeyDownHandler);

					}
					break;
				case ITEM_CLICK:
					TweenLite.killDelayedCallsTo(timeStart);
					AMRMedia.getInstance().stopAMR();
					var path:String = notification.getBody().path;
					var vec:Vector.<UpdateListItemVO> = new Vector.<UpdateListItemVO>;
					
					var file:File =  Global.document.resolvePath(getLocalPath(path));
					if(!file.exists){				
						var downVO:RemoteFileLoadVO = new RemoteFileLoadVO(path,getLocalPath(path),DOWN_FILE,path);
						downVO.downType = RemoteFileLoadVO.USER_FILE;
						sendNotification(CoreConst.REMOTE_FILE_LOAD,downVO);
					}else{
						playLoadFile(path);
					}
					break;
				case DOWN_FILE:
					trace('下载完毕');
					playLoadFile(notification.getBody() as String);
					break;
				case JPGALERT_CLOSE:
					view.visible = true;
					view.input.visible = true;
					break;
				case GET_YYORal:
					if(!result.isErr){//第一步获取阅读id
						spokenVO = new EgSpokenVO(PackData.app.CmdOStr.concat());
						view.contentTxt.htmlText = normalSentence;
						view.contentGpu.textField = view.contentTxt;
						view.listScroll.readjustLayout();
					}
					break;
			}
		}

		override public function listNotificationInterests():Array
		{
			return [USER_PERINFO,ITEM_CLICK,DOWN_FILE,JPGALERT_CLOSE,GET_YYORal];
		}
		
		private var _normalSentence:String;//正常模式
		private var spokenVO:EgSpokenVO;
		private function get normalSentence():String{
//			if(_normalSentence==null){
				_normalSentence = spokenVO.content;
				_normalSentence = _normalSentence.replace(/`/g,"");	
				_normalSentence+="\n\n\n\n\n";
				_normalSentence = _normalSentence.replace(/\r/g,"<br>");
//			}			
			return _normalSentence;
		}
		
		protected function playLoadFile(path:String):void{
			var file:File =  Global.document.resolvePath(getLocalPath(path));
			if(file.exists){
				if(file.extension =="amr"){		
					AMRMedia.getInstance().addEventListener(AMRMedia.PLAY_COMPLETE,playCompleteHandler);
					AMRMedia.getInstance().playAMR(file.nativePath);
					total = AMRMedia.getInstance().getDuration()/1000;
					timeStart();
					showText(path);
				}else if (file.extension =="jpg"){
					view.input.visible = false;
					view.visible = false;
					sendNotification(WorldConst.SWITCH_SCREEN,new SwitchScreenVO(JpgAlertMediator,file.url,SwitchScreenType.SHOW));
				}
			}
		}
		protected function playCompleteHandler(event:flash.events.Event):void
		{
			TweenLite.killDelayedCallsTo(timeStart);
			AMRMedia.getInstance().removeEventListener(AMRMedia.PLAY_COMPLETE,playCompleteHandler);
		}
		
		private var total:int;
		private function timeStart():void{
			view.timeTxt.text = int(AMRMedia.getInstance().getAMRCurrentPosition()/1000)+'秒/总长'+total;
			TweenLite.delayedCall(1,timeStart);
		}
		
		private function showText(path:String):void{
			var typeArr:Array = path.split('/');
			var name:String = typeArr[typeArr.length-1];
			var id:String = name.replace('R','');
			id = id.split('-')[0];
			if(id.length>0){
				PackData.app.CmdIStr[0] = CmdStr.GET_YYOralByIdV2;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = '@y.O';
				PackData.app.CmdIStr[3] = id;; 
				PackData.app.CmdInCnt = 4;	
				sendNotification(CoreConst.SEND_11,new SendCommandVO(GET_YYORal));
			}
		}
		
		
		private function getLocalPath(path:String):String{
			var url:String = path.replace("/home/cpyf/userdata/",'');
			return Global.localPath+"promise/"+url;
		}
		
		override public function get viewClass():Class
		{
			return UserPerDataView;
		}
		
		public function get view():UserPerDataView{
			return getViewComponent() as UserPerDataView;
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
			
		}
	}
}