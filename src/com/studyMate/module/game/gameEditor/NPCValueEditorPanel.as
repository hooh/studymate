package com.studyMate.module.game.gameEditor
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.mylib.game.card.CardTypeSelector;
	import com.mylib.game.card.CardValueEditor;
	import com.mylib.game.card.GameCharaterData;
	import com.studyMate.module.ModuleConst;
	import com.studyMate.world.screens.ScreenBaseMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import feathers.controls.TextInput;
	import feathers.core.PropertyProxy;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Sprite;
	import starling.text.TextField;

	public class NPCValueEditorPanel extends ScreenBaseMediator
	{
		private var _data:GameCharaterData;
		private var editors:Vector.<CardValueEditor>;
		private var editorsHolder:Sprite;
		private var otherValueHolder:Sprite;
		
		private var nameInput:TextInput;
		private var nameLable:TextField;
		
		private var hpInput:TextInput;
		private var hpLable:TextField;
		
		private var classInput:TextInput;
		private var classLable:TextField;
		
		private var stateInput:TextInput;
		private var stateLable:TextField;
		
		
		public function NPCValueEditorPanel(viewComponent:Object=null)
		{
			super(ModuleConst.NPC_VALUE_EDITOR_PANEL, viewComponent);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			CardTypeSelector.bgTexture.dispose();
			CardTypeSelector.bgTexture = null;
			
			CardTypeSelector.frameTexture.dispose();
			CardTypeSelector.frameTexture = null;
		}
		
		override public function get viewClass():Class
		{
			return Sprite;
		}
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRegister():void
		{
			CardTypeSelector.bgTexture = CardTypeSelector.getHorizontalTexture();
			CardTypeSelector.frameTexture = CardTypeSelector.getFrameTexture();
			
			editorsHolder = new Sprite;
			view.addChild(editorsHolder);
			
			editors = new Vector.<CardValueEditor>;
			
			
			var editorItem:CardValueEditor;
			for (var i:int = 0; i < 5; i++) 
			{
				
				editorItem = new CardValueEditor();
				editorsHolder.addChild(editorItem);
				editorItem.y = i*50;
				
				editors.push(editorItem);
				
			}
			
			
			otherValueHolder = new Sprite;
			view.addChild(otherValueHolder);
			otherValueHolder.x = 230;
			
			
			nameInput = new TextInput();
			nameInput.width = 220;
			nameInput.x = 50;
			
			
			
			nameLable = new TextField(50,40,"name");
			otherValueHolder.addChild(nameLable);
			
			var property:PropertyProxy = new PropertyProxy();
			property.maxChars =16;
			nameInput.textEditorProperties = property;
			
			otherValueHolder.addChild(nameInput);
			
			hpInput = new TextInput();
			hpInput.width = 100;
			hpInput.x = 50;
			hpInput.y = 50;
			property = new PropertyProxy();
			property.maxChars =10;
			property.restrict  = "0-9";
			hpInput.textEditorProperties = property;
			otherValueHolder.addChild(hpInput);
			
			hpLable = new TextField(50,40,"hp");
			hpLable.y = 50;
			otherValueHolder.addChild(hpLable);
			
			classInput = new TextInput();
			classInput.width = 40;
			classInput.x = 50;
			classInput.y = 100;
			property = new PropertyProxy();
			property.maxChars =1;
			property.restrict  = "a-z";
			classInput.textEditorProperties = property;
			otherValueHolder.addChild(classInput);
			classLable = new TextField(50,40,"等级");
			classLable.y = 100;
			otherValueHolder.addChild(classLable);
			
			stateInput = new TextInput();
			stateInput.width = 40;
			stateInput.x = 50;
			stateInput.y = 150;
			property = new PropertyProxy();
			property.maxChars =1;
			property.restrict  = "a-z";
			stateInput.textEditorProperties = property;
			otherValueHolder.addChild(stateInput);
			
			stateLable = new TextField(50,40,"状态");
			stateLable.y = 150;
			otherValueHolder.addChild(stateLable);
			
			
		}
		
		private function updateValue():void{
			for (var i:int = 0; i < _data.values.length; i++) 
			{
				editors[i].data = _data.values[i];
			}
			
			nameInput.text = _data.name;
			hpInput.text = _data.fullHP.toString();
			stateInput.text = _data.state;
			classInput.text = _data.charaterClass;
			
			
		}
		
		override public function prepare(vo:SwitchScreenVO):void
		{
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SCREEN_PREPARE_READY,vo);
		}
		
		public function set data(_cp:GameCharaterData):void{
			_data = _cp;
			updateValue();
		}
		
		public function updateData():void{
			
			if(!_data){
				return;
			}
			
			_data.name = nameInput.text;
			_data.fullHP = parseInt(hpInput.text);
			_data.state = stateInput.text;
			_data.charaterClass = classInput.text;
			
			for (var i:int = 0; i < editors.length; i++) 
			{
				editors[i].updateData();
			}
			
		}
		
		public function get data():GameCharaterData{
			
			
			
			return _data;
		}
		
		
	}
}