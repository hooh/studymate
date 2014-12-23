package com.studyMate.module.classroom
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.module.classroom.list.ListClassGridItem;
	import com.studyMate.module.classroom.list.ListClassItemRenderer1;
	import com.studyMate.world.component.gridList.GridList;
	import com.studyMate.world.component.gridList.ListExtends;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	
	internal class ListCRstudentMediator extends ScreenBaseMediator
	{
		private const NAME:String = 'ListCRstudentMediator';
		private var croomList:ListExtends;//列表组件
		
		private var prepareVO:SwitchScreenVO;
		private var pageIndex:int;
		public function ListCRstudentMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		

		override public function onRemove():void{
			if(croomList){
				croomList.removeFromParent(true);	
				
			}
			super.onRemove();
		}
		override public function onRegister():void{
			var value:String;
			if(CacheTool.has(NAME,'crType')){
				value = CacheTool.getByKey(NAME,'crType') as String;
				if(value=='U'){					
					useUlist();			
				}else{
					useDlist();
				}
			}else{
				useUlist();
			}
		}
		//使用已完成的list 组件
		private function useDlist():void{
			if(croomList){
				croomList.stopScrolling();
				croomList.removeFromParent(true);
			}
			var len:int = (facade.retrieveMediator(ModuleConst.CLASSROOM) as ListClassRoomMediator).croomDVec.length;
			if(len==0){
				sendNotification(CoreConst.TOAST,new ToastVO("目前您尚未有已辅导过的教室科目",1));
				return;
			}
			croomList = new GridList;
			croomList.itemRendererType = ListClassGridItem;
			packlist((facade.retrieveMediator(ModuleConst.CLASSROOM) as ListClassRoomMediator).croomDVec);
			CacheTool.put(NAME,'crType','D');
		}
		
		//使用未辅导的list 组件
		private function useUlist():void{
			if(croomList){
				croomList.stopScrolling();
				croomList.removeFromParent(true);
			}
			var len:int = (facade.retrieveMediator(ModuleConst.CLASSROOM) as ListClassRoomMediator).croomUVec.length;
			if(len==0){
				sendNotification(CoreConst.TOAST,new ToastVO("目前您尚未有预约的教室科目",1));
				return;
			}
			croomList = new ListExtends();
			croomList.itemRendererType = ListClassItemRenderer1;			
			packlist((facade.retrieveMediator(ModuleConst.CLASSROOM) as ListClassRoomMediator).croomUVec);						
			CacheTool.put(NAME,'crType','U');
		}
		
		
		private function packlist(dataProvider:ListCollection):void{
			var layout:HorizontalLayout = new HorizontalLayout();			
			croomList.x = 0;
			croomList.y = 0;
			croomList.setSize(Global.stageWidth,632);
			croomList.layout = layout;
			croomList.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			croomList.snapToPages = true;
			croomList.hasHorizonDot = true;
			croomList.setHorizonDotSkin(Assets.getListClassTexture('dot1'),Assets.getListClassTexture('dot0'));
			croomList.horizontalScrollBarFactory = null;
			croomList.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			croomList.dataProvider = dataProvider;
			view.addChild(croomList);
			
			if(CacheTool.has(NAME,'pageIndex')){
				var value:int = CacheTool.getByKey(NAME,'pageIndex') as int;
				if(value<croomList.dataProvider.length){
					croomList.scrollToPageIndex(value,0);
				}
			}
		}

		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()) {
				/*case WorldConst.HIDE_SETTING_SCREEN :
					prepareVO.type = SwitchScreenType.HIDE;
					sendNotification(WorldConst.SWITCH_SCREEN,[prepareVO]);
					break;*/
				case CRoomConst.CHANGE_U_LIST:
					useUlist();
					break;
				case CRoomConst.CHANGE_D_LIST:
					useDlist();
					break;
				case WorldConst.SWITCH_SCREEN:
					if(croomList){						
						CacheTool.put(NAME,'pageIndex',croomList.horizontalPageIndex);
					}
					break;
			}
		}
		override public function listNotificationInterests():Array{
			return [CRoomConst.CHANGE_U_LIST,CRoomConst.CHANGE_D_LIST,WorldConst.SWITCH_SCREEN];
		}
		
		override public function get viewClass():Class{
			return Sprite;
		}		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function prepare(vo:SwitchScreenVO):void{	
			prepareVO = vo;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
	}
}