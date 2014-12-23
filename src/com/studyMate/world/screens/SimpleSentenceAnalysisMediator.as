package com.studyMate.world.screens
{
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.view.component.myScroll.Scroll;
	import com.studyMate.world.screens.component.drawGetWord.DrawGetWord;
	import com.studyMate.world.screens.component.drawGetWord.ElementGrid;
	import com.studyMate.world.screens.component.drawGetWord.WordElement;
	
	import fl.controls.Button;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class SimpleSentenceAnalysisMediator extends ScreenBaseMediator
	{
		public static const NAME:String = "SimpleSentenceAnalysisMediator";
		
		
		private var prepareVO:SwitchScreenVO;
		
		private var grid:ElementGrid;
		private var scroll:Scroll;
		private var temptf:TextField;
		private var tf:TextFormat; 
		
		private var mask:Sprite = new Sprite();
		
		
		public function SimpleSentenceAnalysisMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void{	
			mask.graphics.beginFill(0,0.8);
			mask.graphics.drawRect(0,0,1280,768);
			mask.graphics.endFill();
			
			tf = new TextFormat(null,40);
			temptf = new TextField();
			temptf.width = 1024;
			temptf.autoSize = TextFieldAutoSize.LEFT;
			temptf.wordWrap = true;
			temptf.multiline = true;
			temptf.defaultTextFormat = tf;			
			temptf.text = "When you request sensor data, you can specific rate (how much and how often). Don't ask for too much data at once,"									
			view.addChild(temptf);
			
			var edit:Button = new Button();
			edit.label = "编辑文本";
			edit.x = 1100;
			view.addChild(edit);
			edit.addEventListener(MouseEvent.CLICK,editHandler);
				
			var word:WordElement = new WordElement();
			word.y = 150;
			view.addChild(word);
			word.addEventListener(MouseEvent.CLICK,wordClickHandler);
			
			grid = new ElementGrid();
			//grid.y = 200;
			//view.addChild(grid);
			grid.DrawSentence(temptf);		
			
			scroll = new Scroll();
			scroll.y = 200;
			scroll.width = 1024;
			scroll.height = 550;			
			scroll.viewPort = grid;
			view.addChild(scroll);
		}
		
		private function editHandler(e:MouseEvent):void{
			view.addChild(mask);
			
			var txt:TextField = new TextField();
			txt.type = TextFieldType.INPUT;
			txt.width = 1024;
			txt.height = 500;
			txt.border = true;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.wordWrap = true;
			txt.multiline = true;
			var tf:TextFormat = new TextFormat(null,40,0xFFFFFF);
			txt.defaultTextFormat = tf;	
			txt.text = temptf.text
			view.addChild(txt);
			
			var btn:Button = new Button();
			btn.label = "编辑完成";
			btn.x = 500;
			btn.y = 516;
			view.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK,complete);
			
			function complete(e:MouseEvent):void{
				temptf.text = txt.text;
				view.removeChild(mask);
				view.removeChild(txt);
				view.removeChild(btn);
			}
		}
		
		private function wordClickHandler(e:MouseEvent):void
		{
			var btn:Button = e.target as Button;
			grid.inSertElement(btn.label);
			scroll.update();
		}
		
		override public function onRemove():void{		
			
		}
		
		
		
		private function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		override public function get viewClass():Class{
			return Sprite;
		}
		override public function prepare(vo:SwitchScreenVO):void{
			prepareVO = vo;			
			Facade.getInstance(ApplicationFacade.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,prepareVO);															
		}
	}
}