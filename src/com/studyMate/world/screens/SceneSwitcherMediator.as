package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.FreeScrollerMediator;
	import com.mylib.framework.controller.HorizontalScrollerMediator;
	import com.mylib.framework.controller.vo.TransformVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;

	public class SceneSwitcherMediator extends ScreenBaseMediator
	{
		protected var _camera:CameraSprite;
		protected var _scenes:Vector.<SceneMediator>;
		protected var _idx:int;
		private var scrollerVO:SwitchScreenVO;
		public static const MOVE_SCENE:String = "SceneSwitcherMediatorMoveScene";
		public static const UPDATE_SCENE_RANGE:String = "SceneSwitcherMediatorUpdateSceneRange";
		protected var tvo:TransformVO;
		
		public function SceneSwitcherMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			_camera.removeFromParent(true);
		
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRegister():void
		{
			_idx = -1;
			
			
			var local:Point = new Point(0,0);
			var edge:Rectangle = new Rectangle(0,0,0,0);
			tvo = new TransformVO(local,edge);
			
			sendNotification(WorldConst.SWITCH_SCREEN,[
				new SwitchScreenVO(FreeScrollerMediator,tvo,SwitchScreenType.SHOW,view),
			]);
			
			super.onRegister();
		}
		
		public function set camera(_c:CameraSprite):void{
			
			if(_camera){
				_camera.removeEventListeners();
				_camera.dispose();
			}
			
			_camera = _c;
			view.addChild(_camera);
			
			
		}
		
		
		public function get camera():CameraSprite{
			return _camera;
		}
		
		private function focusScene(__newIdx:int):void{
			
			if(__newIdx!=_idx){
//				(facade.retrieveMediator(HorizontalScrollerMediator.NAME) as HorizontalScrollerMediator).leftEdge = scenes[__newIdx].left;
//				(facade.retrieveMediator(HorizontalScrollerMediator.NAME) as HorizontalScrollerMediator).rightEdge = scenes[__newIdx].right;
				
				tvo.range.x = scenes[__newIdx].left;
				tvo.range.width = scenes[__newIdx].right;
				
				
				move(scenes[__newIdx].x);
				
				if(__newIdx<scenes.length){
					scenes[__newIdx].run();
				}
				
				if(_idx>=0){
					scenes[_idx].pause();
				}
				
			}
			_idx = __newIdx;
			
		}
		
		public function currentScene():SceneMediator{
			return scenes[_idx];
		}
		
		public function move(_x:int):void{
//			(facade.retrieveMediator(HorizontalScrollerMediator.NAME) as HorizontalScrollerMediator).currentX = -_x;
//			(facade.retrieveMediator(HorizontalScrollerMediator.NAME) as HorizontalScrollerMediator).targetX = -_x;
			
			tvo.location.x = -_x;
			(facade.retrieveMediator(FreeScrollerMediator.NAME) as FreeScrollerMediator).targetX = -_x;
			_camera.moveTo(_x,0);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case MOVE_SCENE:
				{
					move(notification.getBody() as int);
					break;
				}
				case WorldConst.UPDATE_CAMERA:
				{
					if(camera){
						var local:Point = notification.getBody() as Point;
						camera.moveTo(-local.x/tvo.scale,-local.y/tvo.scale,tvo.scale,0,false);
					}
					break;
				}
				case UPDATE_SCENE_RANGE:{
					var scene:SceneMediator = notification.getBody() as SceneMediator;
//					(facade.retrieveMediator(HorizontalScrollerMediator.NAME) as HorizontalScrollerMediator).leftEdge = scene.left;
//					(facade.retrieveMediator(HorizontalScrollerMediator.NAME) as HorizontalScrollerMediator).rightEdge = scene.right;
					tvo.range.left = scene.left;
					tvo.range.width = scene.right-scene.left;
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
			return [MOVE_SCENE,WorldConst.UPDATE_CAMERA,UPDATE_SCENE_RANGE];
		}
		
		
		public function set index(__idx:int):void{
			
			if(__idx>scenes.length-1||__idx<0){
				return;
			}
			
			focusScene(__idx);
		}
		
		public function get index():int{
			return _idx;
		}

		public function get scenes():Vector.<SceneMediator>
		{
			return _scenes;
		}

		public function set scenes(value:Vector.<SceneMediator>):void
		{
			_scenes = value;
			
			
			layout();
			
		}
		
		protected function layout():void{
			var arr:Array = [];
			for (var i:int = 0; i < _scenes.length; i++) 
			{
//				_scenes[i].view.pivotX = _scenes[i].width*0.5;
				_scenes[i].view.x = _scenes[i].x//+_scenes[i].offsetX;
				_camera.addChild(_scenes[i].view);
			}
			
		}
		
		
	}
}