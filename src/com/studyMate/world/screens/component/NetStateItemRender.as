package com.studyMate.world.screens.component
{
	import com.studyMate.model.vo.IPSpeedVO;
	import com.studyMate.world.component.BaseListItemRenderer;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	
	import starling.display.Graphics;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class NetStateItemRender extends BaseListItemRenderer
	{
		public function NetStateItemRender()
		{
			super();
		}
		
		private var addNameTF:Label;
		private var timeTF:Label;
		private var touchsp:Sprite;
		
		private var speedTF:Label;
		private var tips:Label;
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			touchsp.visible = value;
			
			
		}
		
		override protected function initialize():void
		{
			var touchArea:Quad = new Quad(589,35,0xffffff);
			touchArea.alpha = 0;
			addChild(touchArea);
			
			touchsp = new Sprite;
			var bg2:Graphics = new Graphics(touchsp);//
			bg2.lineStyle(0);
			bg2.beginFill(0x3399ff);//0x99CCFF //0xE6A73F
			bg2.drawRect(0,0,589,35);
			bg2.endFill();
			touchsp.touchable = false;
			touchsp.visible = false;
			this.addChild(touchsp);
			
			addNameTF = new Label();
			addNameTF.textRendererFactory = function():ITextRenderer
			{
				return new TextFieldTextRenderer;
			}
			addNameTF.textRendererProperties.textFormat = new TextFormat( "Verdana", 18, 0, null, null, null,null,null, TextFormatAlign.LEFT);
			addNameTF.width = 150;
			addNameTF.height = 30;
			addNameTF.x = 10;
			addNameTF.y = 2.5;
			addNameTF.text = "";
			this.addChild(addNameTF);
			
			
			timeTF = new Label();
			timeTF.textRendererFactory = function():ITextRenderer
			{
				return new TextFieldTextRenderer;
			}
			timeTF.textRendererProperties.textFormat = new TextFormat( "Verdana", 18, 0, null, null, null,null,null, TextFormatAlign.LEFT);
			timeTF.width = 180;
			timeTF.height = 30;
			timeTF.x = 190;
			timeTF.y = 2.5;
			timeTF.text = "";
			this.addChild(timeTF);
			
//			speedTF
			speedTF = new Label();
			speedTF.textRendererFactory = function():ITextRenderer
			{
				return new TextFieldTextRenderer;
			}
			speedTF.textRendererProperties.textFormat = new TextFormat( "Verdana", 16, 0, null, null, null,null,null, TextFormatAlign.LEFT);
			speedTF.width = 180;
			speedTF.height = 30;
//			speedTF.x = 190;
			speedTF.x = 340;
			speedTF.y = 2.5;
			speedTF.text = "";
			this.addChild(speedTF);
			
			
			tips = new Label();
			tips.textRendererFactory = function():ITextRenderer
			{
				return new TextFieldTextRenderer;
			}
			tips.textRendererProperties.textFormat = new TextFormat( "Verdana", 13, 0, null, null, null,null,null, TextFormatAlign.CENTER);
			tips.width = 100;
			tips.height = 30;
//			tips.x = 350;
			tips.x = 480;
			tips.y = 2.5;
			tips.text = "";
			this.addChild(tips);
			
			
			this.addEventListener(TouchEvent.TOUCH,TOUCHHandler);
		}
		
		private function setFontSize(size:int):void{
			timeTF.textRendererProperties.textFormat = new TextFormat( "Verdana", size, 0, null, null, null,null,null, TextFormatAlign.LEFT);
		}
		
		override protected function commitData():void
		{
			if(this._data)
			{
				var _vo:IPSpeedVO = this._data as IPSpeedVO;
				addNameTF.text = "接入口: "+_vo.name;
				
//				timeTF.fontSize = 18;
				setFontSize(18);
				timeTF.text = "Times: --";
				speedTF.text = "";
				
				if(_vo.checkState == -1){
					tips.text = "";
				}else if(_vo.checkState == 0){
					tips.text = "拼命测试中...";
				}else if(_vo.checkState == 1){
					tips.text = "√";
					
					if(_vo.stat == IPSpeedVO.SOCKET_NORMAL){
						timeTF.text = "Times: "+_vo.timeout;
						speedTF.text = "网速: "+_vo.speed.toFixed(0)+"Kb/s";
					}else if(_vo.stat == IPSpeedVO.SOCKET_ERROR){
//						timeTF.fontSize = 14;
						setFontSize(14);
						timeTF.text = "网络故障，socket连接失败";
						
					}else if(_vo.stat == IPSpeedVO.DATA_HEAD_ERROR){
//						timeTF.fontSize = 14;
						setFontSize(14);
						timeTF.text = "校验数据头解析错误";
						
					}else if(_vo.stat == IPSpeedVO.DATA_ERROR){
//						timeTF.fontSize = 14;
						setFontSize(14);
						timeTF.text = "校验数据解析错误";
						
					}else if(_vo.stat == IPSpeedVO.DATA_TIMEOUT){
//						timeTF.fontSize = 14;
						setFontSize(14);
						timeTF.text = "校验数据传输超时";
						
					}
					
				}
				
				
			}
		}
		
		
		private var beginY:Number;
		private var endY:Number;
		private function TOUCHHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);				
			if(touch){
				if(touch.phase == TouchPhase.BEGAN){
					beginY = touch.globalY;
					
					touchsp.visible = true;
				}else if(touch.phase==TouchPhase.MOVED){
					endY = touch.globalY;
					if(Math.abs(endY-beginY) > 10)
						touchsp.visible = false;
					
				}else if(touch.phase == TouchPhase.ENDED){
					
					endY = touch.globalY;
					if(Math.abs(endY - beginY) <= 10){
						isSelected = true;
					}
				}
				
			}		
		}
		
		override public function dispose():void
		{
			this.removeChildren(0,-1,true);
			super.dispose();
		}
	}
}