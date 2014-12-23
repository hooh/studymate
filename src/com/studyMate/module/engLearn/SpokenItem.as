package com.studyMate.module.engLearn
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	internal class SpokenItem  extends Sprite
	{
		private var bg:Image;
		private var textField:TextField;
		private var id:String="0";
		
	
		public var rrl:String = "";
		public var title:String="";
		public var oralid:String="";
		public var state:String="0";
//		public var wcount:String="0";
//		public var textType:String="text";
//		public var text:String="";
//		public var worldNum:String="1";
		private var flag:int;
		
		public function SpokenItem(ids:String,arr:Array)
		{
			rrl = arr[2];
			state = arr[3];
			title = arr[5];
			oralid = arr[4];
			
			this.id = ids;
			
			bg = new Image(Assets.getAtlasTexture("task/bg"));
			addChild(bg);
			
			
			textField = new TextField(185,26,this.id,"HK",26,0xff9c00);
			textField.y = 60;
			
			var font:Sprite = Assets.getWordSprite(this.id,"HK");
			font.x = (this.width-font.width)>>1;
			font.y = 60;
			addChild(font);
			
			textField = new TextField(185,26,title,"Verdana",15,0x6e4623);
			textField.y = 106;
			addChild(textField);
			
			var statuTextField:TextField = new TextField(185,27,"","HuaKanT",20,0xba6036,true);
			statuTextField.y = 146;
			addChild(statuTextField);
			
			flag = int(state);
			if(flag<1000){
				statuTextField.text = "未完成"
			}else{
				statuTextField.text = "已完成"
			}
			
			/*var star:Image;
			var starNum:int;

			for (var i:int = 0; i < starNum; i++) 
			{
				star = new Image(Assets.getAtlasTexture("task/star"));
				star.x = 40*i+36;
				star.y = bg.height-26;
				addChild(star);
			}*/
			//if(flag<1000){
				addEventListener(TouchEvent.TOUCH,touchHandle);
				
			//}
			
		}
		
		private var beginX:Number;
		private var endX:Number;
		private function touchHandle(event:TouchEvent):void{
			var touchPoint:Touch = event.getTouch(this);
			if(touchPoint){
				if(touchPoint.phase==TouchPhase.BEGAN){
					beginX = touchPoint.globalX;
				}else if(touchPoint.phase==TouchPhase.ENDED){
					endX = touchPoint.globalX;
					if(Math.abs(endX-beginX) < 10){
						var data:Object = new Object();
						data.oralid = oralid;
						data.rrl = rrl;
						if(flag<1000){
							
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SpokenNewMediator,data)]);
						}else{
							Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SpokenGpuCompleteMediator,data)]);
						}
					}
				}
			}
		}
	}
}