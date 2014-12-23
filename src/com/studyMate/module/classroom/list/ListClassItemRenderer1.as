package com.studyMate.module.classroom.list
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.module.classroom.ClassroomMediator;
	import com.studyMate.module.classroom.CroomVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	
	/**
	 * 学生已辅导的list
	 * @author wt
	 * 
	 */	
	public class ListClassItemRenderer1 extends BaseListItemRenderer
	{
		private var bgImg:Image;
		private var enterBtn:Button;
		private var introduceTxt:TextField;//简介
		private var dateTxt:TextField;//日期
		private var timeTxt:TextField;//时间
		private var countdownTxt:TextField;//倒计时
		
		public function ListClassItemRenderer1()
		{
			super();
		}
		override public function dispose():void
		{
			this.removeChildren(0,-1,true);
			super.dispose();
		}
		
		override protected function initialize():void
		{
			bgImg = new Image(Assets.getListClassTexture("crIntroduceBg"));
			bgImg.x = 97;
			bgImg.y = 17;
			bgImg.touchable = false;
			this.addChild(bgImg);
			
			enterBtn = new Button(Assets.getListClassTexture("enterCrBtn"));
			enterBtn.x = 491;
			enterBtn.y = 413;
			this.addChild(enterBtn);
			
			introduceTxt = new TextField(293,288,'','HeiTi',20,0xBFBFBE,true);
			introduceTxt.x = 744;
			introduceTxt.y = 151;
			introduceTxt.hAlign = HAlign.LEFT;
			introduceTxt.autoSize = TextFieldAutoSize.VERTICAL;
			introduceTxt.touchable = false;
			this.addChild(introduceTxt);
			
			dateTxt = new TextField(210,56,'','HeiTi',36,0xE56619);
			dateTxt.x = 409;
			dateTxt.y = 183;
			dateTxt.touchable = false;
			this.addChild(dateTxt);
			
			timeTxt = new TextField(240,32,'','HeiTi',25,0x198D24);
			timeTxt.x = 404;
			timeTxt.y = 240;
			timeTxt.touchable = false;
			this.addChild(timeTxt);
			
			countdownTxt = new TextField(342,32,'','HeiTi',25,0xB7E8FF);
			countdownTxt.x = 359;
			countdownTxt.y = 332;
			countdownTxt.touchable = false;
			countdownTxt.autoScale = true;
			this.addChild(countdownTxt);
			
			enterBtn.addEventListener(Event.TRIGGERED,enterHandler);
			
		}
		
		private function enterHandler():void
		{
			if(this._data){
				
				Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ClassroomMediator,this._data)]);
			}
		}
		override protected function commitData():void
		{
			if(this._data)
			{
				var baseClass:CroomVO = this._data as CroomVO;
				introduceTxt.text = '辅导老师Id:'+ baseClass.tid +'\n房间名称:'+baseClass.crname+' id:'+baseClass.crid+'\n房间描述:'+ baseClass.crdes;
				
				dateTxt.text = (baseClass.startDate.month+1)+'月'+baseClass.startDate.date+'日';
				
				timeTxt.text = baseClass.startDate.hours+':'+baseClass.startDate.minutes;
				
				countdownTxt.text = '距离辅导时间'+baseClass.surplusTips;
			}
			width = Global.stageWidth;
		}
	}
}