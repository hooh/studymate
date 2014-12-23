package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.CmdStr;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.DataResultVO;
	import com.studyMate.model.vo.SendCommandVO;
	import com.studyMate.model.vo.tcp.PackData;
	import com.studyMate.world.controller.vo.DialogBoxShowCommandVO;
	import com.studyMate.world.model.FormulaMediator;
	import com.studyMate.world.model.vo.FormulaVO;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class FormulaTestMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "FormulaTestMediator";
		public static const QRY_FORMULA:String = NAME +　"QryFormula";
		
		private var vo:SwitchScreenVO;
		private var input:flash.text.TextField;
		private var formulaBMP:Bitmap;
		private var layout:VerticalLayout;
		private var setContainer:ScrollContainer;
		private var formulaHolder:ScrollContainer;
		
		private var formulas:Array;
		
		private var textureList:Vector.<Texture>;
		
		public function FormulaTestMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function prepare(_vo:SwitchScreenVO):void
		{
			vo = _vo;
			Facade.getInstance(CoreConst.CORE).registerMediator(new FormulaMediator);
			queryFormulas();
		}
		private function clearTexture():void{
			if(textureList){
				for(var i:int=0;i<textureList.length;i++){
					textureList[i].dispose();
				}
				textureList.length = 0 ;
			}
		}
		
		override public function onRegister():void
		{
			textureList = new Vector.<Texture>;
			sendNotification(WorldConst.HIDE_MAIN_MENU);
			layout = new VerticalLayout();
			layout.gap = 5;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			
			setContainer = new ScrollContainer();
			setContainer.layout = layout;
			setContainer.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			setContainer.snapScrollPositionsToPixels = true;
			setContainer.width = 260; setContainer.height = Global.stageHeight;
			view.addChild(setContainer);
			
			var tabs:TabBar = new TabBar();
			tabs.width = 260; tabs.gap = 5;
			tabs.direction = TabBar.DIRECTION_VERTICAL;
			tabs.dataProvider = new ListCollection(formulas);
			setContainer.addChild(tabs);
			tabs.addEventListener( Event.CHANGE, tabs_changeHandler );
			var defaultSkin:Quad = new Quad(260, 56, 0x1a1a1a);
			defaultSkin.alpha = 0;
			tabs.tabProperties.defaultSkin = defaultSkin;
			tabs.tabProperties.defaultSelectedSkin = new Image(Assets.getAtlasTexture("set/tabBarSelect"));
			var downSkin:Quad = new Quad(260, 56, 0x1a1a1a);
			downSkin.alpha = 0.2;
			tabs.tabProperties.downSkin = downSkin;
//			tabs.tabProperties.@defaultLabelProperties.textFormat = new TextFormat("HeiTi", 24, 0x1a1a1a, false);
//			tabs.tabProperties.@defaultSelectedLabelProperties.textFormat = new TextFormat("HeiTi", 24, 0x1a1a1a, true);
			tabs.tabProperties.stateToSkinFunction = null;
			var boldFontDescription:FontDescription = new FontDescription("HeiTi",FontWeight.NORMAL,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
			tabs.tabProperties.@defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 24, 0x1a1a1a);
			tabs.tabProperties.@defaultSelectedLabelProperties.elementFormat =  new ElementFormat(boldFontDescription, 24, 0x1a1a1a)
			
			layout = new VerticalLayout();
			layout.gap = 5; layout.padding = 20;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			
			formulaHolder = new ScrollContainer();
			formulaHolder.layout = layout;
			formulaHolder.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			formulaHolder.snapScrollPositionsToPixels = true;
			formulaHolder.x = 261; 
//			formulaHolder.y = 110;
			formulaHolder.width = Global.stageWidth - 261; formulaHolder.height = Global.stageHeight;
			view.addChild(formulaHolder);
			
			var rec:starling.text.TextField = new starling.text.TextField(1018, 761, "");
			rec.border = true; rec.x = 261;
			rec.touchable = false;
			view.addChild(rec);
		}
		
		override public function onRemove():void
		{
			clearTexture();
			sendNotification(WorldConst.SHOW_MAIN_MENU);
			facade.removeMediator(FormulaMediator.NAME);
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var result:DataResultVO;
			switch(notification.getName()){
				case WorldConst.GET_FORMULA_IMAGE :
					var fvo:FormulaVO = notification.getBody() as FormulaVO;
					if(fvo.bmp.height > 2048 || fvo.bmp.width > 2048){
						sendNotification(WorldConst.DIALOGBOX_SHOW,new DialogBoxShowCommandVO(view.stage,
							640,381,null,"生成图片异常，高度或宽度超过2048. O(∩_∩)O~"));
					}else{
						addBitmap(fvo.bmp);
					}
					break;
				case QRY_FORMULA :
					result = notification.getBody() as DataResultVO;
					if(!result.isEnd){
						formulas.push({id:PackData.app.CmdOStr[1], label:PackData.app.CmdOStr[2], text:PackData.app.CmdOStr[3]});
					}else{
						Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
					}
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.GET_FORMULA_IMAGE, QRY_FORMULA];
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		private function showFormula(fvo:FormulaVO):void{
			sendNotification(WorldConst.SET_FORMULA_IMAGE, fvo);
		}
		
		private function queryFormulas():void{
			formulas = new Array();
			PackData.app.CmdIStr[0] = CmdStr.QRY_MATH_FORMULA;
			PackData.app.CmdInCnt = 1;
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.SEND_1N,new SendCommandVO(QRY_FORMULA));
		}
		
		private function addBitmap(bmp:Bitmap):void{
			formulaHolder.removeChildren(0, -1, true);
			var texture:Texture = Texture.fromBitmap(bmp,false);
			formulaHolder.addChild(new Image(texture));
			textureList.push(texture);
		}
		
		private function tabs_changeHandler( event:Event ):void{
			formulaHolder.removeChildren(0, -1, true);
			clearTexture();
			var tabs:TabBar = TabBar( event.currentTarget );
			var index:int = tabs.selectedIndex;
			var fvo:FormulaVO = new FormulaVO(index.toString());
			fvo.formula = formulas[index].text;
			showFormula(fvo);
		}
		
	}
}