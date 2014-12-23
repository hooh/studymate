package com.studyMate.world.screens
{
	import com.studyMate.global.Global;
	import com.studyMate.world.model.vo.PromiseVO;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class PromiseItem extends Sprite
	{
		private var _promise:PromiseVO;
		
		private var background:Quad;
		private var proPhoto:Image;
		
		public function PromiseItem(){
			super();
		}
		
		public function get promise():PromiseVO{
			return _promise;
		}

		public function set promise(value:PromiseVO):void{
			_promise = value;
			this.name = promise.proid;
			this.removeChildren(0, -1, true);
			makeItem();
		}
		
		private function makeItem():void{
			initBg();
			addDetails();
			addButtons();
		}

		private function initBg():void{
			background = new Quad(892, 148, 0x000000);
			background.alpha = 0;
			this.addChild(background);
		}
		
		private function addDetails():void{
			var baseX:Number = 0;
			if(promise.rwstatus== "Y" && promise.hasImage){
				baseX = 121;
			}
			
			var childName:starling.text.TextField = new starling.text.TextField(85, 28, Global.player.name, "HuaKanT", 20, 0xe18242);
			childName.autoScale = true;
			childName.x = baseX + 19; childName.y = 22;
			this.addChild(childName);
			
			var target:starling.text.TextField = new starling.text.TextField(778, 28, "获取" + promise.gold + "个金币", "HuaKanT", 20, 0x725f5f);
			target.autoScale = true;target.hAlign = HAlign.LEFT;
			target.x = baseX + 106; target.y = 22;
			this.addChild(target);
			
			var parName:starling.text.TextField = new starling.text.TextField(85, 28, promise.parname, "HuaKanT", 20, 0xe18242);
			parName.autoScale = true;
			parName.x = baseX + 19; parName.y = 70;
			this.addChild(parName);
			
			var jiangLi:starling.text.TextField = new starling.text.TextField(778, 39, "奖励  " + promise.rwcontent, "HuaKanT", 20, 0x725f5f);
			jiangLi.autoScale = true;
			jiangLi.hAlign = HAlign.LEFT; jiangLi.vAlign = VAlign.TOP;
			jiangLi.x = baseX + 106; jiangLi.y = 70;
			this.addChild(jiangLi);
			
			var sign:starling.text.TextField = new starling.text.TextField(240, 25, Global.player.name + " / " + promise.parname, "HuaKanT", 18, 0x827968);
			sign.autoScale = true;
			sign.hAlign = HAlign.RIGHT;
			sign.x = 460; sign.y = 118;
			this.addChild(sign);
			
			var time:starling.text.TextField = new starling.text.TextField(110, 25, promise.sdate.substr(0,4) + "-" + promise.sdate.substr(4,2)+ "-" + promise.sdate.substr(6,2), "comic", 18, 0x68afc4);
			time.autoScale = true;
			time.hAlign = HAlign.RIGHT;
			time.x = 680; time.y = 118;
			this.addChild(time);
		}
		
		
		public var deleteBtn:Button;
		public var smallCamerBtn:Button;
		public var cameraBtn:Button;
		public var confirm:Button;
		
		public var photo:Image;
		
		private function addButtons():void{
			deleteBtn = new starling.display.Button(Assets.getAtlasTexture("targetWall/dele"));
			deleteBtn.x = 849; deleteBtn.y = 113;
			this.addChild(deleteBtn);
			
			if(promise.rwstatus == "Y"){
				if(promise.hasImage){
					var finishImage:Image = new Image(Assets.getAtlasTexture("targetWall/finish"));
					finishImage.x = 746; finishImage.y = 11;
					this.addChild(finishImage);
					
					photo = promise.image;
					this.addChild(photo);
					photo.pivotX = photo.width >> 1; photo.pivotY = photo.height >> 1;
					photo.x = 19 + photo.pivotX;
					photo.y = (148 - photo.height) / 2 + photo.pivotY;
					
					smallCamerBtn = new starling.display.Button(Assets.getAtlasTexture("targetWall/cameraSmall"));
					smallCamerBtn.x = 799; smallCamerBtn.y = 113; 
					this.addChild(smallCamerBtn);
				}else{
					cameraBtn = new starling.display.Button(Assets.getAtlasTexture("targetWall/cameraBig"));
					cameraBtn.x = 760; cameraBtn.y = 34;
					this.addChild(cameraBtn);
				}
			}else if(promise.status == "Y"){
				confirm = new starling.display.Button(Assets.getAtlasTexture("targetWall/fulfillBtn"));
				confirm.x = 754; confirm.y = 47;
				confirm.name = promise.proid.toString();
				this.addChild(confirm);
			}
		}
		
	}
}