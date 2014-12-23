package com.studyMate.world.component.SVGEditor.windows
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.world.component.SVGEditor.SVGConst;
	import com.studyMate.world.component.SVGEditor.data.PropertyVO;
	import com.studyMate.world.component.SVGEditor.model.EditSVGProxy;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditBase;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditGraph;
	import com.studyMate.world.component.SVGEditor.product.interfaces.IEditText;
	import com.studyMate.world.component.SVGEditor.utils.EditType;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	


	/**
	 * 编辑区面板。
	 * 负责编辑功能。编辑完成交付SVGDrawCanvasMediator去渲染绘制
	 * @author wangtu
	 * 
	 */	
	public class SVGEditCanvasMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SVGEditCanvasMediator";	
		private var editSvg:IEditBase;//当前的编辑对象
		private var _isEditState:Boolean;//当前是否处于编辑状态		
		
		private var swfrecive:String;//swf类名
		
		
		public function SVGEditCanvasMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}

		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		override public function onRemove():void{
			isEditState = false;
			editSvg = null;
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,editDelHandler,true);
			stopDrawingHandler();
			super.onRemove();
		}
		override public function onRegister():void
		{
			isEditState = false;
			view.graphics.clear();
			view.graphics.beginFill(0,0.1);
			view.graphics.drawRect(0,0,SVGConst.stageWidth,SVGConst.stageHeight);
			view.graphics.endFill();			
		}	

		public function get isEditState():Boolean{
			return _isEditState;
		}
		public function set isEditState(value:Boolean):void{
			_isEditState = value;
			SVGConst.isEditState = value;
			if(value){//true编辑状态下
				view.visible = true;
				view.addEventListener(MouseEvent.CLICK,clickToUpdateHandler);
				Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,editDelHandler,true,1);//侦听删除
				trace('注册侦听');
			}else{//非编辑状态
				view.visible = false;
				view.removeChildren();
				editSvg = null;
				trace('删除侦听');
				Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,editDelHandler,true);
				view.removeEventListener(MouseEvent.CLICK,clickToUpdateHandler);
			}			
		}
		//Delete键盘删除事件
		protected function editDelHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.DELETE){
				event.preventDefault();
				event.stopImmediatePropagation();
				if(editSvg){
					var children:XMLList = SVGConst.svgXML.children();			
					for(var i:int = 0;i <children.length();i++){
						if(children[i].@id ==editSvg.id ){
							delete children[i];
							sendNotification(SVGConst.CHANGE_TAG);//修改标签
							break;
						}
					}
					isEditState = false;
				}				
			}
		}
			
		
		//刷新
		protected function clickToUpdateHandler(e:MouseEvent=null):void
		{
			if(SVGConst.isEditState){
				updateData();				
			}
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case SVGConst.PREPARE_CREAT_NEW://注册点击新建编辑对象
					addListener();
					swfrecive = notification.getBody() as String;//swf库类名。可以有也可以不传
					break;				
				case SVGConst.REMOVE_REPARE_CREAT_NEW://移除新建编辑状态
					removeLiestener();
					updateData();
					if(isEditState){
						isEditState = false;
					}
					break;
				case SVGConst.CREAT_NEW_ELEMENT:
					isEditState = true;
					editSvg = notification.getBody() as IEditBase;
					view.addChild(editSvg as DisplayObject);
					SVGConst.svgXML.appendChild(editSvg.getElementXML());
					sendNotification(SVGConst.CHANGE_TAG);//修改标签
					break;
				case SVGConst.MODIFIY_ELEMENT://修编辑框					
					isEditState = true;					
					editSvg = notification.getBody() as IEditBase;
					view.addChild(editSvg as DisplayObject);
					break;
				case SVGConst.CLEAR_ALL_ELEMENT:
					isEditState = false;
					break;
				case SVGConst.UPDATE_SVG_DOCUMENT://刷新
					updateData();
					view.removeChildren();
					editSvg = null;
					
//					sendNotification(SVGConst.UPDATE_SVG_DOCUMENT_COMPLETE);
					break;

				case SVGConst.PROPERTIES_CHANGE:
					var propertyVO:PropertyVO = notification.getBody() as PropertyVO;
					if(editSvg){
						if(propertyVO.type==0){
							editSvg[propertyVO.attribute] = propertyVO.value;
						}else{
							editSvg.setAttribute(propertyVO.attribute,propertyVO.value)
						}
					}					
					break;
				case SVGConst.UPDATE_STAGE_SCALE:
					this.updateStageScale();
					
					break;		
			}
		}
		
		public function updateStageScale():void{
			view.graphics.clear();
			view.graphics.beginFill(0,0.1);
			view.graphics.drawRect(0,0,SVGConst.stageWidth,SVGConst.stageHeight);
			view.graphics.endFill();
			view.x = (1280-SVGConst.stageWidth)/2;
			view.y = (752-SVGConst.stageHeight)/2;
		}
		
		
//**---------------------------------准备创建新对象---------------------------------------------------*/		
		private function addListener():void{
			if(SVGConst.isEditState){
				sendNotification(SVGConst.UPDATE_SVG_DOCUMENT);
			}
			view.visible = true;	
			view.buttonMode = true;
			view.addEventListener(MouseEvent.MOUSE_DOWN,creatNewElementHandler);				
			
		}
		private function removeLiestener():void{
			view.buttonMode = false;
			view.removeEventListener(MouseEvent.MOUSE_DOWN,creatNewElementHandler);
		}
		
		protected function drawingHandler(event:MouseEvent):void
		{
			var point:Point = (editSvg as DisplayObject).globalToLocal(new Point(event.stageX,event.stageY));
			if(point.x>1 && point.y>1)
			(editSvg as IEditGraph).draw(point.x,point.y);										
		}
		
		private function stopDrawingHandler(event:MouseEvent = null):void{
			Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE,drawingHandler);
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,stopDrawingHandler);
		}
		
		protected function creatNewElementHandler(e:MouseEvent):void
		{			
			e.stopImmediatePropagation();
			removeLiestener();			
			editSvg = (facade.retrieveProxy(EditSVGProxy.NAME) as EditSVGProxy).creatNewEdit(new Point(e.stageX,e.stageY),swfrecive);
			if(editSvg is IEditGraph){
				(editSvg as IEditGraph).begin(0,0);
				Global.stage.addEventListener(MouseEvent.MOUSE_MOVE,drawingHandler);
				Global.stage.addEventListener(MouseEvent.MOUSE_UP,stopDrawingHandler);
			}
			if(editSvg){								
				sendNotification(SVGConst.CREAT_NEW_ELEMENT,editSvg);
			}
		}
//**---------------------------------准备创建新对象---------------------------------------------------*/
		
		
		
		private function updateData():void{
			if(editSvg){
				var children:XMLList = SVGConst.svgXML.children();			
				for(var i:int = 0;i <children.length();i++){
					if(children[i].@id ==editSvg.id ){
						var xml:XML =  editSvg.getElementXML();
						if((editSvg is IEditText) && editSvg.type == EditType.text){
							if(StringUtil.trim(xml.children()[0])==""){
								delete children[i];
								sendNotification(SVGConst.CHANGE_TAG);//修改标签
								break;
							}
						}else if((editSvg is IEditText) && editSvg.type == EditType.image){
							var xlink:Namespace = new Namespace("http://www.w3.org/1999/xlink");			
							if(xml.@xlink::href == ''){
								delete children[i];
								sendNotification(SVGConst.CHANGE_TAG);//修改标签
								break;
							}
						}
						SVGConst.svgXML.replace(children[i].childIndex(),xml);
						break;
					}
				}
			}
			view.removeChildren();
			editSvg = null;								
			xml = null;
			isEditState = false;
			sendNotification(SVGConst.UPDATE_SVG_DOCUMENT_COMPLETE);
			
			sendNotification(SVGConst.PROPERTIES,null);//发送属性面板
			
		}
			
				
		override public function listNotificationInterests():Array{
			return [SVGConst.PROPERTIES_CHANGE,
					SVGConst.UPDATE_STAGE_SCALE,
					SVGConst.REMOVE_REPARE_CREAT_NEW,
					SVGConst.CREAT_NEW_ELEMENT,
					SVGConst.CLEAR_ALL_ELEMENT,
					SVGConst.UPDATE_SVG_DOCUMENT,
					SVGConst.MODIFIY_ELEMENT,
					SVGConst.PREPARE_CREAT_NEW];
		}
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
	}
}