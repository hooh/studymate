package com.studyMate.world.component
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.studyMate.global.Global;
	import com.studyMate.world.model.vo.StandardItemsVO;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class LineItemSprite extends Sprite
	{
		
		private var texture:Texture;
		private var titleTF:TextField;
		
		public var standItemVo:StandardItemsVO;
		
		private var iconSp:Sprite;
		
		public var itembg:Image;
		public var itemmybg:Image;
		public var itemGrade:Image;
		
		public function LineItemSprite(_standItemVo:StandardItemsVO)
		{
			this.standItemVo = _standItemVo;
			
			init();
		}
		
		private function init():void{
			
			//根据不同需求设置不同颜色的线
			var line:Image = new Image(Assets.getWorldMapTexture("line_"+standItemVo.lineType));
			if(standItemVo.lineType == "White"){
				
			}else{
				
				
				line.rotation = Math.PI/2;
				
			}
			
			addChild(line);
			
			
			
			var lineName:int = int(standItemVo.name);
			
			//偶数线条，添加背景
			if(lineName!= 0&& lineName%2 == 0){
				
				itembg = new Image(Assets.getWorldMapTexture("line_Grade_Bg"));
				addChild(itembg);
				
			}
			/*if(lineName == 2){
				itemmybg = new Image(Assets.getWorldMapTexture("line_MyGrade_Bg"));
				addChild(itemmybg);
			}*/
			
			
			//每条线，添加年级
			itemGrade = new Image(Assets.getWorldMapTexture(standItemVo.name));
			addChild(itemGrade);
			itemGrade.y = (Global.stageHeight-itemGrade.height)>>1;
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			iconSp = new Sprite();
			addChild(iconSp);
			
			var tfSp:Sprite = new Sprite();
			
			var glevelIcon:Image = new Image(Assets.getWorldMapTexture("grade_Level"+int(standItemVo.level)));
			glevelIcon.x = -glevelIcon.width>>1;
			/*glevelIcon.y = -glevelIcon.height + 80;*/
			glevelIcon.y = 700-glevelIcon.height
			iconSp.addChild(glevelIcon);

			
			
			/*var gradeNumImg:Image = new Image(Assets.getWorldMapTexture(standItemVo.name));
			gradeNumImg.x = -gradeNumImg.width>>1;
			gradeNumImg.y = glevelIcon.y+((glevelIcon.height-gradeNumImg.height)>>1);
			iconSp.addChild(gradeNumImg);*/
			
			titleTF = new TextField(100,25,"","HuaKanT",18,0xffffff);
			titleTF.hAlign = HAlign.CENTER;
			titleTF.text = standItemVo.standData;
			titleTF.x = -titleTF.width>>1;
			titleTF.y = glevelIcon.y+63;
			iconSp.addChild(titleTF);
			
			
			TweenMax.to(iconSp,1,{delay:Math.random(),y:iconSp.y-5, yoyo:true,repeat:int.MAX_VALUE});
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			TweenLite.killTweensOf(iconSp);
			
			removeChildren(0,-1,true);
		}

	}
}