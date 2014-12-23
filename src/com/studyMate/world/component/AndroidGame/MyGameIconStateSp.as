package com.studyMate.world.component.AndroidGame
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.controller.MutiCharaterControllerMediator;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.InstallAppCommandVO;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.screens.AndroidGameShowMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.ProgressBar;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class MyGameIconStateSp extends Sprite
	{
		private var gamevo:AndroidGameVO;
		
		private var holder:Sprite;
		
		public function MyGameIconStateSp(_gamevo:AndroidGameVO)
		{
			gamevo = _gamevo;
			name = gamevo.gameName;
			
			holder = new Sprite;
			addChild(holder);
			
			
			addEventListener(Event.ADDED_TO_STAGE, showbyType);
		}
		
		
		
		private function showbyType(e:Event):void{
			//显示背景
			var statebg:Image = new Image(Assets.getAndroidGameTexture("iconStateBg"));
			holder.addChild(statebg);
			
			
			
			//下载
			if(gamevo.state == "down"){
				
				showDownload();
				
//				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.MANUAL_LOADING,false);
				//禁屏
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_MODAL,true);
				
				//文件不存在，请求下载
				if(!Global.document.resolvePath(Global.localPath+"game/"+gamevo.apkName).exists)
					Facade.getInstance(CoreConst.CORE).sendNotification(AndroidGameShowMediator.APPLY_DOWNLOAD,parent.parent as MyGameItem);
				else{
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SET_MODAL,false);
					
					(parent.parent as MyGameItem).updateItemState("down");
					removeFromParent(true);
				}
				
			}else if(gamevo.state == "install"){
				//安装
				
				showInstall();
				
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DIALOGBOX_SHOW,
					new DialogBoxShowCommandVO(stage,640,381,null,"正在努力安装 \""+(parent.parent as MyGameItem).gameVo.gameName+"\" ，请耐心等待...",null));
				
					
				TweenLite.delayedCall(0.5,sendApplyInstall,[parent.parent as MyGameItem]);
			}
		}
		
		private function sendApplyInstall(_item:MyGameItem):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(AndroidGameShowMediator.APPLY_INSTALL,_item);
		}
		private function cancelInstall():void{
			(parent.parent as MyGameItem).updateItemState("install");
			removeFromParent(true);
		}
		
		private var proValue:Vector.<Number>;
		private var proBar:ProgressBar;
		private var proTF:TextField;
		private function showDownload():void{
			proBar = new ProgressBar();
			proBar.minimum = 0;
			proBar.maximum = 100;
			proBar.value = 0;
			proBar.width = 63;
			holder.addChild(proBar);
			proBar.x = (holder.width-proBar.width)>>1;
			proBar.y = 53;
			
			
			
			//progressBar换肤
			var fillTexture:Scale9Textures = new Scale9Textures(Assets.getAndroidGameTexture("iconStateProbarFill"),new Rectangle(1,0,2,5));
			proBar.backgroundSkin = new Image(Assets.getAndroidGameTexture("iconStateProbarBg"));
			var fillSkin:Scale9Image = new Scale9Image(fillTexture);
			fillSkin.width = 4;
			proBar.fillSkin = fillSkin;
			
			
		}
		
		//控制进度条
		public function setProBar(_total:int = -1,_process:int=0):void{
			if(_total != -1){
				proBar.minimum = 0;
				proBar.maximum = _total;
				
				proBar.value = 0;
			}
			
			if(_process != 0){
				proBar.value = _process;
				
				/*trace((_process/proBar.maximum)+"%");*/
			}
		}
		
		
		
		private function showInstall():void{
			
			var tips:Image = new Image(Assets.getAndroidGameTexture("iconStateInstall"));
			tips.x = ((holder.width - tips.width)>>1);
			tips.y = 53;
			holder.addChild(tips);
			
			
		}
		
		
		
		
		
		
		
		
		
		
		override public function dispose():void
		{
			super.dispose();
			TweenLite.killTweensOf(sendApplyInstall);
			
			removeEventListener(Event.ADDED_TO_STAGE, showbyType);
			
			removeChildren(0,-1,true);
			
			
		}
		
		
		
		
		
		
		
	}
}