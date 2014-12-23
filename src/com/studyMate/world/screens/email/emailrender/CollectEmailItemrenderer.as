package com.studyMate.world.screens.email.emailrender
{
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.screens.email.EmailData;
	
	import feathers.controls.List;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class CollectEmailItemrenderer extends BaseListItemRenderer
	{
		
		private var send:TextField;
		private var sendid:TextField;//题目类型
		private var creattime:TextField;//房间名称
		
		private var subject:TextField;//辅导题目id
		private var mailtext:TextField;//开始时间
		
		private var save:Button;
		
		
		public function CollectEmailItemrenderer()
		{
			
		}
		
		override protected function commitData():void
		{
			if(this.data){
				
				var baseClass:EmailData = this._data as EmailData;
				this.send.text = baseClass.send;
				var _year:String = baseClass.creattime.slice(0,4);
				var _month:String = baseClass.creattime.slice(4,6);
				var _day:String = baseClass.creattime.slice(6,8);
				var _hour:String = baseClass.creattime.slice(9,11);
				var _min:String = baseClass.creattime.slice(11,13);
				this.creattime.text = _year+"-"+_month+"-"+_day+"  "+_hour+":"+_day;
				if(baseClass.subject.length == 1){
					baseClass.subject = "邮件无主题";
				}
				this.subject.text = baseClass.subject;
				this.mailtext.text = baseClass.mailtext;
				if(baseClass.mark == "0"){
					collect.visible = true;
				}else{
					collected.visible = true;
				}
			}
			height = this.bg.height;
		}
		
		
		private var texture:Texture;
		private var email:Image;
		private var collect:Button;
		private var collected:Button;
		private var bg:Quad;
		
		override protected function initialize():void
		{
			if(!this.creattime)
			{
				
				this.bg = new starling.display.Quad(1000,180,0xE5F8FF);
				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
				this.addChild(this.bg);
				
				texture = Assets.getEmailAtlasTexture("readed");
				email = new Image(texture);
				email.x = 0;
				email.y = 30;
				email.scaleX = 0.7;
				email.scaleY = 0.7;
				this.addChild(email);
				
				texture = Assets.getEmailAtlasTexture("logo");
				collect = new Button(texture);
				collect.x = 390;
				collect.y = 50;
				collect.visible = false;
				this.addChild(collect);
				collect.addEventListener(Event.TRIGGERED,collectHandler);
				
				texture = Assets.getEmailAtlasTexture("logo1");
				collected = new Button(texture);
				collected.x = 390;
				collected.y = 50;
				collected.visible = false;
				this.addChild(collected);
				collected.addEventListener(Event.TRIGGERED,collectHandler);
				
				
				
				
				this.send = new TextField(150,50,'',"HeiTi",15,0x595653,false);
				this.send.x = -15;
				this.send.y = 0;
				this.send.autoScale = true;
				this.send.touchable = false;
				this.addChild(this.send);
				
				/*				this.sendid = new TextField(100,50,'',"HeiTi",15,0x8E9080,false);
				this.sendid.x = this.send.x +this.send.width/2;
				this.sendid.y = 2;
				this.sendid.autoScale = true;
				this.sendid.touchable = false;
				this.addChild(this.sendid);*/
				
				this.creattime = new TextField(200,50,"","HeiTi",15,0x595653,false);
				this.creattime.x = 250;
				this.creattime.y = 0;
				this.creattime.autoScale = true;
				this.creattime.touchable = false;
				this.addChild(this.creattime);
				
				this.subject = new starling.text.TextField(300, 50, "","HeiTi",20,0,false);
				this.subject.x = -50;
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
		
		
		private function collectHandler():void
		{
			if(!collect.visible||collected.visible){
				collect.visible = true;
				collected.visible = false;
			}else if(collect.visible ||!collected.visible){
				collect.visible = false;
				collected.visible = true;
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


