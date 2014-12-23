package com.studyMate.world.screens.wordcards 
{
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.component.BaseListItemRenderer;
	import com.studyMate.world.screens.component.vo.WordCardVO;
	import com.studyMate.world.screens.email.EmailData;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	
	import feathers.controls.List;
	
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class RememberWordCardItemRender extends BaseListItemRenderer
	{
		
		
		
		
		public function RememberWordCardItemRender()
		{
			
		}
		
		override protected function commitData():void
		{
			if(this.data){
				var baseClass:WordCardVO = this.data as WordCardVO;
				baseClass
				
			}
			height = this.bg.height;

		}
		
		
		private var bg:Quad
		private var wordText:TextField;
		private var bgVec:Vector.<flash.display.DisplayObject>;
		private var showStr:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
		private var pool:RememberCardPool;
		private var word1:RememberCard;
		private var word2:RememberCard;
		override protected function initialize():void
		{
			bgVec = new Vector.<flash.display.DisplayObject>;
			pool = new RememberCardPool();
			
			var wordCardBmp1:Bitmap = new Bitmap(Assets.store["rememberCard"].bitmapData);
			wordCardBmp1.name = "bg";
			bgVec.push(wordCardBmp1);
			
			var wordCardBmp2:Bitmap = new Bitmap(Assets.store["rememberCard1"].bitmapData);
			wordCardBmp2.name ="green";
			bgVec.push(wordCardBmp2)
			
			BitmapFontUtils.init(showStr,bgVec,new TextFormat("HeiTi",36,0,false,false,null,null,null,"center"));
			
//			word1 = new RememberCard(BitmapFontUtils.getTexture("bg_00000"));
			
			
			var _rememberCard:RememberCard;
			var wordPosY:int;
			var btnY:int;
			var wordPosX:int;
			for(var j:int = 0;j<16;j++){
				_rememberCard = pool.object ;
				if(j!=0&&j%4==0||wordPosY==4){
					wordPosX++;
					btnY = btnY+145
					wordPosY=0;
				}
				_rememberCard.x = wordPosY*312;
				_rememberCard.y = btnY;
				wordPosY++;
				_rememberCard.addWordField();
//				_rememberCard.vo = nowWords[j];
//				_rememberCard.wordid = nowWords[j].wordid;
				_rememberCard.addEventListener(TouchEvent.TOUCH,changeStatusHandler);
				addChild(_rememberCard);
			}
				
		}
		
		private function changeStatusHandler():void
		{
			// TODO Auto Generated method stub
			
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

