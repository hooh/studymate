package com.studyMate.world.component
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.AssetTool;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.world.component.MydragMethod.MyDragEvent;
	import com.studyMate.world.component.MydragMethod.MyDragFunc;
	import com.studyMate.world.events.ItemLoadEvent;
	import com.studyMate.world.events.NoticeEffectEvent;
	import com.studyMate.world.events.ShowFaceEvent;
	import com.studyMate.world.screens.ScrollShelfPicturebook2Mediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mycomponent.DrawBitmap;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class BookGroupComponent extends Sprite
	{					
		private var pathlist:Array;//存放图片路径数组
		private var titlelist:Array;//存放标题数组
		private var sourceArr:Array;//书本合集数组			
		private var whichOne:int;
		public var WhichOneFlag:int=0;
		private var toPage:int;	
		
		private var windowClass:Class;
		private var mySortGroup:MySortGroup;
		private var lazyLoad:LazyLoad;
		private var num:int=0;//执行个数 
		private var icoWidth:Number=131;//图片长
		private var icoHeight:Number=162;//图片宽
		
		private var oldDragNum:int;//当前拖动的号
		private var newDragNum:int;//将移动到的号
		private var uiMove:BookUIMovieClip;
		
		private var vecPoint:Vector.<Point>;//存储图片位置的点阵				
		/**
		 * @param _listArr 图片路径数组
		 * @param _titlelist 标题数组
		 * @param _sourceArr 资源数组
		 * @param _width 图片的宽
		 * @param _height 图片的高 
		 */		
		public function BookGroupComponent(_listArr:Array,_titlelist:Array=null,_sourceArr:Array=null,WhichOne:int=0){	
			this.pathlist = _listArr.concat();
			this.titlelist = _titlelist;
			this.sourceArr = _sourceArr;
			this.whichOne = WhichOne;
			//this.vecPoint = CacheTool.getByKey(ScrollShelfPicturebookMediator.NAME,"PointAll") as Vector.<Point>;//存贮的是点阵
			
			windowClass = AssetTool.getCurrentLibClass("small_Book_Face");//书本默认封面
			
//			this.addEventListener(NoticeEffectEvent.MOVE_EFFECT_START,MoveEffectHandler);
//			this.addEventListener(NoticeEffectEvent.RESET_STATE,ResetStateHandler);
			
			lazyLoad = new LazyLoad(_listArr);//延迟加载
			lazyLoad.addEventListener(ItemLoadEvent.ITEM_LOAD_COMPLETE,itemLoadCompleteHandler);//加载成功侦听
			lazyLoad.addEventListener(ItemLoadEvent.ITEM_LOAD_FAILD,itemLoadFaildHandler);//加载失败或者数组元素为空
			lazyLoad.addEventListener(Event.COMPLETE,loadCompleteHandle);//加载失败或者数组元素为空
			
			mySortGroup = new MySortGroup();	
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
		}
		
		private function loadCompleteHandle(event:Event):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.VIEW_READY);
		}
		
		protected function removeFromStageHandler(event:Event):void
		{
			lazyLoad.removeEventListener(ItemLoadEvent.ITEM_LOAD_COMPLETE,itemLoadCompleteHandler);//加载成功侦听
			lazyLoad.removeEventListener(ItemLoadEvent.ITEM_LOAD_FAILD,itemLoadFaildHandler);//加载失败或者数组元素为空
			lazyLoad.removeEventListener(Event.COMPLETE,loadCompleteHandle);
			lazyLoad.clear();
			lazyLoad = null;
			this.pathlist = null;
		}
		
		private function itemLoadCompleteHandler(event:ItemLoadEvent):void{
			var bitmap:Bitmap = new DrawBitmap(event.Item,icoWidth,icoHeight);
			var bookBtn:BookUIMovieClip = installBook(windowClass,bitmap);
			mySortGroup._addElement(bookBtn,this);
		}
		private function itemLoadFaildHandler(event:ItemLoadEvent):void{
			var bookBtn:BookUIMovieClip = installBook(windowClass,null,true);//只加载背景图和文字
			mySortGroup._addElement(bookBtn,this);
		}	
		
		//开启加载
		public function startLoad():void{
			lazyLoad.startLoad();
		}
		//暂停加载
		public function pauseLoad():void{
			lazyLoad.pauseLoad();
		}
											
		//派发给外部ScrollShelPicture，通知显示封面
		private function Clickhandler(event:MouseEvent):void{				
			var showFaceEvent:ShowFaceEvent = new ShowFaceEvent(ShowFaceEvent.SHOW_FACE);
			showFaceEvent.Item = event.currentTarget as BookUIMovieClip;
			this.dispatchEvent(showFaceEvent);
		}
		
		//开始拖动
		private function StartEffectHandler(e:MyDragEvent):void{
			if(!CacheTool.getByKey(ScrollShelfPicturebook2Mediator.NAME,"PointAll")){//如果数值为NULL，则存储点阵
				var vecPoint:Vector.<Point> = new Vector.<Point>(21,false);
				for(var num:int=0;num<21;num++){
					var baseX:Number = ((int)(num%MySortGroup.row))*MySortGroup.rowgap + MySortGroup.leftSpace;
					var baseY:Number = ((int)(num/MySortGroup.row))%MySortGroup.col*MySortGroup.colgap + MySortGroup.topSpace;
					var point:Point = new Point(baseX,baseY);
					//vecPoint.push(point);
					vecPoint[num] = point;
				}
				CacheTool.put(ScrollShelfPicturebook2Mediator.NAME,"PointAll",vecPoint);//存储点阵var vec2222:Vector.<Point> = CacheTool.getByKey(NAME,"PointAll") as Vector.<Point>;
				this.vecPoint = vecPoint;
				//trace("赋值"+this.vecPoint);
			}else{
				//trace("读取" + this.vecPoint);
				this.vecPoint = CacheTool.getByKey(ScrollShelfPicturebook2Mediator.NAME,"PointAll") as Vector.<Point>;//存贮的是点阵
			}
			
			uiMove = (e.currentTarget as MyDragFunc).target as BookUIMovieClip;
			oldDragNum = int(uiMove.name);
			uiMove.removeEventListener(MouseEvent.CLICK,Clickhandler);//移除点击事件
			var obj:Object = new Object();		
			obj.target = uiMove;
			obj.name = this.name;//第几本书
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.DRAG_FACE_MOVE,obj);
		}
		//技术拖动
		private function EndEffectHandler(e:MyDragEvent):void{
			uiMove.addEventListener(MouseEvent.CLICK,Clickhandler);
		}

		private function ResetStateHandler(e:NoticeEffectEvent):void{
			addEvent(uiMove);
		}
		
		private function MoveEffectHandler(e:NoticeEffectEvent):void{		
			if(e.special!=null){
				MovefunctionB(e.startNum,e.endNum,e.special,e.currentUI);
			}else{
				MovefunctionA(e.startNum,e.endNum);
			}						
		}
				
		//本页换位
		private function MovefunctionA(startCount:int,endCound:int):void{
			oldDragNum = startCount;
			newDragNum = endCound;
			
			var sp1:Sprite = this.getChildByName(String(startCount)) as Sprite;//后一个元素向前面移动
			
			var total:int = Math.abs(oldDragNum-newDragNum);//需执行换位操作的次数
			var flag:int = oldDragNum<newDragNum ? 1 : -1;//向后则+1，向前则-1；						

			for(var i:int=0;i<total;i++){
				var sp:Sprite = this.getChildByName(String(oldDragNum+flag)) as Sprite;//后一个元素向前面移动
				TweenLite.to(sp,0.8,{x:vecPoint[oldDragNum].x,y:vecPoint[oldDragNum].y,alpha:1});
				
				var tempName:String;
				var preSp:Sprite = this.getChildByName(String(oldDragNum)) as Sprite;
				var nextSp:Sprite = this.getChildByName(String(oldDragNum+flag)) as Sprite;
				
				tempName = preSp.name;				
				var str:String;
				preSp.name = nextSp.name.toString();		
				nextSp.name = tempName;	
				oldDragNum+=flag;								
			}		
			TweenLite.to(sp1,0.5,{x:vecPoint[oldDragNum].x,y:vecPoint[oldDragNum].y,alpha:1,onComplete:addEvent,onCompleteParams:[uiMove]})
			
		}
		
		//隔页换面
		private function MovefunctionB(startCount:int,endCount:int,direction:String,currentMoveUI:Sprite):void{
			this.vecPoint = CacheTool.getByKey(ScrollShelfPicturebook2Mediator.NAME,"PointAll") as Vector.<Point>;//存贮的是点阵
			
			var flag:int,total:int;
			if(direction=="left"){
				oldDragNum = 0;
				flag = 1;								
				total = endCount;				
			}else if(direction=="right"){
				oldDragNum = this.numChildren-1;
				flag = -1;				
				total = 20-endCount;				
			}
			var sp1:Sprite = this.getChildByName(String(oldDragNum)) as Sprite;
			this.removeChild(sp1);
			for(var i:int=0;i<total;i++){
				var sp:Sprite = this.getChildByName(String(oldDragNum+flag)) as Sprite;//后一个元素向前面移动
				TweenLite.to(sp,0.8,{x:vecPoint[oldDragNum].x,y:vecPoint[oldDragNum].y,alpha:1});
				
				var nextSp:Sprite = this.getChildByName(String(oldDragNum+flag)) as Sprite;
				nextSp.name = String(oldDragNum);
				
				oldDragNum+=flag;
			}
			this.addChild(currentMoveUI);
			currentMoveUI.name = String(endCount);
			currentMoveUI.x = vecPoint[oldDragNum].x;
			currentMoveUI.y = vecPoint[oldDragNum].y;
			addEvent(currentMoveUI);
		}
				
		private function addEvent(sp:Sprite):void{
			sp.addEventListener(MouseEvent.CLICK,Clickhandler);
		}						
				
		/**
		 * 制造书本按钮图片
		 * @param num 书本顺序
		 * @param bitmap 封面
		 * @param lab 是否有标题
		 * @return  返回书本，书本的name为序列号
		 */				
		private function installBook(_bgImage:Class,_faceImage:DisplayObject=null,_lab:Boolean=false):BookUIMovieClip{		
			var sp:Sprite = new Sprite();
			if(_bgImage!=null){				
				var bg:DisplayObject = new _bgImage as DisplayObject;
				sp.addChild(bg);
			}
			if(_faceImage!=null){
				sp.addChild(_faceImage);
				_faceImage.y = 12;
			}
			if(_lab){	
				var textformat:TextFormat = new TextFormat();
				textformat.color = 0x907650;
				textformat.size = 18;
				
				var textField:TextField = new TextField();				
				textField.defaultTextFormat = textformat;
				textField.text = titlelist[num];
				textField.width = 110;
				textField.height = 120;
				textField.wordWrap = true;
				sp.addChild(textField);
				textField.x = 23;
				textField.y = 30;			
			}
			var bitmap:Bitmap = new DrawBitmap(sp,sp.width,sp.height);
			var bookUI:BookUIMovieClip = new BookUIMovieClip();
			bookUI.addChild(bitmap);
			sp = null;
			
			bookUI.name = String(num);//作为第几个图标的标志
			bookUI.bookName = String(num);
			bookUI.bookContent = this.sourceArr[num];
			num++;
			bookUI.addEventListener(MouseEvent.CLICK,Clickhandler);
			/*var UIDrag:MyDragFunc = new MyDragFunc(bookUI);//暂时禁用拖动换位
			UIDrag.addEventListener(MyDragEvent.START_EFFECT,StartEffectHandler);
			UIDrag.addEventListener(MyDragEvent.END_EFFECT,EndEffectHandler);*/
			return bookUI;
		}
	}
}