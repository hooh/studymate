package com.studyMate.module.classroom.view
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.classroom.DrawBoardMediator;
	import com.studyMate.world.component.weixin.interfaces.IDropDownView;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	/**
	 * note
	 * 2014-6-5下午3:00:37
	 * Author wt
	 *
	 */	
	
	public class CRDropDownView extends Sprite implements IDropDownView
	{
		private var cameraBtn:Button;
		private var shareBoardBtn:Button;
		
		public function CRDropDownView()
		{
			var bg:Quad = new Quad(560,142,0xD9D9D9);
			this.addChild(bg);
			
			cameraBtn = new Button(Assets.getCnClassroomTexture("cameraBtn"));
			cameraBtn.x = 33;
			cameraBtn.y = 28;
			this.addChild(cameraBtn);
			
			shareBoardBtn = new Button(Assets.getCnClassroomTexture("shareBtn"));
			shareBoardBtn.x = 134;
			shareBoardBtn.y = 28;
			this.addChild(shareBoardBtn);
			
			
			shareBoardBtn.addEventListener(Event.TRIGGERED,shareBoardHandler);

		}
		
		
		private function shareBoardHandler():void
		{
			if(Facade.getInstance(CoreConst.CORE).hasMediator(DrawBoardMediator.NAME)){
				Facade.getInstance(CoreConst.CORE).sendNotification(DrawBoardMediator.HIDE_DRAWBOARD);
			}else{				
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(DrawBoardMediator,null,SwitchScreenType.SHOW)]);
			}
		}
		
		public function get cameraDisplayObject():DisplayObject{
			return cameraBtn;
		}
		
		
		public function get shareBoardplayObject():DisplayObject{
			return shareBoardBtn;
		}
	}
}