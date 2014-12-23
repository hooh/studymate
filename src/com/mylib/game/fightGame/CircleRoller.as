package com.mylib.game.fightGame
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class CircleRoller extends Sprite
	{
		private var chart:CircleChart;
		private var bar:Image;
		public var speed:int;
		private const rad:Number = 57.325;
		
		public function CircleRoller()
		{
			chart = new CircleChart;
			addChild(chart);
			bar = new Image(Assets.getFightGameTexture("rbar"));
			addChild(bar);
			bar.pivotX = 50;
			bar.pivotY = bar.height>>1;
			
			bar.rotation = Math.PI*1.25;
		}
		
		public function addRange(start:int,len:int):void{
			
			if(start>=360){
				chart.addSector(start-360,len,CircleChart.ADV_ATT);
			}else if(start>=0&&len>0){
				chart.addSector(start,len,CircleChart.BASE_ATT);
			}else if(start<=0&&start>-360){
				chart.addSector(-start,Math.abs(len),CircleChart.BASE_DEF,0.5);
			}else{
				chart.addSector(-start-360,Math.abs(len),CircleChart.ADV_DEF,0.5);
			}
			
		}
		
		
		
		public function refresh():void{
			chart.refresh();
		}
		
		public function clear():void{
			
			chart.clear();
		}
		
		
		override public function dispose():void
		{
			stop();
			chart.dispose();
			super.dispose();
		}
		
		
		public function start():void{
			bar.rotation = Math.PI*2*Math.random();
			loop();
		}
		
		private function loop():void{
			stop();
			TweenLite.to(bar,0.2+speed*0.01,{rotation:bar.rotation+Math.PI*2,ease:Linear.easeNone,onComplete:loop});
		}
		
		public function roAngle(angle:int,_speed:Number):void{
			TweenLite.to(bar,0.2+_speed,{rotation:bar.rotation+angle*Math.PI/180,ease:Quad.easeOut});
		}
		
		
		
		public function get value():int{
			var v:int = ((bar.rotation-Math.PI)*180/Math.PI)%360;
			while(v<0){
				v+=360;
			}
			return v;
		}
		
		public function stop():void{
			TweenLite.killTweensOf(bar);
		}
		
		
		
	}
}