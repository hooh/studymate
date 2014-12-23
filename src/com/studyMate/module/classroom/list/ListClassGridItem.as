package com.studyMate.module.classroom.list
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.module.classroom.ClassroomMediator;
	import com.studyMate.module.classroom.CroomVO;
	import com.studyMate.world.component.gridList.IGridItem;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	public class ListClassGridItem extends Sprite implements IGridItem
	{
		public var introduceTxt:TextField;//简介
		
		public var teacherTxt:TextField;//辅导老师
		
		public var dateTxt:TextField;//日期
		
		public var bgBtn:Image;
		
		private var _data:Object;
		
		public function ListClassGridItem()
		{
			bgBtn = new Image(Assets.getListClassTexture("CRItemBg"));
			this.addChild(bgBtn);
			
			introduceTxt = new TextField(166,110,'','HeiTi',18,0xAF5D14);
			introduceTxt.x = 28;
			introduceTxt.y = 22;
			introduceTxt.hAlign = HAlign.LEFT;
			introduceTxt.autoSize = TextFieldAutoSize.VERTICAL;
			introduceTxt.touchable = false;
			this.addChild(introduceTxt);
			
			teacherTxt = new TextField(166,23,'','HeiTi',14,0x1857907);
			teacherTxt.x = 28;
			teacherTxt.y = 130;
			teacherTxt.hAlign = HAlign.RIGHT;
			teacherTxt.touchable = false;
			this.addChild(teacherTxt);
			
			dateTxt = new TextField(166,23,'','HeiTi',17,0x73591C);
			dateTxt.x = 28;
			dateTxt.y = 146;
			teacherTxt.hAlign = HAlign.CENTER;
			dateTxt.touchable = false;
			this.addChild(dateTxt);
		}
		
		public function get data():Object
		{
			return _data;
		}

		
		public function set data(value:Object):void
		{
			this._data = value;
			this.introduceTxt.text = (value as CroomVO).qtype + '\n习题辅导'+(value as CroomVO).qids.split(',').length+ '题';
			this.teacherTxt.text = '辅导老师id:'+(value as CroomVO).tid;
			this.dateTxt.text = MyUtils.dateFormat((value as CroomVO).startDate);
			
			this.addEventListener(TouchEvent.TOUCH,enterHandler);
		}
		
		private var beginX:Number;
		private var endX:Number;
		protected function enterHandler(event:TouchEvent):void
		{
			
			var touchPoint:Touch = event.getTouch(this);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
						if(this._data){
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ClassroomMediator,this.data)]);

						}
					}
				}
			}
		}
	}
}