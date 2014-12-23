package com.mylib.game.drawing
{
	import com.emibap.textureAtlas.DynamicAtlas;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Linear;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.CmdStr;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.IGraphicsData;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import de.polygonal.core.ObjectPool;
	
	import feathers.controls.Button;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	public class DrawingGalleryMeditor extends ScreenBaseMediator
	{
		public static const NAME:String = "DrawingGalleryMeditor";
		private static const DATA_REC:String = NAME + "datarec";
		private var raw:Vector.<DrawingDataVO>;
		private var atlas:TextureAtlas;
		
		private var selected:DrawingSprite;
		
		private var spritePool:ObjectPool;
		private var drawingSpritePool:ObjectPool;
		private var textureHolder:flash.display.Sprite;
		
		private var imgHolder:Sprite3D;
		private var imgArray:Vector.<DrawingSprite>;
		
		private var juggler:Juggler;
		
		
		public function DrawingGalleryMeditor(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return starling.display.Sprite;
		}
		
		public function get view():starling.display.Sprite{
			
			return getViewComponent() as starling.display.Sprite;
			
		}
		
		private function getPage():void{
			
			raw = new Vector.<DrawingDataVO>;
			PackData.app.CmdIStr[0] = CmdStr.QRY_DRAW_DATA;
			PackData.app.CmdIStr[1] = "0";
			PackData.app.CmdInCnt = 2;
			sendNotification(CoreConst.SEND_11,new SendCommandVO(DATA_REC,null,"cn-gb",Vector.<int>([6])));
			
			
		}
		
		
		
		
		private function refresh():void{
			
			
			if(!raw.length){
				return;
			}
			
			
			var item:flash.display.Sprite;
			for (var i:int = 0; i < raw.length; i++) 
			{
				
				item = spritePool.object as flash.display.Sprite;
				textureHolder.addChild(item);
				item.name = "p"+i;
				item.graphics.beginFill(0xeeeeee);
				item.graphics.drawRect(0,0,400,400);
				item.graphics.drawGraphicsData(raw[i].picData);
			}
			
			if(atlas){
				atlas.dispose();
			}
			atlas = DynamicAtlas.fromMovieClipContainer(textureHolder,0.25);
			
			
			while(textureHolder.numChildren){
				item = textureHolder.removeChildAt(0) as flash.display.Sprite;
				item.graphics.clear();
				spritePool.object = item;
			}
			
			
			
			for (var j:int = 0; j < raw.length; j++) 
			{
				var img:Image = new Image(atlas.getTexture("p"+j+"_00000"));
				
				img.pivotX = img.width*0.5;
				img.pivotY = img.height*0.5;
				
				
				var sp:DrawingSprite = drawingSpritePool.object as DrawingSprite;
				
				sp.rawData = raw[j];
				sp.addEventListener(TouchEvent.TOUCH,itemHandle);
				sp.addImg(img);
				sp.px = sp.x = (j%8)* (100+10);
				sp.py = sp.y = int(j/8)*(100+10);
				
				imgArray.push(sp);
				
				imgHolder.addChild(sp);
				
				
			}
			
			
			imgHolder.rotationX = -0.6;
			
			
			imgHolder.x = 250;
			imgHolder.y = 100;
			
			
			fadeInPage();
			
		}
		
		private function recyle():void{
			
			var item:DrawingSprite;
			while(imgHolder.numChildren){
				item = imgHolder.removeChildAt(0) as DrawingSprite;
				item.disposeImage();
				item.rawData = null;
				item.removeFromParent();
				drawingSpritePool.object = item;
			}
			
			imgArray.length = 0;
			
		}
		
		private function fadeOutPage():void{
			
			for (var i:int = 0; i < imgArray.length; i++) 
			{
				
				juggler.tween(imgArray[i],0.1,{delay:i*0.05,z:-150,alpha:0,onComplete:fadeOutHandle});
				
				
			}
			
		}
		
		private function fadeOutHandle():void{
			imgArray.shift();
			
			if(!imgArray.length){
				recyle();
				refresh();
			}
			
			
		}
		
		private function fadeInPage():void{
			
			for (var i:int = 0; i < imgArray.length; i++) 
			{
				
				imgArray[i].alpha = 0;
				imgArray[i].z = -150;
				juggler.tween(imgArray[i],0.1,{delay:i*0.05,z:0,alpha:1});
				
				
			}
			
		}
		
		
		
		
		private function itemHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject,TouchPhase.ENDED);
			if(touch){
				var item:DrawingSprite = event.currentTarget as DrawingSprite;
				
				
				if(item==selected){
					item.deactive();
					selected = null;
					return;
				}
				
				
				if(selected){
					selected.deactive();
				}
				item.active();
				selected = item;
				
			}
		}		
		
		
		
		override public function handleNotification(notification:INotification):void
		{
			var vo:DataResultVO = notification.getBody() as DataResultVO;
			switch(notification.getName())
			{
				case DATA_REC:
				{
					
					if(!vo.isEnd){
						var rawByte:ByteArray = PackData.app.CmdOStr[6];
						rawByte.uncompress();
						var data:Vector.<IGraphicsData> = rawByte.readObject();
						
						var item:DrawingDataVO = new DrawingDataVO(PackData.app.CmdOStr[1],PackData.app.CmdOStr[2],PackData.app.CmdOStr[3],PackData.app.CmdOStr[4],data);
						raw.push(item);
						
						
						
					}else{
						juggler.delayCall(fadeOutPage,3);
						refresh();
						
					}
					
					
					
					
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [DATA_REC];
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			spritePool = new ObjectPool(true);
			spritePool.allocate(120,flash.display.Sprite);
			
			drawingSpritePool = new ObjectPool(true);
			drawingSpritePool.allocate(120,DrawingSprite);
			
			imgHolder = new Sprite3D;
			view.addChild(imgHolder);
			
			textureHolder = new flash.display.Sprite;
			
			imgArray = new Vector.<DrawingSprite>;
			
			juggler = new Juggler();
			Starling.juggler.add(juggler);
			
			
			getPage();
			
			
			
			var uiHolder:Sprite3D = new Sprite3D;
			view.addChild(uiHolder);
			var btn:Button = new Button();
			btn.label = "下一页";
			btn.rotation = 74*Math.PI/180;
			
			btn.x = 1100;
			btn.y = 270;
			uiHolder.rotationY = 30*Math.PI/180;
			uiHolder.addChild(btn);
			
			
			/*var img:Image = new Image(Assets.getAtlasTexture("mainMenu/menuInstallBtn"));
			
			var s:Sprite3D = new Sprite3D;
			s.addChild(img);
			img.pivotX = img.width*0.5;
			img.pivotY = img.height;
			img.rotation = Math.PI*0.3;
			view.addChild(s);
			s.x = 100;
			s.y = 500;
			s.scaleX = 0;
			s.scaleY = 0;
			TweenMax.to(s,2,{rotationX:-Math.PI*6,repeat:999,ease:Circ.easeIn});
			TweenMax.to(s,1.5,{scaleX:1,scaleY:1,x:500,y:200,rotationX:-Math.PI*6,repeat:999,ease:Linear.easeOut});*/
			
			
			
			
		}
		
	}
}