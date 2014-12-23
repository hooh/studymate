package com.studyMate.world.pages
{
	import com.edu.EduAllExtension;
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.vo.GameListInfoVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class GameMarketItem extends Sprite
	{
		private const Play_Game_Time:String = "PlayGameTime";
		
		private var bg:Image;
		private var textField:TextField;
		
		private var btn:Button;
		
		private var packName:String;
		private var gameName:String;
		private var opoint:String;
		private var loaders:Loader = new Loader();
		private var installGameList:String;
//		private var getActName:GetInstalledPackagesFunction;
//		private var rootExecuteExtension:RootExecuteExtension;
//		private var lauapk:LaunchAppExtension;	
		private var tf:TextFormat = new TextFormat(null,15);
		private var bitdata:BitmapData = new BitmapData(100,95,true,0x00000000); //游戏图标位图数据
		private var sp:flash.display.Sprite = new flash.display.Sprite(); //游戏图标、名称sprite

		private var glist:GameListInfoVO;
		
		private var tapDown:Boolean;
		private var texture:Texture;

		public function GameMarketItem(_glsist:GameListInfoVO)
		{
			glist = _glsist;
			gameName = glist.gname; //游戏名称
			packName = glist.pname; //包名
			opoint = glist.opoint; //开启游戏金钱
			
			textField = new TextField();
			tf.align = TextFormatAlign.CENTER;
			textField.defaultTextFormat = tf;
			textField.width = 100;
			textField.height= 20;
			textField.y = 75;
			
			
			
			
//			getActName = new GetInstalledPackagesFunction();//取得安装包
//			installGameList = getActName.execute();//遍历所有已安装程序的包，查看制定程序是否已安装
//			rootExecuteExtension = new RootExecuteExtension();//取得其命令行
//			lauapk = new LaunchAppExtension();//运行游戏
			
			installGameList = EduAllExtension.getInstance().getInstalledPackagesFunction();;//遍历所有已安装程序的包，查看制定程序是否已安装

			loaders.contentLoaderInfo.addEventListener(Event.COMPLETE,LoaderComHandler);
//			loaders.load(new URLRequest(Global.document.resolvePath(Global.localPath + "game/" + gameName + "." + packName + ".png").url));
			loaders.load(new URLRequest(Global.document.resolvePath(Global.localPath + "game/" + packName + ".png").url));

			
		}
		
		private function LoaderComHandler(event:Event):void{	
			var bit:Bitmap=Bitmap(event.target.content);

			bit.x = 14;
			sp.addChild(bit);

			bitdata.draw(sp);
			texture = Texture.fromBitmap(new Bitmap(bitdata),false);
			bg = new Image(texture);
			if(!listAppHandle(packName))//游戏未安装	
				bg.alpha = 0.5;
			addChild(bg);
			
			btn = new Button();
			btn.name = packName+".apk";
			btn.label = "RMB "+opoint;
			btn.y = 75;
			btn.addEventListener(TouchEvent.TOUCH,btnHandle);
			addChild(btn);
		}
		private function listAppHandle(packagename:String):Boolean {
			if(installGameList.indexOf(packagename) >= 0)
				return true;
			else
				return false;
		}
		
		
		private function btnHandle(event:TouchEvent):void{
			var touch:Touch = event.getTouch(event.target as DisplayObject,TouchPhase.ENDED);
			if(touch){
				
				if(btn.label == "Loading..."){
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(this.stage,640,381,null,"该游戏正在下载，请耐心等候..."));
				}else if(btn.label == "Have Load"){
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(this.stage,640,381,null,"游戏已经购买了，不要乱花钱哦"));
				}else{
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
						new DialogBoxShowCommandVO(this.stage,640,381,buyClickHandle,"轻敲\"确认\"确认购买。"));
				}
			}
		}
		private function buyClickHandle():void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.OPEN_GAME,[packName,btn]);	//开启游戏	
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			removeChildren(0,-1,true);
			
			texture.dispose();
		}
		
		

	}
}