package com.studyMate.module.classroom
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.classroom.list.ListClassItemRenderer;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.List;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	internal class ListCRteacherMediator extends ScreenBaseMediator
	{
		
		private var croomList:List;//列表组件
		private var prepareVO:SwitchScreenVO;
		
		public function ListCRteacherMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super('ListCRteacherMediator', viewComponent);
		}
		
		override public function onRemove():void{
			if(croomList){
				croomList.removeFromParent(true);	
				
			}
			super.onRemove();
		}
		override public function onRegister():void{
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 5;		
			croomList = new List();
			croomList.x = 100;
			croomList.y = 20;
			croomList.width = 1100;
			croomList.height = 608;
			croomList.layout = layout;
			croomList.itemRendererType = ListClassItemRenderer;
			view.addChild(croomList);	
			croomList.dataProvider = (facade.retrieveMediator(ModuleConst.CLASSROOM) as ListClassRoomMediator).croomUVec;			
			croomList.addEventListener( Event.CHANGE, list_changeHandler );			
		}
		
		
		
		private function list_changeHandler( event:Event ):void
		{
			var item:CroomVO = croomList.selectedItem as CroomVO;			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(ClassroomMediator,item)]);
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				/*case WorldConst.HIDE_SETTING_SCREEN :
					prepareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
					break;*/
				case CRoomConst.CHANGE_U_LIST:
					croomList.stopScrolling();
					croomList.dataProvider = (facade.retrieveMediator(ModuleConst.CLASSROOM) as ListClassRoomMediator).croomUVec;			
					break;
				case CRoomConst.CHANGE_D_LIST:
					croomList.stopScrolling();
					croomList.dataProvider = (facade.retrieveMediator(ModuleConst.CLASSROOM) as ListClassRoomMediator).croomDVec;			
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [CRoomConst.CHANGE_U_LIST,CRoomConst.CHANGE_D_LIST];
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function prepare(vo:SwitchScreenVO):void{	
			prepareVO = vo
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}