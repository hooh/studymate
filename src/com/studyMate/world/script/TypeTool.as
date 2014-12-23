package com.studyMate.world.script
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.events.TweenEvent;
	import com.greensock.text.SplitTextField;
	import com.mylib.framework.CoreConst;
	import com.studyMate.model.ExerciseLogicProxy;
	import com.studyMate.model.vo.ExerciseFlowVO;
	import com.studyMate.model.vo.ExerciseVO;
	import com.studyMate.view.component.ReadingTextField;
	import com.studyMate.world.component.SimpleMenuTextField;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.getDefinitionByName;
	
	import mx.utils.StringUtil;
	
	import com.studyMate.view.component.Table;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import utils.FunctionQueueEvent;
	import utils.FunctionQueueVO;
	import com.studyMate.utils.LayoutToolUtils;

	public final class TypeTool
	{
		
		public static var manual:Boolean = false;
		public static var font:String = "HeiTi";
		public static var size:int = 24;
		public static var color:int;
		public static var leading:int=100;
		public static var letterSpacing:int;
		public static var typeSpeed:Number = 0.1;
		public static var selectable:int=0;
		public static var boder:int=0;
		private static var idIdx:int;
		public static var lastFun:FunctionQueueVO;
		public static var nextFun:FunctionQueueVO;
		
		public static var isExerciseWrong:Boolean = false;
		
		public static var EXECUTE_SHOW_QUESTION_FUNCTION:String = "ExecuteShowQuestionFunction";
		
		public function TypeTool(){}
		
		public static function getId():String{
			idIdx++;
			return "t_"+idIdx;
		}
		public static function setFont(_font:String):void{
			font = _font;
			markFunComplete();
		}
		public static function setSize(_size:String):void{
			size = int(_size);
			markFunComplete();
		}
		public static function setColor(_color:String):void{
			color = int(_color);
			markFunComplete();
		}
		public static function setLeading(_leading:String):void{
			leading = int(_leading);
			markFunComplete();
		}
		public static function setBorderVisible(_boder:String):void{
			boder = int(_boder);
			markFunComplete();
		}
		public static function setLetterSpacing(_letterSpacing:String):void{
			letterSpacing = int(_letterSpacing);
			markFunComplete();
		}
		
		public static function setTypeSpeed(_speed:String):void{
			typeSpeed = Number(_speed);
			markFunComplete();
		}
		public static function setSelectable(_selectable:String):void{
			selectable = int(_selectable);
			markFunComplete();
		}
		public static function createTextField(id:*,_font:String,_x:int,_y:int,_width:uint,_height:uint):void{
			var textField:TextField;
			if(selectable>0){
				textField = new SimpleMenuTextField;
			}else if(selectable==-1){
				//textField = new SimpleMenuTextField;
				textField = new ReadingTextField;
			}else{
				textField = new TextField();
			}
			if(_font!="null"){
				textField.embedFonts = true;
				textField.antiAliasType = AntiAliasType.ADVANCED;
				var tf:TextFormat = new TextFormat(_font);
				textField.defaultTextFormat = tf;
			}
			textField.x = _x;
			textField.y = _y;
			textField.width = _width;
			textField.height = _height;
			textField.selectable = true;
			textField.multiline = true;
			textField.wordWrap = true;
			if(boder!=0){
				textField.border = true; 
			}
			if(leading!=0){
				tf = new TextFormat;
				tf.leading = leading;
				textField.defaultTextFormat = tf;
			}
			
//			textField.text="";
			addObj(id,textField);
			LayoutTool.holder.addChild(textField);
			markFunComplete();
		}
		public static function appendText(id:*,text:String):void{
			var textField:TextField = TextField(getObj(id));
			textField.htmlText += text;
			
			markFunComplete();
		}
		
		public static function setTextFormat(id:*,_size:uint,_color:int,_style:String,beginIndex:int, endIndex:int,_letterSpacing:Number,_leading:Number):void{
			var textField:TextField = TextField(getObj(id));
			textField.setTextFormat(getTextFormat(_size,_color,_style,_letterSpacing,_leading),beginIndex,textField.text.length);
			markFunComplete();
		}
		public static function setTextFormatByTF(textField:TextField,tf:TextFormat,beginIndex:int,endIndex:int):void{
			textField.setTextFormat(tf,beginIndex,endIndex);
		}
		public static function setDefaultFormat(id:*,_size:uint,_color:int,style:String,_bolder:int,bolderColor:int,_letterSpacing:Number,_leading:Number):void{
			var textField:TextField = TextField(getObj(id));
			
			textField.defaultTextFormat = getTextFormat(_size,_color,style,_letterSpacing,_leading);
			
			if(_bolder>0){
				textField.filters = [new DropShadowFilter(0,90,bolderColor,1,_bolder,_bolder,_bolder)];
			}
			markFunComplete();
		}
		
		public static function getTextFormat(_size:uint,color:int,_style:String,_letterSpacing:Number,_leading:Number):TextFormat{
			var tf:TextFormat = new TextFormat(null,_size,color);
			if(_size==0){
				tf.size = null;
			}
			if(_style=="B"){
				tf.bold = true;
			}
			if(_style=="I"){
				tf.italic = true;
			}
			if(_style=="U"){
				tf.underline = true;
			}
			tf.kerning = true;
			tf.letterSpacing = _letterSpacing;
			tf.leading = _leading;
			return tf;
		}
		public static function print(_x:int,_y:int,_txt:String):void{
			manual = true;
			var id:String = getId();
			createTextField(id,font,_x,_y,500,100);
			
			var textField:TextField = TextField(getObj(id));
			
			setDefaultFormat(id,size,color,null,0,0,0,0);
			
			textField.multiline = false;
			textField.wordWrap = false;
			textField.text = _txt;
			adjustTextFieldWH(textField);
			manual = false;
			
			markFunComplete();
		}
		public static function printText(_x:*,_y:*,_width:*,_height:*,_txt:*):void{
			manual = true;
			var id:String = getId();
			createTextField(id,font,_x,_y,_width,_height);
			
			var textField:TextField = TextField(getObj(id));
			
			setDefaultFormat(id,size,color,null,0,0,letterSpacing,leading);
			
			textField.wordWrap = true;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.htmlText = _txt;
			manual = false;
			
			markFunComplete();
		}
		public static function advancedPrint(_x:*,_y:*,_size:*,_font:*,_color:*,_style:*,_bolder:*,_bolderColor:*,_letterSpacing:*,_leading:*,_txt:*):void{
			var id:String = getId();
			manual = true;
			createTextField(id,_font,_x,_y,600,200);
			var textField:TextField = TextField(getObj(id));
			textField.multiline = false;
			textField.wordWrap = false;
			setDefaultFormat(id,_size,_color,_style,_bolder,_bolderColor,_letterSpacing,_leading);
			manual = false;
			textField.appendText(_txt);
			adjustTextFieldWH(textField);
			trace("advancedPrint");
			markFunComplete();
		}
		public static function simpleType(_x:*,_y:*,_str:*):void{
			var id:String = getId();
			manual = true;
			createTextField(id,font,_x,_y,500,200);
			setDefaultFormat(id,size,color,null,0,0,0,0);
			var tf:TextField = TextField(getObj(id));
			tf.wordWrap = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = false;
			
			appendText(id,_str);
			var textField:TextField = TextField(getObj(id));
			adjustTextFieldWH(textField);
			manual = false;
			typeTextFiled(id,typeSpeed);
		}
		public static function advancedType (_x:*,_y:*,_width:*,_height:*,_font:*,_speed:*,_size:*,_color:*,_style:*,_bolder:*,_bolderColor:*,_letterSpacing:*,_leading:*,_str:*):void{
			manual = true;
			trace("advancedTyping");
			var id:String = getId();
			
			createTextField(id,_font,_x,_y,_width,_height);
			setDefaultFormat(id,_size,_color,_style,_bolder,_bolderColor,_letterSpacing,_leading);
			appendText(id,_str);
			var textField:TextField = TextField(getObj(id));
			adjustTextFieldWH(textField);
			manual = false;
			typeTextFiled(id,_speed);
		}
		public static function typeArea(_x:*,_y:*,_width:*,_height:*,_str:*):void{
			var id:String = getId();
			manual = true;
			createTextField(id,font,_x,_y,_width,_height);
			setDefaultFormat(id,size,color,null,0,0,0,0);
			var tf:TextField = TextField(getObj(id));
			appendText(id,_str);
			var textField:TextField = TextField(getObj(id));
			adjustTextFieldWH(textField);
			manual = false;
			typeTextFiled(id,typeSpeed);
		}
		private static var advancedTypeId:String;
		private static var advancedTypeLength:int = 0;
		
		public static function continueType (_x:*,_y:*,_width:*,_height:*,_font:*,_speed:*,_size:*,_color:*,_letterSpacing:*,_leading:*,_str:*):void{
			
			lastFun = LayoutTool.lastFun;
			nextFun = LayoutTool.nextFun;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = _font;
			textFormat.size = _size;
			textFormat.color = _color;
			textFormat.letterSpacing = _letterSpacing;
			textFormat.leading = _leading;
			
			_str = String(_str).replace(/<br>/g,"\n");
			
			var tf:TextField;
			//执行第一个函数
			if(lastFun==null || lastFun.fun!=LayoutTool.continueType){
				advancedTypeLength = 0;
				manual = true;
				var id:String = getId();
				advancedTypeId = id;
				createTextField(advancedTypeId,_font,_x,_y,_width,_height);
				tf = TextField(getObj(advancedTypeId));
				tf.appendText(_str);
				tf.autoSize = TextFieldAutoSize.LEFT;
				if(_str!=""){
					tf.setTextFormat(textFormat,advancedTypeLength,tf.length);
				}
				//如果只有一个函数
				if(nextFun==null || nextFun.fun!=LayoutTool.continueType){
					manual = false;
//					tf.appendText(_str);
					typeTextFiled(advancedTypeId,_speed);
					advancedTypeId = null;
					advancedTypeLength = 0;
				}else{
					advancedTypeLength +=String(_str).length;
					manual = false;
					markFunComplete();
				}
				//执行最后一个函数
			}else if(nextFun==null || nextFun.fun!=LayoutTool.continueType ){
				manual = true;
				tf = TextField(getObj(advancedTypeId));
				tf.appendText(_str);
				if(_str!=""){
					tf.setTextFormat(textFormat,advancedTypeLength,tf.length);
				}
				manual = false;
				typeTextFiled(advancedTypeId,_speed);
				advancedTypeId = null;
				advancedTypeLength = 0;
			}
			//执行中间的函数
			else if(nextFun.fun==LayoutTool.continueType){
				manual = true;
				tf = TextField(getObj(advancedTypeId));
				tf.appendText(_str);
				if(_str!=""){
					tf.setTextFormat(textFormat,advancedTypeLength,tf.length);
				}
				advancedTypeLength +=String(_str).length;
				manual = false;
				markFunComplete();
			}
			trace("continueType");
		}
		
		private static var tableId:String;
		public static function showTable(_x:*,_y:*,_row:*,_column:*,_gridWidth:*,_gridHeight:*):void{
			tableId = getId();
			var t:Table = new Table(_row,_column,_gridWidth,_gridHeight);
			t.x = _x;
			t.y = _y;
			addItem(tableId,t,-1);
			tableSytle();
			markFunComplete();
		}
		private static function tableSytle():void{
			var t:Table = Table(getObj(tableId));
			t.defaultTextFont = font;
			t.defaultTextSize = size;
			t.defaultTextColor = color;
		}
		public static function setTableTextFont(_font:*):void{
			var t:Table = Table(getObj(tableId));
			t.textFont = _font;
		}
		public static function setTableTextColor(_color:*):void{
			var t:Table = Table(getObj(tableId));
			t.textColor = _color;
		}
		public static function setTableTextSize(_size:*):void{
			var t:Table = Table(getObj(tableId));
			t.textSize = _size;
		}
		public static function hideLine(index:*):void{
			var t:Table = Table(getObj(tableId));
			t.hideLine(3);
			markFunComplete();
		}
		public static function setBorder(_thick:*=1,_color:*=0):void{
			var t:Table = Table(getObj(tableId));
			t.updateBorder(int(_thick),uint(_color));
			markFunComplete();
		}
		public static function hideBorder(_tmp:*):void{
			var t:Table = Table(getObj(tableId));
			t.hideBorder();
			markFunComplete();
		}
		public static function setGridText(_row:*,_col:*,_text:*,_leading:*=0):void{
			_text = String(_text).replace(/<br>/g,"\n");
			var t:Table = Table(getObj(tableId));
			typeGridText(t.rowColumn([_row,_col]),_text);
		}
		public static function setRowText(_row:int,_arr:Array):void{
			var t:Table = Table(getObj(tableId));
			t.setRowText(_row,_arr);
			markFunComplete();
		}
		public static function setColumnText(_column:*,_arr:Array):void{
			var t:Table = Table(getObj(tableId));
			t.setColumnText(_column,_arr);
			markFunComplete();
		}
		public static function setRowHeight(_row:*,_height:*):void{
			var t:Table = Table(getObj(tableId));
			t.updateHeight(int(_row),int(_height));
			markFunComplete();
		}
		public static function setColumnWidth(_col:*,_width:*):void{
			var t:Table = Table(getObj(tableId));
			t.updateWidth(int(_col),int(_width));
			markFunComplete();
		}
		
		public static function setTableAlign(align:*):void{
			var t:Table = Table(getObj(tableId));
			t.setTableAlign(align);
			markFunComplete();
		}
		public static function setRowAlign(_row:*,align:*):void{
			var t:Table = Table(getObj(tableId));
			t.setRowAlign(_row,align);
			markFunComplete();
		}
		
		public static function setColumnAlign(_column:*,align:*):void{
			var t:Table = Table(getObj(tableId));
			t.setColumnAlign(_column,align);
			markFunComplete();
		}
		public static function setGridAlign(_row:*,_column:*,align:*):void{
			var t:Table = Table(getObj(tableId));
			t.setGridAlign(_row,_column,align);
			markFunComplete();
		}
		
		private static var typingStr:String;
		private static var typingField:TextField;
		private static var typingFormat:TextFormat;
		
		//针对typeArea函数而创建的函数,typeArea在板子执行有些卡
		public static function typeTextString(_x:*,_y:*,_width:*,_height:*,_str:*,_leading:*=0):void{
			var id:String = getId();
			manual = true;
			createTextField(id,font,_x,_y,_width,_height);
			setDefaultFormat(id,size,color,null,0,0,0,_leading);
			typingField = TextField(getObj(id));
			manual = false;
			_str = String(_str).replace(/<br>/g,"\n");
			typingStr = _str;
			LayoutToolUtils.typeTimeLine.clear();
			LayoutToolUtils.typeTimeLine.stop();

			
			var timeLine:TimelineMax = LayoutToolUtils.typeTimeLine;
			timeLine.addEventListener(TweenEvent.COMPLETE,typeCompleteHandle);
			for (var i:int = 0; i < typingStr.length; i++) 
			{
				timeLine.append(new TweenLite(typingField,typeSpeed,{onComplete:popText,onCompleteParams:[i]}));
				
			}
			if(LayoutToolUtils.jump){
				timeLine.progress(1);
			}else if(timeLine.paused){
				timeLine.restart(true);
			}
			
		}
		//用来在表格中打字的函数
		private static function typeGridText(_obj:*,_str:*):void{
			//修改为不打字
			typingField = TextField(_obj);
			var format:TextFormat = typingField.getTextFormat();
			format.font = font;
			format.size = size;
			format.color = color;
			format.leading = leading;
			format.letterSpacing = letterSpacing;
			
			typingField.defaultTextFormat = format;
			typingField.setTextFormat(format)
			typingField.htmlText = _str;
			
			markFunComplete();
			return;
			
			TweenLite.killTweensOf(popText);
			typingField = TextField(_obj)
			typingStr = _str;
			typingField.text="";
			typingFormat = null;
			LayoutToolUtils.typeTimeLine.clear();
			LayoutToolUtils.typeTimeLine.stop();
			
			var timeLine:TimelineMax = LayoutToolUtils.typeTimeLine;
			timeLine.addEventListener(TweenEvent.COMPLETE,typeCompleteHandle);
			for (var i:int = 0; i < typingStr.length; i++) 
			{
				timeLine.append(new TweenLite(typingField,typeSpeed,{visible:true,onComplete:popText,onCompleteParams:[i]}));
			}
			if(LayoutToolUtils.jump){
				timeLine.progress(1);
			}else if(timeLine.paused){
				timeLine.restart();
			}
		}
		private static function popText(_typingIdx:int):void{
			if(_typingIdx>typingStr.length){
				markFunComplete();
			}else{
				if(typingField==null){
					trace("typingField 为空");
					return;
				}
				typingField.appendText(typingStr.charAt(_typingIdx));
				if(typingFormat){
					setTextFormatByTF(typingField,typingFormat,0,-1);
				}
			}
		}
		private static function myPopText(_typingIdx:int):void{
			typingField.appendText(typingStr.charAt(_typingIdx));
			if(typingFormat){
				setTextFormatByTF(typingField,typingFormat,continueTypeIndex,typingField.length);
			}
			if(_typingIdx==typingStr.length-1){
				continueTypeIndex += typingStr.length;
			}
		}
		private static function myTypeInGrid(_obj:*,_str:*,_tf:*):void{
			TweenLite.killTweensOf(myPopText);
			LayoutToolUtils.typeTimeLine.clear();
			LayoutToolUtils.typeTimeLine.stop();
			
			typingField = TextField(_obj);
			typingStr =_str;
			typingFormat = _tf;
			
			var timeLine:TimelineMax = LayoutToolUtils.typeTimeLine;
			timeLine.addEventListener(TweenEvent.COMPLETE,typeCompleteHandle);
			for (var i:int=0; i<typingStr.length;i++) 
			{
				timeLine.append(new TweenLite(typingField,typeSpeed,{visible:true,onComplete:myPopText,onCompleteParams:[i]}));
			}
			
			if(LayoutToolUtils.jump){
				timeLine.progress(1);
			}else if(timeLine.paused){
				timeLine.restart();
			}
		}
		private static var continueTypeTF:TextField;
		private static var continueTypeIndex:int=0;
		public static function continueTypeInGrid(_row:*,_col:*,_font:*,_size:*,_color:*,_letterSpacing:*,_leading:*,_underline:*,_str:*):void{
			
			lastFun = LayoutTool.lastFun;
			nextFun = LayoutTool.nextFun;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = _font;
			textFormat.size = _size;
			if(_underline>0){
				textFormat.underline = true;
			}else{
				textFormat.underline = false;
			}
			textFormat.color = _color;
			textFormat.letterSpacing = _letterSpacing;
			textFormat.leading = _leading;
			//			
			_str = String(_str).replace(/<br>/g,"\n");
			
			//执行第一个函数
			if(lastFun==null || lastFun.fun!=LayoutTool.continueTypeInGrid || lastFun.parameters[0]!=_row || lastFun.parameters[1]!=_col){
				continueTypeIndex = 0;
				var t:Table = Table(getObj(tableId));
				continueTypeTF = t.rowColumn([_row,_col]);
				myTypeInGrid(continueTypeTF,_str,textFormat);
				//执行最后一个函数
			}else if(nextFun==null || nextFun.fun!=LayoutTool.continueTypeInGrid || nextFun.parameters[0]!=_row || nextFun.parameters[1]!=_col ){
				myTypeInGrid(continueTypeTF,_str,textFormat);
			}
				//执行中间函数
			else if(nextFun.fun==LayoutTool.continueTypeInGrid && nextFun.parameters[0]==_row && nextFun.parameters[1]==_col){
				myTypeInGrid(continueTypeTF,_str,textFormat);
			}
		}
		private static var typingSplitField:SplitTextField;
		public static function typeText(_id:*,_str:String,_speed:Number,_size:uint,_color:int,_style:String,_letterSpacing:Number,_leading:Number):void{
			var typingField:TextField;
			manual = true;
			if(_id is TextField){
				typingField = _id;
			}else{
				typingField = TextField(getObj(_id));
			}
			
			typingField.text = _str;
			typingField.selectable = true;
			setTextFormat(_id,_size,_color,_style,0,_str.length-1,_letterSpacing,_leading);
			typingSplitField = new SplitTextField(typingField,SplitTextField.TYPE_WORDS);
			var timeLine:TimelineMax = LayoutToolUtils.typeTimeLine;
			
			
			timeLine.addEventListener(TweenEvent.COMPLETE,typeCompleteHandle);
			for (var i:int = 0; i < typingSplitField.textFields.length; i++) 
			{
				typingSplitField.textFields[i].visible = false;
				timeLine.append(new TweenLite(typingSplitField.textFields[i],_speed,{visible:true}));
			}
			manual = false;
			
			if(timeLine.paused){
				timeLine.restart();
			}
		}
		public static function typeTextFiled(_id:*,_speed:Number):void{
			
			var typingField:TextField;
			if(_id is TextField){
				typingField = _id;
			}else{
				typingField = TextField(getObj(_id));
			}
			typingSplitField = new SplitTextField(typingField,SplitTextField.TYPE_CHARACTERS);
			
			LayoutToolUtils.typeTimeLine.clear();
			LayoutToolUtils.typeTimeLine.stop();
			
			var timeLine:TimelineMax = LayoutToolUtils.typeTimeLine;
			timeLine.addEventListener(TweenEvent.COMPLETE,typeCompleteHandle);
			for (var i:int = 0; i < typingSplitField.textFields.length; i++) 
			{
				typingSplitField.textFields[i].visible = false;
				timeLine.append(new TweenLite(typingSplitField.textFields[i],_speed,{visible:true}));
			}
			
			if(LayoutToolUtils.jump){
				timeLine.progress(1);
			}else if(timeLine.paused){
				timeLine.restart();
			}
		}
		private static function adjustTextFieldWH(tf:TextField):void{
			var lineIndex:int = 0;
			var lastLineLength:int = 0;
			var currentLineLength:int=0;
			for(var i:int=0;i<tf.numLines;i++){
				currentLineLength = tf.getLineLength(i);
				if(currentLineLength>lastLineLength){
					lastLineLength = currentLineLength;
					lineIndex = i;
				}
			}
			var lineMetrics:TextLineMetrics = tf.getLineMetrics(lineIndex);
//			tf.width = lineMetrics.width+50;
			tf.height = tf.textHeight+lineMetrics.leading+4;
		}
		private static function typeCompleteHandle(event:TweenEvent):void{
			
			if(typingField){
				adjustTextFieldWH(typingField);
			}
			(event.target as TimelineMax).clear();
			(event.target as TimelineMax).stop();
			
			if(typingSplitField){
				typingSplitField.destroy();
				typingSplitField = null;
			}
			markFunComplete();
		}
		public static function killType():void{
			
			manual = false;
			TweenLite.killTweensOf(pushCharacter);
			if(LayoutToolUtils.typeTimeLine){
				LayoutToolUtils.typeTimeLine.clear();
			}
			typingStr = null;
			TweenLite.killTweensOf(popText);
		}
		public static var textFieldContainer:SplitTextField;
		public static var sentenceTextField:TextField;
		public static var sentenceContainer:Sprite=null;
		public static var wordsArray:Array = null;
		public static var replaced:Boolean = false;
		
		//此方法类似advancedType，不过存储了引用，可以在后续方法中继续对句子进行标记。
		public static function showBasicSentence(_x:*,_y:*,_size:*,_font:*,_color:*,_letterSpacing:*,_leading:*,_str:*):void{
			sentenceContainer = new Sprite;
			sentenceContainer.x = _x;
			sentenceContainer.y = _y;
			
			var id:String = getId();
			manual = true;
			createTextField(id,_font,0,0,1280,100);
			sentenceTextField = TextField(getObj(id));
			var textFormat:TextFormat = new TextFormat;
			textFormat.size = _size;
			textFormat.font = _font;
			textFormat.color = _color;
			textFormat.letterSpacing = _letterSpacing;
			textFormat.leading = _leading;
			textFormat.kerning = true;
			sentenceTextField.multiline = false;
			sentenceTextField.wordWrap = false;
			sentenceTextField.appendText(_str);
			sentenceTextField.setTextFormat(textFormat,0,_str.length)
			sentenceTextField.width = sentenceTextField.textWidth+10;
			sentenceTextField.height = sentenceTextField.textHeight;
			
			sentenceContainer.addChild(sentenceTextField);
			addItem(id,sentenceContainer,-1);
			replaced = false;
			manual = false;
			typeTextFiled(sentenceTextField,typeSpeed);
		}
		
		public static function markWordBlank(_index:*):void{
			replaceTextField();
			
			if(textFieldContainer){
				var t:TextField = new TextField;
				t.defaultTextFormat = textFieldContainer.textFields[_index-1].defaultTextFormat;
				t.x = textFieldContainer.textFields[_index-1].x;
				t.y = textFieldContainer.textFields[_index-1].y;
				t.width = textFieldContainer.textFields[_index-1].width
				t.height = textFieldContainer.textFields[_index-1].height;
				t.type = TextFieldType.INPUT;
				
				sentenceContainer.addChild(t);
			}
			markFunComplete();
		}
		public static function markWordUnderline(_color:*,_arg:*):void{
			
			replaceTextField();
			
			var arr:Array = _arg;
			var gap:int = 2;
			if(textFieldContainer){
				sentenceContainer.graphics.lineStyle(1,_color);
				for(var i:int;i<arr.length;i++){
					sentenceContainer.graphics.moveTo(textFieldContainer.textFields[arr[i]-1].x+gap,textFieldContainer.textFields[arr[i]-1].y+textFieldContainer.textFields[arr[i]-1].height);
					sentenceContainer.graphics.lineTo(textFieldContainer.textFields[arr[i]-1].x+textFieldContainer.textFields[arr[i]-1].width-gap,textFieldContainer.textFields[arr[i]-1].y+textFieldContainer.textFields[arr[i]-1].height);
				}
				sentenceContainer.graphics.endFill();
			}
			markFunComplete();
		}
		//showBasicSentence函数执行完成后对sentenceTextField进行打碎，返回一个包含多个TextField的Sprite，用于后续函数的操作。
		private static function replaceTextField():void{
			if(!replaced){
				//sentenceTextField先是被textFieldContainer替换，当textFieldContainer调用destroy方法后会把source还原的原来的地方
				textFieldContainer = new SplitTextField(sentenceTextField,SplitTextField.TYPE_WORDS);
				replaced = true;
			}
		}
		//当执行到这个函数时，看到的颜色是显示在textFieldContainer上的，当页面执行完成后，textFieldContainer被destroy掉，sentenceTextField被还原
		public static function markWordColor(_color:*,_arg:*):void{
//			replaced = true;
			replaceTextField();
			var textFormat:TextFormat = new TextFormat;
			textFormat.color = _color;
			var arr:Array = _arg;
			var str1:String;
			var str2:String;
			var beginIndex:int;
			var endIndex:int;
			if(textFieldContainer){
				for(var i:int=0;i<arr.length;i++){
					var p:int = arr[i];
					//当前单词位置
					var c:int = 0;
					var isBlank:Boolean = true;
					beginIndex = 0;
					endIndex = 0;
					
					for(var j:int=0;j<sentenceTextField.length;j++){
						if(sentenceTextField.text.charAt(j) != " "){
							if(isBlank){
								c++;
								if(c==p){
									beginIndex = j;
								}
							}
							isBlank = false;
						}else{
							if(c==p){
								endIndex = j;
								break;
							}
							isBlank = true;
						}
					}
					sentenceTextField.setTextFormat(textFormat,beginIndex,endIndex);
				}
			}
			markFunComplete();
		}
		private static var picSprite:Sprite;
		public static function markDownArrow(_index:*):void{
			if(textFieldContainer){
				var _x:Number = sentenceContainer.x + textFieldContainer.textFields[_index-1].x+textFieldContainer.textFields[_index-1].width*0.5;
				var _y:Number = sentenceContainer.y +  textFieldContainer.textFields[_index-1].y+textFieldContainer.textFields[_index-1].height+5;
				
				picSprite = tweenPicture("toDown",_x,_y,"down",0.5);
			}
		}
		//去除单词前后的空格
		private static function trim(string:String):String{
			var str:String = StringUtil.trim(string);
			return str;
		}
		//将连续的空格转换成一个空格
		private static function changeBlanksToOne(string:String):String{
			string = string.replace(/\s+/g," ");
			return string;
		}
		public static function showArrowTips(_index:*,_str:*):void{
			if(picSprite){
				if(textFieldContainer){
					var _x:Number = sentenceContainer.x + textFieldContainer.textFields[_index-1].x;
					var _y:Number = sentenceContainer.y +  textFieldContainer.textFields[_index-1].y+textFieldContainer.textFields[_index-1].height+5;
					var _width:Number =textFieldContainer.textFields[_index-1].width;
					if(_width<50){
						_width = 50;
					}
					var id:String = getId();
					manual = true;
					createTextField(id,font,_x,_y+picSprite.height,_width,100);
					var tf:TextField = TextField(getObj(id));
					tf.autoSize = TextFieldAutoSize.LEFT;
					tf.text = _str;
					
					manual = false;
					typeTextFiled(tf,typeSpeed);
					picSprite = null;
				}
			}
		}
		
		public static function showExerciseAnswer():void{
			var answerArr:Array = getExerciseAnswer();
			for(var g:int=0;g<answerArr.length;g++){
				var arrStr:String = answerArr[g];
				if(arrStr.indexOf("&")!=-1){
					arrStr = arrStr.replace("&","/");
				}
				var t3:TextField = LayoutTool.mainHolder.getChildByName("eee"+g) as TextField;
				if(t3){
					t3.text = arrStr;
					t3.textColor = 0xff0000;
					t3.autoSize = TextFieldAutoSize.CENTER;
				}
			}
		}
		public static function getExerciseAnswer():Array{
			var tmpStr:String = TypeTool.doExerciseAnswer;
			var mArr:Array = [];
			if(tmpStr.indexOf("/")!=-1){
				var tmpArr:Array = tmpStr.split("/");
				for(var n:int=0;n<tmpArr.length;n++){
					mArr.push(tmpArr[n]);
				}
			}else{
				mArr.push(tmpStr);
			}
			return mArr;
		}
		
		public static function outHTML(_x:*,_y:*,_width:*,_height:*,_txt:*):void{
			printText(_x,_y,_width,_height,_txt);
		}
		public static function showQuestion(_x:*,_y:*,_width:*,_height:*,_isType:*,_txt:*,_answer:*,_arr:*):void{
			var _arr:Array;
			var exerciseFlowVO:Vector.<ExerciseFlowVO> = new Vector.<ExerciseFlowVO>;
			for(var i:int=0;i<_arr.length;i++){
				var evo:ExerciseFlowVO = new ExerciseFlowVO("",false,_arr[i]);
				exerciseFlowVO.push(evo);
			}
			var exerciseVO:ExerciseVO = new ExerciseVO(_answer,exerciseFlowVO);
			(Facade.getInstance(CoreConst.CORE).retrieveProxy(ExerciseLogicProxy.NAME) as ExerciseLogicProxy).init(exerciseVO);
			
			Facade.getInstance(CoreConst.CORE).sendNotification(EXECUTE_SHOW_QUESTION_FUNCTION);
			
			_txt = String(_txt).replace(/<br>/g,"\n");
			if(_isType==0){
				printText(_x,_y,_width,_height,_txt);
			}else{
				typeTextString(_x,_y,_width,_height,_txt);
			}
		}
		public static var doExerciseAnswer:String="";
		public static var rightHandler:String = "";
		public static var firstWrongHandler:String = "";
		public static var secondWrongHandler:String = "";
		public static var exerciseAnswerIndex:int = 0;
		
		public static function doExercise(_x:*,_y:*,_width:*,_height:*,_isType:*,_txt:*,_answer:*,_rightHandler:*,_firstWrongHandler:*,_secWrongHandler:*):void{
			
//			ExerciseTool.isInitialized = false;
			
			ExerciseTool.initElements();
			
			LayoutTool.holder.addChild(ExerciseTool.holder);
			
			doExerciseAnswer = _answer;
			rightHandler = _rightHandler;
			firstWrongHandler = _firstWrongHandler;
			secondWrongHandler = _secWrongHandler;
			isExerciseWrong = false;
			
			fillBlanks(_x,_y,_width,_height,_isType,_txt,_answer);
		}
		
		private static var isForPractice:Boolean = false;
		private static var practiceDrawArray:Array = [];
		private static var practiceTFArray:Array = [];
		private static var practiceTF:TextField;
		public static var practiceAnswerArray:Array = [];
		public static var practiceAnswerIndex:int=0;
		private static var practiceStr:String = "";
		private static var priacticeShape:Shape = null;
		private static var practiceShowImmediately:Boolean = true;
		private static var charIndex:int=0;//字符增加计量
		
		public static function fillBlanks(_x:*,_y:*,_width:*,_height:*,isType:*,_txt:*,_answer:*):void{
			if(isType==0){
				practiceShowImmediately=true;
			}else{
				practiceShowImmediately = false;
			}
			isForPractice = false;
			
			practiceDrawArray = [];
			practiceTFArray = [];
			practiceStr = "";
			priacticeShape = null;
			charIndex = 0;
			
			//是数组的话用来填空，不是数组的话用来做习题
			if(_answer is Array){
				isForPractice = true;
				var tmpArr:Array = _answer as Array;
				for(var k:int=0;k<tmpArr.length;k++){
					practiceAnswerArray.push(tmpArr[k]);
				}
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FILL_BLANKS_INITIALIZED);
			}else{
				isForPractice = false;
			}
			var w:Array = String(_txt).match(/<s\d+>/g);
			for(var m:int=0;m<w.length;m++){
				var _s:String = w[m].toString();
				var _a:Array = _s.match(/\d+/g);
				var _n:int = int(_a[0]);
				var _s2:String="";
				for(var p:int=0;p<_n;p++){
					_s2 +="^";
				}
				_txt = String(_txt).replace(_s,_s2);
			}

			_txt = String(_txt).replace(/<s>/g,"^");
			_txt = String(_txt).replace(/<br>/g,"\n");
			
			manual = true;
			var id:String = getId();
			createTextField(id,font,_x,_y,_width,_height);
			
			practiceTF = TextField(getObj(id));
			var textFormat:TextFormat = new TextFormat
			textFormat.size = size;
			textFormat.color = color;
			textFormat.leading = leading;
			practiceTF.defaultTextFormat = textFormat;
			
			priacticeShape = new Shape;
			priacticeShape.graphics.lineStyle(2,0x000000);
			LayoutTool.holder.addChild(priacticeShape);
			var str:String = _txt;
			var isBlank:Boolean = false;
			var beginIndex:int = 0;
			var endIndex:int = 0;
			
			for(var i:int=0;i<str.length;i++){
				if(str.charAt(i) == "^"){
					if(!isBlank){
						beginIndex = i;
					}
					isBlank = true;
				}else{
					if(isBlank){
						endIndex = i;
						practiceTFArray.push(new Point(beginIndex,endIndex));
						for(var j:int=beginIndex;j<endIndex;j++){
							practiceDrawArray.push(j);
						}
					}
					isBlank = false;
				}
				if(isBlank&&i==str.length-1){
					endIndex = i;
					practiceTFArray.push(new Point(beginIndex,endIndex));
					for(j=beginIndex;j<=endIndex;j++){
						practiceDrawArray.push(j);
					}
				}
			}
			practiceStr = String(_txt).replace(/\^/g," ");
			TweenLite.delayedCall(typeSpeed,pushCharacter,[String(practiceStr).charAt(0)]);
		}
	
		public static function pushCharacter(_s:String):void{
			if(practiceShowImmediately){
				practiceTF.appendText(practiceStr);
				if(practiceTFArray.length>0){
					for(var m:int=0;m<practiceTFArray.length;m++){
						var rec4:Rectangle = practiceTF.getCharBoundaries(practiceTFArray[m].x);
						var rec5:Rectangle = practiceTF.getCharBoundaries(practiceTFArray[m].y);
						priacticeShape.graphics.moveTo(practiceTF.x+rec4.x,practiceTF.y+rec4.y+rec4.height);
						if(practiceTFArray[m].x==practiceTFArray[m].y){
							priacticeShape.graphics.lineTo(practiceTF.x+rec5.x+rec5.width,practiceTF.y+rec5.y+rec5.height);
						}else{
							priacticeShape.graphics.lineTo(practiceTF.x+rec5.x,practiceTF.y+rec5.y+rec5.height);
						}
						var tf2:TextField = new TextField;
						if(isForPractice){
							tf2.name = "ttt"+String(practiceAnswerIndex);
							practiceAnswerIndex++;
							tf2.addEventListener(KeyboardEvent.KEY_DOWN,checkPracticeAnswer);
							tf2.type = TextFieldType.INPUT;
						}else{
							tf2.name = "eee"+String(exerciseAnswerIndex);
							exerciseAnswerIndex++;
						}
						
						LayoutTool.holder.addChild(tf2);
						
						var textFormat2:TextFormat = new TextFormat;
						textFormat2.size = size;
						textFormat2.font = font;
						tf2.defaultTextFormat = textFormat2;
						tf2.x = practiceTF.x+rec4.x;
						tf2.y = practiceTF.y+rec4.y-2;
						if(practiceTFArray[m].x==practiceTFArray[m].y){
							tf2.width =  rec5.x+rec5.width - rec4.x;
						}else{
							tf2.width = rec5.x - rec4.x;
						}
						tf2.height = rec4.height+10;
					}
				}
				LayoutTool.holder.addChild(priacticeShape);
				manual = false;
				markFunComplete();
				
				return;
			}
			//
			practiceTF.appendText(_s);
			//
			if(practiceDrawArray.length>0){
				if(practiceDrawArray[0]==charIndex){
					var rec:Rectangle = practiceTF.getCharBoundaries(charIndex);
					priacticeShape.graphics.moveTo(practiceTF.x+rec.x,practiceTF.y+rec.y+rec.height);
					priacticeShape.graphics.lineTo(practiceTF.x+rec.x+rec.width,practiceTF.y+rec.y+rec.height);
					practiceDrawArray.shift();
				}
			}
			if(practiceTFArray.length>0){
				if(practiceTFArray[0].y==charIndex){
					var tf:TextField = new TextField;
					if(isForPractice){
						tf.name = "ttt"+String(practiceAnswerIndex);
						practiceAnswerIndex++;
						tf.addEventListener(KeyboardEvent.KEY_DOWN,checkPracticeAnswer);
						tf.type = TextFieldType.INPUT;
					}else{
						tf.name = "eee"+String(exerciseAnswerIndex);
						exerciseAnswerIndex++;
					}
					
					LayoutTool.holder.addChild(tf);
					var textFormat:TextFormat = practiceTF.getTextFormat();
					tf.defaultTextFormat = textFormat;
					var rec2:Rectangle = practiceTF.getCharBoundaries(practiceTFArray[0].x);
					var rec3:Rectangle = practiceTF.getCharBoundaries(practiceTFArray[0].y);
					tf.x = practiceTF.x+rec2.x;
					tf.y = practiceTF.y+rec2.y-2;
					if(practiceTFArray[0].y==practiceStr.length-1){
						tf.width = rec3.x+rec3.width - rec2.x;
					}else{
						tf.width = rec3.x - rec2.x;
					}
					tf.height = rec3.height+10;
					practiceTFArray.shift();
				}
			}
			charIndex++;
			
			if(charIndex<practiceStr.length){
				TweenLite.delayedCall(typeSpeed,pushCharacter,[practiceStr.charAt(charIndex)])
			}else{
				LayoutTool.holder.addChild(priacticeShape);
				manual = false;
				markFunComplete();
			}
		}
		private static function checkPracticeAnswer(e:KeyboardEvent):void{
			if(e.keyCode == 10||e.keyCode==13){
				if(practiceAnswerArray){
					if(practiceAnswerArray.length>0){
						var tf:TextField = TextField(e.target);
						var order:int = int(tf.name.substr(3));
						var inputString:String = tf.text;
						inputString = StringUtil.trim(inputString);
						inputString = inputString.toLowerCase();
						var answerString:String = practiceAnswerArray[order];
						
						var body:Object = {};
						body.answer = answerString;
						body.tf = e.currentTarget;
						
						Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.FILL_BLANKS_MESSAGE,body);
						
						return;
						
						if(!answerString){
							return;
						}
						answerString = StringUtil.trim(answerString);
						answerString = answerString.toLowerCase();
						if(answerString.indexOf("&")!=-1){
							var isCorrect:Boolean = false;
							var tmpArr:Array = answerString.split("&");
							for(var k:int=0;k<tmpArr.length;k++){
								if(tmpArr[k]==inputString){
									isCorrect = true;
									break;
								}
							}
							if(isCorrect){
								answerString = answerString.replace("&","/");
								tf.text = answerString;
								tf.autoSize = TextFieldAutoSize.CENTER;
								tf.textColor = 0xff0000;
								tf.type = TextFieldType.DYNAMIC;
								e.target.removeEventListener(KeyboardEvent.KEY_DOWN,checkPracticeAnswer);
							}else{
								answerString = answerString.replace("&","/");
								tf.text = answerString;
								tf.textColor = 0x000000;
							}
						}else{
							if(inputString == answerString){
								tf.text = practiceAnswerArray[order];
								tf.autoSize = TextFieldAutoSize.CENTER;
								tf.textColor = 0xff0000;
								tf.type = TextFieldType.DYNAMIC;
								e.target.removeEventListener(KeyboardEvent.KEY_DOWN,checkPracticeAnswer);
							}else{
								tf.text = practiceAnswerArray[order];
								tf.textColor = 0x000000;
							}
						}
					}
				}
			}
		}
		public static function destroy():void{
			if(textFieldContainer){
				textFieldContainer.destroy();
				replaced = false;
			}
			textFieldContainer = null;
			sentenceTextField = null;
			sentenceContainer = null;
		}
		private static var maskShape:Shape;
		private static var maskShapeArr:Array = [];
		public static function tweenPicture(_name:*,_x:*,_y:*,direction:*="right",scale:*=1):Sprite{
			var tweenSpeed:Number = 0.5
			var imageClass:Class = Class(getDefinitionByName(_name));
			var image:DisplayObject = new imageClass();
			image.scaleX=image.scaleY=scale;
			var sp:Sprite = new Sprite;
			sp.x = _x;
			sp.y = _y;
			maskShape = new Shape;
			maskShapeArr.push(maskShape);
			maskShape.graphics.beginFill(0xffffff);
			switch(direction){
				case "down":
					maskShape.graphics.drawRect(-image.width*0.5,0,image.width,1);
					break;
				case "right":
					maskShape.graphics.drawRect(0,-image.height*0.5,1,image.height);
					break;
			}
			maskShape.graphics.endFill();
			sp.addChild(image);
			sp.addChild(maskShape);
			image.mask = maskShape;
			
			addItem(getId(),sp,-1);
			
			switch(direction){
				case "down":
					TweenLite.to(maskShape,tweenSpeed,{height:image.height,onComplete:markFunComplete});
					break;
				case "right":
					TweenLite.to(maskShape,tweenSpeed,{width:image.width,onComplete:markFunComplete});
					break;
			}
			return sp;
		}
		public static function killTweenImage():void{
			//kill image tween
			for(var i:int;i<maskShapeArr.length;i++){
				TweenLite.killTweensOf(maskShapeArr[i]);
			}
			maskShapeArr = [];
			maskShape = null;
		}
		public static function addItem(id:*,obj:DisplayObject,index:int):void{
			addObj(id,obj);
			if(index<0){
				LayoutTool.holder.addChild(obj);
			}else{
				LayoutTool.holder.addChildAt(obj,index);
			}
		}
		private static function addObj(id:String,obj:DisplayObject):void{
			LayoutToolUtils.holderObjs[id] = obj;
		}
		public static function getObj(id:String):DisplayObject{
			return LayoutToolUtils.holderObjs[id];
		}
		private static function markFunComplete():void{
			if(!manual){
				if(textFieldContainer){
					textFieldContainer.destroy();
				}
				LayoutToolUtils.queue.dispatcher.dispatchEvent(new FunctionQueueEvent(FunctionQueueEvent.FUNCTION_COMPLETE));
			}
		}
		//退出绘本时执行
		public static function reset():void{
			
			font = "HuaKanT";
			size = 24;
			color = 0;
			leading = 0;
			letterSpacing = 0;
			typeSpeed = 0.1;
			selectable = 0;
			
			isExerciseWrong = false;
			manual = false;
			lastFun = null;
			nextFun = null;
			advancedTypeId = null;
			advancedTypeLength = 0;
			tableId = null;
			typingStr = null;
			typingField = null;
			typingFormat = null;
			continueTypeTF = null;
			continueTypeIndex=0;
			typingSplitField = null;
			textFieldContainer = null;
			sentenceTextField = null;
			sentenceContainer=null;
			wordsArray = null;
			replaced = false;
			picSprite = null;
			maskShape=null;
			maskShapeArr = [];
		}
	}
}