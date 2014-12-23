package com.studyMate.view.component
{
		import flash.display.DisplayObject;
		import flash.display.GradientType;
		import flash.display.InterpolationMethod;
		import flash.display.MovieClip;
		import flash.display.Shape;
		import flash.display.SpreadMethod;
		import flash.display.Sprite;
		import flash.events.Event;
		import flash.events.MouseEvent;
		import flash.events.TimerEvent;
		import flash.geom.Matrix;
		import flash.text.AntiAliasType;
		import flash.text.Font;
		import flash.text.FontStyle;
		import flash.text.TextField;
		import flash.text.TextFieldAutoSize;
		import flash.text.TextFormat;
		import flash.utils.Timer;
		
		/**
		 * Dispatched when the selection in the date table is changed.
		 *
		 * @eventType com.sickworks.components.DateChooser.SELECTION_CHANGED
		 * @eventType com.sickworks.components.DateChooserComp.SELECTION_CHANGED (if you use the Flash component)
		 */
		[Event(name = "selectionChanged", type = "flash.events.Event")]
		
		/**
		 * The DateChooser class contains everything for creating a fully customizable date picker.
		 * <p>The default dimensions of the DateChooser are 193 x 183 px. To adjust the dimensions please use the provided methods for changing the size of the cells, borders and the header. Calling <code>dateChooserInstance.width</code> might lead to the problem, that some texts are not properly placed. To adjust the settings of the component you can also use the configurator based in the directory of the class or on the author's website.</p>
		 * <p>If multiple selections are allowed, the user needs to hold down the SHIFT key to select more than one date.</p>
		 * @see http://www.sickworks.com/tools/DateChooser/
		 * 
		 * @author Reinhart Redel
		 */
		
		public class DateChooser extends Sprite
		{
			/**
			 * The DateChooser.SELECTION_CHANGED constant defines the value of the 
			 * <code>type</code> property of the event object 
			 * for a <code>selectionChanged</code> event.
			 * 
			 * <p><strong>Note for component users: </strong>If you use the component instead of the ActionScript version, the constant to use is DateChooserComp.SELECTION_CHANGED instead of DateChooser.SELECTION_CHANGED! In each case you can always use the string declaration: "selectionChanged". </p>
			 * 
			 * <p> The properties of the event object have the following values:</p>
			 * <table class="innertable">
			 * <tr><th>Property</th> <th>Value</th></tr>
			 * <tr><td><code>type</code></td> <td><code>"selectionChanged"</code></td></tr>
			 * <tr><td><code>bubbles</code></td> <td><code>false</code></td></tr>
			 * <tr><td><code>cancelable</code></td> <td><code>false</code></td></tr>
			 * </table>
			 *
			 * @eventType selectionChanged
			 */
			public static const SELECTION_CHANGED:String = "selectionChanged";
			public static const VERSION:String = "Sickworks' DateChooser v1.1.1";
			
			/**
			 * The DateCooser.DD_MM_YYYY constant defines the string representation of the dates returned by "dc.selectedDates".
			 */
			public static const DD_MM_YYYY:String = "DD_MM_YYYY";
			/**
			 * The DateCooser.DD_YYYY_MM constant defines the string representation of the dates returned by "dc.selectedDates".
			 */
			public static const DD_YYYY_MM:String = "DD_YYYY_MM";
			/**
			 * The DateCooser.MM_YYYY_DD constant defines the string representation of the dates returned by "dc.selectedDates".
			 */
			public static const MM_YYYY_DD:String = "MM_YYYY_DD";
			/**
			 * The DateCooser.MM_DD_YYYY constant defines the string representation of the dates returned by "dc.selectedDates".
			 */
			public static const MM_DD_YYYY:String = "MM_DD_YYYY";
			/**
			 * The DateCooser.YYYY_DD_MM constant defines the string representation of the dates returned by "dc.selectedDates".
			 */
			public static const YYYY_DD_MM:String = "YYYY_DD_MM";
			/**
			 * The DateCooser.YYYY_MM_DD constant defines the string representation of the dates returned by "dc.selectedDates".
			 */
			public static const YYYY_MM_DD:String = "YYYY_MM_DD";	
			/**
			 * The DateCooser.DATE_OBJECT constant defines the default representation of the dates returned by "dc.selectedDates" which are dates as defined by Actionscript.
			 */
			public static const DATE_OBJECT:String = "DATE_OBJECT";
			
			private const _numDays:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
			
			/*
			* Initial format settings
			*/
			private const FORMATS:Array = [DD_MM_YYYY, DD_YYYY_MM, MM_YYYY_DD, MM_DD_YYYY, YYYY_DD_MM, YYYY_MM_DD, DATE_OBJECT];
			private var _dateFormat:String = DATE_OBJECT;
			private var _fullYear:Boolean = true;
			private var _dayLeadingZero:Boolean = true;
			private var _monthLeadingZero:Boolean = true;
			private var _dateSeperator:String = ".";
			
			/*
			* Private vars
			*/
			private var _months:Array;
			private var _days:Array;
			private var _dayFields:Array;
			private var _dayBoxes:Array;
			private var _cellWidth:Number;
			private var _cellHeight:Number;
			private var _cellColor:Number;
			private var _cellColorAlpha:Number;
			private var _highlightColor:Number;
			private var _highlightColorAlpha:Number;
			private var _selectedColor:Number;
			private var _selectedColorAlpha:Number;
			private var _backgroundColors:Array;
			private var _backgroundColorsAlpha:Array;
			private var _borderThickness:uint;
			private var _borderColor:Number;
			private var _borderAlpha:Number;
			private var _todayColor:Number;
			private var _todayColorAlpha:Number;
			private var _today:Date;
			private var _currentYear:Number;
			private var _currentMonth:Number;
			private var _background:Sprite;
			private var _header:TextField;
			private var _headerHeight:Number;
			private var _forward:Sprite;
			private var _backward:Sprite;
			private var _steppersize:Number;
			private var _stepperColor:Number;
			private var _currentSelection:MovieClip;
			private var _cellTextFormat:TextFormat;
			private var _headerTextFormat:TextFormat;
			private var _selectedDates:Array;
			private var _allowMultiple:Boolean;
			private var _embeddedFonts:Array;
			private var _nextButton:DisplayObject;
			private var _previousButton:DisplayObject;
			private var _addedtostage:Boolean;
			private var _yearUp:Sprite;
			private var _yearDown:Sprite;
			private var _yearUpButton:DisplayObject;
			private var _yearDownButton:DisplayObject;
			private var _lowestYear:int;
			private var _highestYear:int;
			private var _highestMonth:int;
			private var _gradientOffset:Number;
			private var _autoRepeat:Timer;
			private var _changeValue:int;
			private var _buttonRepeatInterval:uint = 150;
			private var _buttonRepeatDelay:uint = 750;
			private var _incrementYear:Boolean = true;
			private var _allowPastDates:Boolean = true;
			private var _showPastDates:Boolean = true;
			private var _alphaPastDates:Number = .5;
			
			private var _width:Number;
			private var _height:Number;
			
			/**
			 * Creates a new DateChooser instance.
			 * @param	allowMultipleSelection If set to true, multiple dates can be selected by pressing the SHIFT key (default is false).
			 * @see #allowMultiple
			 * @param	month Initial month to be shown (default is the current month according to the date settings of the user).
			 * @see #setMonth()
			 * @param	year Initial year to be shown (default is the current year according to the date settings of the user).
			 * @example The following code shows the basic implementation of the DateChooser:
			 * <listing version="3.0"> import com.sickworks.components.DateChooser;
			 * var dc:DateChooser = new DateChooser(); //Only single selection allowed. Current Date will be shown.
			 * addChild(dc);
			 * </listing> 
			 */
			public function DateChooser(allowMultipleSelection:Boolean = false, month:int = -1, year:int = -1):void 
			{
				_addedtostage = false;
				_dayBoxes = [];
				_dayFields = [];
				_months = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"];
				_days = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"];
				_selectedDates = [];
				_allowMultiple = allowMultipleSelection;
				_today = new Date();
				_today.setHours(0, 0, 0, 0);
				_cellHeight = 21;
				_cellWidth = 26;
				_headerHeight = 30;
				_gradientOffset = 35;
				_lowestYear = 1900;
				_highestYear = 2100;
				_highestMonth = 11;
				
				_highlightColor = 0x99CCFF;
				_highlightColorAlpha = .5;
				_selectedColor = 0x999999;
				_selectedColorAlpha = 1;
				_backgroundColors = [0xE2E6EB, 0xFFFFFF];
				_backgroundColorsAlpha = [1, 1];
				_borderThickness = 1;
				_borderColor = 0xCCCCCC;
				_borderAlpha = 1;
				_todayColor = 0xE2E6EB;
				_todayColorAlpha = 1;
				_cellColor = 0xFFFFFF;
				_cellColorAlpha = 1;
				
				_currentMonth = month != -1 ? (month - 1) : _today.getMonth();
				_currentYear = year != -1 ? year : _today.getFullYear();
				
				_steppersize = 20;
				_stepperColor = 0x000000;
				
				_cellTextFormat = new TextFormat();
				_cellTextFormat.size = 9;
				_cellTextFormat.align = "center";
				_cellTextFormat.font = "Verdana";
				
				_headerTextFormat = new TextFormat();
				_headerTextFormat.align = "center";
				_headerTextFormat.size = 9;
				_headerTextFormat.bold = true;
				_headerTextFormat.font = "Verdana";
				
				_background = new Sprite();
				_header = new TextField();
				_forward = new Sprite();
				_backward = new Sprite();
				_yearDown = new Sprite();
				_yearUp = new Sprite();
				
				_width = 193;
				_height = 183;
				
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			}
			
			private function init(e:Event):void
			{
				removeEventListener(Event.ADDED_TO_STAGE, init);
				addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
				_addedtostage = true;
				
				_width *= this.scaleX;
				_height *= this.scaleY;
				this.scaleX = this.scaleY = 1;
				
				_embeddedFonts = Font.enumerateFonts();
				
				var embedheaderfont:Boolean = false;
				var fstyle:String = FontStyle.REGULAR;
				
				if (_headerTextFormat.font != null)
				{
					if (_headerTextFormat.bold && _headerTextFormat.italic)
					{
						fstyle = FontStyle.BOLD_ITALIC;
					}
					else if (_headerTextFormat.bold)
					{
						fstyle = FontStyle.BOLD;
					}
					else if (_headerTextFormat.italic)
					{
						fstyle = FontStyle.ITALIC;
					}
					for each(var fnt:Font in _embeddedFonts)
					{
						if (fnt.fontName == _headerTextFormat.font && fnt.fontStyle == fstyle)
						{
							embedheaderfont = true;
							break;
						}
					}
				}
				_header.embedFonts = embedheaderfont;
				_header.defaultTextFormat = _headerTextFormat;
				_header.autoSize = TextFieldAutoSize.CENTER;
				_header.selectable = false;
				addChild(_header);
				
				drawGraphics();
				addChildAt(_background, 0);
				addChild(_forward);
				addChild(_backward);
				addChild(_yearUp);
				addChild(_yearDown);
				
				var embedcellfont:Boolean = false;
				if (_cellTextFormat.font != null)
				{
					if (_cellTextFormat.bold && _cellTextFormat.italic)
					{
						fstyle = FontStyle.BOLD_ITALIC;
					}
					else if (_cellTextFormat.bold)
					{
						fstyle = FontStyle.BOLD;
					}
					else if (_cellTextFormat.italic)
					{
						fstyle = FontStyle.ITALIC;
					}
					for each(var ft:Font in _embeddedFonts)
					{
						if (ft.fontName == _cellTextFormat.font)
						{
							embedcellfont = true;
							break;
						}
					}
				}
				for (var i:uint = 0; i < 42; i++)
				{
					generateCells(i, embedcellfont, embedheaderfont);
				}
				
				_autoRepeat = new Timer(_buttonRepeatInterval);
				
				_forward.addEventListener(MouseEvent.MOUSE_DOWN, monthstep, false, 0, true);
				_backward.addEventListener(MouseEvent.MOUSE_DOWN, monthstep, false, 0, true);
				
				_autoRepeat.addEventListener(TimerEvent.TIMER, autoIncYear, false, 0, true);
				_yearDown.addEventListener(MouseEvent.MOUSE_DOWN, yearstep, false, 0, true);
				_yearUp.addEventListener(MouseEvent.MOUSE_DOWN, yearstep, false, 0, true);
				stage.addEventListener(MouseEvent.MOUSE_UP, stopChange, false, 0, true);
				
				_forward.addEventListener(MouseEvent.ROLL_OVER, drawRollOver, false, 0, true);
				_backward.addEventListener(MouseEvent.ROLL_OVER, drawRollOver, false, 0, true);
				_yearDown.addEventListener(MouseEvent.ROLL_OVER, drawRollOver, false, 0, true);
				_yearUp.addEventListener(MouseEvent.ROLL_OVER, drawRollOver, false, 0, true);
				
				_forward.addEventListener(MouseEvent.ROLL_OUT, drawGraphics, false, 0, true);
				_backward.addEventListener(MouseEvent.ROLL_OUT, drawGraphics, false, 0, true);
				_yearDown.addEventListener(MouseEvent.ROLL_OUT, drawGraphics, false, 0, true);
				_yearUp.addEventListener(MouseEvent.ROLL_OUT, drawGraphics, false, 0, true);
				
				fillGrid(_currentYear, _currentMonth);
				setSize(_width, _height);
			}
			
			private function autoIncYear(e:TimerEvent):void 
			{
				if (_incrementYear && !_yearDown.visible || !_backward.visible)
				{
					_autoRepeat.stop();
					return;
				}
				_autoRepeat.delay = _buttonRepeatInterval;
				if(_incrementYear)
				{
					_currentYear += _changeValue;
					if (_currentYear >= _highestYear)
					{
						_currentYear = _highestYear;
						if (_currentMonth > _highestMonth)
						{
							_currentMonth = _highestMonth;
						}
					}
					else if (_currentYear <= _lowestYear)
					{
						_currentYear = _lowestYear;
					}
				}
				else
				{
					_currentMonth += _changeValue;
					if (_currentYear == _highestYear && _currentMonth > _highestMonth)
					{
						_currentMonth = _highestMonth;
						return;
					}
					if (_currentMonth == 12)
					{
						_currentMonth = 0;
						_currentYear++;
						if (_currentYear >= _highestYear)
						{
							_currentYear = _highestYear;
							return;
						}
					}
					else if (_currentYear == _highestYear && _currentMonth >= _highestMonth)
					{
						_currentMonth = _highestMonth;
					}
					if (_currentMonth == -1)
					{
						_currentMonth = 11;
						_currentYear--;
						if (_currentYear <= _lowestYear)
						{
							_currentYear = _lowestYear;
						}
					}
				}
				fillGrid(_currentYear, _currentMonth);
			}
			
			private function stopChange(e:MouseEvent):void 
			{
				_autoRepeat.stop();
			}
			
			private function drawRollOut(e:MouseEvent):void 
			{
				
			}
			
			private function drawRollOver(e:MouseEvent):void 
			{
				var matrix:Matrix = new Matrix();
				var rocolor:Number = 0x999999;
				switch(e.currentTarget)
				{
					case _forward:
						_forward.graphics.clear();
						if (_nextButton == null)
						{
							_forward.graphics.lineStyle(1, rocolor,1,true);
							matrix.createGradientBox(_steppersize, _steppersize, Math.PI * (360 + 90) / 180);
							_forward.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xCECECE], [1, 1], [0, 255], matrix, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB, 0);
							_forward.graphics.drawRoundRect(0, 0, _steppersize, _steppersize, 7);
							_forward.graphics.lineStyle();
							_forward.graphics.beginFill(rocolor);
							_forward.graphics.moveTo(Math.ceil(_steppersize * .4), Math.ceil(_steppersize * .25));
							_forward.graphics.lineTo(Math.ceil(_steppersize * .7), Math.ceil(_steppersize *.5));
							_forward.graphics.lineTo(Math.ceil(_steppersize * .4), Math.ceil(_steppersize * .75));
							_forward.graphics.lineTo(Math.ceil(_steppersize * .4), Math.ceil(_steppersize * .25));
							_forward.graphics.endFill();
						}
						break;
					case _backward:
						_backward.graphics.clear();
						if (_previousButton == null)
						{
							_backward.graphics.lineStyle(1, rocolor,1,true);
							matrix.createGradientBox(_steppersize, _steppersize, Math.PI * (360 + 90) / 180);
							_backward.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xCECECE], [1, 1], [0, 255], matrix, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB, 0);
							_backward.graphics.drawRoundRect(0, 0, _steppersize, _steppersize, 7);
							_backward.graphics.lineStyle();
							_backward.graphics.beginFill(rocolor);
							_backward.graphics.moveTo(Math.ceil(_steppersize * .6), Math.ceil(_steppersize * .25));
							_backward.graphics.lineTo(Math.ceil(_steppersize * .3), Math.ceil(_steppersize *.5));
							_backward.graphics.lineTo(Math.ceil(_steppersize * .6), Math.ceil(_steppersize * .75));
							_backward.graphics.lineTo(Math.ceil(_steppersize * .6), Math.ceil(_steppersize * .25));
							_backward.graphics.endFill();
						}
						break;
					case _yearDown:
						_yearDown.graphics.clear();
						if (_yearDownButton == null)
						{
							_yearDown.graphics.beginFill(0x000000, 0);
							_yearDown.graphics.drawRect(0, 0, 10, 5);
							_yearDown.graphics.endFill();
							_yearDown.graphics.beginFill(rocolor);
							_yearDown.graphics.lineTo(10, 0);
							_yearDown.graphics.lineTo(5, 5);
							_yearDown.graphics.lineTo(0, 0);
							_yearDown.graphics.endFill();
						}
						break;
					case _yearUp:
						_yearUp.graphics.clear();
						if (_yearUpButton == null)
						{
							_yearUp.graphics.beginFill(0x000000, 0);
							_yearUp.graphics.drawRect(0, 0, 10, 5);
							_yearUp.graphics.endFill();
							_yearUp.graphics.beginFill(rocolor);
							_yearUp.graphics.moveTo(0, 5);
							_yearUp.graphics.lineTo(10, 5);
							_yearUp.graphics.lineTo(5, 0);
							_yearUp.graphics.lineTo(0, 5);
							_yearUp.graphics.endFill();
						}
						break;
				}
			}
			
			private function yearstep(e:MouseEvent):void 
			{
				switch(e.currentTarget)
				{
					case _yearUp:
						_currentYear++;
						if (_currentYear >= _highestYear)
						{
							_currentYear = _highestYear;
							if (_currentMonth > _highestMonth)
							{
								_currentMonth = _highestMonth;
							}
						}
						_changeValue = 1;
						break;
					case _yearDown:
						_currentYear--;
						if (_currentYear <= _lowestYear)
						{
							_currentYear = _lowestYear;
						}
						_changeValue = -1;
						break;
				}
				
				_incrementYear = true;
				_autoRepeat.reset();
				_autoRepeat.delay = _buttonRepeatDelay;
				_autoRepeat.start();
				fillGrid(_currentYear, _currentMonth);
				
			}
			
			private function monthstep(e:MouseEvent):void 
			{
				switch(e.currentTarget)
				{
					case _forward:
						_currentMonth++;
						if (_currentMonth == 12)
						{
							_currentMonth = 0;
							_currentYear++;
							if (_currentYear >= _highestYear)
							{
								_currentYear = _highestYear;
							}
						}
						else if (_currentYear == _highestYear && _currentMonth >= _highestMonth)
						{
							_currentMonth = _highestMonth;
						}
						_changeValue = 1;
						break;
					case _backward:
						_currentMonth--;
						if (_currentMonth == -1)
						{
							_currentMonth = 11;
							_currentYear--;
							if (_currentYear <= _lowestYear)
							{
								_currentYear = _lowestYear;
							}
						}
						_changeValue = -1;
						break;
				}
				
				_incrementYear = false;
				_autoRepeat.reset();
				_autoRepeat.delay = _buttonRepeatDelay;
				_autoRepeat.start();
				fillGrid(_currentYear, _currentMonth);
			}
			
			private function boxhandler(e:MouseEvent):void 
			{
				var target:MovieClip = MovieClip(e.currentTarget);
				var isPast:Boolean = target.DATE.getTime() < _today.getTime();
				switch(e.type)
				{
					case MouseEvent.ROLL_OVER:
						if (isPast && !_allowPastDates)
						{
							break;
						}
						if (!target.SELECTED)
						{
							target.graphics.clear();
							target.graphics.beginFill(_highlightColor, _highlightColorAlpha);
							target.graphics.drawRect(1, 1, _cellWidth - 2, _cellHeight - 2);
							target.graphics.endFill();
						}
						
						break;
					case MouseEvent.ROLL_OUT:
						target.graphics.clear();
						target.graphics.beginFill(target.TODAY ? _todayColor : _cellColor, target.TODAY ? _todayColorAlpha : _cellColorAlpha);
						if (target.SELECTED)
						{
							target.graphics.beginFill(_selectedColor, _selectedColorAlpha);
						}
						target.graphics.drawRect(1, 1, _cellWidth - 2, _cellHeight - 2);
						target.graphics.endFill();
						break;
					case MouseEvent.CLICK:
						if (isPast && !_allowPastDates)
						{
							break;
						}
						var alreadyAdded:Boolean = true;
						for each(var date:Date in _selectedDates)
					{
						if (target.DATE.toString() == date.toString())
						{
							alreadyAdded = true;
							break;
						}
					}
						if (_allowMultiple)
						{
							if (!e.shiftKey)
							{
								for (var i:uint = 0; i < 42; i++)
								{
									var sp:MovieClip = _dayBoxes[i];
									sp.graphics.clear();
									sp.graphics.beginFill(sp.TODAY ? _todayColor : _cellColor, sp.TODAY ? _todayColorAlpha : _cellColorAlpha);
									sp.graphics.drawRect(1, 1, _cellWidth - 2, _cellHeight - 2);
									sp.graphics.endFill();
									sp.SELECTED = false;
								}
								_selectedDates = [];
							}
							else
							{
								target.graphics.clear();
								target.graphics.beginFill(!target.SELECTED ? _selectedColor : _cellColor, !target.SELECTED ? _selectedColorAlpha : _cellColorAlpha);
								if (target.TODAY && target.SELECTED)
								{
									target.graphics.beginFill(_todayColor, _todayColorAlpha);
								}
								target.graphics.drawRect(1, 1, _cellWidth - 2, _cellHeight - 2);
								target.graphics.endFill();
								if (!target.SELECTED)
								{
									_selectedDates.push(target.DATE);
								}
								else
								{
									for (var j:uint = 0; j < _selectedDates.length; j++)
									{
										if (target.DATE.toString() == _selectedDates[j].toString())
										{
											_selectedDates.splice(j, 1);
											break;
										}
									}
								}
								target.SELECTED = !target.SELECTED;
								_currentSelection = target;
								dispatchEvent(new Event(SELECTION_CHANGED));
								return;
							}
						}
						else
						{
							if (_currentSelection != null)
							{
								_currentSelection.graphics.clear();
								_currentSelection.graphics.beginFill(_currentSelection.TODAY ? _todayColor : _cellColor, _currentSelection.TODAY ? _todayColorAlpha : _cellColorAlpha);
								_currentSelection.graphics.drawRect(1, 1, _cellWidth - 2, _cellHeight - 2);
								_currentSelection.graphics.endFill();
								_currentSelection.SELECTED = false;
							}
							_selectedDates = [];
						}
						target.graphics.clear();
						target.graphics.beginFill(_selectedColor, _selectedColorAlpha);
						target.graphics.drawRect(1, 1, _cellWidth - 2, _cellHeight - 2);
						target.graphics.endFill();
						if (!target.SELECTED)
						{
							_selectedDates.push(target.DATE);
						}
						target.SELECTED = true;
						_currentSelection = target;
						dispatchEvent(new Event(SELECTION_CHANGED));
						break;
				}
			}
			
			private function fillGrid(year:Number, month:Number):void
			{
				var dt:Date = new Date(year, month, 1);
				var startindex:uint = uint(dt.getDay());
				var endindex:uint = startindex + getDays(year, month);
				
				_yearUp.visible = _currentYear < _highestYear;
				_yearDown.visible = _currentYear > _lowestYear && !(!_showPastDates && _currentYear == _today.getFullYear());
				
				_forward.visible = !(_currentYear == _highestYear && _currentMonth == _highestMonth);
				_backward.visible = !(_currentYear == _lowestYear && _currentMonth == 0) && !(!_showPastDates && _currentMonth == _today.getMonth() && _currentYear == _today.getFullYear());
				
				for (var i:uint = 0; i < 42; i++)
				{
					var sp:MovieClip = _dayBoxes[i];
					var tf:TextField = TextField(sp.getChildAt(0));
					tf.antiAliasType = AntiAliasType.ADVANCED;
					sp.SELECTED = false;
					sp.alpha = _cellColorAlpha;
					if (i < startindex || i >= endindex)
					{
						tf.text = "";
						sp.visible = false;
						sp.scaleY = 0;
						sp.DATE = "";
					}
					else
					{
						sp.visible = true;
						sp.scaleY = 1;
						tf.text = String(i - startindex + 1);
						sp.TODAY = false;
						sp.DATE = new Date(_currentYear, _currentMonth, (i - startindex + 1));
						if (_currentYear == _today.fullYear && _currentMonth == _today.month && _today.date == (i - startindex + 1))
						{
							sp.TODAY = true;
						}
						if (sp.DATE.getTime() < _today.getTime())
						{
							sp.alpha = _alphaPastDates;
							sp.visible = _showPastDates;
						}
					}
					sp.graphics.clear();
					sp.graphics.beginFill(sp.TODAY ? _todayColor : _cellColor, sp.TODAY ? _todayColorAlpha : _cellColorAlpha);
					for each(var date:Date in _selectedDates)
					{
						if (sp.DATE.toString() == date.toString())
						{
							sp.graphics.beginFill(_selectedColor, _selectedColorAlpha);
							sp.SELECTED = true;
							_currentSelection = sp;
						}
					}
					sp.graphics.drawRect(1, 1, _cellWidth - 2, _cellHeight - 2);
					sp.graphics.endFill();
					tf.y = int(_cellHeight * .5 - tf.height * .5);
				}
				_header.text = _months[_currentMonth] + " " + _currentYear.toString();
				_header.x = int(this.width * .5 - _header.width * .5);
				_header.y = int(_headerHeight * .5 - _header.height * .5);
			}
			
			private function getDays(year:Number, month:Number):uint
			{
				var numdays:uint = _numDays[month];
				if (month == 1 && (year % 4) == 0)
				{
					numdays += 1;
				}
				return numdays;
			}
			
			private function invalidate():void
			{
				if (!_addedtostage)
				{
					return;
				}
				
				_embeddedFonts = Font.enumerateFonts();
				
				var embedheaderfont:Boolean = false;
				var fstyle:String = FontStyle.REGULAR;
				
				if (_headerTextFormat.font != null)
				{
					if (_headerTextFormat.bold && _headerTextFormat.italic)
					{
						fstyle = FontStyle.BOLD_ITALIC;
					}
					else if (_headerTextFormat.bold)
					{
						fstyle = FontStyle.BOLD;
					}
					else if (_headerTextFormat.italic)
					{
						fstyle = FontStyle.ITALIC;
					}
					for each(var fnt:Font in _embeddedFonts)
					{
						if (fnt.fontName == _headerTextFormat.font && fnt.fontStyle == fstyle)
						{
							embedheaderfont = true;
							break;
						}
					}
				}
				_header.embedFonts = embedheaderfont;
				_header.defaultTextFormat = _headerTextFormat;
				_header.autoSize = TextFieldAutoSize.CENTER;
				_header.antiAliasType = AntiAliasType.ADVANCED;
				
				drawGraphics();
				
				var embedcellfont:Boolean = false;
				if (_cellTextFormat.font != null)
				{
					if (_cellTextFormat.bold && _cellTextFormat.italic)
					{
						fstyle = FontStyle.BOLD_ITALIC;
					}
					else if (_cellTextFormat.bold)
					{
						fstyle = FontStyle.BOLD;
					}
					else if (_cellTextFormat.italic)
					{
						fstyle = FontStyle.ITALIC;
					}
					for each(var ft:Font in _embeddedFonts)
					{
						if (ft.fontName == _cellTextFormat.font)
						{
							embedcellfont = true;
							break;
						}
					}
				}
				for (var i:uint = 0; i < 42; i++)
				{
					generateCells(i, embedcellfont, embedheaderfont, true);
				}
				
				fillGrid(_currentYear, _currentMonth);
				//trace("DateChooser Header Font Embedded: " + embedheaderfont);
				//trace("DateChooser Cell Font Embedded: " + embedcellfont);
			}
			
			private function generateCells(i:uint, embedcellfont:Boolean, embedheaderfont:Boolean, alreadyAdded:Boolean = false):void
			{
				var sp:MovieClip = alreadyAdded ? _dayBoxes[i] : new MovieClip();
				var tf:TextField = alreadyAdded ? TextField(sp.getChildAt(0)) : new TextField();
				tf.embedFonts = embedcellfont;
				tf.defaultTextFormat = _cellTextFormat;
				sp.x = int((i % 7) * _cellWidth + 5);
				sp.y = Math.floor(i / 7) * _cellHeight + _headerHeight + _cellHeight;
				sp.graphics.beginFill(_cellColor, _cellColorAlpha);
				sp.graphics.drawRect(1, 1, _cellWidth - 2, _cellHeight - 2);
				sp.graphics.endFill();
				
				tf.selectable = false;
				tf.autoSize = TextFieldAutoSize.CENTER;
				tf.antiAliasType = AntiAliasType.ADVANCED;
				tf.x = int(_cellWidth * .5 - tf.width * .5);
				
				if (!alreadyAdded)
				{
					_dayBoxes.push(sp);
					sp.addChild(tf);
					addChild(sp);
					sp.addEventListener(MouseEvent.ROLL_OVER, boxhandler, false, 0, true);
					sp.addEventListener(MouseEvent.ROLL_OUT, boxhandler, false, 0, true);
					sp.addEventListener(MouseEvent.CLICK, boxhandler, false, 0, true);
				}
				
				if (i < 7)
				{
					var day:TextField = alreadyAdded ? _dayFields[i] : new TextField();
					day.antiAliasType = AntiAliasType.ADVANCED;
					day.embedFonts = embedheaderfont;
					day.defaultTextFormat = _headerTextFormat;
					day.selectable = false;
					day.text = _days[i];
					day.autoSize = TextFieldAutoSize.CENTER;
					day.x = int(i * _cellWidth + _cellWidth * .5 - day.width * .5 + 5);
					day.y = Math.ceil(_headerHeight + _cellHeight * .5 - day.textHeight * .5);
					if (!alreadyAdded)
					{
						addChild(day);
						_dayFields.push(day);
					}
				}
			}
			
			private function drawGraphics(e:Event = null):void
			{
				if (_autoRepeat && _autoRepeat.running) _autoRepeat.stop();
				var matrix:Matrix = new Matrix();
				_background.graphics.clear();
				matrix.createGradientBox(_cellWidth * 7 + 10, _gradientOffset, Math.PI * (360 + 90) / 180);
				var alphas:Array = _backgroundColorsAlpha;
				while(_backgroundColorsAlpha.length < _backgroundColors.length) alphas.push(1);
				while(_backgroundColorsAlpha.length > _backgroundColors.length) alphas.pop();
				var gradients:Array = [];
				for (var i:uint = 0; i < _backgroundColors.length; i++)
				{
					gradients.push(i * 255 / (_backgroundColors.length - 1));
				}
				_background.graphics.beginGradientFill(GradientType.LINEAR, _backgroundColors, _backgroundColorsAlpha, gradients, matrix, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB, 0);
				if (_borderThickness == 0)
				{
					_background.graphics.lineStyle();
				}
				else
				{
					_background.graphics.lineStyle(_borderThickness, _borderColor, _borderAlpha, true);
				}
				_background.graphics.drawRoundRect(0, 0, _cellWidth * 7 + 10, _headerHeight + _cellHeight * 7 + 5, 10);
				_background.graphics.moveTo(0, _headerHeight);
				_background.graphics.lineTo(_cellWidth * 7 + 10, _headerHeight);
				_background.graphics.endFill();
				
				_forward.graphics.clear();
				if (_nextButton == null)
				{
					_forward.graphics.lineStyle(1, 0x666666,1,true);
					matrix.createGradientBox(_steppersize, _steppersize, Math.PI * (360 + 90) / 180);
					_forward.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xCECECE], [1, 1], [0, 255], matrix, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB, 0);
					_forward.graphics.drawRoundRect(0, 0, _steppersize, _steppersize, 7);
					_forward.graphics.lineStyle();
					_forward.graphics.beginFill(_stepperColor);
					_forward.graphics.moveTo(Math.ceil(_steppersize * .4), Math.ceil(_steppersize * .25));
					_forward.graphics.lineTo(Math.ceil(_steppersize * .7), Math.ceil(_steppersize *.5));
					_forward.graphics.lineTo(Math.ceil(_steppersize * .4), Math.ceil(_steppersize * .75));
					_forward.graphics.lineTo(Math.ceil(_steppersize * .4), Math.ceil(_steppersize * .25));
					_forward.graphics.endFill();
				}
				_forward.x = Math.floor(_cellWidth * 7 - _forward.width + 5);
				_forward.y = Math.floor(_headerHeight * .5 - _forward.height * .5);
				
				_backward.graphics.clear();
				if (_previousButton == null)
				{
					_backward.graphics.lineStyle(1, 0x666666,1,true);
					matrix.createGradientBox(_steppersize, _steppersize, Math.PI * (360 + 90) / 180);
					_backward.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xCECECE], [1, 1], [0, 255], matrix, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB, 0);
					_backward.graphics.drawRoundRect(0, 0, _steppersize, _steppersize, 7);
					_backward.graphics.lineStyle();
					_backward.graphics.beginFill(_stepperColor);
					_backward.graphics.moveTo(Math.ceil(_steppersize * .6), Math.ceil(_steppersize * .25));
					_backward.graphics.lineTo(Math.ceil(_steppersize * .3), Math.ceil(_steppersize *.5));
					_backward.graphics.lineTo(Math.ceil(_steppersize * .6), Math.ceil(_steppersize * .75));
					_backward.graphics.lineTo(Math.ceil(_steppersize * .6), Math.ceil(_steppersize * .25));
					_backward.graphics.endFill();
				}
				_backward.y = Math.floor(_headerHeight * .5 - _backward.height * .5);
				_backward.x = 5;
				
				_yearUp.graphics.clear();
				if (_yearUpButton == null)
				{
					_yearUp.graphics.beginFill(0x000000, 0);
					_yearUp.graphics.drawRect(0, 0, 10, 5);
					_yearUp.graphics.endFill();
					_yearUp.graphics.beginFill(0x000000);
					_yearUp.graphics.moveTo(0, 5);
					_yearUp.graphics.lineTo(10, 5);
					_yearUp.graphics.lineTo(5, 0);
					_yearUp.graphics.lineTo(0, 5);
					_yearUp.graphics.endFill();
				}
				_yearUp.x = Math.floor(_forward.x - _yearUp.width - 10);
				_yearUp.y = Math.floor(_headerHeight * .5 - _yearUp.height - 1);
				
				_yearDown.graphics.clear();
				if (_yearDownButton == null)
				{
					_yearDown.graphics.beginFill(0x000000, 0);
					_yearDown.graphics.drawRect(0, 0, 10, 5);
					_yearDown.graphics.endFill();
					_yearDown.graphics.beginFill(0x000000);
					_yearDown.graphics.lineTo(10, 0);
					_yearDown.graphics.lineTo(5, 5);
					_yearDown.graphics.lineTo(0, 0);
					_yearDown.graphics.endFill();
				}
				_yearDown.x = Math.floor(_forward.x - _yearUp.width - 10);
				_yearDown.y = Math.floor(_headerHeight * .5 + 1);
			}
			
			override public function get width():Number { return super.width; }
			
			override public function set width(value:Number):void 
			{
				_width = value;
				setSize(_width, _height);
			}
			
			override public function get height():Number { return super.height; }
			
			override public function set height(value:Number):void 
			{
				_height = value;
				setSize(_width, _height);
			}
			/**
			 * @private
			 */
			public function setSize(w:Number, h:Number):void 
			{
				_width = w;
				_height = h;
				_cellWidth = (w - 10 - _borderThickness) / 7;
				_cellHeight = (h - headerHeight - 5 - _borderThickness) / 7;
				invalidate();
			}
			
			private function destroy(e:Event):void
			{
				for each(var sp:MovieClip in _dayBoxes)
				{
					sp.removeEventListener(MouseEvent.ROLL_OVER, boxhandler);
					sp.removeEventListener(MouseEvent.ROLL_OUT, boxhandler);
					sp.removeEventListener(MouseEvent.CLICK, boxhandler);
				}
				_forward.removeEventListener(MouseEvent.MOUSE_DOWN, monthstep);
				_backward.removeEventListener(MouseEvent.MOUSE_DOWN, monthstep);
				
				_autoRepeat.removeEventListener(TimerEvent.TIMER, autoIncYear);
				stage.removeEventListener(MouseEvent.MOUSE_UP, stopChange);
				_yearDown.removeEventListener(MouseEvent.MOUSE_DOWN, yearstep);
				_yearUp.removeEventListener(MouseEvent.MOUSE_DOWN, yearstep);
				
				_forward.removeEventListener(MouseEvent.ROLL_OVER, drawRollOver);
				_backward.removeEventListener(MouseEvent.ROLL_OVER, drawRollOver);
				_yearDown.removeEventListener(MouseEvent.ROLL_OVER, drawRollOver);
				_yearUp.removeEventListener(MouseEvent.ROLL_OVER, drawRollOver);
				
				_forward.removeEventListener(MouseEvent.ROLL_OUT, drawGraphics);
				_backward.removeEventListener(MouseEvent.ROLL_OUT, drawGraphics);
				_yearDown.removeEventListener(MouseEvent.ROLL_OUT, drawGraphics);
				_yearUp.removeEventListener(MouseEvent.ROLL_OUT, drawGraphics);
				
				removeEventListener(Event.ADDED_TO_STAGE, init);
				removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			}
			
			/**
			 * Assigns the width and height of the cells holding the days. Changes will be applied immediately.
			 * @param	width Width of the date cell.
			 * @param	height Height of the date cell. If not set, the height will match the width of the cell.
			 * @example The following code sets the size of the cell to 30x30 pixels:
			 * <listing version="3.0"> import com.sickworks.components.DateChooser;
			 * var dc:DateChooser = new DateChooser();
			 * dc.setCellSize(30);
			 * addChild(dc);
			 * </listing> 
			 */
			public function setCellSize(width:Number, height:Number = -1):void
			{
				_cellWidth = width;
				_cellHeight = height == -1 ? width : height;
				invalidate();
			}
			
			/**
			 * Assigns the color to each cell in the grid holding a date of the current month.
			 * @param	color Background color of the cells holding the dates.
			 * @param	alpha Transparency of the background color holding the cells (default is 1 == no transparency).
			 * @example The following example sets the cell color to a semi transparent magenta:
			 * <listing version="3.0"> import com.sickworks.components.DateChooser;
			 * var dc:DateChooser = new DateChooser();
			 * dc.setCellColor(0xFF00FF, .5);
			 * addChild(dc);
			 * </listing> 
			 */
			public function setCellColor(color:Number, alpha:Number = 1):void
			{
				_cellColor = color;
				_cellColorAlpha = alpha;
				invalidate();
			}
			
			/**
			 * Assigns the the background color to the cell on mouse over.
			 * @param	color Color of the cell while the mouse is over the cell.
			 * @param	alpha Transparency of the cell color on mouse over (default is 1 == no transparency).
			 * @example The following example sets the highlight color to plain red:
			 * <listing version="3.0"> import com.sickworks.components.DateChooser;
			 * var dc:DateChooser = new DateChooser();
			 * dc.setHighlightColor(0xFF0000);
			 * addChild(dc);
			 * </listing> 
			 */
			public function setHighlightColor(color:Number, alpha:Number = 1):void
			{
				_highlightColor = color;
				_highlightColorAlpha = alpha;
				invalidate();
			}
			
			/**
			 * Assigns the background color to the selected cell. The usage of this method is similar to <code>setCellColor</code> and <code>setHighlightColor</code>.
			 * @param	color Color of the cell if the date has been selected.
			 * @param	alpha Transparency of the cell color (default is 1 == no transparency).
			 */
			public function setSelectionColor(color:Number, alpha:Number = 1):void
			{
				_selectedColor = color;
				_selectedColorAlpha = alpha;
				invalidate();
			}
			
			/**
			 * Assigns the background color of the cell holding the actual date. The usage of this method is similar to <code>setCellColor</code> and <code>setHighlightColor</code>.
			 * @param	color Color of the cell if its date matches today.
			 * @param	alpha Transparency of the cell color (default is 1 == no transparency).
			 */
			public function setTodayColor(color:Number, alpha:Number = 1):void
			{
				_todayColor = color;
				_todayColorAlpha = alpha;
				invalidate();
			}
			
			/**
			 * Assigns the border style to the background container.
			 * @param	thickness Border thickness in pixels. To delete borders set this value to 0.
			 * @param	color Border color (default is 0xCCCCCC).
			 * @param	alpha Border alpha (default is 1).
			 * @example The following code sets the border of the background to funny pink, 5px width/height and 50% transparency:
			 * <listing version="3.0"> import com.sickworks.components.DateChooser;
			 * var dc:DateChooser = new DateChooser();
			 * dc.setBorderStyle(5, 0xff00ff, .5);
			 * addChild(dc);
			 * </listing> 
			 */
			public function setBorderStyle(thickness:uint, color:Number = 0xCCCCCC, alpha:Number = 1):void
			{
				_borderThickness = thickness;
				_borderColor = color;
				_borderAlpha = alpha;
				invalidate();
			}
			
			/**
			 * @private
			 */
			public function getBorderStyle():Object
			{
				var borderstyle:Object = { thickness:_borderThickness, color:_borderColor, alpha:_borderAlpha };
				return borderstyle;
			}
			
			/**
			 * Assigns the colors of the background. Since it's a gradient fill, you have to add an Array of two colors. If you want a static color, just assign an array of two similar colors. For example: [0xCCCCCC, 0xCCCCCC]. To remove the background, you can either set the alpha values to 0 or simply call <code>dc.setBackgroundColors();</code> without any parameter.
			 * @param	colors Array of the colors to be set as background. If not set, background colors will be removed.
			 * @param	alphas Array of the alpha values of the background colors. If not set, the currently set alpha values will be used.
			 */
			public function setBackgroundColors(colors:Array = null, alphas:Array = null):void
			{
				_backgroundColors = colors == null ? [] : colors;
				_backgroundColorsAlpha = alphas == null ? _backgroundColorsAlpha : alphas;
				invalidate();
			}
			
			/**
			 * Sets the month to be shown.
			 * @param	month Assigns the month to be shown from 1-12. (1 == January, 2 == February, and so on).
			 * @param	year Sets the year to be shown. If not set, the current year will be used.
			 */
			public function setMonth(month:uint, year:int = -9999):void
			{
				_currentMonth = month - 1;
				_currentYear = year == -9999 ? _currentYear : year;
				//fillGrid(_currentYear, _currentMonth);
				invalidate();
			}
			
			private function formatDates(d:Date):String
			{
				var day:String = (_dayLeadingZero && d.getDate() < 10 ? "0" : "") + d.getDate().toString();
				var month:String = (_monthLeadingZero && d.getMonth() < 9 ? "0" : "") + (d.getMonth() + 1).toString();
				var year:String = d.getFullYear().toString().substring(_fullYear ? 0 : 2);
				var ds:String;
				
				switch (_dateFormat)
				{
					case DD_MM_YYYY:
					{
						ds = day + _dateSeperator + month + _dateSeperator + year;
						break;
					}
					case DD_YYYY_MM:
					{
						ds = day + _dateSeperator + year + _dateSeperator + month;
						break;
					}
					case MM_DD_YYYY:
					{
						ds = month + _dateSeperator + day + _dateSeperator + year;
						break;
					}
					case MM_YYYY_DD:
					{
						ds = month + _dateSeperator + year + _dateSeperator + day;
						break;
					}
					case YYYY_DD_MM:
					{
						ds = year + _dateSeperator + day + _dateSeperator + month;
						break;
					}
					case YYYY_MM_DD:
					{
						ds = year + _dateSeperator + month + _dateSeperator + day;
						break;
					}
				}
				return ds;
			}
			
			/**
			 * Assigns the colors of the background. Since it's a gradient fill, you have to add an Array of two colors. If you want a static color, just assign an array of two similar colors. For example: [0xCCCCCC, 0xCCCCCC].
			 */
			[Inspectable(name="Background Colors", type= Array, defaultValue= "0xE2E6EB,0xFFFFFF")]
			public function get backgroundColors():Array { return _backgroundColors; }
			
			public function set backgroundColors(value:Array):void 
			{
				_backgroundColors = value == null ? [] : value;
				invalidate();
			}
			
			/**
			 * Assign the alpha values of the background here. Since it's a gradient fill, you have to add an Array of two values.
			 */
			[Inspectable(name="Background Colors Alphas", type= Array, defaultValue= "1,1")]
			public function get backgroundColorsAlpha():Array { return _backgroundColorsAlpha; }
			
			public function set backgroundColorsAlpha(value:Array):void 
			{
				_backgroundColorsAlpha = value;
				invalidate();
			}
			
			/**
			 * Sets the names of the months to be shown in the header. The default settings are the months from January to December in english. Passing less than 12 values, every missing value will be set to "Monthname".
			 * @default ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
			 */
			[Inspectable(name="Month Names", type= Array, defaultValue= "January,February,March,April,May,June,July,August,September,October,November,December")]
			public function get months():Array { return _months; }
			
			public function set months(value:Array):void 
			{
				_months = value;
				for (var i:uint = _months.length - 1; i < 12; i++)
				{
					_months.push("Monthname");
				}
				invalidate();
			}
			
			/**
			 * Sets the names of the days shown on top of the calendar. The order is: Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday. Just pass the new names using an array with the desired values.
			 * @default ["S", "M", "T", "W", "T", "F", "S"]
			 */
			[Inspectable(name="Day Names", type= Array, defaultValue= "S,M,T,W,T,F,S")]
			public function get days():Array { return _days; }
			
			public function set days(value:Array):void 
			{
				_days = value;
				for (var i:uint = _days.length - 1; i < 7; i++)
				{
					_days.push("Day");
				}
				invalidate();
			}
			
			/**
			 * Gets or sets the currently selected dates, updated everytime a date is clicked. The items in the array are or have to be date objects. When setting the selected dates, all currently selected dates will be overridden by the new dates.
			 * @default []
			 */
			[Inspectable(name="Selected Dates", type= Array, defaultValue= "")]
			public function get selectedDates():Array 
			{
				if (_dateFormat != DATE_OBJECT)
				{
					var dates:Array = [];
					for each(var date:Date in _selectedDates)
					{
						dates.push(formatDates(date));
					}
					return dates;
				}
				else return _selectedDates;
			}
			
			public function set selectedDates(dates:Array):void
			{
				_selectedDates = [];
				_selectedDates = _selectedDates.concat(dates);
				invalidate();
			}
			
			/**
			 * Sets the TextFormat for the cells holding the dates.
			 * @default _cellTextFormat.size = 9;
			 * _cellTextFormat.align = "center";
			 * _cellTextFormat.font = "Verdana";
			 */
			public function set cellTextFormat(value:TextFormat):void 
			{
				_cellTextFormat = value;
				invalidate();
			}
			
			/**
			 * Sets TextFormat for the header (month and year) and the day text.
			 * @default _headerTextFormat.align = "center";
			 * _headerTextFormat.size = 9;
			 * _headerTextFormat.bold = true;
			 * _headerTextFormat.font = "Verdana";
			 */
			public function set headerTextFormat(value:TextFormat):void 
			{
				_headerTextFormat = value;
				invalidate();
			}
			
			/**
			 * Sets a DisplayObject to be used as previous month handler. You can use any DisplayObject as button here.
			 * To adjust individual positions use: datechooserInstance.monthDownButton.x/y
			 */
			public function get monthDownButton():DisplayObject { return _previousButton; }
			
			public function set monthDownButton(value:DisplayObject):void 
			{
				if (_previousButton != null)
				{
					_backward.removeChild(_previousButton);
				}
				//_backward.removeEventListener(MouseEvent.ROLL_OVER, drawRollOver);
				//_backward.removeEventListener(MouseEvent.ROLL_OUT, drawGraphics);
				_previousButton = value;
				_backward.graphics.clear();
				_backward.addChild(_previousButton);
				invalidate();
			}
			
			/**
			 * Sets a DisplayObject to be used as next month handler. You can use any DisplayObject as button here.
			 * To adjust individual positions use: datechooserInstance.monthUpButton.x/y
			 */
			public function get monthUpButton():DisplayObject { return _nextButton; }
			
			public function set monthUpButton(value:DisplayObject):void 
			{
				if (_nextButton != null)
				{
					_forward.removeChild(_nextButton);
				}
				//_forward.removeEventListener(MouseEvent.ROLL_OVER, drawRollOver);
				//_forward.removeEventListener(MouseEvent.ROLL_OUT, drawGraphics);
				_nextButton = value;
				_forward.graphics.clear();
				_forward.addChild(_nextButton);
				invalidate();
			}
			
			/**
			 * Sets a DisplayObject to be shown as next year handler. You can use any DisplayObject as button here.
			 */
			public function get yearUpButton():DisplayObject { return _yearUpButton; }
			
			public function set yearUpButton(value:DisplayObject):void 
			{
				if (_yearUpButton != null)
				{
					_yearUp.removeChild(_yearUpButton);
				}
				//_yearUp.removeEventListener(MouseEvent.ROLL_OVER, drawRollOver);
				//_yearUp.removeEventListener(MouseEvent.ROLL_OUT, drawGraphics);
				_yearUpButton = value;
				_yearUp.graphics.clear();
				_yearUp.addChild(_yearUpButton);
				invalidate();
			}
			
			/**
			 * Sets a DisplayObject to be shown as previous year handler. You can use any DisplayObject as button here.
			 */
			public function get yearDownButton():DisplayObject { return _yearDownButton; }
			
			public function set yearDownButton(value:DisplayObject):void 
			{
				if (_yearDownButton != null)
				{
					_yearDown.removeChild(_yearDownButton);
				}
				//_yearDown.removeEventListener(MouseEvent.ROLL_OVER, drawRollOver);
				//_yearDown.removeEventListener(MouseEvent.ROLL_OUT, drawGraphics);
				_yearDownButton = value;
				_yearDown.graphics.clear();
				_yearDown.addChild(_yearDownButton);
				invalidate();
			}
			
			/**
			 * Allow users to select one (false) or more (true) dates by holding down the SHIFT key.
			 * @default false
			 */
			[Inspectable(name="Multiple Selection", type= Boolean, defaultValue= false)]
			public function get allowMultiple():Boolean { return _allowMultiple; }
			
			public function set allowMultiple(value:Boolean):void 
			{
				_allowMultiple = value;
				if (!_allowMultiple)
				{
					_selectedDates = [];
				}
				invalidate();
			}
			
			/**
			 * Sets the minimum year.
			 * @default 1900
			 */
			[Inspectable(name="Lowest Year", type= Number, defaultValue= 1900)]
			public function get lowestYear():int { return _lowestYear; }
			
			public function set lowestYear(value:int):void 
			{
				_lowestYear = value;
				invalidate();
			}
			
			/**
			 * Sets the maximum year.
			 * @default 2100
			 */
			[Inspectable(name="Highest Year", type= Number, defaultValue= 2100)]
			public function get highestYear():int { return _highestYear; }
			
			public function set highestYear(value:int):void 
			{
				_highestYear = value;
				invalidate();
			}
			
			/**
			 * Sets the value to which the gradient header will flow.
			 * @default 35
			 */
			[Inspectable(name="Gradient Offset", type= Number, defaultValue= 35)]
			public function get gradientOffset():Number { return _gradientOffset; }
			
			public function set gradientOffset(value:Number):void 
			{
				_gradientOffset = value;
				invalidate();
			}
			
			/**
			 * The background color to be shown if the mouse is over an element.
			 * @default 0x99CCFF
			 * @see #setHighlightColor()
			 */
			[Inspectable(name="Highlight Color", type= Color, defaultValue= "#99CCFF")]
			public function get highlightColor():Number { return _highlightColor; }
			
			public function set highlightColor(value:Number):void 
			{
				_highlightColor = value;
				invalidate();
			}
			
			/**
			 * The alpha value of the background color to be shown if the mouse is over an element.
			 */
			[Inspectable(name="Highlight Color Alpha", type= Number, defaultValue= .5)]
			public function get highlightColorAlpha():Number { return _highlightColorAlpha; }
			
			public function set highlightColorAlpha(value:Number):void 
			{
				_highlightColorAlpha = value;
				invalidate();
			}
			
			/**
			 * The background color of the cells holding the dates.
			 * @default 0xFFFFFF
			 * @see #setCellColor()
			 */
			[Inspectable(name="Cell Color", type= Color, defaultValue= "#FFFFFF")]
			public function get cellColor():Number { return _cellColor; }
			
			public function set cellColor(value:Number):void 
			{
				_cellColor = value;
				invalidate();
			}
			
			/**
			 * The alpha value of the background color of the cells holding the dates.
			 * @default 1
			 */
			[Inspectable(name="Cell Color Alpha", type= Number, defaultValue= 1)]
			public function get cellColorAlpha():Number { return _cellColorAlpha; }
			
			public function set cellColorAlpha(value:Number):void 
			{
				_cellColorAlpha = value;
				invalidate();
			}
			
			/**
			 * The background color of the cell keeping today's date.
			 * @default 0xE2E6EB
			 * @see #setTodayColor()
			 */
			[Inspectable(name="Today Color", type= Color, defaultValue= "#E2E6EB")]
			public function get todayColor():Number { return _todayColor; }
			
			public function set todayColor(value:Number):void 
			{
				_todayColor = value;
				invalidate();
			}
			
			/**
			 * The alpah value of the background color of the cell keeping today's date.
			 * @default 1
			 */
			[Inspectable(name="Today Color Alpha", type= Number, defaultValue= 1)]
			public function get todayColorAlpha():Number { return _todayColorAlpha; }
			
			public function set todayColorAlpha(value:Number):void 
			{
				_todayColorAlpha = value;
				invalidate();
			}
			
			/**
			 * The background color of the cell if the date has been selected.
			 * @default 0x999999
			 * @see #setSelectionColor()
			 */
			[Inspectable(name="Selection Color", type= Color, defaultValue= "#999999")]
			public function get selectedColor():Number { return _selectedColor; }
			
			public function set selectedColor(value:Number):void 
			{
				_selectedColor = value;
				invalidate();
			}
			
			/**
			 * The alpha value of the background color of the cell if the date has been selected.
			 * @default 1
			 */
			[Inspectable(name="Selection Color Alpha", type= Number, defaultValue= 1)]
			public function get selectedColorAlpha():Number { return _selectedColorAlpha; }
			
			public function set selectedColorAlpha(value:Number):void 
			{
				_selectedColorAlpha = value;
				invalidate();
			}
			
			/**
			 * Gets/sets the width of the cells holding the dates
			 * @default 26
			 */
			public function get cellWidth():Number { return _cellWidth; }
			
			public function set cellWidth(value:Number):void 
			{
				_cellWidth = value;
				invalidate();
			}
			
			/**
			 * Gets/sets the height of the cells holding the dates
			 * @default 21
			 */
			public function get cellHeight():Number { return _cellHeight; }
			
			public function set cellHeight(value:Number):void 
			{
				_cellHeight = value;
				invalidate();
			}
			
			/**
			 * Gets/sets the height of the header where the month and year is shown.
			 * @default 30
			 */
			[Inspectable(name="Header Height", type= Number, defaultValue= 30)]
			public function get headerHeight():Number { return _headerHeight; }
			
			public function set headerHeight(value:Number):void 
			{
				_headerHeight = value;
				invalidate();
			}
			/**
			 * Gets/sets the highest month to be shown when the highest year is active. If not set december will be used. Valid values are 0 to 11, where 0 = January, 1 = February, and so on.
			 */
			[Inspectable(name="Highest Month", type= Number, defaultValue= 11)]
			public function get highestMonth():int { return _highestMonth; }
			
			public function set highestMonth(value:int):void 
			{
				if (value >= 0 && value < 12)
				{
					_highestMonth = value;
					invalidate();
				}
			}
			/**
			 * Gets/sets the interval for autorepeating the click on a year or month button in miliseconds.
			 * @default 150
			 */
			[Inspectable(name="Button Repeat Interval", type= Number, defaultValue= 150)]
			public function get buttonRepeatInterval():uint { return _buttonRepeatInterval; }
			
			public function set buttonRepeatInterval(value:uint):void 
			{
				_buttonRepeatInterval = value;
				if(!_autoRepeat) return;
				_autoRepeat.delay = _buttonRepeatInterval;
				if(_autoRepeat.running)
				{
					_autoRepeat.reset();
					_autoRepeat.start();
				}
			}
			/**
			 * Gets/sets the delay befor button autorepeating starts in miliseconds.
			 * @default 750
			 */
			[Inspectable(name="Button Repeat Delay", type= Number, defaultValue= 750)]
			public function get buttonRepeatDelay():uint { return _buttonRepeatDelay; }
			
			public function set buttonRepeatDelay(value:uint):void 
			{
				_buttonRepeatDelay = value;
			}
			
			/**
			 * Gets/sets if the user is allowed to choose dates that are in the past.
			 * @default true
			 */
			[Inspectable(name="Allow Past Dates", type= Boolean, defaultValue= true)]
			public function get allowPastDates():Boolean { return _allowPastDates; }
			
			public function set allowPastDates(value:Boolean):void 
			{
				_allowPastDates = value;
				invalidate();
			}
			/**
			 * Gets/sets if dates that are in the past are visible.
			 * @default true
			 */
			[Inspectable(name="Show Past Dates", type= Boolean, defaultValue= true)]
			public function get showPastDates():Boolean { return _showPastDates; }
			
			public function set showPastDates(value:Boolean):void 
			{
				_showPastDates = value;
				invalidate();
			}
			/**
			 * Gets/sets the alpha value for past dates.
			 * @default .5
			 */
			[Inspectable(name="Past Dates Alpha", type= Number, defaultValue= .5)]
			public function get alphaPastDates():Number { return _alphaPastDates; }
			
			public function set alphaPastDates(value:Number):void 
			{
				_alphaPastDates = Math.abs(value);
				invalidate();
			}
			/**
			 * <p>Gets/sets the Date to be used as the current day. In some cases it may be useful to set the current date manually to avoid selections of past dates.</p>
			 * 
			 * <p><strong>NOTE:</strong> When <code>today</code> is set to a TIME other than 00:00:00 and <code>allowPastDates</code> is set to false, <code>today</code> will not be selectable. This is because every date within the component starts at 00:00:00 and would therefore be a past date.</p>
			 * @default the current date (defined by the OS of the client) 00:00:00.
			 */
			public function get today():Date { return _today; }
			
			public function set today(value:Date):void 
			{
				_today = value;
				invalidate();
			}
			/**
			 * <p>Gets/sets the format to be returned by "DateChooserObject".getSelectedDates(). If set to "DATE_OBJECT", Dates will be returned in the array. Otherwise the array will hold formatted Strings containing the dates in the given order, seperated by the dateSeperator parameter.</p>
			 * @see dateSeperator
			 */
			[Inspectable(name="Date Format", defaultValue="DATE_OBJECT",enumeration="DD_MM_YYYY, DD_YYYY_MM, MM_YYYY_DD, MM_DD_YYYY, YYYY_DD_MM, YYYY_MM_DD, DATE_OBJECT")]
			public function get dateFormat():String { return _dateFormat; }
			
			public function set dateFormat(value:String):void 
			{
				if (FORMATS.indexOf(value.toUpperCase()) > -1)_dateFormat = value;
			}
			/**
			 * Gets/sets the seperator between days, months and years. (Ignored if dateFormat is set to "DATE_OBJECT").
			 * @default "."
			 */
			[Inspectable(name="Date Seperator", type= String, defaultValue= ".")]
			public function get dateSeperator():String { return _dateSeperator; }
			
			public function set dateSeperator(value:String):void 
			{
				_dateSeperator = value;
			}
			/**
			 * Gets/sets if the full year will be returned or just the last two digits. (Ignored if dateFormat is set to "DATE_OBJECT").
			 * @default true
			 */
			[Inspectable(name="Date Format Full Year", type= Boolean, defaultValue= true)]
			public function get returnFullYear():Boolean { return _fullYear; }
			
			public function set returnFullYear(value:Boolean):void 
			{
				_fullYear = value;
			}
			/**
			 * Gets/sets if days will be returned with leading zeros if the day is below 10. (Ignored if dateFormat is set to "DATE_OBJECT").
			 * @default = true
			 */
			[Inspectable(name="Date Format Day Leading Zeron", type= Boolean, defaultValue= true)]
			public function get dayLeadingZero():Boolean { return _dayLeadingZero; }
			
			public function set dayLeadingZero(value:Boolean):void 
			{
				_dayLeadingZero = value;
			}
			/**
			 * Gets/sets if months will be returned with leading zeros if the month is below 10. (Ignored if dateFormat is set to "DATE_OBJECT").
			 * @default true
			 */
			[Inspectable(name="Date Format Month Leading Zero", type= Boolean, defaultValue= true)]
			public function get monthLeadingZero():Boolean { return _monthLeadingZero; }
			
			public function set monthLeadingZero(value:Boolean):void 
			{
				_monthLeadingZero = value;
			}
		}
		
}