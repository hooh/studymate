package com.studyMate.world.screens.component
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.studyMate.world.controller.vo.RemindPriMessVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ChatFriendListScroll extends starling.display.Sprite
	{
		private var texture:Texture;
		private var relList:Vector.<RelListItemSpVO>;
		
		private var itemBgList:Vector.<Image> = new Vector.<Image>;
		private var itemIconList:Vector.<Image> = new Vector.<Image>;
		private var itemMessList:Vector.<starling.display.Sprite> = new Vector.<starling.display.Sprite>;
		
		
		
		public function ChatFriendListScroll(_relList:Vector.<RelListItemSpVO>)
		{
			super();
			
			
			relList = _relList;
			
			
			freshRelList();
		}
		
		
		private function freshRelList():void{
			//清空旧列表
			if(texture)	texture.dispose();
			itemBgList.splice(0,itemBgList.length);
			itemIconList.splice(0,itemIconList.length);
			itemMessList.splice(0,itemMessList.length);
			
			removeChildren(0,-1,true);
			
			
			//加选项背景
			for(var i:int=0;i<relList.length;i++){
				var bg:Image = new Image(Assets.getChatViewTexture("friItemBg"));
				bg.y = i*61;
				bg.visible = false;
				itemBgList.push(bg);
				addChild(bg);
			}
			
			//加所有好友item
			texture = Texture.fromBitmapData(getListBitmap(),false);
			var scroll:Image = new Image(texture);
			scroll.x = 55;
			addChild(scroll);
			
			
			//加所有好友头像
			for(i=0;i<relList.length;i++){
				var firIcon:String = "friIconF";
				
				//头像
				var icon:Image = new Image(Assets.getChatViewTexture(firIcon));
				icon.x = 10;
				icon.y = i*61+4;
				addChild(icon);
				itemIconList.push(icon);
				
				//有消息，需要提醒
				if(relList[i].isShake)
					shakeIcon(i);
				
				
				//消息条数
				var messNumSp:starling.display.Sprite = new starling.display.Sprite;
				messNumSp.y = i*61;
				addChild(messNumSp);
				messNumSp.visible = false;
				itemMessList.push(messNumSp);
				
				var messNumBg:Image = new Image(Assets.getChatViewTexture("firMessNum"));
				messNumSp.addChild(messNumBg);
				
				var messNumTF:starling.text.TextField = new starling.text.TextField(20,15,"","HeiTi",12,0xffffff);
				messNumTF.x = 1;
				messNumTF.hAlign = HAlign.CENTER;
				messNumTF.vAlign = VAlign.TOP;
				messNumSp.addChild(messNumTF);
				
				if(relList[i].messNum > 0){
					itemMessList[i].visible = true;
					
					//文本
					(itemMessList[i].getChildAt(1) as starling.text.TextField).text = relList[i].messNum.toString();
				}
			}
			
			
			
		}
		
		private var sp:flash.display.Sprite;
		//生成好友名单bitmap
		private function getListBitmap():BitmapData{
			if(sp)	sp.removeChildren(0,sp.numChildren-1);
			
			sp = new flash.display.Sprite;
			
			
			var tf:TextFormat = new TextFormat("HeiTi",16);
			tf.align = TextFormatAlign.LEFT;
			var nameTF:flash.text.TextField;
			
			
			for(var i:int=0;i<relList.length;i++){
				
				nameTF = new flash.text.TextField();
				nameTF.autoSize = TextFieldAutoSize.LEFT;
				
				nameTF.embedFonts = true;
				nameTF.defaultTextFormat = tf;
				nameTF.antiAliasType = AntiAliasType.ADVANCED;
				nameTF.width = 65;
				nameTF.height= 20;
				nameTF.text = relList[i].realName;
				nameTF.y = i*61+12;
				
				if(relList[i].relaType == "S")
					nameTF.textColor = 0x404dfe;
				
				sp.addChild(nameTF);
			}
			
			var bitdata:BitmapData = new BitmapData(66,sp.numChildren*61,true,0x00000000);
			bitdata.draw(sp);
			
			return bitdata;
		}
		
		//更新列表
		public function updateList(_relList:Vector.<RelListItemSpVO>):void{
			
			relList = _relList;
			
			
			freshRelList();
		}
		
		
		
		
		
		private function shakeIcon(_idx:int):void{
			
			TweenMax.to(itemIconList[_idx],0.3,{x:itemIconList[_idx].x+2,y:itemIconList[_idx].y+2,repeat:int.MAX_VALUE,yoyo:true,ease:Linear.easeNone});
			
		}
		public function stopShake(_idx:int):void{
			relList[_idx].isShake = false;
			relList[_idx].messNum = 0;
			itemMessList[_idx].visible = false;
			
			TweenLite.killTweensOf(itemIconList[_idx]);
			itemIconList[_idx].x = 10;
			itemIconList[_idx].y = _idx*61+4;
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.REMIND_PRIVATE_MESS,new RemindPriMessVO(false,relList[_idx].rstdId));
		}
		
		
		
		
		
		public function setItemSelect(_idx:int,_isSelect:Boolean=true):void{
			if(_idx != -1)
				itemBgList[_idx].visible = _isSelect;

		}
		
		
		
		override public function dispose():void
		{
			super.dispose();
			
			texture.dispose();
			if(sp)
				sp.removeChildren(0,sp.numChildren-1);
			
			removeChildren(0,-1,true);
		}
		

		
		
		
		
		
	}
}