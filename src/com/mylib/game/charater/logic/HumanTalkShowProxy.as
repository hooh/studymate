package com.mylib.game.charater.logic
{
	import com.greensock.TweenLite;
	import com.mylib.framework.utils.CacheTool;
	import com.mylib.game.charater.ActorBehavior;
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.IHuman;
	import com.mylib.game.charater.TalkPair;
	import com.mylib.game.charater.TalkSection;
	import com.mylib.game.charater.item.SpeakFrame;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.tcp.PackData;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import de.polygonal.core.ObjectPool;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class HumanTalkShowProxy extends Proxy
	{
		public static const NPC:String = "NPCTalkShowProxy";
		
		public static const PLAYER:String = "PlayerTalkShowProxy";
		
		/**
		 *最多的在讲话人对数 
		 */		
		protected var maxNum:uint = 2;
		
		
		protected var talkingPair:Dictionary;
		
		public function HumanTalkShowProxy(_name:String)
		{
			super(_name);
		}
		
		override public function onRegister():void
		{
			// TODO Auto Generated method stub
			super.onRegister();
			talkingPair = new Dictionary(true);
			
		}
		
		protected function filterXMLFile(item:File, index:int, array:Array):Boolean{
			if(item.extension=="xml"){
				return true;
			}
			
			return false;
			
		}
		
		public function findTopic():Vector.<TalkSection>{
			
			var file:File = Global.document.resolvePath(Global.localPath+"media/dialogue/english/");
			
			var topicList:Array = file.getDirectoryListing().filter(filterXMLFile);
			
			var chooseIdx:int = Math.random()*topicList.length;
			
			file = topicList[chooseIdx];
			
			
			if(CacheTool.has(NPC,file.name)){
			}else{
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.READ);
				var str:String = fs.readMultiByte(fs.bytesAvailable,PackData.BUFF_ENCODE);
				fs.close();
				var topic:XML = XML(str);
				CacheTool.put(NPC,file.name,parseTopicXML(topic));
			}
			return CacheTool.getByKey(NPC,file.name) as Vector.<TalkSection>;
		}
		
		public static function parseTopicXML(_xml:XML):Vector.<TalkSection>{
			
			var sections:XMLList = _xml.section;
			var result:Vector.<TalkSection> = new Vector.<TalkSection>;
			for (var i:int = 0; i < sections.length(); i++) 
			{
				var section:XML = sections[i];
				var talkSection:TalkSection = new TalkSection();
				var behaviors:XMLList = section.children();
				for (var j:int = 0; j < behaviors.length(); j++) 
				{
					var item:XML= behaviors[j];
					var behavior:ActorBehavior = new ActorBehavior();
					behavior.type = item.name().toString();
					behavior.data = item.text().toString();
					
					var attributes:XMLList = item.attributes();
					for each(var k:XML in attributes) 
					{
						behavior.parameters||={};
						behavior.parameters[k.name().toString()] = k.toString();
					}
						
					
					talkSection.addBehavior(behavior);
				}
				result.push(talkSection);
			}
			
			return result;
		}
		
		
		public function processDialogue(pair:TalkPair):void{
			talkingPair[pair] = true; 
			if(pair.sectionIdx<pair.dialogue.length){
				var speaker:IHuman;
				var listener:IHuman;
				var speakerDisplay:SpeakFrame;
				var listenerDisplay:SpeakFrame;
				var duration:Number;
				speakerDisplay = pair.frame;
				if((pair.sectionIdx&1)==0){
					//right
					speaker =  pair.player1;
					listener = pair.player2;
				}else{
					//left
					speaker =  pair.player2;
					listener = pair.player1;
				}
				
				pair.frame.removeFromParent();
				pair.feel.removeFromParent();
				
				
				if(pair.behaviorIdx<pair.dialogue[pair.sectionIdx].behaviors.length){
					var behavior:ActorBehavior = pair.dialogue[pair.sectionIdx].behaviors[pair.behaviorIdx];
					if(behavior.parameters&&behavior.parameters["duration"]){
						duration = parseFloat(behavior.parameters["duration"]);
					}else{
						duration = 3;
					}
					
					switch(behavior.type)
					{
						case ActorBehavior.ACTION:
						{
							try
							{
								var fun:Function = speaker[behavior.data];
								fun.apply();
							} 
							catch(error:Error) 
							{
								
							}
							pair.behaviorIdx++;
							
							TweenLite.to(pair,duration,{onComplete:processDialogue,onCompleteParams:[pair]});
							
							break;
						}
						case ActorBehavior.FEEL:{
							pair.feel.show(behavior.data,behavior.parameters);
							speaker.feel(pair.feel);
							pair.behaviorIdx++;
							
							TweenLite.to(pair,duration,{onComplete:processDialogue,onCompleteParams:[pair]});
							break;
						}
						case ActorBehavior.LOOK:{
							speaker.look(behavior.data);
							pair.behaviorIdx++;
							TweenLite.to(pair,duration,{onComplete:processDialogue,onCompleteParams:[pair]});
							
							break;
						}
						case ActorBehavior.SAY:{
							speaker.say(speakerDisplay);
							var sayText:String = behavior.data;
													
							if(pair.sentenceIdx<sayText.length){
								var sentenceEnd:int;							
								var char:String;
								var isEnd:Boolean;
								var words:Array;
								var wordsNum:int;
								
									
									for (var i:int = pair.sentenceIdx; i < sayText.length; i++) 
									{
										char = sayText.charAt(i);						
										if(char==","||char=="."||char=="?"||char=="!"||char=="，"||char=="。"||char=="？"||char=="！"){	
											isEnd = true;
										}
										
									if(isEnd){
										i++;
										speakerDisplay.text = sayText.substring(pair.sentenceIdx,i);																	
										pair.sentenceIdx = i;
										words = speakerDisplay.text.split(" ");
										wordsNum = words.length;
										if (wordsNum<4){
											duration = 2;
										}else {
											duration = 4;
										}	
										break;
									}
								}
									
								TweenLite.to(pair,duration,{onComplete:processDialogue,onCompleteParams:[pair]});
								
							}else{
								//end behavior
								pair.behaviorIdx++;
								processDialogue(pair);
							}
							
							
							break;
						}
						default:
						{
							pair.behaviorIdx++;
							processDialogue(pair);
							break;
						}
							
					}
					
				}else{
					//section end
					pair.sectionIdx++;
					pair.behaviorIdx=0;
					pair.sentenceIdx =0;
					processDialogue(pair);
				}
				
			}else{
				//dialogue end
				endDialogue(pair);
				delete talkingPair[pair];
			}
		}
		
		
		public function endDialogue(pair:TalkPair):void{
			pair.frame.removeFromParent(true);
			pair.feel.removeFromParent(true);
			TweenLite.killTweensOf(pair);
			pair.dispatchEvent(new Event(TalkPair.END_DIALOGUE_EVENT));
			pair.dispose();
			
		}
		
		public function endPlayerDialogue(charater:IHuman):void{
			
			for (var i:* in talkingPair) 
			{
				
				if(i.player1==charater||i.player2==charater){
					endDialogue(i);
					delete talkingPair[i];
					break;
				}
				
			}
			
		}
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			clean();
		}
		
		public function clean():void{
			for (var i:* in talkingPair) 
			{
				endDialogue(i);
			}
			
			talkingPair = new Dictionary(true);
			
		}
		
	}
}
