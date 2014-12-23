package com.mylib.game.runner
{
	import com.byxb.utils.centerPivot;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.utils.BitmapFontUtils;
	import com.studyMate.world.component.BaseListItemRenderer;
	
	import flash.text.TextFormatAlign;
	
	import feathers.controls.Label;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class RunnerChartItemRender extends BaseListItemRenderer
	{
		public function RunnerChartItemRender()
		{
			super();
		}
		
		private var bg:Image;
		private var mebg:Image;
		
		private var nameLabel:Label;
		private var distanceLabel:Label;
		
		private var rankSp:Sprite;
		private var badgeSp:Sprite;
		private var point:Image;
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			
		}
		
		override protected function initialize():void
		{
			if(!this.bg)
			{
				bg = new Image(BitmapFontUtils.getTexture("chartItemBg_00000"));
				bg.visible = false;
				this.addChild(bg);
				
				mebg = new Image(BitmapFontUtils.getTexture("chartItemBg_Me_00000"));
				mebg.visible = false;
				this.addChild(mebg);
				
				point = new Image(BitmapFontUtils.getTexture("chartPoints_00000"));
				point.x = 150;
				point.y = 5;
				point.visible = false;
				this.addChild(point);
				
				
				//排名
				rankSp = new Sprite;
				rankSp.x = 35;
				rankSp.y = 10;
				this.addChild(rankSp);
				
				//徽章
				badgeSp = new Sprite;
				badgeSp.x = 125;
				badgeSp.y = 10;
				this.addChild(badgeSp);
				
				
				this.nameLabel = BitmapFontUtils.getLabel();
				this.nameLabel.setSize(250,30);
				this.nameLabel.x = 165;
				this.nameLabel.y = 12;
				this.nameLabel.touchable = false;
				this.addChild(nameLabel);
				
				
				this.distanceLabel = BitmapFontUtils.getLabel();
				this.distanceLabel.setSize(250,30);
				this.distanceLabel.x = 958;
				this.distanceLabel.y = 12;
				this.distanceLabel.touchable = false;
//				this.distanceLabel.textRendererProperties.hAlign = HAlign.RIGHT;
				this.addChild(distanceLabel);
				
				
			}
		}
		
		override protected function commitData():void
		{
			if(this._data)
			{
				var _vo:RunnerChartVO = this._data as RunnerChartVO;
				
				//默认如果operId是-1，则为过度行
				if(_vo.operId == -1)
				{
					nameLabel.visible = false;
					distanceLabel.visible = false;
					point.visible = true;
					return;
				}
				
				
				mebg.visible = (_vo.operId == PackData.app.head.dwOperID);
				bg.visible = !mebg.visible;
				
				this.nameLabel.text = _vo.name;
				this.distanceLabel.text = _vo.distance.toString()+"m";
				
				
				rankSp.removeChildren(0,-1,true);
				badgeSp.removeChildren(0,-1,true);
				//如果前三，则显示奖杯
				if(_vo.rank <= 3 && _vo.rank > 0)
				{
					var tname:String;
					if(_vo.rank == 1){
						tname = "firstIcon_00000";
					}else if(_vo.rank == 2){
						tname = "secondIcon_00000";
					}else if(_vo.rank == 3){
						tname = "thirdIcon_00000";
					}
					var img:Image = new Image(BitmapFontUtils.getTexture(tname));
					rankSp.addChild(img);
				}else{
					
					var rankTF:TextField = new TextField(76,35,_vo.rank.toString(),"HeiTi",26,0x816029,true);
					rankTF.x = -15;
//					rankTF.border = true;
					rankTF.hAlign = HAlign.CENTER;
					rankSp.addChild(rankTF);
				}
				
				
				var badgeTexture:Texture;
				//根据分数显示不同徽章	小于2万为1级，特殊处理
				if(_vo.distance < 20000){
					badgeTexture = BitmapFontUtils.getTexture("badge/1_00000");
					
				}else{
					
//					var s:Number = (-7+(Math.sqrt(1+4*(_vo.distance*0.001))))*0.5;
//					var level:int = Math.ceil(s);
					var level:int;
					var currentDis:int = 0;
					
					while(currentDis<_vo.distance){
						currentDis+=10000+1000*level;
						level++;
					}
					
					if(level>11){
						level=11;
					}
					
					
					
					badgeTexture = BitmapFontUtils.getTexture("badge/"+level+"_00000");
					
				}
				
				var badge:Image = new Image(badgeTexture);
				centerPivot(badge);
//				badge.x = 50;
				badge.y = 17;
				badge.scaleX = 0.6;
				badge.scaleY = 0.6;
				badgeSp.addChild(badge);
				
			}
		}
		
		
		
		
		
		override public function dispose():void
		{
			this.removeChildren(0,-1,true);
			super.dispose();
		}
	}
}