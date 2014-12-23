package com.studyMate.world.component.SVGEditor.product.display
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditBase;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	
	/**
	 * 所有编辑显示类的基类。
	 * 所有可编辑的对象均继承自本来或其子类
	 * @author wt
	 * 
	 */	
	internal class EditSVGBase extends Sprite implements IEditBase
	{
		private var _id:String;//id
		private var _type:String;//类型如 text rect
		
		
		private var _attributes:Object = {};//其他属性的定义
		private var _needUpdate:Boolean;
		
		protected var dragRect:Sprite;//拖动滑块
						
		public function EditSVGBase()
		{
			super();
			this.addEventListener(MouseEvent.CLICK,clicHandler);
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeStageHandler);
			
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,true,1);
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode){
				case Keyboard.UP:
					Facade.getInstance(CoreConst.CORE).sendNotification(SVGConst.PROPERTIES,this);//发送属性面板
					this.y -=1;
					break;
				case Keyboard.DOWN:
					this.y +=1;
					Facade.getInstance(CoreConst.CORE).sendNotification(SVGConst.PROPERTIES,this);//发送属性面板
					break;
				case Keyboard.LEFT:
					this.x -=1;
					Facade.getInstance(CoreConst.CORE).sendNotification(SVGConst.PROPERTIES,this);//发送属性面板
					break;
				case Keyboard.RIGHT:
					this.x +=1;
					Facade.getInstance(CoreConst.CORE).sendNotification(SVGConst.PROPERTIES,this);//发送属性面板
					break;
			}
		}
		
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		protected function removeStageHandler(event:Event):void
		{
			this.removeChildren();
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler,true);
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
			this.removeEventListener(MouseEvent.CLICK,clicHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removeStageHandler);
			this.removeEventListener(Event.RENDER,render);
		}
		
		protected function clicHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		protected function addToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			this.addEventListener(Event.RENDER,render);
			if ( _needUpdate)   stage.invalidate(); 
		}
		
		protected function setXML(xml:XML):void{
			xml.@id = this.id;
			xml.@x = this.x;
			xml.@y = this.y;
			var keyVec:Vector.<String> = this.getAllAttribute();
			for(var i:int=0;i<keyVec.length;i++){
				xml.@[keyVec[i]] = getAttribute(keyVec[i]);
			}
		}
		
		/**
		 * 获取该Element的XML内容,由子类重写
		 * 
		 */		
		public function getElementXML():XML{
			return null;
		}
		
		/**
		 * 读取属性 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getAttribute(name:String):Object {
			return _attributes[name];
		}
		/**
		 * 设置属性
		 * @param name 属性名
		 * @param value 属性值
		 * 
		 */		
		public function setAttribute(name:String, value:Object):void {
			if(_attributes[name] != value){				
				_attributes[name] = value;

				needUpdate = true;
			}
		}
		/**
		 * 移除属性 
		 * @param name
		 * 
		 */		
		public function removeAttribute(name:String):void {
			delete _attributes[name];
		}
		
		/**
		 * 是否有属性 
		 * @param name
		 * @return 
		 * 
		 */		
		public function hasAttribute(name:String):Boolean {
			return name in _attributes;
		}
		
		/**
		 * 获取所有属性
		 */
		public function getAllAttribute():Vector.<String>{
			var keyStr:Vector.<String> = new Vector.<String>;
			for (var key:String in _attributes){
				keyStr.push(key);
			}
			return keyStr;
		}
		

		protected function get needUpdate():Boolean
		{
			return _needUpdate;
		}
		
		protected function set needUpdate(value:Boolean):void
		{
			if(_needUpdate == value) return
			_needUpdate = value;
			if(_needUpdate){
				this.addEventListener(Event.RENDER,render);				
				Global.stage.invalidate();
				
			}else{
				this.removeEventListener(Event.RENDER,render);
			}
		}
		
		/**
		 * 由子类继承
		 * @param e
		 * 
		 */		
		protected function render(e:Event=null):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(SVGConst.PROPERTIES,this);//发送属性面板
			
			needUpdate = false;
			setDragFunc();
		}
		
		/**
		 *	设置拖动方式。默认是有小方格的。可以子类重写
		 * 
		 */		
		protected function setDragFunc():void{
			if(dragRect==null){
				dragRect = new Sprite();
				dragRect.graphics.clear();
				dragRect.graphics.lineStyle(1,0x123456);
				dragRect.graphics.beginFill(0,0.1);
				dragRect.graphics.drawRect(0,0,this.width,this.height);
				dragRect.graphics.endFill();
				this.addChild(dragRect);
				dragRect.doubleClickEnabled = true;
				dragRect.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);//拖动使用
				dragRect.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickHandler);//双击隐藏
			}						
		}
		
		protected function doubleClickHandler(event:MouseEvent):void
		{
			dragRect.visible = false;
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			this.startDrag();
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
					
		}
		protected function stageMouseUpHandler(event:MouseEvent):void
		{			
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
			this.stopDrag();						
			Facade.getInstance(CoreConst.CORE).sendNotification(SVGConst.PROPERTIES,this);
		}
	}
}