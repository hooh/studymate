package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.model.vo.BackgroundMusicVO;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class UserBGMusicManagerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "UserBGMusicManagerMediator";
		public static const GETBGMUSICLIST:String = NAME + "GetBackgroundMusicList";
		public static const DELBGMUSIC:String = NAME + "DelBgMusic";
		public static const ADDBGMUSIC:String = NAME + "AddBgMusic";
		private var bgMusicList:Array;
		
		public function UserBGMusicManagerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO = notification.getBody() as DataResultVO;
			var music:BackgroundMusicVO;
			switch(notification.getName()){
				case GETBGMUSICLIST : 
					if(!result.isEnd){
						var bgMusic:BackgroundMusicVO = new BackgroundMusicVO(
							PackData.app.CmdOStr[3],
							PackData.app.CmdOStr[4],
							PackData.app.CmdOStr[5]);
						bgMusic.relid = PackData.app.CmdOStr[1];
						bgMusicList.push(bgMusic);
					}else{
						sendNotification(WorldConst.GET_BGMUSIC_LIST_OVER, bgMusicList.concat());
						bgMusicList.length = 0;
						bgMusicList = null;
					}
					break;
				case DELBGMUSIC :
					if(!result.isErr){
						sendNotification(WorldConst.DEL_BGMUSIC_OVER);
					}
					break;
				case ADDBGMUSIC :
					if(!result.isErr){
						sendNotification(WorldConst.ADD_BGMUSIC_OVER);
					}
					break;
				case WorldConst.GET_BGMUSIC_LIST :
					getListCommand();
					break;
				case WorldConst.DEL_BGMUSIC :
					music = notification.getBody() as BackgroundMusicVO;
					delBgMusic(music);
				    break;
				case WorldConst.ADD_BGMUSIC :
					music = notification.getBody() as BackgroundMusicVO;
					addBgMusic(music);
					break;
				default : 
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [GETBGMUSICLIST,DELBGMUSIC,ADDBGMUSIC,WorldConst.GET_BGMUSIC_LIST,WorldConst.DEL_BGMUSIC,WorldConst.ADD_BGMUSIC];
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
		}
		
		/**
		 * 获取背景音乐列表，接受WorldConst.GET_BGMUSIC_LIST消息可以获取列表Array
		 */
		private function getListCommand():void{
			bgMusicList = new Array;
			PackData.app.CmdIStr[0] = CmdStr.QRY_PER_BGMUSIC;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(GETBGMUSICLIST));
		}
		
		/**
		 * 删除背景音乐，根据musicid删除
		 * @param music
		 * 返回: 没有该背景音乐时提示错误信息
		 */		
		private function delBgMusic(music:BackgroundMusicVO):void{
			if(music==null) return;
			PackData.app.CmdIStr[0] = CmdStr.DEL_BGMUSIC;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = music.id;
			PackData.app.CmdInCnt = 3;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(DELBGMUSIC,null,'cn-gb',null,SendCommandVO.QUEUE));
		}
		
		/**
		 * 添加背景音乐，根据musicid查重
		 * @param music
		 * 必要信息musicid,musicName,relativePath
		 */		
		private function addBgMusic(music:BackgroundMusicVO):void{
			if(music==null ) return;
			PackData.app.CmdIStr[0] = CmdStr.ADD_BGMUSIC;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdIStr[2] = music.id;
			PackData.app.CmdIStr[3] = music.name;
			PackData.app.CmdIStr[4] = music.path;
			PackData.app.CmdInCnt = 5;
			sendNotification(CoreConst.SEND_1N,new SendCommandVO(ADDBGMUSIC,null,'cn-gb',null,SendCommandVO.QUEUE));
		}
	}
}