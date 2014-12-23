package com.studyMate.module.engLearn
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * 对用户能力进行评级，首页。进行需要评测的项目
	 * @author wt
	 * 
	 */	
	public class IndexTestLearnMediator extends ScreenBaseMediator
	{
		public function IndexTestLearnMediator(viewComponent:Object=null)
		{
			super(ModuleConst.INDEX_TEST_LEARNING, viewComponent);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			view.removeChildren(0,-1,true);
		}
		override public function onRegister():void
		{
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			var texture:Image = new Image(Assets.getTexture("indexRateBg"));
			texture.blendMode = BlendMode.NONE;
			texture.touchable = false;
			view.addChild(texture);	
			
			
			var wordLearn:Button = new Button(Assets.getEgAtlasTexture("word/rateWordLearnBtn"));
			wordLearn.x = 112;
			wordLearn.y = 200;
			view.addChild(wordLearn);
			wordLearn.addEventListener(Event.TRIGGERED,wordLearnTestHandler);
			
			var readLearn:Button = new Button(Assets.getEgAtlasTexture("word/rateReadLearn"));
			readLearn.x = 697;
			readLearn.y = 200;
			view.addChild(readLearn);	
			readLearn.addEventListener(Event.TRIGGERED,readLearnTestHandler);
		}
		
		private function readLearnTestHandler():void
		{
//			sendNotification(CoreConst.TOAST,new ToastVO('抱歉，阅读测评尚未开放'));

			var data:Object={};
			data.type = 'read';
			data.file = Global.document.resolvePath(Global.localPath+"userTestLearn/bbb");
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestLearnListMediator,data)]);
			
			

		}
		
		private function wordLearnTestHandler():void
		{

			var data:Object={};
			data.type = 'word';
			data.file = Global.document.resolvePath(Global.localPath+"userTestLearn/aaa");
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(TestLearnListMediator,data)]);
			

		}
		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests();
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		
	}
}