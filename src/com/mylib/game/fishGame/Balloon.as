package com.mylib.game.fishGame
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Graphics;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Balloon extends Sprite implements IAnimatable
	{
		private var vs:Vector.<Vtx>;
		private var ss:Vector.<Spr>;
		private var graphics:Graphics;
		private var img:Image;
		public var fix:Boolean;
		
		public function Balloon()
		{
			
			init();
			
			Starling.juggler.add(this);
			vs[0].vx = 0.2;
			vs[0].vy = -0.4;
			
			TweenMax.to(vs[0],2,{vx:-0.1,vy:0.2,yoyo:true,repeat:999});
			
			addEventListener(Event.REMOVED_FROM_STAGE,removeHandle);
			
		}
		
		private function removeHandle(event:Event):void
		{
			if(ss){
				ss = null;
			}
			if(vs[0]){
				TweenMax.killTweensOf(vs[0]);
				vs = null;
			}
			removeChildren(0,-1,true);
			Starling.juggler.remove(this);
		}		
		
		private function init():void{
			
			img = new Image(Assets.getAtlasTexture("task/star"));
			addChild(img);
			
			var line:Sprite = new Sprite;
			addChildAt(line,0);
			line.x = img.width*0.5;
			line.y = img.height-10;
			
			graphics = new Graphics(line);
			
			var numChain:int = 5;
			var chainLen:Number = 16;
			
			vs = new Vector.<Vtx>(numChain, true);
			ss = new Vector.<Spr>();
			var yy:int;
			vs[0] = new Vtx(0, 0, 0);
			for (var i:int = 1; i < numChain; i++) {
				yy += chainLen;
				vs[i] = new Vtx(x, yy, 0.5);
				ss.push(new Spr(vs[i], vs[i - 1], chainLen, true, true));
			}
			
			
			
		}
		
		public function fly():void{
			TweenLite.killTweensOf(vs[0]);
			vs[0].vy = -2;
			vs[0].vx = 1;
		}
		
		public function setTail(_x:Number,_y:Number):void{
//			trace(vs[vs.length-1].x,vs[vs.length-1].y);
			vs[vs.length-1].x = _x;
			vs[vs.length-1].y = _y;
			
			
		}
		
		
		
		public function advanceTime(time:Number):void
		{
			graphics.clear();
			graphics.lineStyle(1, 0);
			
			var numV:int;
			
			if(fix){
				numV = vs.length-1;
			}else{
				numV = vs.length;
			}
			
			
			for (var i:int = 0; i < numV; i++) {
				var v:Vtx = vs[i];
				v.move();
			}
			
			
			var numS:int = ss.length;
			for (var t:int = 0; t < 4; t++) {
				ss[0].move();
				for (i = 1; i < numS; i++) {
					ss[i].move();
					var swap:int = int(Math.random() * i);
					var tmp:Spr = ss[i];
					ss[i] = ss[swap];
					ss[swap] = tmp;
				}
			}
			for (i = 0; i < numS; i++) {
				ss[i].draw(graphics);
			}
			
			img.x = vs[0].x;
			img.y = vs[0].y;
			
		}
		
	}
}
import starling.display.Graphics;


class Vtx {
	public var x:Number;
	public var y:Number;
	public var vx:Number;
	public var vy:Number;
	public var mass:Number;
	
	public function Vtx(x:Number, y:Number, mass:Number) {
		this.x = x;
		this.y = y;
		vx = 0;
		vy = 0;
		this.mass = mass;
	}
	
	public function move():void {
		x += vx;
		y += vy;
		if (mass != 0) {
			vy += mass;
		}
	}
	
	public function wall(wy:Number):void {
		if (mass != 0 && y + vy < wy) {
			vy += wy - (y + vy);
		}
	}
	
	public function draw(g:Graphics):void {
		/*if (mass == 0){
			g.drawCircle(x, y, 5);
		}*/
	}
	
}

class Spr {
	public var v1:Vtx;
	public var v2:Vtx;
	public var rest:Number;
	public var visible:Boolean;
	public var rigid:Boolean;
	
	public function Spr(v1:Vtx, v2:Vtx, rest:Number, rigid:Boolean, visible:Boolean) {
		this.v1 = v1;
		this.v2 = v2;
		this.rest = rest;
		this.rigid = rigid;
		this.visible = visible;
	}
	
	public function move():void {
		var dx:Number = (v2.x + v2.vx) - (v1.x + v1.vx);
		var dy:Number = (v2.y + v2.vy) - (v1.y + v1.vy);
		var dist:Number = Math.sqrt(dx * dx + dy * dy);
		if (dist == 0) return;
		var m:Number = 1 / (v1.mass + v2.mass);
		var invDist:Number = 1 / dist;
		var dvx:Number = v2.vx - v1.vx;
		var dvy:Number = v2.vy - v1.vy;
		var nx:Number = dx * invDist;
		var ny:Number = dy * invDist;
		var rvn:Number = nx * dvx + ny * dvy;
		var f:Number = m * (dist - rest + rvn * 0.8);
		if (!rigid && f < 0) f = 0;
		var fx:Number = nx * f;
		var fy:Number = ny * f;
		v1.vx += fx * v1.mass;
		v1.vy += fy * v1.mass;
		v2.vx -= fx * v2.mass;
		v2.vy -= fy * v2.mass;
	}
	
	public function draw(g:Graphics):void {
		if (!visible) return;
		g.moveTo(v1.x, v1.y);
		g.lineTo(v2.x, v2.y);
		
		
	}
	
}