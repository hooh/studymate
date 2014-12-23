package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.Global;
	import com.studyMate.global.SwitchScreenType;
	
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	public class SystemSetMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SystemSetMediator";
		
		public function SystemSetMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
		}

		override public function prepare(vo:SwitchScreenVO):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
				
		override public function onRegister():void{
//			sendNotification(WorldConst.HIDE_MAIN_MENU);
			sendNotification(WorldConst.HIDE_MENU_BUTTON);
			var quad:Quad = new Quad(260, Global.stageHeight, 0x2D9CBF);
			view.addChild(quad);
			
			quad = new Quad(1020, Global.stageHeight, 0x35B7E1);
			quad.x = 260;
			view.addChild(quad);
			
			var img:Image = new Image(Assets.getAtlasTexture("set/set"));
			img.x = 36;
			img.y = 19;
			view.addChild(img);
			var layout:VerticalLayout;	
			layout = new VerticalLayout();
			layout.gap = 5;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			
			
			var tabs:TabBar = new TabBar();
			tabs.y = 100;
			tabs.dataProvider = new ListCollection(
				[
					{label: "声   音"},
					{label: "密码设置"},
					{label: "其   他"}
				]);
			view.addChild(tabs);
			setStyle(tabs);		//设定样式
				
			tabs.addEventListener( Event.CHANGE, tabs_changeHandler );			
			sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SetSoundNewMeidator,null,SwitchScreenType.SHOW,null,281,16)]);
			
			trace("@VIEW:SystemSetMediator:");
		}
		
		private function tabs_changeHandler( event:Event ):void{
			sendNotification(WorldConst.HIDE_SETTING_SCREEN);
			var tabs:TabBar = TabBar( event.currentTarget );
			switch(tabs.selectedIndex){
				case 0:
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SetSoundNewMeidator,null,SwitchScreenType.SHOW,null,281,16)]);					
					break;
				case 1:
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(SetPasswordMediator,null,SwitchScreenType.SHOW,null,281,16)]);					
					break;
				case 2:					
					sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(UpPackMediator,null,SwitchScreenType.SHOW,null,281,16)]);
					break;
			}

		}
		
		private function setStyle(tabs:TabBar):void{
			tabs.direction = TabBar.DIRECTION_VERTICAL;
			tabs.gap = 1;
			tabs.customTabName = "systemSetTabBar";
			tabs.tabFactory = tabButtonFactory;
			tabs.tabProperties.stateToSkinFunction = null;			
//			tabs.tabProperties.@defaultLabelProperties.textFormat = new TextFormat("HeiTi", 25, 0xFFFFFF,true);
//			tabs.tabProperties.@defaultLabelProperties.embedFonts = true;			
//			tabs.tabProperties.@defaultSelectedLabelProperties.textFormat = new TextFormat("HeiTi", 25, 0xFFFFFF,true);
//			tabs.tabProperties.@defaultSelectedLabelProperties.embedFonts = true;
			
			var boldFontDescription:FontDescription = new FontDescription("HeiTi",FontWeight.BOLD,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
			tabs.tabProperties.@defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 25, 0xFFFFFF);
			tabs.tabProperties.@defaultSelectedLabelProperties.elementFormat =  new ElementFormat(boldFontDescription, 25, 0xFFFFFF)

		}
		private function tabButtonFactory():feathers.controls.Button{
			var tab:ToggleButton = new ToggleButton();
			tab.defaultSkin = new Image(Assets.getAtlasTexture("set/tabBarSelect"));
			tab.defaultSelectedSkin = new Image(Assets.getAtlasTexture("set/soundSetDefaultBg"));
			tab.downSkin = new Image(Assets.getAtlasTexture("set/soundSetDefaultBg"));
			return tab;
		}
		
		override public function onRemove():void{
//			sendNotification(WorldConst.SHOW_MAIN_MENU);
			sendNotification(WorldConst.SHOW_MENU_BUTTON);
			sendNotification(WorldConst.HIDE_SETTING_SCREEN);
			super.onRemove();
		}
		
		public function get view():starling.display.Sprite{
			return getViewComponent() as starling.display.Sprite;
		}
		override public function get viewClass():Class{
			return starling.display.Sprite;
		}
		
	}
}