package com.studyMate.module.classroom.view
{
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.module.classroom.ExamHistVO;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollText;
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.data.ListCollection;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	
	/**
	 * note
	 * 2014-6-6下午2:26:26
	 * Author wt
	 *
	 */	
	
	public class CRExplantionView extends Sprite
	{
		public var closeBtn:starling.display.Button;
		public var titleTxt:starling.text.TextField;
		public var tabs:TabBar;
		
		private var analysisHolder:Sprite;//详解
		
		private var historyHolder:Sprite;//答题历史
		
		public function CRExplantionView()
		{
			var part0:Image = new Image(Assets.getCnClassroomTexture('part0'));
			this.addChild(part0);
			
			var part1:Image = new Image(Assets.getCnClassroomTexture('part1'));
			part1.x = 704;
			this.addChild(part1);
			
			closeBtn = new starling.display.Button(Assets.getCnClassroomTexture('closeHisBtn'));
			closeBtn.x = 24;
			closeBtn.y = 15;
			this.addChild(closeBtn);
			
			titleTxt = new starling.text.TextField(434,38,'习题','HeiTi',27,0xFFFFFF,true);
			titleTxt.hAlign = HAlign.LEFT;
			titleTxt.autoScale = true;
			titleTxt.x = 93;
			titleTxt.y = 30;
			titleTxt.touchable = false;
			this.addChild(titleTxt);
			
			
			tabs = new TabBar();
			tabs.selectedIndex = 0;			
			tabs.x = 966;
			tabs.y = 31.8;
			tabs.direction = TabBar.DIRECTION_HORIZONTAL;
			tabs.gap = 3;
			tabs.dataProvider = new ListCollection(
				[					
					{label: "答案解析"} , 
					{label: "答题情况"}  					
				]);
			tabs.customTabName = "crhisTabBar";
			tabs.tabFactory = tabButtonFactory;
			tabs.tabProperties.stateToSkinFunction = null;			
//			tabs.tabProperties.@defaultLabelProperties.textFormat = new TextFormat("HeiTi", 23, 0xE2AA53,true);
//			tabs.tabProperties.@defaultLabelProperties.embedFonts = true;			
//			tabs.tabProperties.@defaultSelectedLabelProperties.textFormat = new TextFormat("HeiTi", 23, 0x773434,true);
//			tabs.tabProperties.@defaultSelectedLabelProperties.embedFonts = true;
			var boldFontDescription:FontDescription = new FontDescription("HeiTi",FontWeight.BOLD,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF);
			tabs.tabProperties.@defaultLabelProperties.elementFormat = new ElementFormat(boldFontDescription, 23, 0xE2AA53);
			tabs.tabProperties.@defaultSelectedLabelProperties.elementFormat =  new ElementFormat(boldFontDescription, 23, 0x773434)
			this.addChild(tabs);
			
					
		}
		
		private var scroll:ScrollText; 
		private var textfild:flash.text.TextField;
		private var _tips:String;
		public function set showAnalysis(tips:String):void{
			if(historyHolder){
				if(historyHolder.numChildren>1){				
					historyHolder.removeChildren(1,-1,true);
				}
				historyHolder.removeFromParent();
			}
			if(analysisHolder==null){
				textfild = new flash.text.TextField();
								
				analysisHolder = new Sprite();
				analysisHolder.x = 738;
				analysisHolder.y = 82;
				this.addChild(analysisHolder);				

				scroll = new ScrollText();
				analysisHolder.addChild(scroll);
				scroll.width = 510;
				scroll.height = 610;
				scroll.paddingTop = 0;
				scroll.isHTML = true;
				scroll.textFormat = new TextFormat('HeiTi',21,0x7c4727,true);
				scroll.embedFonts = true;
			}
			if(!analysisHolder.parent){
				this.addChild(analysisHolder);
			}
			scroll.text = tips;
			textfild.htmlText = tips;
			
			_tips = tips;
		}
		
		public function get analysisText():String{
			return _tips;
		}
		
		public function set showHistory(vec:Vector.<ExamHistVO>):void{
			if(analysisHolder){
				analysisHolder.removeFromParent();
			}
			if(historyHolder==null){
				historyHolder = new Sprite();
				historyHolder.x = 720;
				historyHolder.y = 72;
				var bg:Image = new Image(Assets.getCnClassroomTexture('answerResultBg'));
				historyHolder.addChild(bg);
			}
			if(!historyHolder.parent){
				this.addChild(historyHolder);
			}
			if(vec.length == 0){
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("用户没有做过该题",1));
				return;
			}
			if(historyHolder.numChildren>1){				
				historyHolder.removeChildren(1,-1,true);
			}
			for(var i:int=0;i<vec.length;i++){
				if(i>6) break;
				var sp:Sprite = creatUI(vec[i]);
				sp.x = 0;
				sp.y = 90 + 71*i;
				historyHolder.addChild(sp);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(analysisHolder){
				analysisHolder.removeFromParent(true);
			}
			if(historyHolder){
				historyHolder.removeFromParent(true);
			}
		}
		
		private function creatUI(histVO:ExamHistVO):Sprite{
			var holder:Sprite = new Sprite();
			holder.touchable = false;
			var time:starling.text.TextField = new starling.text.TextField(188,50,histVO.time,'HeiTi',17,0x714015);
			holder.addChild(time);
			
			if(histVO.mark=='R'){
				var hisTxt:starling.text.TextField = new starling.text.TextField(300,50,histVO.answer,'HeiTi',17,0x0F7708,true);				
				var markIcon:Image = new Image(Assets.getCnClassroomTexture('rightIcon'));
				markIcon.x = 506;
				holder.addChild(markIcon);
			}else{
				hisTxt = new starling.text.TextField(300,50,histVO.answer,'HeiTi',17,0xFF0838,true);	
			}
			hisTxt.autoScale = true;
			hisTxt.hAlign = HAlign.LEFT;
			hisTxt.x = 200;
			holder.addChild(hisTxt);						
			return holder;
		}
		
		private function tabButtonFactory():feathers.controls.Button{
			var tab:ToggleButton = new ToggleButton();
			tab.defaultSkin = new Image(Assets.getCnClassroomTexture("tabBtn1"));
			tab.defaultSelectedSkin = new Image(Assets.getCnClassroomTexture("tabBtn0"));
			tab.downSkin = new Image(Assets.getCnClassroomTexture("tabBtn0"));
			return tab;
		}
	}
}