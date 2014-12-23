package com.studyMate.controller
{
	import com.mylib.api.IConfigProxy;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.testGame.TestGameMediator;
	import com.studyMate.global.Global;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.component.rewardAnimation.RAnimationMediator;
	import com.studyMate.world.screens.LsjTestMediator;
	import com.studyMate.world.screens.TestFightGameMediator;
	import com.studyMate.world.screens.TestRunerGameMediator;
	import com.studyMate.world.screens.WordCardScreen;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.WorldMediator;
	import com.studyMate.world.screens.email.EmailViewMediator;
	import com.studyMate.world.screens.wordcards.GotoWordCardMediator;
	import com.studyMate.world.screens.wordcards.RememberWordCardMediator;
	import com.studyMate.world.screens.wordcards.UnrememberWordCardMediator;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.gestouch.core.Gestouch;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester;
	import org.gestouch.input.NativeInputAdapter;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	public class SwitchFirstScreenCommand extends SimpleCommand
	{
		public function SwitchFirstScreenCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			if(!Gestouch.inputAdapter){
				Gestouch.inputAdapter = new NativeInputAdapter(Global.stage);
				Gestouch.addDisplayListAdapter(starling.display.DisplayObject, new StarlingDisplayListAdapter());
				Gestouch.addTouchHitTester(new StarlingTouchHitTester(Starling.current), -1);
			}
			
			//不登录，直接进入英语岛
			if(!Global.user){
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EnglishIslandMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BattleFieldMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EngTaskIslandMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WorldMapMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CardGameMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HouseEditorMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(NPCEditorMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IslandEditorMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(GameTaskEditorMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SVGTestMediator),new SwitchScreenVO(CleanGpuMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IslandsMapMediator),new SwitchScreenVO(CleanCpuMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CharaterEditorMediator)]);
				return;
			}
			

			if(Global.myDressList == ""  || !Global.myDressList){
//			if(createCharaterOrNot())
				/*sendNotification(WorldConst.SHOW_PERSONALINFO,"true");*/
				
				//默认装备
				Global.myDressList = "face_face1,defaultset";
			}
//			else{

				
				sendNotification(CoreConst.HIDE_STARUP_INFOR);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(EmailViewMediator)]);
				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(WorldMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(UnrememberWordCardMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestFightGameMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestRunerGameMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestGameMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(RAnimationMediator)]);
//				sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(LsjTestMediator)]);
//				if(guideOrNot()){
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(GuideMediator, guidesArray)]);
//				}else{
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestFightGameMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(GameSceneMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IslandsMapMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(IndexMusicMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(MarketViewMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(HappyIslandMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(CharaterEditorMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(AndroidGameMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(GameMarketMediator)]);
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ExecuteScriptViewMediator),new SwitchScreenVO(CleanGpuMediator)]);
					
//					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(BenchMarkViewMediator)]);
//				}
//			}
		}
		
		private var guidesArray:Array;
		
		private function guideOrNot():Boolean{
			var configProxy:IConfigProxy = Facade.getInstance(CoreConst.CORE).retrieveProxy(ModuleConst.CONFIGPROXY)  as IConfigProxy;
			var selfGuideVer:String = configProxy.getValueInUser("guideVersion");
			try{
				var airVersionFile:File = Global.document.resolvePath(Global.localPath+"Guide.ver");
				var stream:FileStream = new FileStream();
				stream.open(airVersionFile,FileMode.READ);
//				var abc:String = stream.readUTFBytes(stream.bytesAvailable);
				var bytes:ByteArray = new ByteArray();
				stream.readBytes(bytes);
				var fileText:String = bytes.toString();
				fileText = fileText.replace(/\n/g,"");
				guidesArray = fileText.split(";");
				var sysGuideVer:String = guidesArray[0];
				stream.readBytes(bytes);
				stream.close();
				Global.guideVersion = sysGuideVer;
			}catch(error:Error){
				return false;
			}
			if(sysGuideVer == selfGuideVer) return false;
			
			return true;
		}
		
	}
}