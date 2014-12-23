package com.mylib.framework.component
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.mylib.api.IItemRender;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.controller.FreeScrollerMediator;
	import com.mylib.framework.controller.vo.ScrollListVO;
	import com.mylib.framework.controller.vo.ScrollRadio;
	import com.mylib.framework.controller.vo.TransformVO;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.VAlign;
	
	public class ScrollListMediator extends ScreenBaseMediator
	{
		
		private var vo:SwitchScreenVO;
		private var tvo:TransformVO;
		private var camera:CameraSprite;
		private var data:ScrollListVO;
		private var pool:ObjectPool;
		private var screenItemNum:uint;
		private var itemH:Number;
		private var halfListHeight:int;
		private var halfScreenH:int;
		private var listHeight:int;
		private var itemW:int;
		private var halfItemW:int;
		private var halfItemH:Number;
		private var offsetY:int;
		private var itemHolder:Sprite;
		
		private var refreshNotification:String;
		
		public static const REFRESH:String = "refresh";
		private var updateNotice:String;
		
		private var refreshY:int;
		
		
		public function ScrollListMediator(mediatorName:String=null,viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
			refreshNotification = mediatorName+REFRESH;
			updateNotice = mediatorName+FreeScrollerMediator.NAME+WorldConst.UPDATE_CAMERA;
		}
		
		
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			this.vo = vo;
			data = vo.data as ScrollListVO;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function onRegister():void
		{
			super.onRegister();
			var local:Point;
			var edge:Rectangle;
			if(!data.range){
				data.range = new Rectangle(0,0,view.stage.stageWidth,view.stage.stageHeight);
			}
			halfScreenH = data.range.height*0.5;
			
			local = new Point(0,halfScreenH);
			edge = new Rectangle();
			tvo = new TransformVO(local,edge,1,1,2,data.range);
			tvo.radio = new ScrollRadio(0,0,0.5,0.5);
			
			
			
			sendNotification(WorldConst.SWITCH_SCREEN,[
				new SwitchScreenVO(FreeScrollerMediator,tvo,SwitchScreenType.SHOW,view,0,0,-1,getMediatorName()+FreeScrollerMediator.NAME),
			]);
			
//			camera.x = 100;
//			camera.y = 200;
			
			if(data.range){
				view.x = data.range.x;
				view.y = data.range.y;
				var clipRect:Rectangle = data.range.clone();
				clipRect.x = clipRect.y = 0;
				view.clipRect = clipRect;
				camera = new CameraSprite(new Rectangle(0, 0, clipRect.width, clipRect.height), null, .3, .1, .01);
			}else{
				camera = new CameraSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), null, .3, .1, .01);
				
			}
			
			
			
			
			view.addChild(camera);
			itemHolder = new Sprite;
			camera.addChild(itemHolder);
			
			
			pool = new ObjectPool();
			var item:ItemRenderer = new data.itemRender;
			itemH = item.height;
			itemW = item.width;
			halfItemH = itemH*0.5;
			screenItemNum = Math.ceil(camera.viewport.height/(itemH+data.gap))+1;
			
			pool.allocate(screenItemNum+1,data.itemRender);
			/*var tt:TextField = new TextField(100,30,"refresh");
			tt.pivotY = 0;
			tt.alignPivot("center",VAlign.BOTTOM);
			tt.y = -halfItemH;*/
			var q:Quad = new Quad(10,10,0xff0000);
			refreshY = q.y = -halfItemH-80;
			
			
			camera.addChildAt(q,0);
			jumpTo(0);
			
			
			
		}
		
		private function refresh(idx:int=0):void{
			clean();
			tvo.range.y = lastY;
			tvo.range.y>0?tvo.range.y=0:1;
			listHeight = (itemH+data.gap)*data.data.length;
			halfListHeight = listHeight*0.5;
			initItems(idx);
			offsetY = halfScreenH-halfItemH;
			
		}
		
		
		
		private function initItems(idx:int):void{
			idx<0?idx=0:1;
			
			var num:int;
			data.data.length>screenItemNum?num = screenItemNum:num = data.data.length;
			
			
			for (var j:int = idx; j < idx+num; j++) 
			{
				displayData(j);
			}
		}
		
		private function displayData(idx:uint):void{
			var item:ItemRenderer;
			
			
			if(idx>data.data.length-1){
				return;
			}
			
			item = pool.object;
			item.pivotX = item.width*0.5;
			item.pivotY = item.height*0.5;
			item.data = data.data[idx];
			item.y = idx*(itemH+data.gap);
			
			if(itemHolder.numChildren&&item.y<itemHolder.getChildAt(0).y){
				itemHolder.addChildAt(item,0);
			}else{
				itemHolder.addChild(item);
			}
			
			
		}
		
		private function recyleItem(item:ItemRenderer):void{
			item.removeFromParent();
			pool.object = item;
		}
		
		private function clean():void{
			
			while(itemHolder.numChildren){
				recyleItem(itemHolder.getChildAt(0) as ItemRenderer);
			}
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case updateNotice:
				{
					if(camera){
						
						var local:Point = notification.getBody() as Point;
						camera.moveTo(-local.x,-local.y+offsetY,tvo.scale,0,false);
						
						var first:ItemRenderer;
						var vy:int = camera.viewport.y;
						var vb:int = camera.viewport.bottom;
						var last:ItemRenderer;
						var idx:int;
						
						if(itemHolder.numChildren>0){
							first = itemHolder.getChildAt(0) as ItemRenderer;
							last = itemHolder.getChildAt(itemHolder.numChildren-1) as ItemRenderer;
							if(first.y+halfItemH+5<vy){
								recyleItem(first);
								first = null;
								if(itemHolder.numChildren>0)
								first = itemHolder.getChildAt(0) as ItemRenderer;
							}else if(last.y-halfItemH-5>vb){
								recyleItem(last);
								last = null;
								if(itemHolder.numChildren>0)
								last = itemHolder.getChildAt(itemHolder.numChildren-1) as ItemRenderer;
							}
						}
						trace(vy);
						
						if(vy<refreshY){
							trace("r");
						}
						
						
//						trace(vy,listHeight-halfItemH);
//						trace(vy,vb,data.range.height,listHeight-halfItemH);
						if(vy>-halfItemH&&first&&first.y-halfItemH-data.gap>vy){
							idx = vy/(itemH+data.gap);
							displayData(idx);
						}else if(vb<listHeight-halfItemH&&last&&last.y+halfItemH+data.gap<vb){
							idx = vb/(itemH+data.gap)+1;
							displayData(idx);
						}else if(!first&&vy>0&&vy<listHeight-halfItemH){
							idx = data.data.length-1;
							displayData(idx);
						}else if(!first&&vy<0&&vy>-data.range.height-halfItemH){
							idx = 0;
							displayData(idx);
						}
						
						
						
						
					}
					break;
				}
				case refreshNotification:{
					
					trace("refresh");
					
					data.data = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
					
//					jumpTo(0);
					//跳到最后
					jumpTo(lastY);
					
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		public function get lastY():int{
			return -(itemH+data.gap)*data.data.length + camera.viewport.height-20;
		}
		
		private function jumpTo(yy:int):void{
			tvo.location.y = yy;
			var ridx:int = (camera.viewport.y+halfItemH)/(itemH+data.gap);
			refresh(ridx);
			camera.moveTo(0,-yy+offsetY,1,0,true);
			sendNotification(getMediatorName()+FreeScrollerMediator.NAME+FreeScrollerMediator.GO,new Point(0,yy));
		}
		
		override public function listNotificationInterests():Array
		{
			return [updateNotice,refreshNotification];
		}
		
		
		
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
	}
}