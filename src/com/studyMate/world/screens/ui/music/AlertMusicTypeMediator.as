package com.studyMate.world.screens.ui.music
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.ExchangeMusicMediator;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class AlertMusicTypeMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "AlertMusicTypeMediator";
		private const CHANGE_SUCCEED:String = NAME + "CHANGE_SUCCEED";
		
		private var img:Image;
		
		private var listScroll:ScrollContainer;
		private var canPlayBoo:Boolean;
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		private var pareVO:SwitchScreenVO;
		private var classifyArr:Vector.<MusicClassify>;
		
		private var localX:Number=482;
		private var localY:Number=224;
		private var width:Number;
		private var height:Number;
		
		public function AlertMusicTypeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);					
		}
		override public function onRegister():void{
			var Bg:Quad = new Quad(1280,768,0);
			Bg.alpha = 0.5;
			Bg.x = -localX;
			Bg.y = -localY;
			view.addChild(Bg);
			
			img = new Image(Assets.getMusicSeriesTexture("AlertMusicTypeBg"));
			view.x = localX;
			view.y = localY;
			width = img.width;
			height = img.height;
			
			img.pivotX = width>>1;
			img.pivotY = height>>1;
			img.x += width>>1;
			img.y += height>>1;
			view.addChild(img);
						
			
			TweenLite.from(img,0.6,{scaleX:0.1,scaleY:0.1,ease:Back.easeOut,onComplete:showHandler});
									
			facade.retrieveMediator(ExchangeMusicMediator.NAME).getViewComponent().touchable = false;
		}
		/*private function bgTouchHandler(e:TouchEvent):void
		{
			if(e.touches[0].phase==TouchPhase.BEGAN){
				e.stopImmediatePropagation();
			}
		}*/
		private function showHandler():void{
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 1;
			layout.paddingBottom =20;
			listScroll = new ScrollContainer();
			listScroll.x = 43;
			listScroll.y = 90;
			listScroll.width = 306;
			listScroll.height = 260;
			listScroll.layout = layout;
			listScroll.snapScrollPositionsToPixels = true;	
			view.addChild(listScroll);
			
			for(var i:int=0;i<classifyArr.length;i++){
				var classify:MusicClassify = classifyArr[i];
				var sp:Sprite = getItem(classify.grid,classify.className);
				listScroll.addChild(sp);
			}
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH,stageTouchHandler);
		}
		private function stageTouchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(Starling.current.stage);	
			var pos:Point;
			if(touch && touch.phase == TouchPhase.BEGAN){
				pos = touch.getLocation(Starling.current.stage); 
				
				if(pos.x<localX || pos.x>localX+width || pos.y<localY || pos.y>localY+height){
					e.stopImmediatePropagation();
					pareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
				}
				
			}
		}
		
		
		override public function onRemove():void{
			if(img)
				TweenLite.killTweensOf(img);
			pareVO = null;
			if(listScroll)
				listScroll.removeChildren(0,-1,true);
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH,stageTouchHandler);
			view.removeChildren(0,-1,true);
			facade.retrieveMediator(ExchangeMusicMediator.NAME).getViewComponent().touchable = true;
			super.onRemove();
			
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case CHANGE_SUCCEED:
					if((PackData.app.CmdOStr[0] as String)=="000"){//接收
						sendNotification(ExchangeMusicMediator.EXCHANGE_CHANGE_SUCCEED,this.pareVO.data);
						pareVO.type = SwitchScreenType.HIDE;
						sendNotification(WorldConst.SWITCH_SCREEN,[pareVO]);
					}
					break;
			}
		}		
		override public function listNotificationInterests():Array{
			return [CHANGE_SUCCEED];
		}
		
				
		private function getItem(grid:String,name:String):Sprite{
			var sp:Sprite = new Sprite();
			var _currentBg1:Image = new Image(Assets.getMusicSeriesTexture("AlertMusicSetBg"));
			sp.addChild(_currentBg1)
			var txt:TextField = new TextField(304,80,name,"HeiTi",32,0x2F2F2F,true);
			sp.addChild(txt);
			sp.name = grid;
			sp.addEventListener(TouchEvent.TOUCH,changeHandler);
			return sp;
		}
		
		
		
		private function changeHandler(e:TouchEvent):void
		{	
			var disObj:DisplayObject = (e.target as DisplayObject);	
			var touch:Touch = e.getTouch(disObj);	
			var pos:Point;
			if(touch && touch.phase == TouchPhase.BEGAN){
				//e.stopImmediatePropagation();
				pos = touch.getLocation(disObj);   
				mouseDownX = pos.x;
				mouseDownY = pos.y;
				canPlayBoo = true;
			}else if(touch && touch.phase == TouchPhase.MOVED){
				pos = touch.getLocation(disObj);  
				if(Math.abs(pos.x-mouseDownX)>10 || Math.abs(pos.y-mouseDownY)>10  ){
					canPlayBoo = false;
				}
			}else if(touch && touch.phase == TouchPhase.ENDED){
				e.stopImmediatePropagation();
				if(canPlayBoo ){
					canPlayBoo=false;
					var target:DisplayObject = e.currentTarget as DisplayObject;
					var grid:String = target.name;
					var instidArr:Array = [];
					var vec:Vector.<ExchangeItemVO> = (pareVO.data as Vector.<ExchangeItemVO>);
					for(var i:int=0;i<vec.length;i++){
						instidArr.push(vec[i].instid);
					}
					sendinServerInofFunc(CmdStr.SET_GOODS_CLASSIFY,CHANGE_SUCCEED,[instidArr.join(','),grid]);											
				}
			}			
		}
		private function sendinServerInofFunc(command:String,reveive:String,infoArr:Array):void{
			PackData.app.CmdIStr[0] = command;
			for(var i:int=0;i<infoArr.length;i++){
				PackData.app.CmdIStr[i+1] = infoArr[i]
			}
			PackData.app.CmdInCnt = i+1;	
			sendNotification(CoreConst.SEND_11,new SendCommandVO(reveive));	//派发调用绘本列表参数，调用后台
		}

		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			pareVO = vo;
			if(Facade.getInstance(CoreConst.CORE).retrieveMediator(ExchangeMusicMediator.NAME)){
				classifyArr = (Facade.getInstance(CoreConst.CORE).retrieveMediator(ExchangeMusicMediator.NAME) as ExchangeMusicMediator).classifyArr.concat();
				for(var i:int=0;i<classifyArr.length;i++){
					if(classifyArr[i].grid == pareVO.data[0].grid){
						classifyArr.splice(i,1);//剔除掉相同列表
						break;
					}
				}
				if(classifyArr.length>0){				
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);								
				}
			}
									
		}
	}
}