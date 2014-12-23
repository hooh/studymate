package com.studyMate.view.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	/**
	 *可以以BitmapData自定义皮肤按钮 
	 * @author HooH
	 * 
	 */	
	public class MCButton extends Sprite implements IData
	{
		public var upSkin:Class;
		public var downSkin:Class;
		public var overSkin:Class;
		public var disableSkin:Class;
		
		public var pic:DisplayObjectContainer;
		public var state:String;
		private var _enable:Boolean;
		public var label:String;
		private var _data:*;
		
		/**
		 * 
		 * @param upSkin 正常状态皮肤
		 * @param downSkin 按下状态皮肤
		 * @param overSkin 经过状态皮肤
		 * @param disableSkin 实效状态皮肤
		 * 
		 */		
		public function MCButton(upSkin:Class = null,downSkin:Class=null,overSkin:Class=null,disableSkin:Class=null,label:String=null)
		{
			
			init(upSkin,downSkin,overSkin,disableSkin,label);
			enable = true;
			
			config();
			
			
		}
		
		public function init(upSkin:Class = null,downSkin:Class=null,overSkin:Class=null,disableSkin:Class=null,label:String=null):void{
			this.upSkin = upSkin;
			this.downSkin = downSkin;
			this.overSkin = overSkin;
			this.disableSkin = disableSkin;
			label = label;
			
			if(pic==null&&upSkin!=null){
				pic = new upSkin;
				addChild(pic);
				height = pic.height;
				setLabel(label);
				
			}
			
			
			
		}
		
		public function setLabel(_label:String):void{
			if(_label){
				label = _label;
				var txt:TextField = pic.getChildByName("txt") as TextField;
				if(txt){
					txt.text =  _label;
				}
				
			}
		}
		
		
		protected function mouseDownHandle(event:Event):void{
			
			
			if(downSkin){
				clean();
				pic = new downSkin();
				addChild(pic);
				setLabel(label);
			}else{
				this.filters = [new flash.filters.GlowFilter(0xffff00F,0.5,32,32,2)];
				
			}
			
			
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandle);
			state = "down";
			
		}
		
		private function clean():void{
			
			if(pic){
				removeChild(pic);
				pic = null;
			}
			
		}
		
		protected function mouseUpHandle(event:Event):void{
			
			if(downSkin){
				clean();
				pic = new upSkin();
				addChild(pic);
				setLabel(label);
			}else{
				this.filters = [];
			}
			
			if(stage){
				stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandle);
			}
			
			state = "up";
		}
		
		
		
		public function config():void{
			buttonMode = true;
			mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandle);
		}
		
		public function set enable(__enable:Boolean):void{
			
			mouseEnabled = __enable;
			
			if(_enable!=__enable){
				if(__enable){
					clean();
					if(upSkin){
						pic = new upSkin();
						addChild(pic);
					}
					state = "up";
				}else{
					if(disableSkin){
						clean();
						pic = new disableSkin();
						addChild(pic);
					}else{
						pic.alpha = 0.5;
					}
					state = "disable";
				}
			}
			
			_enable = __enable;
		}
		
		public function get enable():Boolean{
			return _enable;
		}

		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data = value;
		}

		
	}
}