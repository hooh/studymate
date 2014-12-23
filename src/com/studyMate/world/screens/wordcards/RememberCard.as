package com.studyMate.world.screens.wordcards
{
	import com.studyMate.module.engLearn.WordLearningBGMediator;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.screens.component.vo.WordCardVO;
	
	import feathers.controls.Label;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class RememberCard extends Sprite
	{
		public var bg:Image;
		
		public var geen:Image;
		
		public var wordField:Label;
		
		
		public var status:Boolean
		public var backHolder:Sprite;
		
		public var wordid:String;
		
		
		
		public function RememberCard(texture:Texture)
		{
			super();
			
			
			backHolder= new Sprite();
			
			creatgeenWordCardBackground(BitmapFontUtils.getTexture("green_00000"));
			creatWordCardBackground(texture);
			
			wordField = BitmapFontUtils.getLabel();
			wordField.y = bg.height/5;
			wordField.width = bg.width;
			wordField.textRendererProperties.textFormat.align = "center";
			wordField.textRendererProperties.wordWrap = true;
			addChild(wordField);
			
		}
		
		public function creatWordCardBackground(texture:Texture):void
		{
			if(bg != null){
				removeChild(bg,false);
			}
			if(geen != null){
				geen.alpha = 0;
			}
			bg = new Image(texture);
			addChildAt(bg,0);
		}
		
		public function creatgeenWordCardBackground(texture:Texture):void
		{
			if(geen != null){
				removeChild(geen,false);
			}
			if(bg!= null){
				bg.alpha = 0;
			}
			geen = new Image(texture);
			geen.x = -2;
			geen.y = -2;
			addChildAt(geen,0);
		}
		
		public function setStatus(str:String):void
		{
			status = str
		}
		
		
		public function set vo(_vo:WordCardVO):void{
			text = _vo.word;
		}
		
		public function get vo():WordCardVO
		{
			return vo;
		}
		
		public function set text(txt:String):void{
			wordField.text = txt;
			addChild(wordField);
		}
		
		public function addWordField():void
		{
		}
		
		
		
		
	}
}


