package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class TargetPaperView extends Sprite
	{
		public var parentName:TextField;
		public var parentName1:TextField;
		public var parentName2:TextField;
		public var year:TextField;
		public var month:TextField;
		public var day:TextField;
		public var target:TextField;
		public var jiangLi:TextField;
		public var promiseDate:TextField;
		
		private var finishImg:Image;
		private var deadImg:Image;
		
		public function TargetPaperView(nameString:String){
			super();
			var img:Image = new Image(Assets.getTexture("targetPaper"));
			this.addChild(img);
			
			var userName:TextField = new TextField(113, 34, nameString, "HeiTi", 25, 0x696969);
			this.addChild(userName);
			userName.x = 81; userName.y = 102;
			
			userName = new TextField(113, 34, nameString, "HeiTi", 25, 0x696969);
			this.addChild(userName);
			userName.x = 82; userName.y = 316;
			
			userName = new TextField(113, 34, nameString, "HeiTi", 25, 0x696969);
			this.addChild(userName);
			userName.x = 671; userName.y = 530;
			
			parentName = new TextField(113, 34, "", "HeiTi", 25, 0x696969);
			this.addChild(parentName);
			parentName.x = 243; parentName.y = 102;
			
			parentName1 = new TextField(113, 34, "", "HeiTi", 25, 0x696969);
			this.addChild(parentName1);
			parentName1.x = 82; parentName1.y = 376;
			
			year = new TextField(79, 39, "", "HeiTi", 25, 0xFFA54F);
			this.addChild(year);
			year.x = 306; year.y = 314;
			
			month = new TextField(46, 39, "", "HeiTi", 25, 0xFFA54F);
			this.addChild(month);
			month.x = 421; month.y = 313;
			
			day = new TextField(46, 39, "", "HeiTi", 25, 0xFFA54F);
			this.addChild(day);
			day.x = 494; day.y = 313;
			
			target = new TextField(81, 49, "", "HeiTi", 30, 0xFF82AB);
			this.addChild(target);
			target.x = 634; target.y = 307;
			
			jiangLi = new TextField(590, 120, "", "HeiTi", 25, 0xEE7AE9);
			this.addChild(jiangLi);
			jiangLi.x = 210; jiangLi.y = 410;
			jiangLi.hAlign = HAlign.LEFT; jiangLi.vAlign = VAlign.TOP;
			
			parentName2 = new TextField(113, 34, "", "HeiTi", 25, 0x696969);
			this.addChild(parentName2);
			parentName2.x = 811; parentName2.y = 531;
			
			promiseDate = new TextField(142, 36, "", "HeiTi", 20, 0x696969);
			this.addChild(promiseDate);
			promiseDate.x = 781; promiseDate.y = 572;
			
			finishImg = new Image(Assets.getAtlasTexture("targetWall/finished"));
			deadImg = new Image(Assets.getAtlasTexture("targetWall/expired"));
			
			this.addChild(finishImg);
			finishImg.x = 680; finishImg.y = 60;
			finishImg.visible = false;
			
			this.addChild(deadImg);
			deadImg.x = 680; deadImg.y = 60;
			deadImg.visible = false;
			
		}
		
		public function setTextFieldString(nameOfParent:String, fullYear:String, fullMonth:String, 
										   fullDay:String, target:String, rewardString:String, 
										   makeDate:String):void{
			deadImg.visible = false;
			finishImg.visible = false;
			this.parentName.text = nameOfParent;
			this.parentName1.text = nameOfParent;
			this.parentName2.text = nameOfParent;
			this.year.text = fullYear;
			this.month.text = fullMonth;
			this.day.text = fullDay;
			this.target.text = target;
			this.jiangLi.text = "      " + rewardString;
			this.promiseDate.text = makeDate;
		}
		
		public function setFinish():void{
			finishImg.visible = true;
			var w:Number = finishImg.width;
			var h:Number = finishImg.height;
			finishImg.alpha = 0;
			finishImg.x = 680 - w/2; finishImg.y = 60 - h/2;
			finishImg.scaleX = 2; finishImg.scaleY = 2;
			TweenLite.to(finishImg, 0.8, {alpha:1, scaleX:1, scaleY:1, x:680, y:60, ease:Circ.easeIn});
		}
		
		public function setDead():void{
			deadImg.visible = true;
		}
	}
}