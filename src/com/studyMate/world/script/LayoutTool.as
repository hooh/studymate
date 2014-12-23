package com.studyMate.world.script
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.framework.utils.AssetTool;
	import com.studyMate.model.vo.ScriptExecuseVO;
	import com.studyMate.module.ModuleUtils;
	import com.studyMate.utils.LayoutToolUtils;
	import com.studyMate.utils.MyUtils;
	import com.studyMate.view.component.MCButton;
	import com.urbansquall.ginger.Animation;
	import com.urbansquall.ginger.AnimationPlayer;
	import com.urbansquall.ginger.events.AnimationEvent;
	import com.urbansquall.ginger.tools.AnimationBuilder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import utils.FunctionQueueEvent;
	import utils.FunctionQueueVO;
	
	public final class LayoutTool
	{
		public static var holder:Sprite = null;
		
		public static var mainHolder:Sprite = null;
		
		public static var subHolder:Sprite = null;
		
		public static var manual:Boolean = false;
		private static var idIdx:int;
		
		public static var initPageTag:String = "initialize";
		
		public static var lastFun:FunctionQueueVO;
		public static var nextFun:FunctionQueueVO;
		
		public function LayoutTool(){}
		
		public static function getId():String{
			idIdx++;
			return "s_"+idIdx;
		}
		
		/**----------------------------------文字相关函数----------------------------------------------------------------------------------------*/		
		public static function setFont(_font:String):void{
			TypeTool.setFont(_font);
		}
		public static function setSize(_size:String):void{
			TypeTool.setSize(_size);
		}
		public static function setColor(_color:String):void{
			TypeTool.setColor(_color);
		}
		public static function setTypeSpeed(_speed:String):void{
			TypeTool.setTypeSpeed(_speed);
		}
		public static function setLetterSpacing(_letterSpacing:String):void{
			TypeTool.setLetterSpacing(_letterSpacing);
		}
		public static function setLeading(_leading:String):void{
			TypeTool.setLeading(_leading);	
		}
		public static function setBorderVisible(_border:String):void{
			TypeTool.setBorderVisible(_border);
		}
		public static function setSelectable(_selectable:String):void{
			TypeTool.setSelectable(_selectable);
		}
		public static function print(_x:int,_y:int,_txt:String):void{
			_txt = MyUtils.toSpell2(_txt);
			TypeTool.print(_x,_y,_txt);
		}
		public static function advancedPrint(_x:*,_y:*,_size:*,_font:*,_color:*,_style:*,_bolder:*,_bolderColor:*,_letterSpacing:*,_leading:*,_txt:*):void{
			_txt = MyUtils.toSpell2(_txt);
			TypeTool.advancedPrint(_x,_y,_size,_font,_color,_style,_bolder,_bolderColor,_letterSpacing,_leading,_txt);
		}
		public static function simpleType(_x:*,_y:*,_str:*):void{
			_str = MyUtils.toSpell2(_str);
			TypeTool.simpleType(_x,_y,_str)
		}
		
		public static function advancedType (_x:*,_y:*,_width:*,_height:*,_font:*,_speed:*,_size:*,_color:*,_style:*,_bolder:*,_bolderColor:*,_letterSpacing:*,_leading:*,_str:*):void{
			_str = MyUtils.toSpell2(_str);//显示特殊字符
			TypeTool.advancedType(_x,_y,_width,_height,_font,_speed,_size,_color,_style,_bolder,_bolderColor,_letterSpacing,_leading,_str);
		}
		//指定区域打字
		public static function typeArea(_x:*,_y:*,_width:*,_height:*,_str:*):void{
			_str = MyUtils.toSpell2(_str);
			TypeTool.typeArea(_x,_y,_width,_height,_str);
		}
		//针对typeArea函数而创建的函数,typeArea在板子执行有些卡
		public static function typeTextString(_x:*,_y:*,_width:*,_height:*,_str:*,_leading:*=0):void{
			_str = MyUtils.toSpell2(_str);
			TypeTool.typeTextString(_x,_y,_width,_height,_str,_leading);
		}
		public static function typeText(_id:*,_str:String,_speed:Number,_size:uint,_color:int,_style:String,_letterSpacing:Number,_leading:Number):void{
			TypeTool.typeText(_id,_str,_speed,_size,_color,_style,_letterSpacing,_leading);
		}
		public static function typeTextFiled(_id:*,_speed:Number):void{
			TypeTool.typeTextFiled(_id,_speed);
		}
		public static function continueType (_x:*,_y:*,_width:*,_height:*,_font:*,_speed:*,_size:*,_color:*,_letterSpacing:*,_leading:*,_str:*):void{
			_str = MyUtils.toSpell2(_str);
			TypeTool.continueType(_x,_y,_width,_height,_font,_speed,_size,_color,_letterSpacing,_leading,_str);
		}
		
		// 语法结构
		
		//此方法类似advancedType，不过存储了引用，可以在后续方法中继续对句子进行标记。
		public static function showBasicSentence(_x:*,_y:*,_size:*,_font:*,_color:*,_letterSpacing:*,_leading:*,_str:*):void{
			TypeTool.showBasicSentence(_x,_y,_size,_font,_color,_letterSpacing,_leading,_str);
		}
		public static function markWordBlank(_index:*):void{
			TypeTool.markWordBlank(_index);
		}
		public static function markWordUnderline(_color:*,..._arg):void{
			TypeTool.markWordUnderline(_color,_arg);
		}
		//当执行到这个函数时，看到的颜色是显示在textFieldContainer上的，当页面执行完成后，textFieldContainer被destroy掉，sentenceTextField被还原
		public static function markWordColor(_color:*,..._arg):void{
			TypeTool.markWordColor(_color,_arg);
		}
		public static function markDownArrow(_index:*):void{
			TypeTool.markDownArrow(_index);
		}
		public static function showArrowTips(_index:*,_str:*):void{
			TypeTool.showArrowTips(_index,_str);
		}
		public static function switchHolder(_holder:*):void{
			if(_holder=="mainHolder"){
				if(!mainHolder){
					mainHolder = new Sprite;
				}
				holder = mainHolder;
			}else if(_holder=="subHolder"){
				if(!subHolder){
					subHolder = new Sprite;
				}
				holder = subHolder;
				if(LayoutToolUtils.holder){
					LayoutToolUtils.holder.addChild(holder);
				}
			}
			markFunComplete();
		}
		public static function printText(_x:*,_y:*,_width:*,_height:*,_txt:*):void{
			TypeTool.printText(_x,_y,_width,_height,_txt);
		}
		public static function outHTML(_x:*,_y:*,_width:*,_height:*,_txt:*):void{
			_txt = MyUtils.toSpell2(_txt);
			TypeTool.outHTML(_x,_y,_width,_height,_txt);
		}
		public static function showQuestion(_x:*,_y:*,_width:*,_height:*,_isType:*,_txt:*,_answer:*,..._arg):void{
			_txt = MyUtils.toSpell2(_txt);
			TypeTool.showQuestion(_x,_y,_width,_height,_isType,_txt,_answer,_arg);
		}
		public static function doExercise(_x:*,_y:*,_width:*,_height:*,_isType:*,_txt:*,_answer:*,_rightHandler:*,_firstWrongHandler:*,_secondWrongHandler:*):void{
			TypeTool.doExercise(_x,_y,_width,_height,_isType,_txt,_answer,_rightHandler,_firstWrongHandler,_secondWrongHandler);
		}
		public static function executeCustomTag(_tag:*):void{
			Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.EXECUSE_SCRIPT_NEW,new ScriptExecuseVO(_tag,-1,false,false));
		}
		public static function gotoNext(_r:*):void{
			ExerciseTool.nextPage(null);
		}
		public static function showExerciseAnswer(t:*):void{
			TypeTool.showExerciseAnswer();
			markFunComplete();
		}
		public static function fillBlanks(_x:*,_y:*,_width:*,_height:*,_isType:*,_txt:*,..._arg):void{
			TypeTool.fillBlanks(_x,_y,_width,_height,_isType,_txt,_arg);
		}
		public static function destroy():void{
			TypeTool.destroy();
		}
		//表格
		public static function showTable(_x:*,_y:*,_row:*,_column:*,_gridWidth:*,_gridHeight:*):void{
			TypeTool.showTable(_x,_y,_row,_column,_gridWidth,_gridHeight);
		}
		public static function hideLine(index:*):void{
			TypeTool.hideLine(index);
		}
		public static function setBorder(_thick:*=1,_color:*=0):void{
			TypeTool.setBorder(_thick,_color);
		}
		public static function hideBorder(_tmp:*):void{
			TypeTool.hideBorder(_tmp);
		}
		public static function setGridText(_row:*,_col:*,_text:*,_leading:*=0):void{
			TypeTool.setGridText(_row,_col,_text,_leading);
		}
		public static function setRowText(_row:*,...arg):void{
			TypeTool.setRowText(_row,arg);
		}
		public static function setColumnText(_column:*,...arg):void{
			TypeTool.setColumnText(_column,arg);
		}
			
		public static function setRowHeight(_row:*,_height:*):void{
			TypeTool.setRowHeight(_row,_height);
		}
		public static function setColumnWidth(_col:*,_width:*):void{
			TypeTool.setColumnWidth(_col,_width);
		}
		public static function setRowAlign(_row:*,align:*):void{
			TypeTool.setRowAlign(_row,align);
		}
		public static function setColumnAlign(_column:*,align:*):void{
			TypeTool.setColumnAlign(_column,align);
		}
		public static function setGridAlign(_row:*,_column:*,align:*):void{
			TypeTool.setGridAlign(_row,_column,align);
		}
		public static function setTableAlign(align:*):void{
			TypeTool.setTableAlign(align);
		}
		//用来在表格中打字的函数
		public static function continueTypeInGrid(_row:*,_col:*,_font:*,_size:*,_color:*,_letterSpacing:*,_leading:*,_underline:*,_str:*):void{
			TypeTool.continueTypeInGrid(_row,_col,_font,_size,_color,_letterSpacing,_leading,_underline,_str);
		}

		
		
		/**-------------------------------背景、图片、影片剪辑 相关函数	---------------------------------*/	
		private static var backgroundX:Number=0;
		private static var backgroundY:Number=0;
		private static var backgroundWidth:Number=300;
		private static var backgroundHeight:Number=300;
		private static var backgroundColor:Number=0;
		private static var isSetAllSameColor:Boolean = false;
		public static function showBackground(_x:*,_y:*,_width:*,_height:*,_color:*,_isAllSameColor:Boolean = true):void{
			
			if(_isAllSameColor){
				backgroundX = _x;
				backgroundY = _y;
				backgroundWidth = _width;
				backgroundHeight = _height;
				backgroundColor = _color;
				isSetAllSameColor = true;
			}else{
				isSetAllSameColor = false;
			}
			
			holder.graphics.beginFill(_color);
			holder.graphics.drawRect(_x,_y,_width,_height);
			holder.graphics.endFill();
			
			markFunComplete();
		}
		public static function showPicture(_name:*,_x:*=0,_y:*=0,_width:*=0,_height:*=0,_scale:*=1):void{
			trace("show picture");
			var bg:Class = AssetTool.getCurrentLibClass(_name);
			if(!bg) return;
			var dobj:DisplayObject = new bg;
			if(_x!=0){
				dobj.x = _x;
			}
			if(_y!=0){
				dobj.y = _y;
			}
			if(_width !=0){
				dobj.width = _width;
			}
			if(_height!=0){
				dobj.height = _height;
			}
			if(_scale != 1){
				dobj.scaleX = dobj.scaleY = _scale;
			}
			addItem(getId(),dobj,-1);
			markFunComplete();
		}
		//显示弹出框的图片
		public static function showPopUpPics(_name:*,_x:*=0,_y:*=0,_width:*=0,_height:*=0,_scale:*=1):void{
			trace("show pop up picture");
			var r:int =int(Math.random()*3);
			switch(r){
				case 0:
					_name = "present";
					break;
				case 1:
					_name = "goldCoins";
					break;
				case 2:
					_name = "pet";
					break;
			}
			var bg:Class = AssetTool.getCurrentLibClass(_name);
			var dobj:DisplayObject = new bg;
			if(_x!=0){
				dobj.x = _x;
			}
			if(_y!=0){
				dobj.y = _y;
			}
			if(_width !=0){
				dobj.width = _width;
			}
			if(_height!=0){
				dobj.height = _height;
			}
			if(_scale != 1){
				dobj.scaleX = dobj.scaleY = _scale;
			}
			addItem(getId(),dobj,-1);
			markFunComplete();
		}
		
		//测试动画效果。。。。
		private static var maskShape:Shape;
		private static var maskShapeArr:Array = [];
		public static function tweenPicture(_name:*,_x:*,_y:*,direction:*="right",scale:*=1,_time:*=0.5):Sprite{
//			var imageClass:Class = Class(ModuleUtils.getModuleClass(_name));
			var imageClass:Class = AssetTool.getCurrentLibClass(_name);
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
					TweenLite.to(maskShape,_time,{height:image.height,onComplete:markFunComplete});
					break;
				case "right":
					TweenLite.to(maskShape,_time,{width:image.width,onComplete:markFunComplete});
					break;
			}
			return sp;
		}
		
		//显示弹出框的动画
		private static var mcPlayTimes:int;
		private static var mcCurrentTimes:int;
		private static var animationObj:MovieClip;
		public static function showMC(_name:*,_x:*=0,_y:*=0,_width:*=0,_height:*=0,playTimes:*=int.MAX_VALUE):void{
			var _mcName:String = _name;
			if(String(_name).indexOf("[")!=-1 && String(_name).indexOf("]")!=-1){
				var s:int = String(_name).indexOf("[");
				var e:int = String(_name).indexOf("]");
				var subStr:String = String(_name).substring(s+1,e);
				var mcArray:Array = subStr.split(",");
				var index:int = Math.random()*mcArray.length;
				_mcName = mcArray[index];
			}
			
			mcPlayTimes = playTimes;
			var animation:Class = AssetTool.getCurrentLibClass(_mcName);
			animationObj = new animation;
			animationObj.name = "fireworksAnim";
			animationObj.addFrameScript(animationObj.totalFrames-1,addLastFrameScript);
			animationObj.addEventListener(Event.COMPLETE,countNum);
			animationObj.addEventListener(Event.REMOVED_FROM_STAGE,removeMCHandler);
			
			var sp:Sprite = new Sprite;
			sp.name = "fireworksContainer";
			sp.addChild(animationObj);
			sp.x = _x;
			sp.y = _y;
			
			if(_width !=0){
				sp.width = _width;
			}
			if(_height!=0){
				sp.height = _height;
			}
			addItem(getId(),sp,-1);
		}
		private static function removeMCHandler(e:Event):void{
			MovieClip(e.target).stop();
			MovieClip(e.target).removeEventListener(Event.REMOVED_FROM_STAGE,removeMCHandler);
			MovieClip(e.target).addFrameScript(MovieClip(e.target).totalFrames-1,null);
			MovieClip(e.target).removeEventListener(Event.COMPLETE,countNum);
		}
		private static function stopMC():void{
			
		}
		private static function countNum(e:Event):void{
			mcCurrentTimes++;
			if(mcCurrentTimes>=mcPlayTimes){
				trace("影片剪辑播放了"+mcCurrentTimes+"次");
				MovieClip(e.target).gotoAndStop(1);
				mcCurrentTimes=0;
				mcPlayTimes=0;
				MovieClip(e.target).parent.removeChild(MovieClip(e.target));
				markFunComplete();
			}
		}
		
		//浩华加的播放
		public static function playAnimation(mcName:String,x:Number,y:Number,loopTime:int=1):void{
			
			
			var c:Class = AssetTool.getCurrentLibClass(mcName) as Class;
			var mc:MovieClip = new c;
			player = new AnimationPlayer();
			var ani:Animation = AnimationBuilder.importDisplayObject(mc,60);
			player.addAnimation("deafult",ani);
			
			TweenLite.to(player,Number.MAX_VALUE,{onUpdate:updateAnimation});
			
			holder.addChild(player);
			aniLoopTimeCnt = 1;
			aniLoopTime = loopTime;
			player.x = x;
			player.y = y;
			if(loopTime==0){
				markFunComplete();
			}else{
				player.addEventListener(AnimationEvent.CHANGE,playerEndHandle);
			}
		}
		private static function updateAnimation():void{
			if(player){
				player.update(60);
			}
		}
		private static function playerEndHandle(event:AnimationEvent):void{
			(event.target as AnimationPlayer).removeEventListener(AnimationEvent.CHANGE,playerEndHandle);
			holder.removeChild(event.target as AnimationPlayer);
			TweenLite.killTweensOf(event.target);
			if(aniLoopTimeCnt<aniLoopTime||aniLoopTime==0&&aniLoopTime!=1){
				var cplayer:AnimationPlayer = player.copy();
				cplayer.x = player.x;
				cplayer.y = player.y;
				holder.addChild(cplayer);
				cplayer.addEventListener(AnimationEvent.CHANGE,playerEndHandle);
				player = cplayer;
				TweenLite.to(player,Number.MAX_VALUE,{onUpdate:updateAnimation});
				aniLoopTimeCnt++;
				
			}else if(aniLoopTimeCnt==aniLoopTime){
				TweenLite.killTweensOf(player);
				markFunComplete();
				player = null;
			}
		}
		
		private static var player:AnimationPlayer;
		private static var aniLoopTime:int;
		private static var aniLoopTimeCnt:int;
		
		private static function addLastFrameScript():void{
			var sp:Sprite;
			if(holder.getChildByName("fireworksContainer")){
				sp = Sprite(holder.getChildByName("fireworksContainer"));
				var e:Event = new Event(Event.COMPLETE);
				var mc:MovieClip = MovieClip(sp.getChildByName("fireworksAnim"));
				mc.dispatchEvent(e);
			}
		}
		//测试动画停止
		public static function killTweenImage():void{
			for(var i:int;i<maskShapeArr.length;i++){
				TweenLite.killTweensOf(maskShapeArr[i]);
			}
			maskShapeArr = [];
			maskShape = null;
		}
		
		/**-----------------------------------------------声音相关函数-----------------------------------------------------------------*/
		private static var bgSound:Sound;
		private static var bgSoundChannel:SoundChannel;
		private static var bgSoundTransform:SoundTransform;
		public static function playBgSound(_name:*,_volume:*=1):void{
			if(bgSoundChannel){
				bgSoundChannel.stop();
			}
			bgSound = getSound(_name);
			bgSoundChannel = bgSound.play(0,int.MAX_VALUE);
			bgSoundTransform = new SoundTransform;
			bgSoundTransform.volume = _volume;
			bgSoundChannel.soundTransform = bgSoundTransform;
			markFunComplete();
		}
		private static var foreSound:Sound;
		private static var foreSoundChannel:SoundChannel;
		private static var foreSoundTransform:SoundTransform;
		public static function playForSound(_name:*,_volume:*=1,_times:*=1):void{
			if(foreSoundChannel){
				foreSoundChannel.stop();
			}
			if(_times==0){
				_times = int.MAX_VALUE;
			}
			foreSound = getSound(_name);
			foreSoundTransform = new SoundTransform;
			foreSoundTransform.volume = _volume;
			foreSoundChannel = foreSound.play(0,_times,foreSoundTransform);
			markFunComplete();
		}
		//阅读正确、错误提示。
		public static function playTipSound(_name:String):void{
			var sc:Class = ModuleUtils.getModuleClass(_name) as Class;
			var sound:Sound = new sc;
			sound.play();
			markFunComplete();
		}
		private static var soundButtonURL:String;
		private static var playSoundFrom:int=0;
		private static var playSoundTo:int=0;
		private static var playDuration:int = 0;
		public static function playSoundByMS(_name:*,_x:*,_y:*,_playFrom:*,_duration:*,playImmediately:int):void{
			soundButtonURL = _name;
			playSoundFrom = _playFrom;
			playDuration = _duration;
			var btn:MCButton = new MCButton(Class(ModuleUtils.getModuleClass("speakerUp")),Class(ModuleUtils.getModuleClass("speakerDown")),null,null);
			btn.x = _x;
			btn.y = _y;
			btn.addEventListener(MouseEvent.CLICK,listener);
			btn.addEventListener(Event.REMOVED,removedHandler);
			holder.addChild(btn);
			if(playImmediately>0){
				listener(null);
			}
			markFunComplete();
		}
		private static function countMiliseconds(form:String):int{
			var startP:Array = String(form).split(":");
			var len:int = 0;
			var i:int=0;
			var len0:Number=0;
			
			for ( i=0;i<=startP.length-2;i++){
				len0 = len0*60+Number(startP[i]);
			}
			len = int((len0*60+Number(startP[i]))*1000);
			return len;
		}
		//绘本基本用小时：分钟：秒数.毫秒
		public static function playSoundByTimeFormat(_name:*,_x:*,_y:*,_playFrom:*,_playTo:*,playImmediately:int):void{
			soundButtonURL = _name;
			playSoundFrom = countMiliseconds(_playFrom);
			playSoundTo =countMiliseconds(_playTo);
			
			var btn:MCButton = new MCButton(Class(ModuleUtils.getModuleClass("speakerUp")),Class(ModuleUtils.getModuleClass("speakerDown")),null,null);
			btn.x = _x;
			btn.y = _y;
			btn.addEventListener(MouseEvent.CLICK,listener2);
			btn.addEventListener(Event.REMOVED,removedHandler2);
			holder.addChild(btn);
			if(playImmediately>0){
				listener2(null);
			}
			markFunComplete();
		}
		public static function removedHandler(e:Event):void{
			e.target.removeEventListener(Event.REMOVED,removedHandler);
			e.target.removeEventListener(MouseEvent.CLICK,listener);
		}
		public static function removedHandler2(e:Event):void{
			e.target.removeEventListener(Event.REMOVED,removedHandler2);
			e.target.removeEventListener(MouseEvent.CLICK,listener2);
		}
		private static function listener(e:MouseEvent):void{
			playMusic(soundButtonURL,playSoundFrom,playDuration);
			//			playSoundFrom = 0;
			//			playSoundTo = 0;
			trace("click button");
		}
		private static function listener2(e:MouseEvent):void{
			playMusic(soundButtonURL,playSoundFrom,playSoundTo-playSoundFrom);
		}
		private static var gsound:Sound;
		public static function playMusic(_name:*,_start:*,_duration:*):void{
			gsound = getSound(_name);
			if(!gsound){
				return;
			}
			playSound(gsound,_start,_duration);
		}
		
		public static var soundChannel:SoundChannel;
		private static var soundId:uint;
		public static function playSound(sound:Sound,start:Number,_duration:Number):void{
			stopSound();
			soundChannel = sound.play(start);
	
			if(_duration!=0){
				soundId = setTimeout(stopSound,_duration);
			}
		}
		public static function stopSound():void{
			clearTimeout(soundId);
			
			if(soundChannel){
				soundChannel.stop();
				soundChannel = null;
			}
			
			if(foreSoundChannel){
				foreSoundChannel.stop();
				foreSoundChannel = null;
			}
		}
		public static function killSound():void{
			stopSound();
			if(gsound){
				try{
					gsound.close();
				}catch(e:Error){
					
				}
				gsound = null;
			}
			if(foreSound){
				try{
					foreSound.close();
				}catch(e:Error){
					
				}
				foreSound = null;
			}
		}
		public static function getSound(className:String):Sound{
			
			if(!AssetTool.hasLibClass(className)){
				return null;
			}
			var c:Class = AssetTool.getCurrentLibClass(className);
			
			
			
			return new c;
		}
		
		/**----------------------------------------------------其他函数---------------------------------------------------------------------*/
		private static var isSetMouseXY:Boolean=false;
		private static var xyText:TextField;
		private static var mx:*;
		private static var my:*;
		public static function showMouseXY(_x:*,_y:*):void{
			if(!isSetMouseXY){
				isSetMouseXY = true;
			}
			mx = _x;
			my = _y;
			markFunComplete();
			
		}
		private static function showMouseXY2():void{
			if(isSetMouseXY){
				xyText = new TextField;
				xyText.x = mx;
				xyText.y = my;
				holder.addChild(xyText);
/*				if(MyUtils.view.hasEventListener(MouseEvent.MOUSE_MOVE)){
					return;
				}
				MyUtils.view.addEventListener(MouseEvent.MOUSE_MOVE,getXY);
*/			}
		}
		private static function getXY(e:MouseEvent):void{
			/*if(xyText){
				xyText.text = int(MyUtils.view.mouseX)+","+int(MyUtils.view.mouseY);
			}else{
				if(MyUtils.view){
					if(MyUtils.view.hasEventListener(MouseEvent.MOUSE_MOVE)){
						MyUtils.view.removeEventListener(MouseEvent.MOUSE_MOVE,getXY);
					}
				}
			}*/
		}
		public static function executeFunction(f:Function,para:Array):void{
			f.apply(null,para);
		}
		public static function delay(time:Number):void{
			TweenLite.delayedCall(time,markFunComplete);
		}
		
		/**学单词用到  ----*/
		/*public static function setPopUpButtonPosition(_name:*,_x:*,_y:*):void{
			trace("setPopUpButtonPositon:  "+_name);
			var evt:PopUpButtonEvent;
			if(_name=="confirm"){
				evt = new PopUpButtonEvent(WordLearningViewMediator.SET_POPUP_CONFIRM,true,false,Number(_x),Number(_y));
			}else if(_name=="close"){
				evt = new PopUpButtonEvent(WordLearningViewMediator.SET_POPUP_CLOSE,true,false,Number(_x),Number(_y));
			}
			LayoutToolUtils.holder.dispatchEvent(evt);
			markFunComplete();
		}
		public static function enabledPopUpButton(s:*):void{
			trace("enabledPopUpButton");
			LayoutToolUtils.holder.dispatchEvent(new Event(WordLearningViewMediator.ENABLE_POPUP_BUTTON));
			markFunComplete();
		}*/
		
		//-------------------------------------------基本函数-------------------------------------------------------------------------------
		public static function createButton(id:*,_x:int,_y:int,upSkin:Class,downSkin:Class,overSkin:Class,disableSkin:Class,listener:Function):void{
			var btn:MCButton = new MCButton(upSkin,downSkin,overSkin,disableSkin);
			btn.x = _x;
			btn.y = _y;
			btn.addEventListener(MouseEvent.CLICK,listener);
			addObj(id,btn);
			holder.addChildAt(btn,id);
		}
		public static function killListenner(id:*,listener:Function):void{
			var btn:DisplayObject = getObj(id);
			if(btn){
				btn.removeEventListener(MouseEvent.CLICK,listener);
			}
		}
		public static function setListenner(id:*,listener:Function):void{
			var btn:DisplayObject = getObj(id);
			btn.addEventListener(MouseEvent.CLICK,listener);
		}
		public static function setPosition(id:*,x:int,y:int):void{
			var btn:DisplayObject = getObj(id);
			btn.x = x;
			btn.y = y;
		}
		public static function addItem(id:*,obj:DisplayObject,index:int):void{
			addObj(id,obj);
			if(index<0){
				holder.addChild(obj);
			}else{
				holder.addChildAt(obj,index);
			}
		}
		public static function removeItem(id:*):void{
			holder.removeChild(getObj(id));
			delete LayoutToolUtils.holderObjs[String(id)];	
		}
		private static function addObj(id:String,obj:DisplayObject):void{
			LayoutToolUtils.holderObjs[id] = obj;
		}
		public static function getObj(id:String):DisplayObject{
			return LayoutToolUtils.holderObjs[id];
		}
		private static function markFunComplete():void{
			if(!manual){
				LayoutToolUtils.queue.dispatcher.dispatchEvent(new FunctionQueueEvent(FunctionQueueEvent.FUNCTION_COMPLETE));
			}
		}
		public static function initPage():void{
			//填空、选择题 答案清空
			TypeTool.practiceAnswerArray = [];
			TypeTool.practiceAnswerIndex = 0;
			TypeTool.exerciseAnswerIndex = 0;
			
			manual = true;
			
			//kill掉delay函数的delayCall()
			TweenLite.killDelayedCallsTo(markFunComplete);
			
			mainHolder = new Sprite();
			
			holder = mainHolder;
			
			if(LayoutToolUtils.holder){
				LayoutToolUtils.holder.addChild(holder);
			}
			if(isSetAllSameColor){
				showBackground(backgroundX,backgroundY,backgroundWidth,backgroundHeight,backgroundColor);
			}
			manual = false;
			trace("initPage  ***********************");
		}
		public static function completePage():void{
			manual = true;
			showMouseXY2();
			manual = false;
			trace("completePage  ***********************");
		}
		public static function clearMainHolder():void{
			if(mainHolder){
				mainHolder.removeChildren();
			}
		}
		public static function clearSubHolder():void{
			if(subHolder){
				subHolder.removeChildren();
			}
		}
		//
		public static function reset():void{
			ExerciseTool.currentIndex = 1;
			isSetMouseXY = false;
			backgroundX=0;
			backgroundY=0;
			backgroundWidth=300;
			backgroundHeight=300;
			backgroundColor=0;
			isSetAllSameColor = false;
			maskShape = null;
			maskShapeArr = [];
			mcPlayTimes = 0;
			mcCurrentTimes = 0;
			animationObj = null;
			soundButtonURL = null;
			if(bgSoundChannel){
				bgSoundChannel.stop();
			}
			bgSoundChannel = null;
			bgSound = null
			bgSoundTransform = null;
			if(foreSoundChannel){
				foreSoundChannel.stop();
			}
			foreSoundChannel = null;
			foreSound = null;
			foreSoundTransform = null;
			playSoundFrom =0;
			playSoundTo =0;
			playDuration = 0;
			gsound = null;
			if(soundChannel){
				soundChannel.stop()
			}
			soundChannel = null;
			xyText = null;
			mx = 0;
			my = 0;
			TweenLite.killTweensOf(player);
			player = null;
			aniLoopTime = 0;
			aniLoopTimeCnt = 0;
			pannel = null;
			
			TypeTool.reset();
		}
		/*public static function formula(text:String):void{
			trace(text);
			var xml:XML = XML(LatexConvertor.convertToMathML(text));
			var f:File = File.documentsDirectory.resolvePath(Global.localPath);
			var mathML:MathML = new MathML(xml, f.url);
			
			var style:Style = new Style();
			style.size= 24;
			style.mathvariant = "normal";
			style.color = "#000000";
			
			pannel = new Sprite()
			LayoutToolUtils.holder.addChild(pannel);
			mathML.drawFormula(pannel, style, callbackFunct);
		}*/
		private static var pannel:Sprite; 
		public static function callbackFunct(r:Rectangle):void{
			trace("callbackFunct:" + r);
			pannel.x = (550-r.width)/2;
			pannel.y = (400-r.height)/2;
		}
		private static var drawSprite:Sprite;
		private static var drawSpriteX:int=0;
		private static var drawSpriteY:int=0;
		public static function formula2(text:String,type:String,x:int,y:int):void{
			
		}
		private static function drawCallBack(p:*):void{
			
			var data:BitmapData = new BitmapData(p.width,p.height);
			var matrix:Matrix = new Matrix;
			matrix.translate(p.x,-p.y);
			data.draw(drawSprite,matrix);
			
			var bitmap:Bitmap = new Bitmap(data);
			bitmap.x = drawSpriteX;
			bitmap.y = drawSpriteY;
			LayoutToolUtils.holder.addChild(bitmap);
			
			TweenLite.delayedCall(0.1,markFunComplete)
//			markFunComplete();
		}
	}
}
