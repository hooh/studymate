package com.studyMate.world.pages
{
	import com.edu.EduAllExtension;
	import com.greensock.TweenLite;
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.AndroidGameMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.errors.IOError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class AndroidGameItem extends Sprite
	{
		private const Play_Game_Time:String = "PlayGameTime";
		
		private var bg:Image;
		private var textField:TextField;
		private var file:File;
		private var packName:String;
		private var gameName:String;
		private var installGameList:String;
		private var tf:TextFormat = new TextFormat(null,15);
		private var bitdata:BitmapData = new BitmapData(100,95,true,0x00000000); //游戏图标位图数据
		
		private var lauchBtn:Button;
		private var delBtn:Button;


		public function AndroidGameItem(apkFile:File,bg:Image=null)
		{
			file = apkFile;
			this.bg = bg;
			
			gameName = file.name.substring(0,file.name.indexOf("&")); //游戏名称
			packName = file.name.substring(file.name.indexOf("&")+1,file.name.lastIndexOf(".")); //包名
			
			textField = new TextField(100,20,"","HuaKanT",15);
			textField.hAlign = HAlign.CENTER;
			textField.y = 75;

			installGameList = EduAllExtension.getInstance().getInstalledPackagesFunction();
			
			doShow();
			
			addEventListener(TouchEvent.TOUCH,touchHandle);
			
		}
		
		private function doShow():void{	
			var sp:Sprite = new Sprite;
			bg.x = 14;
			sp.addChild(bg);
			
			sp.addChild(textField);
			
			textField.text = gameName;
			
			if(!listAppHandle(packName))//游戏未安装	
				bg.alpha = 0.5;
			addChild(sp);
			
			
			lauchBtn = new Button();
			lauchBtn.name = "lauchBtn";
			lauchBtn.label = "启动";
			lauchBtn.y = 75;
			lauchBtn.addEventListener(Event.TRIGGERED,btnHandle);
			addChild(lauchBtn);
			
			delBtn = new Button();
			delBtn.name = "delBtn";
			delBtn.label = "删除";
			delBtn.x = 60;
			delBtn.y = 75;
			delBtn.addEventListener(Event.TRIGGERED,btnHandle);
			addChild(delBtn);
			hideBtn();
		}
		private function btnHandle(event:Event):void{
			var btn:Button = event.target as Button;
			//启动
			if(btn.name == "lauchBtn"){
				//判断是常用app，还是游戏
				if(isNormalApp(packName)){
					//禁屏，避免多次点击
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_MODAL,true);
					
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(this.stage,640,381,null,"正在为您打开应用。"));
					GameStart();
				}
				else{
					
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.MANUAL_LOADING,true);
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_MODAL,true);
					
					//禁用上一个运行的游戏
					//rootExecuteExtension.execute("pm disable "+setGameName(packName));
					EduAllExtension.getInstance().rootExecuteExtension("pm disable "+setGameName(packName));
					
					if(Global.bgGameTime >= 900){
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
							new DialogBoxShowCommandVO(this.stage,640,381,null,"你有 "+Global.bgGameTime/60+" 分钟的游戏时间。"));
						
						
						GameStart();
					}else{
						
						
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.GET_PLAY_GAME_TIME,[gameName,packName]);
					}
				}
			}else{
				//删除
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(this.stage,640,381,doDel,"确定删除该游戏？"));
				
			}
		}
		private function doDel():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(AndroidGameMediator.Del_Game,[gameName,packName]);
		}
		private function showBtn():void{
			lauchBtn.visible = true;
			delBtn.visible = true;
		}
		private function hideBtn():void{
			lauchBtn.visible = false;
			delBtn.visible = false;
		}

		private var beginX:Number;
		private var endX:Number;
		private function touchHandle(event:TouchEvent):void
		{
			var touchPoint:Touch = event.getTouch(this);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
						TweenLite.killTweensOf(hideBtn);
						showBtn();
						
						TweenLite.delayedCall(2,hideBtn);
					}
					
				}
			}
		}
		
		private function isNormalApp(appName:String):Boolean{
			try{
				var norAppFile:File = Global.document.resolvePath(Global.localPath+"command/normalAppList.dat");
				var stream:FileStream = new FileStream();
				stream.open(norAppFile,FileMode.READ);
				var norAppList:String = stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
				
				if(norAppList.indexOf(appName) != -1)	return true;
				else return false;
			}catch(error:Error){
				
			}
			return false;
		}
		
		private function setGameName(gamename:String):String{
			var pgamename:String = "";
			var file:File = Global.document.resolvePath("Android/data/pregame.txt");
			var fileStream:FileStream = new FileStream();
			
			try{
				fileStream.open(file,FileMode.READ);
				if(fileStream.bytesAvailable != 0){
					pgamename = fileStream.readUTFBytes(fileStream.bytesAvailable);
				}
				fileStream.close();
			}catch(e:IOError){
				
			}
			
			if(gamename == pgamename){
				pgamename = "";
			}else{
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeUTFBytes(gamename);
				fileStream.close();
			}
			return pgamename;
		}
		
		/**
		 *判断packagename游戏是否已经安装
		 * @param packagename
		 * @return 
		 * 
		 */		
		private function listAppHandle(packagename:String):Boolean {
			if(installGameList.indexOf(packagename) >= 0)
				return true;
			else
				return false;
		}
		private function GameStart():void{
			
			
			if(!listAppHandle(packName)) { //游戏未安装				
				//var apk:ApkExecuteExtension = new ApkExecuteExtension(); //获取apk程序名
				
				if(gameName != "")
					//apk.execute(Global.document.nativePath + "/" + Global.localPath + "game/" + gameName + "&" + packName + ".apk");
					EduAllExtension.getInstance().apkExecuteExtension(Global.document.nativePath + "/" + Global.localPath + "game/" + gameName + "&" + packName + ".apk");
				else
					EduAllExtension.getInstance().apkExecuteExtension(Global.document.nativePath + "/" + Global.localPath + "game/" + packName + ".apk");
				
				TweenLite.delayedCall(2,callApp,[""]);
			} else { //程序已安装，直接启动
				//rootExecuteExtension.execute("pm enable "+ packName);
				EduAllExtension.getInstance().rootExecuteExtension("pm enable "+ packName);
				TweenLite.delayedCall(2,callApp,[packName]);				
			}
		}
		private function callApp(appName:String):void {
			//lauapk.execute(appName,"call");
			Global.isUserExit = true;
			EduAllExtension.getInstance().launchAppExtension(appName,"call");
			NativeApplication.nativeApplication.exit();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeChildren(0,-1,true);
			
			TweenLite.killTweensOf(hideBtn);
		}
	}
}