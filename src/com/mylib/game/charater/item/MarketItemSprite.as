package com.mylib.game.charater.item
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.world.screens.MarketBuyViewMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class MarketItemSprite extends Sprite
	{
		private var markItemSpVo:MarketItemSpriteVO;
		
		private var nameTF:TextField;
		private var goldCostTF:TextField;
		private var tf:TextFormat = new TextFormat(null,15);
		private var loaders:Loader = new Loader();
		public var faceImgTexture:Texture;
		
		private var sp:flash.display.Sprite = new flash.display.Sprite(); //商品图标
		private var btn:Button;
		
		private var canTouch:Boolean = true;
		
		public function MarketItemSprite(_markItemSpVo:MarketItemSpriteVO,_canTouch:Boolean=true)
		{
			this.markItemSpVo = _markItemSpVo;
			this.canTouch = _canTouch;
			
			init();
		}
		
		private function init():void{
			var bg:Image = new Image(Assets.getMarketTexture("Frame/ItemFrame"));
			bg.x = 92-(bg.width>>1);
			addChild(bg);
			
			
			if(canTouch){
				nameTF = new TextField(130,45,"","HuaKanT",20,0xb81cd6);
			}else{
				nameTF = new TextField(130,45,"","HuaKanT",20,0x737373);
			}
			nameTF.hAlign = HAlign.CENTER;
			nameTF.x = 30;
			nameTF.y = 115;
			
			goldCostTF = new TextField(100,20,"","HuaKanT",20,0xa50000);
			goldCostTF.hAlign = HAlign.LEFT;
			goldCostTF.x = 131;
			goldCostTF.y = 83;
			
			
			loaders.contentLoaderInfo.addEventListener(Event.COMPLETE,LoaderComHandler);
			if(markItemSpVo.wbidlean.bytesAvailable != 0)
				loaders.loadBytes(markItemSpVo.wbidlean);
			else
				loaders.load(new URLRequest(Global.document.resolvePath(Global.localPath + "Market/GoodsFace/" + "video_defaultIcon" + ".png").url));

		}
		
		override public function dispose():void
		{
			if(loaders){
				loaders.contentLoaderInfo.removeEventListener(Event.COMPLETE,LoaderComHandler);
			}
			if(faceImgTexture){
				faceImgTexture.dispose();
			}
			removeChildren(0,-1,true);
			super.dispose();
		}
		
		private function LoaderComHandler(event:Event):void{
			faceImgTexture = Texture.fromBitmap(event.target.content,false);
			var faceImg:Image = new Image(faceImgTexture);
			faceImg.width = 123;
			faceImg.height = 92;
			faceImg.x = 92-(faceImg.width>>1);
			faceImg.y = 3;
			addChild(faceImg);
			
			var infoImg:Image = new Image(Assets.getMarketTexture("Frame/infoPanel"));
			infoImg.x = 90;
			infoImg.y = 72;
			if(canTouch){
				addChild(infoImg);
			}
			
			
			
			if(markItemSpVo.frameName.length > 6)	nameTF.text = markItemSpVo.frameName.substr(0,5)+"..";
			else	nameTF.text = markItemSpVo.frameName;
			addChild(nameTF);
			
			goldCostTF.text = markItemSpVo.goldCost;
			if(canTouch){
				addChild(goldCostTF);
			}

			this.addEventListener(TouchEvent.TOUCH,btnHandle);
		}
		private function btnHandle(event:TouchEvent):void{
			if(event.touches[0].phase == TouchPhase.ENDED){
				
				if(canTouch){
					Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,
						[new SwitchScreenVO(MarketBuyViewMediator,[new Point(this.x,this.y),markItemSpVo,faceImgTexture],SwitchScreenType.SHOW,this.parent.stage)]);
				}else{
					Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST, new ToastVO("非适龄电影,不能购买哦~",1));
					
				}
				
				
				
			}
		}
	}
}