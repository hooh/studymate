package com.studyMate.global
{
	import com.studyMate.db.schema.Player;
	import com.studyMate.model.vo.LicenseVO;
	import com.studyMate.model.vo.RootInfoVO;
	import com.studyMate.model.vo.TimeLimitVo;
	import com.studyMate.world.model.vo.DressSuitsVO;
	import com.studyMate.world.model.vo.PromiseInf;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.media.SoundChannel;
	import flash.system.Worker;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	

	public final class Global
	{
		private static var _user:String="";
		private static var _password:String;
		public static var region:String;
		private static var _hasLogin:Boolean;
		public static var isLoading:Boolean;
		public static var isBusy:Boolean;
		private static var _license:LicenseVO;
		
		
		public static var booted:Boolean;
		
		public static var isEmail:Boolean;
		public static var savePassword:String = "false"
		
		public static const stageWidth:Number = 1280;
		public static const stageHeight:Number = 752;
		public static var networkId:int;
		
		public static var stage:Stage;
		public static var root:DisplayObject;
		
		private static var _player:Player;
		public static var goldNumber:int;
		
		public static var isFirstSwitch:Boolean;
		
		public static var isBeating:Boolean;
		
		public static var isUserExit:Boolean;//用户主动退出
//		public static var mapsLocation:Object={};
		
		[Bindable]
		public static var bgGameTime:int;
		
		public static var appRootVo:RootInfoVO = new RootInfoVO;
		
		
		
		/**
		 *标记进入或退出地图 true为进入,false为退出 
		 */		
		public static var mapsDircetion:Boolean;
		
		
		public static var OS:String;
				
		/**
		 * 附加登录次数
		 */		
		public static var cntsocket:uint = 0;
		
		
		public static var serverPath:String = "/usr1/snet/swf/";
		
		public static var localPath:String = "edu/";
		
		public static var document:File = File.documentsDirectory;
		public static var appName:String;
		public static var appVersion:String;
		
		private static var _nowDate:Date = new Date;
		public static var nowSec:Number;
		private static var lastGetDateTime:int;
		
		
		public static var initialized:Boolean;
		
		public static var guideVersion:String;
		
		private static var _packSize:int=16;
		
		public static const fixUserName:String = "default";
		public static const fixUserPSW:String = "cpyfcpyf";
		
		public static var playerNum:int;
		public static var welcomeInit:Boolean;
		public static var unreadMessage:Boolean;
		
		//用户连续学习等级跟天数
		public static var conDay:Number;
		
		//主角装备字符串
		public static var myDressList:String = "";
		//服务器装备信息
		public static var dressDatalist:Vector.<DressSuitsVO> = new Vector.<DressSuitsVO>;
		
		public static var myLevel:int = 0;
		
		public static var timeLimitVo:TimeLimitVo;
		
		private static var _use3G:Boolean;
		
		
		public static var manualLoading:Boolean;
		
		public static var _mp3IsRunning:Boolean=false;//关屏判断有用。
		public static var activate:Boolean;
		public static var isStartupShowing:Boolean;
		
		public static var shareParameters:Dictionary = new Dictionary;
		
		public static var address:String;	//mac地址
		
		public static var mainThread:Worker;
		
		public static var loopSound:SoundChannel;
		
		public static var hadRecordView:Boolean = false;
		
		public static var packSizeB:String;
		{
			packSizeKB=16;
		}
		
		public static function getSharedProperty(key:String):*{
			if(mainThread){
				return mainThread.getSharedProperty(key);
			}else{
				return shareParameters[key];
			}
		}
		
		public static function setSharedProperty(key:String,value:*):void{
			if(mainThread){
				mainThread.setSharedProperty(key,value);
			}else{
				shareParameters[key]=value;
			}
		}
		

		public static function get license():LicenseVO
		{
			return getSharedProperty("license");
		}

		public static function set license(value:LicenseVO):void
		{
			setSharedProperty("license",value);
		}


		public static function get password():String
		{
			return getSharedProperty("password");
		}

		public static function set password(value:String):void
		{
			setSharedProperty("password",value);
		}
		

		public static function get user():String
		{
			return getSharedProperty("user");
		}

		public static function set user(value:String):void
		{
			setSharedProperty("user",value);
		}

		public static function get player():Player
		{
			return _player;
		}

		public static function set player(value:Player):void
		{
			_player = value;
		}
		

		public static function get hasLogin():Boolean
		{
			
			return getSharedProperty("hasLogin");
		}

		public static function set hasLogin(value:Boolean):void
		{
			setSharedProperty("hasLogin",value);
		}

		public static function get isSwitching():Boolean
		{
			return _isSwitching;
		}

		public static function set isSwitching(value:Boolean):void
		{
			_isSwitching = value;
		}

		public static function get use3G():Boolean
		{
			return _use3G;
		}

		public static function set use3G(value:Boolean):void
		{
			_use3G = value;
		}

		public static function get nowDate():Date
		{
			_nowDate.milliseconds+=getTimer()-lastGetDateTime;
			lastGetDateTime = getTimer();
			
			//有权限，则直接返回系统时间；无权限，则用程序计时
			if(appRootVo.studyMateRoot == "Root")
				return new Date;
			return new Date(_nowDate.time);
		}

		public static function set nowDate(value:Date):void
		{
			_nowDate.time = value.time;
			lastGetDateTime  = getTimer();
		}

		public static function get packSizeKB():int
		{
			return _packSize;
		}

		public static function set packSizeKB(value:int):void
		{
			_packSize = value;
			packSizeB = (packSizeKB*1024 - 300).toString();
		}
		
		public static var myPromiseInf:PromiseInf;
		private static var _isSwitching:Boolean;
		public static var msgMap:Array;
		
		public static var widthScale:Number;
		public static var heightScale:Number;

	}
}