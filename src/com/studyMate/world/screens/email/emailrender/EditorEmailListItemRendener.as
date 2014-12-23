package com.studyMate.world.screens.email.emailrender
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.screens.WorldConst;
	import com.studyMate.world.screens.email.EmailData;
	
	import feathers.controls.List;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class EditorEmailListItemRendener extends BaseListItemRenderer
	{
		
		private var send:TextField;
		private var sendid:TextField;//题目类型
		private var creattime:TextField;//房间名称
		
		private var subject:TextField;//辅导题目id
		private var mailtext:TextField;//开始时间
		
		private var save:Button;
		
		public function EditorEmailListItemRendener()
		{
			
		}
		
		override protected function commitData():void
		{
			if(this.data){
				var baseClass:EmailData = this._data as EmailData;
				this.send.text = "#"+baseClass.send;
				var _year:String = baseClass.creattime.slice(0,4);
				var _month:String = baseClass.creattime.slice(4,6);
				var _day:String = baseClass.creattime.slice(6,8);
				var _hour:String = baseClass.creattime.slice(9,11);
				var _min:String = baseClass.creattime.slice(11,13);
				this.creattime.text = _year+"-"+_month+"-"+_day+"  "+_hour+":"+_min;
				this.subject.text = baseClass.subject;
				if(baseClass.mark == "0"){
					collect.visible = true;
					collected.visible =false;
				}else{
					collected.visible = true;
					collect.visible = false;	
				}
				if(baseClass.other!= ""){
					gold.visible = true;
				}else{
					gold.visible = false;
				}
				if(baseClass.isRead){
					emailed.visible = true;
					gold.visible = email.visible = false;
				}else{
					emailed.visible = false;
					email.visible = true;
				}
			}
			height = this.bg.height;
		}
		
		
		private var email:Image;
		private var gold:Image;
		private var collect:Button;
		private var collected:Button;
		public var delEmail:Button;
		private var emailed:Image;
		private var bg:Quad;
		
		override protected function initialize():void
		{
			if(!this.creattime)
			{
				
				this.bg = new starling.display.Quad(1000,120,0xE5F8FF);
				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
				this.addChild(this.bg);
				
				email = new Image(Assets.getEmailAtlasTexture("read"));
				email.x = 40;
				email.y = 47;
				this.addChild(email);
				
				gold = new Image(Assets.getEmailAtlasTexture("coin"));
				gold.visible = false;
				gold.scaleX = 0.7;
				gold.scaleY = 0.7
				gold.x = 350;
				gold.y = 50;
				this.addChild(gold);
				
				emailed = new Image(Assets.getEmailAtlasTexture("readed"));
				emailed.x = 40;
				emailed.y = 47;
				emailed.scaleX = 0.7;
				emailed.scaleY = 0.7;
				emailed.visible = false;
				this.addChild(emailed);
				
				collect = new Button(Assets.getEmailAtlasTexture("logo"));
				collect.x = 390;
				collect.y = 50;
				collect.visible = false;
				this.addChild(collect);
				collect.addEventListener(Event.TRIGGERED,collectHandler);
				
				collected = new Button(Assets.getEmailAtlasTexture("logo1"));
				collected.x = 390;
				collected.y = 50;
				collected.visible = false;
				this.addChild(collected);
				collected.addEventListener(Event.TRIGGERED,collectHandler);
				
				
				delEmail = new Button(Assets.getEmailAtlasTexture("del"));
				delEmail.x = 10;
				delEmail.y = 45;
				this.addChild(delEmail);
				delEmail.addEventListener(Event.TRIGGERED,delEmailHandler);
				
				
				
				this.send = new TextField(150,50,'',"HeiTi",15,0x595653,false);
				this.send.x = 10;
				this.send.y = 0;
				this.send.hAlign = HAlign.LEFT;
				this.send.autoScale = true;
				this.send.touchable = false;
				this.addChild(this.send);
				
				this.creattime = new TextField(200,50,"","HeiTi",15,0x595653,false);
				this.creattime.x = 250;
				this.creattime.y = 0;
				this.creattime.autoScale = true;
				this.creattime.touchable = false;
				this.addChild(this.creattime);
				
				this.subject = new starling.text.TextField(300, 50, "","HeiTi",20,0,false);
				this.subject.x = 80;
				this.subject.y = 35;
				this.subject.hAlign = HAlign.LEFT;
				this.subject.autoScale = true;
				this.subject.touchable = false;
				this.addChild(this.subject);	
				
				this.mailtext = new TextField(400, 50,"","HeiTi",18,0x595653,false);
				this.mailtext.x = 10;
				this.mailtext.y = 80;	
				this.mailtext.hAlign = HAlign.LEFT;
				this.mailtext.autoScale = true;
				this.mailtext.touchable = false;
				this.addChild(this.mailtext);
			}
		}
		
		private function delEmailHandler():void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.DELEMAIL,_data);
		}	
		
		private function collectHandler():void
		{
			if(!Global.isLoading){
				PackData.app.CmdIStr[0] = CmdStr.MARKEMAIL4PAD;
				PackData.app.CmdIStr[1] = PackData.app.head.dwOperID.toString();
				PackData.app.CmdIStr[2] = this._data.mailid;
				if(!collect.visible||collected.visible){
					collect.visible = true;
					collected.visible = false;
					PackData.app.CmdIStr[3] = 0;
				}else if(collect.visible ||!collected.visible){
					collect.visible = false;
					collected.visible = true;
					PackData.app.CmdIStr[3] = 1;
				}
				PackData.app.CmdInCnt = 4;
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_11,new SendCommandVO(EmailNumListClassItemRendener.COLLECTEMAIL));
			}
	
		}
		
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this.bg);				
			if(touch && touch.phase == TouchPhase.ENDED){		
				isSelected = true;					
				
			}			
		}
		
		override public function get data():Object
		{
			// TODO Auto Generated method stub
			return super.data;
		}
		
		override public function set data(value:Object):void
		{
			// TODO Auto Generated method stub
			super.data = value;
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
		}
		
		override public function get index():int
		{
			// TODO Auto Generated method stub
			return super.index;
		}
		
		override public function set index(value:int):void
		{
			// TODO Auto Generated method stub
			super.index = value;
		}
		
		
		override public function get isSelected():Boolean
		{
			// TODO Auto Generated method stub
			return super.isSelected;
		}
		
		
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			if(value){	
				this.bg.alpha=1;				
			}else{
				this.bg.alpha=0;		
			}
		}
		
		override public function get owner():List
		{
			// TODO Auto Generated method stub
			return super.owner;
		}
		
		override public function set owner(value:List):void
		{
			// TODO Auto Generated method stub
			super.owner = value;
		}
		
	}
}


