package com.mylib.game.charater.logic
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	public class RandomActionProxy extends Proxy implements IProxy
	{
		public static var NAME:String = "RandomActionProxy";
		public static var proxyNum:int= 0;
		public var name:String = ""; //带序号的proxy名字

		private var displayObject:Object;
		private var holder:Sprite; //显示对象的容器
		private var _costumes:Object; //存储显示对象movieclip
		private var captain:Object; //当前显示的movieclip
//		private var image:DisplayObject; //当前显示的image
		private var _juggler:Juggler; //starling类
		
		private var randomX:int; //起始点X值
		private var randomY:int; //起始点Y值
		private var endX:int; //结束点X值
		private var endY:int; //结束点Y值
		
		private var range:Rectangle; //指定显示对象运动范围
		
		private var randomSize:Boolean = true; //是否随机大小，默认为true
		private var randomAction:Boolean = true; //是否随机运动，默认为true
		private var randomSpeed:Boolean = true; //是否变速，默认为true
		
		private var actionDirection:String = "LTR"; //非随机运动，默认运动路径从左到右
		private var fps:int = 8; //默认fps为8
		private var setFrameDuration:Object; //设置显示对象movieclip每帧的时间
		
		private var isImage:Boolean; //displayObject类型，是否为图片，否则是MC
		
		public function RandomActionProxy(data:Object=null)
		{
			name = NAME+proxyNum.toString();
			super(name, data);
			proxyNum++;
		}
		
		override public function onRegister():void
		{
		}

		override public function onRemove():void
		{
			proxyNum = 0;
			TweenLite.killTweensOf(pick);
			TweenMax.killTweensOf(captain);
			TweenLite.killTweensOf(manualAction);
			
			if(!isImage)
				_juggler.remove(captain as MovieClip);
			
			name = null;
		}

		//Action启动入口
		public function addItem(item:Object):void{
			this.displayObject = item.displayObject as Object;
			this.holder = item.holder as Sprite;
			if(item.range != null){
				this.range = item.range as Rectangle;
			}else{
				this.range = new Rectangle(0,0,holder.width,holder.height);
			}
			
			if(item.randomSize != null)
				this.randomSize = item.randomSize as Boolean;
			
			if(item.randomAction != null)
				this.randomAction = item.randomAction as Boolean;
			if(!randomAction){
				if(item.actionDirection != null)
					this.actionDirection = item.actionDirection as String;
				getActDirection();
			}
			
			if(item.randomSpeed != null)
				this.randomSpeed = item.randomSpeed as Boolean;
			
			if(item.fps != null)
				this.fps = item.fps;
			
			if(item.setFrameDuration != null)
				this.setFrameDuration = item.setFrameDuration;
			
			start();
		}
		
		public function start():void{
			_juggler = Starling.juggler;
			
			if(!(displayObject is MovieClip)){
				isImage = true;
				
				_costumes||=new Object();
				_costumes["image"] = displayObject as DisplayObject;
				
				centerPivot(_costumes["image"] as DisplayObject);
			}else{
				isImage = false;

				_costumes||=new Object();
				_costumes["movieClip"] = displayObject as MovieClip;
				(_costumes["movieClip"] as MovieClip).fps = fps;
				
				if(setFrameDuration != null)
					for(var k:int=0;k<setFrameDuration.length;k++)
						(_costumes["movieClip"] as MovieClip).setFrameDuration(k,setFrameDuration[k]);

				centerPivot(_costumes["movieClip"] as MovieClip);
			}

			//判断是否为随机运动
			if(randomAction)
				randomPick(0);
			else
				manualAction();
		}

		//随机运动
		private function randomPick(_time:int):void{
			TweenLite.delayedCall(_time,pick);
		}
		public function pick():void{
			var name:String;
			if(isImage)	name = "image";
			else	name = "movieClip";
			
			randomX = Math.round(Math.random()*range.width)+range.x;
			randomY = Math.round(Math.random()*range.height)+range.y;
			if(randomX<=((range.width>>1)+range.x))
				endX = Math.round(Math.random()*((range.width>>1)-50))+(range.width>>1)+50+range.x;
			else
				endX = Math.round(Math.random()*((range.width>>1)-50))+range.x;
			endY = Math.round(Math.random()*range.height)+range.y;
			
			TweenMax.killTweensOf(captain);
			switchCostume(name,randomX,randomY,endX,endY,endX<randomX,randomSize,true,randomSpeed);
		}
		private function switchCostume(name:String,_randomX:int,_randomY:int,
									   _endX:int,_endY:int,_oppo:Boolean=false,
									   _randomSize:Boolean=true,_randomAction:Boolean=true,
									   _randomSpeed:Boolean=true):void
		{
			if(isImage){
				holder.removeChild(captain as DisplayObject);
			}else{
				//stop the current costume from animating 
				_juggler.remove(captain as MovieClip);
				holder.removeChild(captain as MovieClip);
			}
			
			captain=_costumes[name];
			captain.alpha = 0;
			captain.x = _randomX;
			captain.y = _randomY;
			
			var _randomScale:Number = 1;
			if(_randomSize)
				_randomScale = (Math.round(Math.random()*4)+8)*0.1; //随机0.8~1.2
			
			if(_oppo)
				captain.scaleX = -_randomScale;
			else
				captain.scaleX = _randomScale;
			captain.scaleY = _randomScale;
			
			if(isImage){
				holder.addChild(captain as DisplayObject);
			}else{
				holder.addChild(captain as MovieClip);
				//start the new costume animating
				_juggler.add(captain as MovieClip);
			}

			
			var distance:int = Math.round(Math.sqrt(Math.pow(_endX-_randomX,2)+Math.pow(_endY-_randomY,2)));
			var time:int;
			if(_randomSpeed)	time = distance/((Math.random()*50)+25);
			else	time = distance/50;
			
			TweenMax.to(captain,time/4,{alpha:1,ease:Linear.easeNone});
			TweenMax.to(captain,time,{x:_endX,y:_endY,ease:Linear.easeNone});
			TweenMax.to(captain,time/4,{delay:(time/4)*3,alpha:0,x:_endX,y:_endY,ease:Linear.easeNone});
			
			if(_randomAction){
				randomPick(time);
			}
			else{
				time = Math.round(Math.random()*10)+time;
				TweenLite.delayedCall(time*2,manualAction);
			}
		}
		
		//非随机运动
		private function manualAction():void{
			//指定路径可能更新，刷新动作路径
			getActDirection();
			var name:String;
			if(isImage)	name = "image";
			else	name = "movieClip";
			switchCostume(name,randomX,randomY,endX,endY,endX<randomX,randomSize,false,randomSpeed);
		}
		//解析指定动作路径
		private function getActDirection():void{
			switch(actionDirection){
				case "LTR":
					randomX = range.x;
					endX = range.x+range.width;
					endY = randomY = range.y+range.height>>1;
					break;
				case "RTL":
					randomX = range.x+range.width;
					endX = range.x;
					endY = randomY = range.y+range.height>>1;
					break;
				case "DTU":
					randomX = endX = range.x+range.width>>1;
					randomY = range.y+range.height;
					endY = range.y;
					break;
				case "UTD":
					randomX = endX = range.x+range.width>>1;
					randomY = range.y;
					endY = range.y+range.height;
					break;
			}
		}
	}
}