package com.studyMate.world.screens.component
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class ChatViewlSimpleBtn extends Sprite
	{
		private var mutiState:Boolean;
		private var firBtnTexture:Texture;
		private var secBtnTexture:Texture;
		
		public function ChatViewlSimpleBtn(_mutiState:Boolean,_firBtnTexture:Texture,_secBtnTexture:Texture=null)
		{
			super();
			
			mutiState = _mutiState;
			firBtnTexture = _firBtnTexture;
			secBtnTexture = _secBtnTexture;
			
			
			var bg:Image = new Image(Assets.getChatViewTexture("simpleBtnBg"));
			addChild(bg);
			
			
			initBtn();
		}
		
		private var firBtn:Button;
		private var secBtn:Button;
		private function initBtn():void{
			
			firBtn = new Button(firBtnTexture);
			firBtn.x = (this.width-firBtn.width)>>1;
			firBtn.y = 1;
			addChild(firBtn);
				
			//多按钮状态
			if(mutiState){	
				secBtn = new Button(secBtnTexture);
				secBtn.x = (this.width-secBtn.width)>>1;
				secBtn.y = 1;
				secBtn.visible = false;
				addChild(secBtn);
				
			}
		}
		//添加按钮监听
		public function addBtnListener(type:String, listener:Function):void{
			
			firBtn.addEventListener(type,listener);
			
			if(mutiState){
				
				firBtn.addEventListener(Event.TRIGGERED,firbtnHandle);
				
				secBtn.addEventListener(type,listener);
				secBtn.addEventListener(Event.TRIGGERED,secbtnHandle);
			}
		}
		//移除按钮监听
		public function removeBtnListener(type:String, listener:Function):void{
			
			firBtn.removeEventListener(type,listener);
			
			if(mutiState){
				
				firBtn.removeEventListener(Event.TRIGGERED,firbtnHandle);
				
				secBtn.removeEventListener(type,listener);
				secBtn.removeEventListener(Event.TRIGGERED,secbtnHandle);
			}
		}
		
		
		
		private function firbtnHandle():void{
			
			firBtn.visible = false;
			secBtn.visible = true;
			
		}
		private function secbtnHandle():void{
			secBtn.visible = false;
			firBtn.visible = true;
			
			
		}
		
		public function enable(_value:Boolean=false):void{
			if(firBtn)	firBtn.enabled = _value;
			if(secBtn)	secBtn.enabled = _value;
		}
		public function text(_value:String=""):void{
			if(firBtn)	firBtn.text = _value;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(firBtn)
				firBtn.removeEventListeners(Event.TRIGGERED);
			if(secBtn)
				secBtn.removeEventListeners(Event.TRIGGERED);
		}
		
	}
}