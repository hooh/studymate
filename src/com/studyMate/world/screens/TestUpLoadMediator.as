package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.VertexImage;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.UpLoadCommandVO;
	
	import flash.filesystem.File;
	import flash.geom.Point;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class TestUpLoadMediator extends ScreenBaseMediator
	{
		
		public const NAME:String = "TestUpLoadMediator";
		
		private var _dashTexture:Texture;
		
		private var _lastSlice:Vector.<Number>;
		private var _slices:Vector.<VertexImage>;
		private var _sliceIndex:uint = 0;
		private var _previousDash:Point;
		
		private var _dashBuffer:Number=0;
		
		private const DASH_PIXEL_BUFFER:uint = 5;
		
		private var _halfTextureHeight:uint;
		
		private var point:Point;
		
		public function TestUpLoadMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function onRegister():void
		{
			/*var image:Image = new Image(Assets.getAtlasTexture("bg/leaf"));
			view.addChild(image);
			image = new Image(Assets.getAtlasTexture("bg/wave"));
			
			view.addChild(image);
			
			image = new Image(Assets.getChapterAtlas().getTexture("chapter/whale"));
			
			view.addChild(image);*/
			
			var sp:Quad = new Quad(100,100,0xff0000);
			view.addChild(sp);
			sp.addEventListener(TouchEvent.TOUCH,updateLoadBtnHandle);
			
		}
		
		private function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			
			if(touch){
				
				if(touch.phase ==TouchPhase.BEGAN){
					_lastSlice[0] = touch.globalX;
					_lastSlice[1] = touch.globalY;
					_lastSlice[2] = touch.globalX;
					_lastSlice[3] = touch.globalY;
					_lastSlice[4] = 0;
					
					_previousDash = new Point(touch.globalX,touch.globalY);
					
				}else if(touch.phase ==TouchPhase.MOVED){
					drawToPoint(new Point(touch.globalX,touch.globalY));
				}
				
				
				
				
			}
			
			
		}
		
		private function drawToPoint(p:Point):void{
			
			if(_previousDash){
				var diff:Point=p.subtract(_previousDash);
				_dashBuffer+=diff.length;
				var atan:Number=Math.atan2(diff.y, diff.x);
				var i:uint=0;
				
				while (_dashBuffer > DASH_PIXEL_BUFFER)
				{
					//there is enough distance in the buffer to merit at least one new tunnel segment.
					i++;
					
					diff.normalize(DASH_PIXEL_BUFFER);
					_previousDash=_previousDash.add(diff);
					_dashBuffer-=DASH_PIXEL_BUFFER;
					
					// calculate the edges of the tunnel from the dig point which is in the center of the tunnel
					var normal:Point=Point.polar(_halfTextureHeight, atan + (Math.PI >>1));
					var reverseNormal:Point=new Point(-normal.x, -normal.y);
					var left:Point=reverseNormal.add(_previousDash);
					var right:Point=normal.add(_previousDash);
					
					
					//if not, a molehill animation is needed.
					addSlice(left, right, (DASH_PIXEL_BUFFER / _dashTexture.width));
					
				}
				
			}
			
			_previousDash = p;
			
		}
		
		
		
		private function addSlice(p1:Point, p2:Point, uStep:Number=0 ):void{
			
			var slice:VertexImage = _slices[_sliceIndex];
			var u:Number = _lastSlice[4];
			slice.setVertex(0, _lastSlice[0],_lastSlice[1], u,0);
			slice.setVertex(1, _lastSlice[2],_lastSlice[3], u,1);
			u+=uStep;
			slice.setVertex(2, p1.x, p1.y, u,0);
			slice.setVertex(3, p2.x, p2.y, u,1);
			slice.update();
			_lastSlice[0]=p1.x;
			_lastSlice[1]=p1.y;
			_lastSlice[2]=p2.x;
			_lastSlice[3]=p2.y;
			_lastSlice[4]=u;
			++_sliceIndex;
			_sliceIndex %=_slices.length;
			
			view.addChild(slice)
			
		}
		
		private function updateLoadBtnHandle(event:TouchEvent):void
		{
			
			if(event.touches[0].phase=="ended"){
				var file:File = Global.document.resolvePath(Global.localPath+"mp3/bgSound0.mp3");
				sendNotification(CoreConst.UPLOAD_FILE,new UpLoadCommandVO(file,"bgSound0.mp3"));
			}
			
		}		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
	}
}