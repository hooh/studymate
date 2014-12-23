package com.mylib.game.charater
{
	import com.byxb.utils.centerPivot;
	import com.greensock.TweenLite;
	import com.mylib.framework.utils.CacheTool;
	import com.studyMate.world.controller.CreateCharaterCommand;
	import com.studyMate.world.model.vo.CharaterSuitsVO;
	import com.studyMate.world.model.vo.EquipmentItemVO;
	import com.studyMate.world.model.vo.SuitEquipmentVO;
	import com.studyMate.world.model.vo.SuitVO;
	
	import flash.utils.Dictionary;
	
	import akdcl.skeleton.Armature;
	import akdcl.skeleton.Bone;
	import akdcl.skeleton.export.TextureMix;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class ActorMediator extends Mediator implements IMediator,IAnimatable,IActor
	{
		public static var NAME:String="ActorMediator";
		
		private var armature:Armature;
		public var armatureClip:Sprite;
		
		private var suitVO:SuitVO = new SuitVO();
		
		public function stopMove():void
		{
			// TODO Auto Generated method stub
			TweenLite.killTweensOf(view);
		}
		
		
		private var _costumes:Object;
		
		public function start():void
		{
			if(!_juggler.contains(this)){
				_juggler.add(this);
			}
		}
		
		public function stop():void
		{
			if(_juggler.contains(this)){
				_juggler.remove(this);
			}
		}
		
		
		private var movs:Vector.<starling.display.MovieClip>;
		
		public var profile:CharaterSuitsVO;
		private var _juggler:Juggler;
		private var _skeletonId:String;
		private var equipment:Dictionary;
		private var texturemix:TextureMix;

		
		public function ActorMediator(charaterName:String,charaterSuit:CharaterSuitsVO,_skeletonId:String,viewComponent:Object,_juggler:Juggler,texture:TextureMix)
		{
			this._juggler = _juggler;
			this._skeletonId= _skeletonId;
			this.texturemix = texture;
			profile = charaterSuit;
			super(charaterName, viewComponent);
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.handleNotification(notification);
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return super.listNotificationInterests();
		}
		
		override public function onRegister():void
		{
			armature = CreateCharaterCommand.createArmature(_skeletonId, _skeletonId, texturemix,profile);
			armatureClip = armature.getDisplay() as Sprite;
			equipment= new Dictionary(true);
			view.addChild(armatureClip);
			
			start();
			
			dressUp();
			
		}
		
		public function playAnimation(_to:Object, _toFrames:uint, _listFrames:uint=0, _loop:Boolean=false):void{
			armature.animation.playTo(_to,_toFrames,_listFrames,_loop);
		}
		
		public  function dressUp():void{
			var holder:DisplayObjectContainer;
			for each (var i:SuitEquipmentVO in profile.equipments) 
			{
				
				var bone:Bone = armature.getBone(i.bone);
				var body:DisplayObject;
//				if(SuitEquipmentVO.STATIC==i.type&&bone.display is DisplayObjectContainer){
				if(bone.display is DisplayObjectContainer){
					holder = bone.display as DisplayObjectContainer;
					body = holder.getChildByName(holder.name);
				}else{
					holder = new Sprite();
					body = bone.display as DisplayObject;
					armature.addBone(i.bone,null,holder);
					body.x = 0;
					body.y = 0;
					body.rotation=0;
					
					if(body){
						holder.addChild(body);
					}
					
					bone.display = holder;
				}
				var eq:DisplayObject;
				if(SuitEquipmentVO.STATIC==i.type){
					eq = CreateCharaterCommand.getTextureDisplay(texturemix,i.data);
//					eq = CreateCharaterCommand.getTextureDisplay(Assets.equipmentTexture,i.data);
					if(i.color==i.color && eq){
						(eq as Image).color = i.color;
					}
					
				}else{
					eq = new Sprite;
				}
				//装备不存在，不穿
				if(eq){
					eq.x = i.x;
					eq.y = i.y;
					eq.name = i.name;
					
					if(i.order>=0){
						holder.addChildAt(eq,holder.numChildren);
					}else{
						holder.addChildAt(eq,0);
					}
				}
				

				if(i.items){
					for each (var k:EquipmentItemVO in i.items) 
					{
						addCostume(i.bone,k);
					}
				}
			}
		}
		public function dressDown():void{
			var holder:DisplayObjectContainer;
			for each (var i:SuitEquipmentVO in profile.equipments) 
			{
				var bone:Bone = armature.getBone(i.bone);
				var body:DisplayObject;
				//删除装备，保留bone贴图
				if(bone.display is DisplayObjectContainer){
					holder = bone.display as DisplayObjectContainer;
					body = holder.getChildByName(holder.name);
					
					if(body){
						while(holder.numChildren>1){
							if(holder.getChildIndex(body) == 0)
								holder.removeChildAt(1,true);
							else
								holder.removeChildAt(0,true);
						}
					}else{
						holder.removeChildren(0,-1,true);
					}
				}
				
				//删除表情贴图数据
				if(i.items){
					for each (var k:EquipmentItemVO in i.items) 
					{
						if(equipment[k]){
							(_costumes[i.bone][k.name] as DisplayObject).removeFromParent(true);
							delete equipment[k];
						}
					}
					_costumes = null;
				}
			}
			
			var j:int=0;
			while(view.numChildren>1){
				if(view.getChildAt(j)!=armatureClip){
					view.removeChildAt(j);
				}else{
					j++;
					
				}
			}
			
		}
		
		
		
		public function removeBoneDisplay(boneName:String):void
		{
			var bone:Bone = armature.getBone(boneName);
			(bone.display as DisplayObject).removeFromParent(true);
			bone.display = null;
			
			profile.bones[boneName]="";
			//删除骨骼关联的所有装备
			var len:int = profile.equipments.length;
			for(var i:int=0;i<len;i++){
				if(profile.equipments[i].bone == boneName){
					profile.equipments.splice(i,1);
					len--;
					i--;
				}
			}
		}
		
		public function addFace(faceSuitEquipmentVo:SuitEquipmentVO):void{
			var holder:DisplayObjectContainer;
			
			var bone:Bone = armature.getBone(faceSuitEquipmentVo.bone);
			
			var body:DisplayObject;
			if(bone.display is DisplayObjectContainer){
				holder = bone.display as DisplayObjectContainer;
				body = holder.getChildByName(holder.name);
			}else{
				holder = new Sprite();
				body = bone.display as DisplayObject;
				armature.addBone(faceSuitEquipmentVo.bone,null,holder);
				body.x = 0;
				body.y = 0;
				body.rotation=0;
				
				if(body){
					holder.addChild(body);
				}
				bone.display = holder;
			}
			
			var eq:DisplayObject;
			if(SuitEquipmentVO.PACK==faceSuitEquipmentVo.type){
				eq = new Sprite;
			}
			//装备不存在，不穿
			if(eq){
				eq.x = faceSuitEquipmentVo.x;
				eq.y = faceSuitEquipmentVo.y;
				eq.name = faceSuitEquipmentVo.name;
//				eq.faceName = faceSuitEquipmentVo.faceName;
				
				if(faceSuitEquipmentVo.order>=0){
					holder.addChildAt(eq,holder.numChildren);
				}else{
					holder.addChildAt(eq,0);
				}
			}
			
			
			if(faceSuitEquipmentVo.items){
				for each (var k:EquipmentItemVO in faceSuitEquipmentVo.items) 
				{
					addCostume(faceSuitEquipmentVo.bone,k);
				}
			}
			
			
			var suitEqVO:SuitEquipmentVO = new SuitEquipmentVO();
			suitEqVO.name = faceSuitEquipmentVo.name;
			suitEqVO.faceName = faceSuitEquipmentVo.faceName;
			suitEqVO.order = faceSuitEquipmentVo.order;
			suitEqVO.type = faceSuitEquipmentVo.type;
			suitEqVO.x = faceSuitEquipmentVo.x;
			suitEqVO.y = faceSuitEquipmentVo.y;
			suitEqVO.bone = faceSuitEquipmentVo.bone;
			suitEqVO.items = faceSuitEquipmentVo.items.concat();
			
			profile.equipments.push(suitEqVO);
		}
		
		public function addCostume(boneName:String, eqItem:EquipmentItemVO):void
		{
			
			_costumes||=new Object();
			_costumes[boneName]||={};
			_costumes[boneName][eqItem.name]||={};
			var texture:Texture;
			if(eqItem.type==SuitEquipmentVO.DYNAMIC){
				var textures:Vector.<Texture> = new Vector.<Texture>;
				
				for each (var i:String in eqItem.data) 
				{
					if(CacheTool.has(NAME,i)){
						texture = CacheTool.getByKey(NAME,i) as Texture;
					}else{
						texture = CreateCharaterCommand.getTexture(texturemix,i);
						CacheTool.put(NAME,i,texture);
					}
					textures.push(texture);
				}
				
				var newMov:starling.display.MovieClip = new starling.display.MovieClip(textures, eqItem.rate);
				_costumes[boneName][eqItem.name]=newMov;
				for(var j:String in eqItem.duration)
				{
					newMov.setFrameDuration(parseInt(j),eqItem.duration[j]);
				}
			}else{
				
				if(CacheTool.has(NAME,eqItem.data[0])){
					texture = CacheTool.getByKey(NAME,eqItem.data[0]) as Texture;
				}else{
					
					texture = CreateCharaterCommand.getTexture(texturemix,eqItem.data[0]);
					if(texture == null)
						texture = CreateCharaterCommand.getTexture(texturemix,"face_face1");
				}
				_costumes[boneName][eqItem.name]=new Image(texture);
			}
			
			
			var costume:DisplayObject=_costumes[boneName][eqItem.name] as DisplayObject;
			costume.name=eqItem.name;
			centerPivot(costume);
			
		}
		
		public function removeBoneDisplayItem(boneName:String, itemName:String):void
		{
			var bone:Bone = armature.getBone(boneName);
			
			if(bone.display is DisplayObjectContainer){
				
				var item:DisplayObject=	(bone.display as DisplayObjectContainer).getChildByName(itemName);
				
				if(item){
					item.removeFromParent(true);
					
					//若是脸，则删除脸部item
					if(itemName == "face"){
						for each (var j:SuitEquipmentVO in profile.equipments) 
						{
							//删除表情贴图数据
							if(j.items){
								for each (var k:EquipmentItemVO in j.items) 
								{
									if(equipment[k]){
										(_costumes[boneName][k.name] as DisplayObject).removeFromParent(true);
										delete equipment[k];
									}
								}
							}
						}
						
					}
				}
			}

			var len:int = profile.equipments.length;
			for(var i:int=0;i<len;i++){
				if(profile.equipments[i].name == itemName){
					profile.equipments.splice(i,1);
					break;
				}
			}
		}
		
		
		public function switchCostume(boneName:String,equipmentName:String,itemName:String,loop:Boolean = true):void
		{
			if(!_costumes){
				return;
			}
			
			//stop the current costume from animating 
			var bone:Bone = armature.getBone(boneName);
			var boneEquipment:SuitEquipmentVO;
			movs||=new Vector.<starling.display.MovieClip>;
			
			for each (var i:SuitEquipmentVO in profile.equipments) 
			{
				if(i.bone==boneName&&i.name==equipmentName){
					boneEquipment = i;
					for each (var j:EquipmentItemVO in boneEquipment.items) 
					{
						if(equipment[j]&&j.name!=itemName){
							if(_costumes[boneName][j.name] is starling.display.MovieClip){
								var idx:int = movs.indexOf(_costumes[boneName][j.name]);
								if(idx>=0){
									movs.splice(idx,1);
								}
							}
							
							
							(_costumes[boneName][j.name] as DisplayObject).removeFromParent(true);
							delete equipment[j];
						}else if(j.name==itemName){
							if(equipment[j]){
								//相同装备退出
								return;
							}else{
								equipment[j] = true;
							}
						}
					}
					break;
				}
			}
			
			if(_costumes[boneName][itemName] is starling.display.MovieClip){
				movs.push(_costumes[boneName][itemName]);
				(_costumes[boneName][itemName] as starling.display.MovieClip).loop = loop;
			}
			
			((bone.display as Sprite).getChildByName(equipmentName) as DisplayObjectContainer).addChild(_costumes[boneName][itemName] as DisplayObject);
			
			
			
		}
		
		public function addBoneDisplay(boneName:String, _display:DisplayObject,textureId:String,orderId:int):void
		{
			var bone:Bone = armature.getBone(boneName);
			var body:DisplayObject;
			if(!bone.display){
				armature.addBone(boneName,null,_display);
				suitVO.bone = boneName;
				suitVO.id = textureId;
				profile.bones[boneName]=suitVO;
			}else{
				var holder:DisplayObjectContainer;
				//骨骼是sprite,直接addchile
				if(bone.display is DisplayObjectContainer){
					holder = bone.display as DisplayObjectContainer;

					body = holder.getChildByName(holder.name);
					
					
				}
				//非sprite,创建sprite包含原来的骨骼贴图，将新的装备addChile
				else{
					holder = new Sprite();
					body = bone.display as DisplayObject;
					armature.addBone(boneName,null,holder);
					
					holder.addChild(body);
					body.x=0;
					body.y=0;
					body.rotation=0;
					bone.display = holder;
					
				}
				
				if(orderId>=0){
					holder.addChildAt(_display,holder.numChildren);
				}else{
					holder.addChildAt(_display,0);
				}
				//将_display->EquipmentItemVO to myData.equipments
				var eqVO:EquipmentItemVO = new EquipmentItemVO();
				var suitEqVO:SuitEquipmentVO = new SuitEquipmentVO();
				
				if(_display is starling.display.MovieClip){
					
				}else{
					var img:Image = _display as Image;
					suitEqVO.name = img.name;
					suitEqVO.data = textureId;
					suitEqVO.order = orderId;
					suitEqVO.type = "s";
					suitEqVO.x = img.x;
					suitEqVO.y = img.y;
					suitEqVO.bone = boneName;
					
				}
				profile.equipments.push(suitEqVO);
			}
			
		}
		
		public function replaceBoneDisplay(boneName:String, _display:DisplayObject,textureId:String):void
		{
			
			var bone:Bone = armature.getBone(boneName);
			var t:DisplayObject = bone.display as DisplayObject;
			if(t is DisplayObjectContainer){
				var _t:DisplayObjectContainer = t as DisplayObjectContainer;
				var numChild:int = _t.numChildren;
				var holder:Sprite = new Sprite();
				for(var i:int=0;i<numChild;i++){
					if(_t.getChildAt(i).name == boneName)
						holder.addChild(_display);
					else{
						holder.addChild(_t.getChildAt(i));
						numChild--;
						i--;
					}
				}

				_display = holder;
				
			}

			var idx:int = t.parent.getChildIndex(t);
			t.removeFromParent(true);
			bone.display=null;
			armature.addBone(boneName,null,_display,idx);
			
			suitVO.bone = boneName;
			suitVO.id = textureId;
			profile.bones[boneName]="";
			profile.bones[boneName]=suitVO;
			
		}
		
		
		
		
		
		public function advanceTime(time:Number):void
		{
			
			armature.update();
			
			for each (var i:starling.display.MovieClip in movs) 
			{
				i.advanceTime(time);	
			}

		}
		
		public function getProfile():CharaterSuitsVO{
				return profile;
		}
		
		public function setProfile(_p:CharaterSuitsVO):void
		{
			profile = _p;
		}
		
		
		public function get view():Sprite{
			return getViewComponent() as Sprite;
		}
		
		override public function onRemove():void
		{
			_juggler.remove(this);
			dressDown();
			armature.remove();
			view.dispose();
			suitVO = null;
		}
		
		public function get display():Sprite
		{
			return armatureClip;
		}
		
	}
}