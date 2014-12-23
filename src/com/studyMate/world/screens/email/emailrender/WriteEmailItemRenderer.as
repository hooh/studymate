package com.studyMate.world.screens.email.emailrender
{
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.screens.email.ContactData;
	
	import feathers.controls.List;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class WriteEmailItemRenderer extends BaseListItemRenderer
	{
		
		private var cust:TextField;
		
		private var subject:TextField;//辅导题目id
		private var mailtext:TextField;//开始时间
		
		private var save:Button;
		
		public static const COLLECTEMAIL:String = "CollectEmail";
		
		public function WriteEmailItemRenderer()
		{
			
		}
		
		override protected function commitData():void
		{
			if(this.data){
				var baseClass:ContactData = this._data as ContactData;
				this.cust.text = baseClass.custname +"<ID:"+baseClass.custid+">";
			}
			height = this.bg.height;
		}
		
		
		private var texture:Texture;
		private var bg:Quad;
		
		private var background:Image;
		
		override protected function initialize():void
		{
				
				
	
				
				texture = Assets.getEmailAtlasTexture("contactList")
				this.background = new Image(texture);
				this.background.height = 50
				this.addChild(this.background);
				
				this.bg = new starling.display.Quad(200,50,0xE5F8FF);
				this.bg.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
				this.addChild(this.bg);
				
				this.cust = new TextField(300,50,'',"HeiTi",15,0x595653,false);
				this.cust.x = 10;
				this.cust.hAlign = HAlign.LEFT;
				this.cust.autoScale = true;
				this.cust.touchable = false;
				this.addChild(this.cust);
				
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


