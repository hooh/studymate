package com.studyMate.view.component.GpuTextField
{
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.model.vo.SwitchScreenVO;
	import com.studyMate.global.AppLayoutUtils;
	import com.studyMate.global.SwitchScreenType;
	import com.studyMate.view.component.myDrawing.helpFile.IsLetter;
	import com.studyMate.world.screens.PopMenuMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 
	 * @author wangtu
	 * 
	 * 主要功能为解决Starling的textfield不能查单词而设计的。
	 * 
	 * 使用方式，传入flash层的Textfield对象即可。
	 * 
	 */	
	
	public class TextFieldToGPU extends starling.display.Sprite
	{
		private var _textField:TextField;	
		private var textDragEvent:TextFieldDragEvent;
		private var holder:starling.display.Sprite;
		private var _quad:Quad;
		private var textureList:Vector.<Texture>;
		
		public function TextFieldToGPU(value:TextField=null)
		{
			if(value){
				_textField = value;
				update();
			}							
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
		}
		
		public function get quad():Quad
		{
			if(_quad == null){
				_quad = new Quad(0.01,0.01,0xBBBBBB);
				_quad.alpha = 0.8;
				this.addChildAt(_quad,0);			
			}
			return _quad;
		}


		private function removeFromStageHandler(e:Event):void
		{
			clearTexture();
			_textField = null;
			this.removeEventListeners();
			if(textDragEvent){
				textDragEvent.dispose();
				textDragEvent.removeEventListeners();
			}
			this.removeChildren(0,-1,true);			
		}	
				
		private function clearTexture():void{
			if(textureList){
				for(var i:int=0;i<textureList.length;i++){
					textureList[i].dispose();
				}
				textureList.length = 0 ;
				textureList = null;
			}
		}

		public function get textField():TextField
		{
			return _textField;
		}

		public function set textField(value:TextField):void
		{
			_textField = value;
			update();			
		}
		
		private function update():void{	
			if(textDragEvent){
				textDragEvent.dispose();
				textDragEvent.removeEventListeners();
				holder.removeChildren(0,-1,true);
				this.removeChild(holder);
			}
			clearTexture();
			textureList = new Vector.<Texture>;
			//var bmd:BitmapData;
			holder = new starling.display.Sprite();
			this.addChild(holder);	
			
			
			var texture:Texture;
			if(_textField.height<2048){	
				var bmd:BitmapData;
				bmd = new BitmapData(_textField.width,_textField.height,true,0);
				bmd.draw(_textField);
				texture = Texture.fromBitmapData(bmd,false);
				img = new Image(texture);	
				textureList.push(texture);
				holder.addChild(img);
//				bmd.dispose();
			}else{
				var total:int = Math.ceil(_textField.height/1024);
				for(var i:int=0;i<total;i++){					
					var height:Number=1024;
					if(i<total-1){
						height=1024
					}else{
						height = _textField.height-i*1024;
					}
					if(height<1) height = 1;
					var bmd2:BitmapData = new BitmapData(_textField.width,height,true,0);
					var matrix:Matrix = new Matrix(1,0,0,1,0,-i*1024);
					bmd2.draw(_textField,matrix);
					texture = Texture.fromBitmapData(bmd2,false);		
					var img:Image =  new Image(texture);
					textureList.push(texture);
					img.y += i*1024;
					holder.addChild(img);
//					bmd2.dispose();
				}
			}
			
			
			textDragEvent = new TextFieldDragEvent(holder);
			textDragEvent.addEventListener(TextFieldDragEvent.START_EFFECT,startEffectHandler);
			textDragEvent.addEventListener(TextFieldDragEvent.END_EFFECT,endEffectHandler);
		}
		
		
		//开始显示单词
		private function startEffectHandler(e:Event):void
		{
			this.show(e.data.localX,e.data.localY,e.data.stageX,e.data.stageY);
		}
		//结束显示单词
		private function endEffectHandler(e:Event):void{
			quad.x = 0.;
			quad.y = 0;
			quad.width = 0.01;
			quad.height = 0.01;
		}		
		private function show(localX:Number=0,localY:Number=0,stageX:Number=0,stageY:Number=0):void{
			var selectStart:int=_textField.getCharIndexAtPoint(localX,localY);
			if(selectStart==-1){
				return;
			}						
			/************************翻译组件显示坐标*****************************/			
			var myX:int = stageX;
			var myY:int;
			
			if(stageY-47>20){
				myY = stageY-47-20;
			}else{
				myY = stageY +20;
			}
			/************************单词选择*****************************/
			var start:int = IsLetter.search(_textField.text,selectStart,"Left");
			var end:int = IsLetter.search(_textField.text,selectStart,"Right");
			
			//显示背景
			var startBounds:Rectangle =  _textField.getCharBoundaries(start);
			if(startBounds==null){
				startBounds = _textField.getCharBoundaries(start);
			}
			var endBounds:Rectangle =  _textField.getCharBoundaries(end+1);			
			if(endBounds == null){
				endBounds = _textField.getCharBoundaries(end);
			}
			quad.x = startBounds.x;
			quad.y = startBounds.y;
			quad.width = endBounds.x +endBounds.width-startBounds.x;
			quad.height = startBounds.height;
			
			var selectWord:String = _textField.text.substring(start,end+1);
//			var holder:flash.display.Sprite = AppLayoutUtils.cpuLayer;
			Facade.getInstance(CoreConst.CORE).sendNotification(WorldConst.SWITCH_SCREEN,[new SwitchScreenVO(PopMenuMediator,selectWord,SwitchScreenType.SHOW,AppLayoutUtils.cpuLayer,myX,myY)]);
		}
		
	}
}