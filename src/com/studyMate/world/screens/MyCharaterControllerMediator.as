package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.VertexImage;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.motionPaths.LinePath2D;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.AssetTool;
	import com.mylib.game.charater.ICharater;
	import com.studyMate.world.controller.vo.LetCharaterWalkToCommandVO;
	import com.studyMate.world.screens.ui.CharaterInterativeObject;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.graphics.Stroke;
	import starling.display.shaders.fragment.TextureVertexColorFragmentShader;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;

	public class MyCharaterControllerMediator extends Mediator
	{
		
		public static const NAME:String = "MyCharaterControllerMediator";
		
		private var _dashTexture:Texture;
		
		private var _lastSlice:Vector.<Number>;
		
		private var charater:ICharater;
		
		private var path:Vector.<Point>;
		
		private var _slices:Vector.<VertexImage>;
		private var _sliceIndex:uint = 0;
		private var _previousDash:Point;
		
		private var _dashBuffer:Number=0;
		
		private const DASH_PIXEL_BUFFER:uint = 12;
		
		private var _halfTextureHeight:uint;
		
		private var point:Point;
		
		private var range:Rectangle;
		
		private var pathIdx:int;
		
		private var motionPath:LinePath2D;
		
		private var startDrawCount:int;
		
		private var renderTexture:RenderTexture;
		
		private var rangeMatrix:Matrix;
		
		private var converNum:int;
		private var converLen:int=20;
		private var oldSliceIdx:int;
		
		private var line:Stroke;
		
		private var lineTexture:Texture;
		private var lineTexture2:Texture;
		
		private var tempXObj:Dictionary;
		private var tempYObj:Dictionary;
		
		private var offset:Point;
		
		public var touchableObjects:Vector.<CharaterInterativeObject>;
		private var isTouchObj:Boolean;
		
		private var rectangle:Rectangle;
		
		private var targetObj:CharaterInterativeObject;
		private var preMoveTime:int;
		private var mark:DisplayObject;
		
		private var startPoint:Point;
		private var isStartDrag:Boolean;
		
		private var bgToucher:Quad;
		private var triggerMark:Boolean;
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.ADD_MYCHARATER_CONTROL:
				{
					
					charater = notification.getBody() as ICharater;
//					charater.view.addEventListener(TouchEvent.TOUCH,touchHandle);
					charater.view.addEventListener(TouchEvent.TOUCH,touchHandle2);
					
//					bgToucher.addEventListener(TouchEvent.TOUCH,triggeredHandle);
					bgToucher.x = range.x;
					bgToucher.y = range.y;
					view.addChild(bgToucher);
					break;
				}
				case WorldConst.UPDATE_PLAYER_MARK:{
					mark = notification.getBody() as DisplayObject;
					break;
				}
					
				default:
				{
					break;
				}
			}
			
		}
		
		private function triggeredHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(view);
			if(touch){
				
				if(touch.phase ==TouchPhase.BEGAN){
					triggerMark = true;
					touch.getLocation(view,startPoint);
				}else if(touch.phase==TouchPhase.MOVED){
					touch.getLocation(view,point);
					
					if(point.x>startPoint.x+10||point.x<startPoint.x-10||point.y>startPoint.y+10||point.y<startPoint.y-10){
						triggerMark = false;
					}
					
				}else if(touch.phase==TouchPhase.ENDED){
					if(triggerMark){
						triggerMark = false;
						sendNotification(WorldConst.STOP_PLAYER_ACTION);
						sendNotification(WorldConst.STOP_PLAYER_TALKING);
						sendNotification(WorldConst.STOP_PLAYER_MOVE);
						touch.getLocation(view,point);
						charater.walk();
						sendNotification(WorldConst.START_PLAYER_CONTROL);
						sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(charater,point.x,point.y,charater.velocity,moveCompleteHandle));
					}
				}
			}
		}
		
		public function clean():void{
			touchableObjects.length=0;
			
			if(charater){
				charater.view.removeEventListener(TouchEvent.TOUCH,touchHandle2);
			}
			
		}
		
		private function createLine():void{
			if(line){
				view.removeChild(line);
			}
			line = new Stroke();
			line.material.fragmentShader = new TextureVertexColorFragmentShader();
			
			line.material.textures[0] = lineTexture;
			view.addChild(line);
			
			line.pivotY = 4;
			
		}
		
		public function stopPlayerMovePath():void{
			TweenLite.killTweensOf(motionPath);
		}
		
		public function cleanLine():void{
			line.clear();
		}
		
		private function touchHandle2(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			var p:Point;
			if(touch){
				
				if(touch.phase ==TouchPhase.BEGAN){
					line.clear();
					TweenLite.killTweensOf(motionPath);
					TweenLite.killTweensOf(charater.view);
					charater.idle();
					pathIdx = 0;
					oldSliceIdx = _sliceIndex;
					touch.getLocation(view,startPoint);
					
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,-1);
					isTouchObj = false;
					range = charater.range;
					isStartDrag = true;
					
					
				}else if(touch.phase ==TouchPhase.MOVED){
					
					if(!isStartDrag){
						return;
					}
					
					
					p = touch.getLocation(view);
					
					range.top>p.y?p.y = range.top:null;
					range.bottom<p.y?p.y = range.bottom:null;
					range.left>p.x?p.x = range.left:null;
					range.right<p.x?p.x = range.right:null;
					
					path[pathIdx] = p;
					pathIdx++;
					
					line.addVertex(p.x,p.y,4,0xffffff,0.2);
							
					checkTouch(touch);
					
						
					
				}else if(touch.phase ==TouchPhase.ENDED){
					isStartDrag = false;
					motionPath = createPath(path,pathIdx-1);
					if(motionPath){
						sendNotification(WorldConst.STOP_PLAYER_ACTION);
						motionPath.addFollower(charater.view);
						TweenMax.to(motionPath, pathIdx/20, {progress:1,onUpdate:movingHandle,onComplete:moveCompleteHandle});
						pathIdx=0;
						charater.walk();
					}
					
					
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
				}
				
				
				
				
			}
			
			
		}
		
		
		private function checkTouch(touch:Touch):void{
			
			isTouchObj = false;
			targetObj = null;
			for (var i:int = 0; i < touchableObjects.length; i++) 
			{
				touchableObjects[i].display.getBounds(view.stage,rectangle);
				
				if(rectangle.contains(touch.globalX,touch.globalY)){
					isTouchObj = true;
					targetObj = touchableObjects[i];
					break;
				}
			
				
			}
			
			
			
			if(isTouchObj&&line.material.textures[0]!=lineTexture2){
				line.material.textures[0] = lineTexture2;
			}else if(!isTouchObj&&line.material.textures[0]!=lineTexture){
				line.material.textures[0] = lineTexture;
			}
			
			
			
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.ADD_MYCHARATER_CONTROL,WorldConst.UPDATE_PLAYER_MARK];
		}
		
		
		public function MyCharaterControllerMediator(viewComponent:Object,range:Rectangle)
		{
			super(NAME, viewComponent);
			this.range = range;
			bgToucher = new Quad(range.width,range.height);
			bgToucher.alpha = 0;
		}
		
		
		override public function onRegister():void
		{
			point = new Point();
			rectangle = new Rectangle;
			_slices = new Vector.<VertexImage>(200, true);
			touchableObjects = new Vector.<CharaterInterativeObject>;
			preMoveTime = 0;
			startPoint = new Point();
			/*_dashTexture = Assets.getAtlas().getTexture("dashLine");
			_dashTexture.repeat = true;
			
			
			for(var i:uint=0; i<_slices.length; i++){
				_slices[i]=new VertexImage(_dashTexture);
			}
			
			_lastSlice= new <Number>[0,0,0,0,0];
			
			_halfTextureHeight = _dashTexture.height>>1;*/
			
			path = new Vector.<Point>(5000,false);
			
			
			/*for (var j:int = 0; j < 200; j++) 
			{
				drawToPoint(new Point(-j,160));
			}*/
			
			/*renderTexture = new RenderTexture(range.width,range.height);
			
			var img:Image = new Image(renderTexture);
			img.x = range.x;
			img.y = range.y;
			img.touchable = false;
			view.addChild(img);
			rangeMatrix = new Matrix;
			rangeMatrix.translate(-range.x,-range.y);
			
			*/
			lineTexture = Assets.getTexture("dashLine");
			lineTexture2 = Assets.getTexture("dashLine2");
			createLine();
		}
		
		
		private function touchHandle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.target as DisplayObject);
			var p:Point;
			if(touch){
				
				if(touch.phase ==TouchPhase.BEGAN){
					_previousDash = touch.getLocation(view);
					
					_lastSlice[0] = _previousDash.x;
					_lastSlice[1] = _previousDash.y;
					_lastSlice[2] = _previousDash.x;
					_lastSlice[3] = _previousDash.y;
					_lastSlice[4] = 0;
					
					startDrawCount = 0;
					TweenLite.killTweensOf(motionPath);
					renderTexture.clear();
					charater.idle();
					pathIdx = 0;
					converNum = 0;
					oldSliceIdx = _sliceIndex;
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,-1);
					
				}else if(touch.phase ==TouchPhase.MOVED){
					
					p = touch.getLocation(view);
					if(range.containsPoint(p)){
						drawToPoint(p);
						
						path[pathIdx] = p;
						pathIdx++;
						
						converNum++;
						
						if(converNum>converLen){
							tempConvert();
							converNum = 0;
						}
						
					}
					
				}else if(touch.phase ==TouchPhase.ENDED){
					
					motionPath = createPath(path,pathIdx-1);
					
					if(motionPath){
						motionPath.addFollower(charater.view);
						TweenMax.to(motionPath, pathIdx/20, {progress:1,onUpdate:movingHandle,onComplete:moveCompleteHandle,ease:Linear.easeNone});
						charater.walk();
					}
					
					sendNotification(WorldConst.CHANGE_HSCROLL_DIRECTION,1);
					tempConvert();
					
				}
				
				
				
				
			}
			
			
		}
		
		private function convertToOnePiece():void{
			renderTexture.clear();
			renderTexture.drawBundled(function():void{
				
				for (var i:int = 0; i < _slices.length; i++) 
				{
					
					if(_slices[i].parent){
						
						renderTexture.draw(_slices[i],rangeMatrix);
						
						
					}
					
					
				}
				
				
				
				
			});
			view.removeChildren(1);
			
		}
		
		private function tempConvert():void{
			
			var start:int = oldSliceIdx;
			var end:int = _sliceIndex;
			
			var turn:Boolean;
			var turnLen:int;
			if(oldSliceIdx>_sliceIndex){
				turnLen = _sliceIndex;
				end = _slices.length;
				turn = true;
			}
			
			renderTexture.drawBundled(function():void{
				
				for (var i:int = start; i < end; i++) 
				{
					
					if(_slices[i].parent){
						
						renderTexture.draw(_slices[i],rangeMatrix);
						
						
					}
					
					
				}
				
			});
			
			if(turn){
				
				renderTexture.drawBundled(function():void{
					
					for (var i:int = 0; i < turnLen; i++) 
					{
						
						if(_slices[i].parent){
							
							renderTexture.draw(_slices[i],rangeMatrix);
							
							
						}
						
						
					}
					
				});
			}
			
			oldSliceIdx = _sliceIndex;
			view.removeChildren(1);
			
			
		}
		
		
		
		
		
		private function moveCompleteHandle():void{
			
//			view.removeChildren();
//			renderTexture.clear();
			charater.idle();
			
			line.clear();
			
			
			if(charater.view.x!=charater.view.x){
				charater.view.x = startPoint.x;
			}
			
			if(charater.view.y!=charater.view.y){
				charater.view.y = startPoint.y;
			}
			
			
			
			if(targetObj){
				targetObj.takeAction(charater);
			}
			sendNotification(WorldConst.STOP_PLAYER_CONTROL);
			
		}
		
		private var preCharaterX:Number;
		private var preCharaterY:Number;
		
		private function movingHandle():void{
			
			
			if(charater.view.x>preCharaterX){
				
				if(charater.dirX!=1){
					charater.dirX = 1;
				}
				
			}else if(charater.view.x<preCharaterX){
				
				if(charater.dirX!=-1){
					charater.dirX = -1;
				}
			}
			
			if(charater.view.x!=charater.view.x){
				charater.view.x = preCharaterX;
			}
			
			if(charater.view.y!=charater.view.y){
				charater.view.y = preCharaterY;
				
			}
			
			if(preMoveTime>0){
				
				
				var distance:Number = Math.sqrt((charater.view.x - preCharaterX)*(charater.view.x - preCharaterX)+(charater.view.y - preCharaterY)*(charater.view.y - preCharaterY));
				
				var speed:Number = distance/(getTimer()-preMoveTime);
				
				
				if(speed>0.3){
					charater.run();
				}else{
					charater.walk();
				}
				
				
				
			}
			
			preCharaterX = charater.view.x;
			preCharaterY = charater.view.y;
			
			
			/*mark.x = charater.view.x;
			mark.y = charater.view.y;*/
			
			preMoveTime = getTimer();
			
		}
		
		
		
		private function createPath(path:Vector.<Point>,len:int):LinePath2D{
			if(len>0){
				
				var arr:Array=new Array(len);
				for (var i:int = 0; i < len; i++) 
				{
					arr[i] = path[i];
				}
				
				var linePath:LinePath2D = new LinePath2D(arr);
				
				return linePath;
			}
			
			return null;
		}
		
		
		
		/*private function followPathMove(path:Vector.<Point>,idx:int,len:uint,speed:uint):void{
			
			if(idx<len){
				idx++;
				sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(charater,path[idx].x,path[idx].y,speed,followPathMove,[path,idx,len,speed]));
			}
			
		}*/
		
		
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
			
			view.addChild(slice);
			
			
		}
		
		public function get view():Sprite{
			
			return getViewComponent() as Sprite;
			
			
		}
		override public function onRemove():void
		{
			bgToucher.removeEventListeners();
			bgToucher.removeFromParent(true);
			if(charater){
				charater.view.removeEventListener(TouchEvent.TOUCH,touchHandle2);
				
			}
		}
		
		
	}
}