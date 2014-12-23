package com.studyMate.world.screens
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;

	public class LxLTestMediator extends ScreenBaseMediator
	{
		public static const NAME:String ="LxLTestMediator";
		
		
		
		public function LxLTestMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.handleNotification(notification);
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return super.listNotificationInterests();
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		private var L:Image;
		override public function onRegister():void
		{
			view.root.stage.color = 0;
			
//			var mv:MovieClip = new MovieClip(Assets.getLXLTestAtals().getTextures("box"),3);
//			mv.pivotX =mv.width*0.5;
//			mv.pivotY =mv.height*0.5;
//			mv.x = 640;
//			mv.y = 384;
//			
//			view.addChild(mv);
//			Starling.juggler.add(mv);
//			mv.play();//播放
//			mv.loop = true; //是否循环
//			//隔3调用函数，函数是将mv停止播放，并将透明度逐渐减为0，
//			TweenLite.delayedCall(3,function():void{
//				TweenMax.to(mv, 1, {alpha:0});
//				mv.stop();
//				second();
//			}
//			);
			TweenLite.delayedCall(1,first);
			/*var q:Quad = new Quad(1280,768,0);
			q.alpha = 0.2;
			view.addChild(q);*/
		}
			
		
//			
//			
//			var c1:Image = new Image(Assets.getLxlTexture("body_clothes68"));
//			
//			c1.x = 100;
//			
//			
//			var holder:Sprite = new Sprite;
//			holder.addChild(c);
//			holder.addChild(c1);
		//			view.addChild(holder);
			
//			private	var mv:MovieClip ;
//			private function first():void{
//				mv = new MovieClip(Assets.getLXLTestAtals().getTextures("box"),5);
//				mv.pivotX =mv.width*0.5;
//				mv.pivotY =mv.height*0.5;
//				mv.x = 640;
//				mv.y = 384;
//				
//				view.addChild(mv);
//				mv.loop = false;
//				mv.play();
//				mv.addEventListener(Event.COMPLETE,mvCompleteHandler);			
//			//	TweenMax.to(mv,0.1,{scaleX:1.2,scaleY:1.2,yoyo:true,repeat:4,ease:Quint.easeOut,onComplete:tssss});
//			
//			}
//			
////	private function tssss():void{
////				Starling.juggler.add(mv);
////				mv.play();
////				mv.addEventListener(Event.COMPLETE,mvCompleteHandler);
////			}
//			
//			private function mvCompleteHandler():void
//			{
//				// TODO Auto Generated method stub
//				trace('222');
//				TweenMax.to(mv, 5, {alpha:0});
//				Starling.juggler.remove(mv);
//				mv.stop();
//				mv.removeFromParent(true);
//				second();
//			}
//			
		
			
			
			
			
//TweenMax.to(c, 1, {delay:2, scaleX:2, scaleY:2, alpha:1,ease:Elastic.easeInOut});
	//		TweenMax.to(holder, 1, {delay:2,alpha:0});
	//		TweenMax.to(view.root.stage, 1, {delay:2,color:0xffffff});
			
//		
		
		
		private	var mv1:MovieClip ;
		private function first():void{
			mv1 = new MovieClip(Assets.getLXLTestAtals().getTextures("box"),5);
			mv1.pivotX =mv1.width*0.5;
			mv1.pivotY =mv1.height*0.5;
			mv1.x = 640;
			mv1.y = 384;
			
			view.addChild(mv1);
			mv1.loop = true;
			Starling.juggler.add(mv1);
			mv1.play();
			mv1.addEventListener(Event.COMPLETE,mv1CompleteHandler);
			
		}
		
		private function mv1CompleteHandler():void
		{
			// TODO Auto Generated method stub
			trace('222');
			TweenMax.to(mv1, 8, {alpha:0});
			Starling.juggler.remove(mv1);
			mv1.stop();
			mv1.removeFromParent(true);
			second();
		}
		
		
		
		
		
		private	var mv2:MovieClip ;
		private function second():void{
			mv2 = new MovieClip(Assets.getLXLTestAtals().getTextures("cloud"),6);
			mv2.pivotX =mv2.width*0.5;
			mv2.pivotY =mv2.height*0.5;
			mv2.x = 640;
			mv2.y = 384;
			
			view.addChild(mv2);
			mv2.loop = false;
			Starling.juggler.add(mv2);
			mv2.play();
			mv2.addEventListener(Event.COMPLETE,mv3CompleteHandler);

		}
		
		private function mv3CompleteHandler():void
		{
			// TODO Auto Generated method stub
			trace('1111');
			TweenMax.to(mv2, 8, {alpha:0});
			Starling.juggler.remove(mv2);
			mv2.stop();
			mv2.removeFromParent(true);
			three();
		}
		
private function three():void{

	L = new Image(Assets.getTexture("lxlMovlightTexture")); 
	L.pivotX = L.width*0.5;
	L.pivotY = L.height*0.5;		
	L.x = 640;
	L.y = 384;				
	view.addChild(L);
	//TweenMax.from(L, 1, {alpha:0});
	TweenMax.to(L,5,{rotation:Math.PI*2,repeat:int.MAX_VALUE,ease:Linear.easeNone});
	four();
}	
private function four():void{
	var mv3:Image = new Image(Assets.getLxlTexture("diamond"));			
	mv3.pivotX =mv3.width*0.5;
	mv3.pivotY =mv3.height*0.5;
	mv3.x = 650;
	mv3.y = 300;		
	//TweenMax.from(mv3, 1, {alpha:0});
	view.addChild(mv3);
	six();
	five();
	seven();
	
}	


private function five():void{
	var b:Image = new Image(Assets.getLxlTexture("button"));	
	b.pivotX =b.width*0.5;
	b.pivotY =b.height*0.5;
	b.x =645;
	b.y =530;
	//TweenMax.from(b, 1, {alpha:0});
	view.addChild(b);	
}

private function six():void{
	var p:PDParticleSystem = new PDParticleSystem(Assets.store["light"],Assets.getLxlTexture("ball"));
	Starling.juggler.add(p);
	p.start();
	p.pivotX =p.width*0.5;
	p.pivotY =p.height*0.5;
	p.x =620;
	p.y =350;
	view.addChild(p);	
}
private function seven():void{
	var s:PDParticleSystem = new PDParticleSystem(Assets.store["star"],Assets.getLxlTexture("star"));
	Starling.juggler.add(s);
	s.start();
	s.pivotX =s.width*0.5;
	s.pivotY =s.height*0.5;
	s.x =680;
	s.y =50;
	view.addChild(s);	
}

	private function completeHandle():void{
			TweenMax.to(L, 1, { scaleX:2, scaleY:2, alpha:0,ease:Elastic.easeInOut});
		}
	
	}
}