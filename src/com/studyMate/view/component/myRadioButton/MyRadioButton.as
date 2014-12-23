package com.studyMate.view.component.myRadioButton
{
	import com.studyMate.view.component.MCButton;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import spark.filters.GlowFilter;
	
	public class MyRadioButton extends MCButton implements IMyRadioButton
	{
		
		
		private var _textFormat:TextFormat=null;	
		private var _groupName:String;
		
		
		override public function setLabel(_label:String):void
		{
			// TODO Auto Generated method stub
			if(_label){
				label = _label;
				var txt:TextField = pic.getChildByName("txt") as TextField;
				if(txt){
					if(_textFormat){//如果有定义的话，
						txt.embedFonts = true;
						txt.defaultTextFormat = _textFormat;
					}else{//否则如果没有定义textformat
						txt.embedFonts = true;
						var textFormat:TextFormat = new TextFormat;
						textFormat.font = "SongTi";
						txt.defaultTextFormat = textFormat;
					}
					txt.text =  _label;
				}				
			}			
		}

		//刷新按下界面
		public function update():void
		{
			mouseDownHandle(null);

		}
		
		//弹起界面
		public function unupdate():void{
			mouseUpHandle(null);
		}
		
		override protected function mouseDownHandle(event:Event):void
		{
			if(downSkin){
				clean();
				pic = new downSkin();
				addChild(pic);
				setLabel(label);
			}else{
				this.filters = [new GlowFilter(0xffff00F,0.5,32,32,2)];
				
			}						
			state = "down";
		}
		
		override protected function mouseUpHandle(event:Event):void{
			if(downSkin){
				clean();
				pic = new upSkin();
				addChild(pic);
				setLabel(label);
			}else{
				this.filters = [];
			}			
			state = "up";
		}
		
		private function clean():void{			
			if(pic){
				removeChild(pic);
				pic = null;
			}			
		}				

		//设置字体样式
		public function set textFormat(value:TextFormat):void{
			_textFormat = value;
			setLabel(label);
		}

		public function get groupName():String{
			return _groupName;
		}

		//设置组名
		public function set groupName(value:String):void{
			_groupName = value;
			if(_groupName!=""){
				var myRadioButtonGroup:IRadioButtonGroup = MyRadioButtonGroup.getInstance();
				myRadioButtonGroup.groupName = _groupName;
				myRadioButtonGroup.registerGoup(this);
			}
		}


	}
}