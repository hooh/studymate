package com.studyMate.world.component.SVGEditor.myTagList
{
	import com.studyMate.world.component.SVGEditor.data.LoadSVGVO;
	
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.core.UIComponent;
	
	public class ListCellRender extends UIComponent implements ICellRenderer
	{
		private var wrongidLabel:TextField;//id
		private var subjectLabel:TextField;//学科
		private var srcdescLabel:TextField;//#素材出处来源描述；小升初、中考、高考、书、网络等
		private var copcodeLabel:TextField;//创建人工号
		private var mopcodeLabel:TextField;//最后修改人工号
		private var modtimeLabel:TextField;//最后修改时间
		
		private const defaultColor:uint = 0x0066FF;
		private const rollColor:uint = 0x0099FF;
		
		private var tf:TextFormat;
		
		public function ListCellRender()
		{
			createChildren();  
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			super();
		}
		private function rollOverHandler(event:MouseEvent):void
		{
			setBgColor(defaultColor);
		}
		
		private function rollOutHandler(event:MouseEvent):void
		{
			if (selected)
			{
				setBgColor(defaultColor);
			}
			else
			{
				setBgColor(rollColor);
			}
		}
		private function createChildren():void 
		{  
			
			addChild(new TextField);
			
			wrongidLabel = new TextField();  
			wrongidLabel.x = 0;		
			
			subjectLabel = new TextField();
			subjectLabel.x = 100;
			subjectLabel.autoSize = TextFieldAutoSize.LEFT;
			
			srcdescLabel = new TextField();
			srcdescLabel.x = 200;
			srcdescLabel.autoSize = TextFieldAutoSize.LEFT;			
			
			copcodeLabel = new TextField();
			copcodeLabel.x = 680;
			copcodeLabel.autoSize = TextFieldAutoSize.LEFT;			
			
			mopcodeLabel = new TextField();
			mopcodeLabel.x = 780;
			mopcodeLabel.autoSize = TextFieldAutoSize.LEFT;		
			
			modtimeLabel = new TextField();
			modtimeLabel.x = 880;
			modtimeLabel.autoSize = TextFieldAutoSize.LEFT;
				
			
			wrongidLabel.embedFonts = true;
			subjectLabel.embedFonts = true;
			modtimeLabel.embedFonts = true;
			mopcodeLabel.embedFonts = true;
			copcodeLabel.embedFonts = true;
			srcdescLabel.embedFonts = true;
			
			tf = new TextFormat("HeiTi",20,0xFFFFFF);
			
			wrongidLabel.defaultTextFormat = tf;
			subjectLabel.defaultTextFormat = tf;
			modtimeLabel.defaultTextFormat = tf;
			mopcodeLabel.defaultTextFormat = tf;
			copcodeLabel.defaultTextFormat = tf;
			srcdescLabel.defaultTextFormat = tf;
			
			wrongidLabel.antiAliasType = AntiAliasType.ADVANCED;
			subjectLabel.antiAliasType = AntiAliasType.ADVANCED;
			modtimeLabel.antiAliasType = AntiAliasType.ADVANCED;
			copcodeLabel.antiAliasType = AntiAliasType.ADVANCED;
			srcdescLabel.antiAliasType = AntiAliasType.ADVANCED;
			
//			wrongidLabel.autoSize = TextFieldAutoSize.LEFT;	
			
			wrongidLabel.selectable = false;
			subjectLabel.selectable = false;
			modtimeLabel.selectable  = false;
			mopcodeLabel.selectable = false;
			copcodeLabel.selectable = false;
			srcdescLabel.selectable = false;
			this.mouseChildren = false;
			
			addChild(wrongidLabel);
			addChild(subjectLabel);
			addChild(srcdescLabel);
			addChild(copcodeLabel);
			addChild(mopcodeLabel);
			addChild(modtimeLabel);	
		}  
		private var _listData:ListData;  
		
		/**  
		 * @inheritDoc  
		 */ 
		public function get listData():ListData  
		{  
			return _listData;  
		}  
		
		/**  
		 * @inheritDoc  
		 */ 
		public function set listData(value:ListData):void 
		{  
			_listData = value;
			setLabel(); 
		}  
		private function setLabel():void 
		{  
			var svgTitleVO:LoadSVGVO = data.svgTitleVO as LoadSVGVO;
			wrongidLabel.text = svgTitleVO.wrongid;
			subjectLabel.text = svgTitleVO.subject;
			srcdescLabel.text = svgTitleVO.srcdesc;
			copcodeLabel.text = svgTitleVO.copcode;
			mopcodeLabel.text = svgTitleVO.mopcode;
			modtimeLabel.text = svgTitleVO.modtime;
		}  
		
		private var _data:Object;  
		
		/**  
		 * @inheritDoc  
		 */ 
		public function get data():Object  
		{  
			return _data;  
		}  
		
		/**  
		 * @inheritDoc  
		 */ 
		public function set data(value:Object):void 
		{  
			_data = value;  
			if (selected && data)
			{
				setBgColor(defaultColor);
			}
			else
			{
				setBgColor(rollColor);
			}
		}  
		
		/**  
		 * @inheritDoc  
		 */ 
		public function get selected():Boolean  
		{  
			return false;  
		}  
		
		/**  
		 * @inheritDoc  
		 */ 
		public function set selected(value:Boolean):void 
		{  
		}  
		
		/**  
		 * @inheritDoc  
		 */ 
		public function setMouseState(value:String):void 
		{  
		}  
		
		/**  
		 * @inheritDoc  
		 */ 
		public override function setSize(width:Number, height:Number):void 
		{  
			super.setSize(width, height);  
		}  
		/**  
		 * @private  
		 * 设置背景颜色  
		 * @param color 颜色值 默认值为黑色  
		 */ 
		private function setBgColor(color:uint=0):void 
		{  
			graphics.clear();  
			graphics.beginFill(color);
			graphics.drawRect(0, 0, width, height);  
			graphics.endFill();  
		}
	}
}