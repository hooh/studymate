package com.studyMate.world.screens
{
	import com.byxb.extensions.starling.display.CameraSprite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.FlipPageData;
	import com.studyMate.world.component.IFlipPageRenderer;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;

	public class FlipPageMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "FlipPageMediator";
		
		protected var camera:CameraSprite;
		
		public var index:int;
		
		
		public var currentHolder:Sprite;
		public var nextHolder:Sprite;
		public var preHolder:Sprite;
		
		public var data:FlipPageData;
		
		public var total:uint;
		
		private var pageWidth:int;
		
		public static const FLIP_PAGE:String = NAME+"FlipPage";
		public static const FLIPPING:String = NAME+"Flipping";
		
		protected var pageInitMark:Dictionary;
		
		
		public function FlipPageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			data = vo.data as FlipPageData;
			total = data.pages.length;
			
			
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			switch(name)
			{
				case WorldConst.UPDATE_CAMERA:
				{
					camera.moveTo(notification.getBody() as Number,0,1,0,false);
					break;
				}
				case WorldConst.UPDATE_FLIP_PAGE_INDEX:
				{
					
					var new_index:uint = notification.getBody() as uint;
					
					if(new_index>index){
						roll();
					}else if(new_index<index){
						rollBack();
					}
					
					break;
				}
				case WorldConst.UPDATE_FLIP_PAGES:{
					currentHolder.removeChildren(0,-1,true);
					nextHolder.removeChildren(0,-1,true);
					preHolder.removeChildren(0,-1,true);
					data = notification.getBody() as FlipPageData;
					total = data.pages.length;
					
					gotoInitPage();
					
					break;
				}
				case WorldConst.CLEAR_FLIP_PAGE :{
					currentHolder.removeChildren(0,-1,true);
					nextHolder.removeChildren(0,-1,true);
					preHolder.removeChildren(0,-1,true);
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		protected function roll():void{
			index++;
			
			var temp:Sprite;
			temp = currentHolder;
			currentHolder = nextHolder;
			nextHolder = preHolder;
			preHolder = temp;
			
			updatePosition();
			nextHolder.removeChildren();
			if(index<total-1){
				if(index>1){
					disposePage(data.pages[index-2]);
				}
				displayPage(data.pages[index+1]);
				nextHolder.addChild(data.pages[index+1].view);
			}else if(index==total-1&&total>2){
				if(index>-2){
					disposePage(data.pages[index-2]);
				}
					
			}
			
			
		}
		
		protected function rollBack():void{
			index--;
			var temp:Sprite;
			temp = currentHolder;
			currentHolder = preHolder;
			preHolder = nextHolder;
			nextHolder = temp;
			
			updatePosition();
			
			preHolder.removeChildren();
			if(index>0){
				if(index<total-2){
					disposePage(data.pages[index+2]);
				}
				
				
				displayPage(data.pages[index-1]);
				
				preHolder.addChild(data.pages[index-1].view);
					
			}else if(index==0){
				if(index<total-3){
					disposePage(data.pages[index+2]);
				}
			}
			
			
		}
		
		protected function updatePosition():void{
			
			currentHolder.x = index*pageWidth;
			nextHolder.x = (index+1)*pageWidth;
			preHolder.x = (index-1)*pageWidth;
			
		}
		
		protected function displayPage(page:IFlipPageRenderer):void{
			if(!pageInitMark[page]){
				pageInitMark[page] = true;
				page.displayPage();
				
			} 
		}
		
		protected function disposePage(page:IFlipPageRenderer):void{
			pageInitMark[page] = false;
			page.disposePage();
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.UPDATE_CAMERA,WorldConst.UPDATE_FLIP_PAGE_INDEX,WorldConst.UPDATE_FLIP_PAGES,WorldConst.CLEAR_FLIP_PAGE];
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRegister():void
		{
			camera = new CameraSprite(new Rectangle(0, 0, WorldConst.stageWidth, WorldConst.stageHeight), null, .3, .1, .01);
			view.addChild(camera);
			
			
			
			pageInitMark = new Dictionary();
			
			currentHolder = new Sprite();
			nextHolder = new Sprite();
			preHolder = new Sprite();
			camera.addChild(currentHolder);
			camera.addChild(nextHolder);
			camera.addChild(preHolder);
			
			pageWidth = WorldConst.stageWidth;
			
			initialization();
			
		}
		
		protected function initialization():void{
			index = 0;
			gotoInitPage();
		}
		
		protected function gotoInitPage():void{
			facade.removeMediator(ChapterSeleterMediator.NAME);
			index = 0;
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ChapterSeleterMediator,total,SwitchScreenType.SHOW,view,0,0,-1)]);
			
			updatePosition();
			camera.moveTo(0,0,1,0,true);
			if(total > 0){
				displayPage(data.pages[0]);
				currentHolder.addChild(data.pages[0].view);
			}
			if(total>1){
				displayPage(data.pages[1]);
				nextHolder.addChild(data.pages[1].view);
			}
			
		}
		
		
		
		override public function onRemove():void
		{
			pageInitMark = null;
			
			
			for (var i:int = 0; i < data.pages.length; i++) 
			{
				data.pages[i].disposePage();
				data.pages[i].dispose();
			}
			data.pages.length = 0;
			data.pages = null;
			currentHolder.removeChildren();
			currentHolder.dispose();
			nextHolder.removeChildren();
			nextHolder.dispose();
			preHolder.removeChildren();
			preHolder.dispose();
			view.removeChildren(0,-1,true);
			camera.dispose();
		}
		
	}
}