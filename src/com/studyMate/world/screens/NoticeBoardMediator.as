package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.RecordVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.SysNoticeVO;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class NoticeBoardMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "NoticeBoardMediator";
		private static const QRY_PLAY_BRD:String = NAME + "QryPlayBrd";

		private var timePlaying:Boolean = false;
		private var viewPlaying:Boolean = false;
		
		private var noticList:Vector.<SysNoticeVO> = new Vector.<SysNoticeVO>;	//后台数据
		private var viewList:Vector.<SysNoticeVO> = new Vector.<SysNoticeVO>;	//显示队列
		private var timeList:Vector.<SysNoticeVO> = new Vector.<SysNoticeVO>; 	//计时队列
		private var playedList:Vector.<SysNoticeVO> = new Vector.<SysNoticeVO>;	//已经播放过的列表
		
		
		public function NoticeBoardMediator(){
			super(NAME, new Sprite);
		}
		override public function onRegister():void{
			
			initUI();
			
		}
		override public function handleNotification(notification:INotification):void
		{
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleNotification "+notification.getName(),"handleNotification",0));

			var result:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case QRY_PLAY_BRD:
					if(!result.isEnd){
						
						var noticVo:SysNoticeVO = new SysNoticeVO;
						noticVo.id = PackData.app.CmdOStr[1];
						noticVo.level = PackData.app.CmdOStr[2];
						noticVo.text = PackData.app.CmdOStr[3];
						
						//解析广播控制字段-level
						var lev:Array = noticVo.level.split(";");
						if(lev[0])	noticVo.priority = lev[0];
						if(lev[1])	noticVo.times = lev[1];
						if(lev[2])	noticVo.delay = lev[2];
						noticVo.delayCount = noticVo.delay;
						
						noticList.push(noticVo);
					}else{
						//公告显示时，才进行播放
						currentIdx = tips;
						push2Viewlist();
					}
					break;
				case WorldConst.BROADCAST_SYS:
					
					tips = notification.getBody() as String;
					trace("公告栏提示："+tips);
					
					//后台id不同于本地，并且公告栏是显示的，则向后台取公告
					if(currentIdx != tips){
						
						getNotice();
						
					}
					break;
			}
			
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("handleNotification e","handleNotification",0));

		}
		override public function listNotificationInterests():Array
		{
			return [QRY_PLAY_BRD,WorldConst.BROADCAST_SYS];
		}
		
		private var tips:String = "";
		private var currentIdx:String = "0";
		private var textLabel:Label;
		private var modelTF:TextField;	//用来定位文本框textTF长度
		private function initUI():void{
			var bg:Image = new Image(Assets.getAtlasTexture("noticeBoard/notBg"));
			bg.x = 405;
			bg.y = 99;
			view.addChild(bg);
			
			var sp:Sprite = new Sprite;
			sp.clipRect = new Rectangle(430,100,400,25);
			view.addChild(sp);
			
			textLabel = new Label;
			textLabel.x = 420;
			textLabel.y = 100;
//			textLabel.textRendererProperties.textFormat = new TextFormat( "HeiTi", 15, 0xffffff );
//			textLabel.textRendererProperties.embedFonts = true;
//			textLabel.textRendererProperties.nativeFilters = [new DropShadowFilter(1,90,0,0.75,0,0,10)];
//			textLabel.textRendererFactory = defaultFactory;

			textLabel.textRendererFactory = function():ITextRenderer
				 {
					     return new TextFieldTextRenderer;
					 }
//			var boldFontDescription:FontDescription = new FontDescription("HeiTi",FontWeight.BOLD,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
//			textLabel.textRendererProperties.elementFormat = new ElementFormat(boldFontDescription, 15, 0xffffff);
			textLabel.textRendererProperties.textFormat = new TextFormat( "HeiTi", 15, 0xffffff );
			textLabel.textRendererProperties.embedFonts = true;
			textLabel.textRendererProperties.isHTML = true;
			
//			textLabel.textRendererProperties.border = true;
			sp.addChild(textLabel);
			modelTF = new TextField(1000,25,"","HeiTi",15,0);
			modelTF.hAlign = HAlign.LEFT;
			
//			view.visible = false;
			view.alpha = 0;
			view.touchable = false;
			view.y = -90;
			view.x = 100;
			view.addEventListener(TouchEvent.TOUCH,viewTouchHandle);
		}
//		private var defaultFactory:Function = function():ITextRenderer{
//			return new TextFieldt;
//		}
		
		private var viewStandAlpha:Number = 1;
		private function viewTouchHandle(e:TouchEvent):void{
			var touch:Touch = e.getTouch(view);				
			if(touch){
				if(touch.phase==TouchPhase.BEGAN){
					TweenLite.killTweensOf(view);
					TweenLite.delayedCall(0.1,setViewAlpha);
					
				}else if(touch.phase==TouchPhase.ENDED){
					TweenLite.killTweensOf(setViewAlpha);
					
					viewStandAlpha = 1;
					viewDisplay(true);
				}
			}
		}
		private function setViewAlpha():void{
			viewStandAlpha = 0.3;
			view.alpha = 0.3;
			view.touchable = true;
		}
		
		//将更新的公告列表存入到显示列表中
		private function push2Viewlist():void{
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("push2Viewlist s","handleNotification",0));

			TweenLite.killTweensOf(checkTimeList);
			
			//全部重置为已经不存在
			for (var i:int = 0; i < viewList.length; i++)
				viewList[i].isHad = false;
			for (i = 0; i < timeList.length; i++)
				timeList[i].isHad = false;
			
			
			
			var _viewIdx:int = -1;
			var _timeIdx:int = -1;
			for (i = 0; i < noticList.length; i++) 
			{
				//如果已经播放过，则不在播放
				if(isPlayedlistHad(noticList[i].id) != -1)
					continue;
				
				var isOld:Boolean = false;
				
				//如果显示列表 /计时列表有，则不需处理，继续队列循环；
				_viewIdx = isViewlistHad(noticList[i].id);
				if(_viewIdx != -1){
					isOld = true;
					viewList[_viewIdx].isHad = true;
				}else{
					_timeIdx = isTimelistHad(noticList[i].id);
					if(_timeIdx != -1){
						isOld = true;
						timeList[_timeIdx].isHad = true;
					}
				}
				
				//新加入的公告，则直接插入显示列表
				if(!isOld){
					noticList[i].isHad = true;
					viewList.push(noticList[i]);
				}
			}
			
			
			//如果公告已经不存在则从显示列表、计时列表删除
			for (i = viewList.length-1 ; i >= 0; i--){
				if(!viewList[i].isHad)
					viewList.splice(i,1);
			}
			for (i = timeList.length-1 ; i >= 0; i--){
				if(!timeList[i].isHad)
					timeList.splice(i,1);
			}
			
			
			viewList.sort(sortViewlist);
			
			//公告栏显示，才进行显示处理
			if(isShow){
				playViewList();
				TweenLite.delayedCall(1,checkTimeList);
			}
			
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("push2Viewlist e","handleNotification",0));

			
		}
		
		/**
		 * 定时检查 时间队列 
		 * 
		 */		
		private function checkTimeList():void{
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("checkTimeList s","NoticeBoardMediator",0));
			_checkTimeList();
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("checkTimeList e","NoticeBoardMediator",0));
			
		}
	    private function _checkTimeList():void{			
			if(!timeList || timeList.length <= 0){
				timePlaying = false;
				return;
			}
			timePlaying = true;
			TweenLite.killTweensOf(checkTimeList);
			
			var _vo:SysNoticeVO;
			var hasTimeup:Boolean = false;
			var dealList:Vector.<SysNoticeVO> = new Vector.<SysNoticeVO>;
			for (var i:int = 0; i < timeList.length; i++) 
			{
				//时间到了，推送到显示列表播放
				if(timeList[i].delayCount == 0){
					hasTimeup = true;
					timeList[i].delayCount = timeList[i].delay;
					_vo = timeList[i];
					dealList.push(_vo);
				}
				if(timeList[i].delayCount > 0)
					timeList[i].delayCount--;
			}
			//有时间到的公告
			for (i = 0; i < dealList.length; i++) 
			{
				for (var j:int = 0; j < timeList.length; j++) 
				{
					if(dealList[i].id == timeList[j].id){
						timeList.splice(j,1);
						break;
					}
				}
				viewList.push(dealList[i]);
			}
			if(hasTimeup)
				viewList.sort(sortViewlist);
			
			TweenLite.delayedCall(1,checkTimeList);
			
			//播放队列为空，则有时间到的则调度播放
			if(!viewPlaying)
				playViewList();
			
			

		}
		
		/**
		 *  抽取显示列表中的公告显示
		 * 
		 */
		private function playViewList():void{
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("playViewList s","NoticeBoardMediator",playedList.length));

			if(!viewList || viewList.length <= 0){
				viewPlaying = false;
//				view.visible = false;
				viewDisplay(false);
				return;
			}
			viewPlaying = true;
//			view.visible = true;
			viewDisplay(true);
			
			TweenLite.killTweensOf(hideText);
			TweenLite.killTweensOf(textLabel);
			TweenLite.killTweensOf(playViewList);
			
			var playStr:String;
			var playTimes:int;
			var moveToX:int;
			
			//取优先级最高的公告播放，即第1条
			playStr = viewList[0].text;
			modelTF.text = playStr;
			playTimes = int((430+modelTF.textBounds.width)/100);
			moveToX = 410-modelTF.textBounds.width;
			
			
			playText(playTimes,moveToX,viewList[0]);
			TweenLite.delayedCall(playTimes+1,playViewList);
			TweenLite.delayedCall(playTimes+2,hideText);
			
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("playViewList e"+playTimes,"NoticeBoardMediator",playedList.length));

		}
		//播放方法
		private function playText(_durT:int,_moveX:int,_vo:SysNoticeVO):void{
			textLabel.x = 840;
			textLabel.y = 100;
			textLabel.text = _vo.text;
			textLabel.validate();
			push2Timelist(_vo);
			
			//文本长于400,则滚动显示,否则只停留显示
			if(textLabel.width > 400){
				/*textTF.hAlign = HAlign.LEFT;
				TweenLite.to(textTF,_durT,{x:_moveX,ease:Linear.easeNone});*/

				//先往上显示，再向左滚动
				textLabel.x = 430;
				textLabel.y = 125;
				TweenLite.to(textLabel,1,{y:100,ease:Linear.easeNone,roundProps:["y"]});
				TweenLite.to(textLabel,_durT-2.5-2,{delay:2.5,x:820-textLabel.width,ease:Linear.easeNone,roundProps:["x"]});	//处理停留在文本尾部-- x:_moveX+400 -> 730-a-width
			}else{
		
				textLabel.x = 630-textLabel.width/2;
				textLabel.y = 125;
				TweenLite.to(textLabel,1,{y:100,ease:Linear.easeNone,roundProps:["y"]});
				
			}
		}
		
		//播放完毕，判断是否将其推入计时队列
		private function push2Timelist(_vo:SysNoticeVO):void{
			var dealVo:SysNoticeVO = _vo;
			
			viewList.splice(viewList.indexOf(dealVo),1);
			//需要多次播放，从显示列表删除，插入时间队列
			if(dealVo.times > 1){
				dealVo.times--;
				timeList.push(dealVo);
				if(!timePlaying)
					checkTimeList();
			}else
				playedList.push(dealVo);
		}
		private function isViewlistHad(_id:int):int{
			if(!viewList || viewList.length == 0) return -1;
			
			for (var i:int = 0; i < viewList.length; i++) 
			{
				if(viewList[i].id == _id)
					return i;
			}
			return -1;
		}
		private function isTimelistHad(_id:int):int{
			if(!timeList || timeList.length == 0) return -1;
			
			for (var i:int = 0; i < timeList.length; i++) 
			{
				if(timeList[i].id == _id)
					return i;
			}
			return -1;
		}
		private function isPlayedlistHad(_id:int):int{
			if(!playedList || playedList.length == 0) return -1;
			
			for (var i:int = 0; i < playedList.length; i++) 
			{
				if(playedList[i].id == _id)
					return i;
			}
			return -1;
			
			
		}
		

		//view的淡入淡出效果
		private function viewDisplay(_show:Boolean=true):void{
			//渐渐显示
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("viewDisplay s"+_show,"NoticeBoardMediator",0));

			if(_show){
//				view.alpha = 0;
				/*TweenLite.to(view,1,{alpha:1});*/
				TweenLite.to(view,1,{alpha:viewStandAlpha});
				view.touchable = true;
				
			}else{
				TweenLite.to(view,1,{alpha:0});
				view.touchable = false;
				
			}
			
//			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FLOW_RECORD,new RecordVO("viewDisplay e","NoticeBoardMediator",0));

		}
		private function hideText():void{
//			view.visible = false;
			viewDisplay(false);
			
//			stopPlay();
		}
		
		private function sortViewlist(_a:SysNoticeVO,_b:SysNoticeVO):int{
			var aid:int = _a.priority;
			var bid:int = _b.priority;
			
			if(aid > bid) {
				return 1;
			} else if(aid < bid) {
				return -1;
			} else {
				return 0;
			}
		}
		
		private var isShow:Boolean = true;
		/**
		 *停止所有公告显示 
		 * 
		 */		
		public function stopPlay():void{
			textLabel.x = 840;
			currentIdx = "0";
			view.alpha = 0;
			view.visible = false;
			isShow = false;
			
			TweenLite.killTweensOf(view);
			TweenLite.killTweensOf(playViewList);
			TweenLite.killTweensOf(checkTimeList);
			TweenLite.killTweensOf(hideText);
			TweenLite.killTweensOf(textLabel);
			TweenLite.killTweensOf(getNotice);
		}
		public function startPlay():void{
			isShow = true;
			view.visible = true;
			
			playViewList();
			TweenLite.delayedCall(1,checkTimeList);
		}
		
		
		
		private function getNotice():void{
			
			TweenLite.killTweensOf(getNotice);
			
			if(Global.isLoading){
				TweenLite.delayedCall(2,getNotice);
				return;
			}
			
			noticList.splice(0,noticList.length);
			
			PackData.app.CmdIStr[0] = CmdStr.QRY_PLAY_BRD;
			PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
			PackData.app.CmdInCnt = 2;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_PLAY_BRD,null,"cn-gb",null,SendCommandVO.SILENT));

		}
		
	

		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function onRemove():void{
			super.onRemove();
			
			TweenLite.killTweensOf(view);
			TweenLite.killTweensOf(playViewList);
			TweenLite.killTweensOf(checkTimeList);
			TweenLite.killTweensOf(hideText);
			TweenLite.killTweensOf(textLabel);
			TweenLite.killTweensOf(getNotice);
			TweenLite.killTweensOf(setViewAlpha);
			
			view.removeEventListener(TouchEvent.TOUCH,viewTouchHandle);
			view.removeChildren(0,-1,true);
		}
	}
}