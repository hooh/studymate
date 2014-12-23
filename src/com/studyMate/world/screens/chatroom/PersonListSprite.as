package com.studyMate.world.screens.chatroom
{
	import com.studyMate.world.component.weixin.vo.WeixinVO;
	import com.studyMate.world.controller.vo.CharaterStateVO;
	import com.studyMate.world.model.vo.RelListItemSpVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class PersonListSprite extends Sprite
	{
		
		private var list:PersonList;
		private var relatVoList:Array = [];
		
		//分组
		private var rootList:Array = [];
		/**
		 * 存储分组在线人数 
		 */		
		private var rootMap:Dictionary = new Dictionary;
		
		private var _chatArr:Array = [];
		
		/**
		 * 标记需要提醒的id队列 
		 */		
		private var remindId:Array = [];
		
		public function PersonListSprite( volist:Array )
		{
			super();
			
			this.relatVoList = volist;
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init():void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			var bg:Image = new Image(Assets.getChatViewTexture("chatRoom/personListBg"));
			addChild(bg);
			
			list = new PersonList;
			list.y = 16;
			list.setWidth = 265;
			list.setHeight = 690;
			list.clipRect = new Rectangle(0,0,265,690);
			addChild(list);
			
			
			
			//分组目录
			var root:PersonListRootItem;
			var rootType:Array = getRootItems();
			for (var i:int = 0; i < rootType.length; i++) 
			{
				root = new PersonListRootItem(rootType[i]);
				root.addEventListener("RootItemClick",rootClickHandle);
				list.addItem(root);
				
				rootList.push(root);	//存储分组item
			}
			list.usePullRefresh = false;
			list.useBottomMore = false;
			
			//测试显示在线人数
			for (var j:int = 0; j < rootList.length; j++) 
			{
				var num:int = getNumByType((rootList[j] as PersonListRootItem).type);
				(rootList[j] as PersonListRootItem).updateNum(0,num);
				
			}
			
			
		}
		
		/**
		 * 根目录点击处理 
		 * @param e
		 * 
		 */		
		private function rootClickHandle(e:Event):void{
			var clickItem:PersonListRootItem = e.target as PersonListRootItem;
			
			doRootClick(clickItem);
			
		}
		private function doRootClick(_item:PersonListRootItem):void{
			var clickItem:PersonListRootItem = _item;
			
			//如果显示列表list.showlist 有 ：关闭    没有：打开
			//关闭、打开，都需要重新计算list.showlist 的 showIdx ，因为rootItem的位置发生变化
			
			var vo:ShowRootVo;
			for (var i:int = 0; i < list.showlist.length; i++) 
			{
				vo = list.showlist[i];
				if(clickItem.type == vo.showItem.type){	//有，关闭
					
					clickItem.closeRoot();
					closeItems(vo);
					updateShowlist(false,vo);
					//判断是否有消息，还有未读则闪烁
					if(remindType.length != 0 && remindType.indexOf(clickItem.type) != -1)
					{
						clickItem.isTips = true;
					}
					
					return;
				}
				
			}
			//没有，打开
			var newVo:ShowRootVo = new ShowRootVo(clickItem);
			if(clickItem.parent)
			{
				newVo.showIdx = clickItem.parent.getChildIndex(clickItem);
			}
			
			clickItem.isTips = false;
			clickItem.showRoot();
			showItems(newVo);
			updateShowlist(true,newVo);
			
			
		}
		
		/**
		 *  打开根目录，显示相应operId的item
		 * @param rootVo
		 * 
		 */		
		private function showItems(rootVo:ShowRootVo):void{
			rootVo.showLen = 0;
			
			var item:PersonListItem;
			var idx:int = rootVo.showIdx;
			for (var i:int = 0; i < relatVoList.length; i++) 
			{
				if((relatVoList[i] as RelListItemSpVO).relaType == rootVo.showItem.type){
					item = new PersonListItem(relatVoList[i]);
					item.addEventListener("PerItemClick",itemClickHandle);
					
					var r:Boolean = isRemind((relatVoList[i] as RelListItemSpVO).rstdId);
					var s:Boolean = isSetOn((relatVoList[i] as RelListItemSpVO).rstdId);
					
					//如果是消息提醒内的，则移至顶部
					if(r || s)
					{
						list.addItemAt(item,rootVo.showIdx+1);
						idx++;
						
						if(r)	item.isTips = true;
						if(s)	item.isOn = true;
						
					}else{
						list.addItemAt(item,++idx);
					}
					rootVo.showLen++;
					
				}
			}
			setListSelect();
		}
		/**
		 * 关闭根目录 
		 * @param rootVo
		 * 
		 */		
		private function closeItems(rootVo:ShowRootVo):void{
			var removeIdx:int = rootVo.showIdx + 1;
			for (var i:int = 0; i < rootVo.showLen; i++) 
			{
				list.removeItemAt(removeIdx, true);
			}
			
		}
		
		/**
		 * 刷新根目录显示配置  showlist.showIdx
		 * @param isOpen
		 * @param rootVo
		 * 
		 */		
		private function updateShowlist(isOpen:Boolean, rootVo:ShowRootVo):void{
			var tmpIdx:int = -1;
			var vo:ShowRootVo;
			for (var i:int = 0; i < list.showlist.length; i++) 
			{
				vo = list.showlist[i];
				if(vo == rootVo){
					tmpIdx = i;
					continue;
					
				}
				
				//关闭
				if(!isOpen && vo.showIdx>rootVo.showIdx){
					list.showlist[i].showIdx -= rootVo.showLen;
					
				}else if(isOpen && vo.showIdx>rootVo.showIdx){	//打开
					list.showlist[i].showIdx += rootVo.showLen;
					
				}
				
			}
			
			if(tmpIdx == -1){
				list.showlist.push(rootVo);
				
			}else{
				list.showlist.splice(tmpIdx,1);
				
			}
			
		}
		
		/**
		 * 用于根目录关闭，重新打开后，回复关闭前列表内的item选择 
		 * 
		 */		
		private function setListSelect():void{
			if(!clickItem)
			{
				return;
			}
			
			var item:DisplayObject;
			for (var i:int = 0; i < list.numItem; i++) 
			{
				item = list.getItemAt(i);
				if((item is PersonListItem) && (item as PersonListItem).relatVo.rstdId == clickItem.relatVo.rstdId)
				{
					(item as PersonListItem).isSelect = true;
					clickItem = item as PersonListItem;
					return;
				}
			}
			
		}
		
		/**
		 * 当前选择的item 
		 */		
		private var clickItem:PersonListItem;
		private function itemClickHandle(e:Event):void{
			
			doItemClick(e.target as PersonListItem);
			
		}
		public function doItemClick(_item:PersonListItem):void{
			if(clickItem){
				clickItem.isSelect = false;
				
			}
			var nowItem:PersonListItem = _item;
			nowItem.isSelect = true;
			
			clickItem = nowItem;
			clickItem.isTips = false;
			var rootvo:ShowRootVo = getShowRootVoByType(clickItem.relatVo.relaType);
			if(rootvo && rootvo.showItem)
				rootvo.showItem.isTips = false;
			this.dispatchEvent(new Event("PerListClick",false,_item));
			
			
		}
		
		
		public function selectPerson(_id:int):void{
			
			var _relVo:RelListItemSpVO;
			for (var i:int = 0; i < relatVoList.length; i++) 
			{
				if((relatVoList[i] as RelListItemSpVO).rstdId == _id.toString()){
					_relVo = relatVoList[i] as RelListItemSpVO;
					break;
				}
			}
			
			if(!_relVo)
			{
				return;
			}
			
			
			
			for (i = 0; i < rootList.length; i++) 
			{
				if((rootList[i] as PersonListRootItem).type == _relVo.relaType)
				{
					doRootClick(rootList[i] as PersonListRootItem);
					
					
					var item:DisplayObject;
					for (var j:int = 0; j < list.numItem; j++) 
					{
						item = list.getItemAt(j);
						if((item is PersonListItem) && (item as PersonListItem).relatVo.rstdId == _relVo.rstdId)
						{
							doItemClick(item as PersonListItem);
//							list.scrollToPosition(0,j*72,1);
							list.scrollToPosition(0,0,1);
							break;
						}
					}
					
					
					return;
				}
				
			}
			
			
			
			
			
		}
		
		private function getRelatvo(id:String):RelListItemSpVO{
			for (var k:int = 0; k < relatVoList.length; k++) 
			{
				if((relatVoList[k] as RelListItemSpVO).rstdId == id){
					return relatVoList[k] as RelListItemSpVO;
					
				}
			}
			return null;
		}
		
		
		
		/**
		 * 标记需要提醒的类型
		 */		
		private var remindType:Array = [];
		/**
		 * 设置消息提醒 
		 * @param chatArr
		 * 
		 */		
		public function set remind(chatArr:Array):void{
			_chatArr = chatArr;
			
			var remindArr:Array = [];
			var item:DisplayObject;
			
			remindId = [];
			remindType = [];
			for (var i:int = 0; i < chatArr.length; i++) 
			{
				remindId.push((chatArr[i] as WeixinVO).sedid);
			}
			
			
			
			for (i = 0; i < remindId.length; i++) 
			{
				for (var j:int = 0; j < list.numItem; j++) 
				{
					item = list.getItemAt(j);
					if((item is PersonListItem) && (item as PersonListItem).relatVo.rstdId == remindId[i])
					{
						//设置提醒
						remindArr.push(item);
						break;
					}
				}
				
				var _type:String = getRelatvo(remindId[i]).relaType;
				if(remindType.indexOf(_type) == -1)
				{
					remindType.push(_type);
					
					for (var p:int = 0; p < rootList.length; p++) 
					{
						if((rootList[p] as PersonListRootItem).type == _type)
						{
							(rootList[p] as PersonListRootItem).isTips = true;
							break;
						}
						
					}
					
				}
				
			}
			
			for (i = 0; i < remindArr.length; i++) 
			{
				var tmpItem:PersonListItem = remindArr[i] as PersonListItem;
				for (j = 0; j < list.showlist.length; j++) 
				{
					
					if(tmpItem.relatVo.relaType == list.showlist[j].showItem.type)
					{
						//如果没提醒，则提醒
						if(!tmpItem.isTips)
						{
							list.setItemIdx(tmpItem, list.showlist[j].showIdx+1);
							
//							tmpItem.isOn = true;
							tmpItem.isTips = true;
						}
						break;
					}
					
				}
				
			}
			
			
		}
		
		private function isRemind(id:String):Boolean
		{
			return remindId.indexOf(id) != -1;
		}
		private function isSetOn(id:String):Boolean{
			return onArr.indexOf(id) != -1;
		}
		
		/**
		 * 更新好友显示列表 
		 * @param relVo
		 * @param add
		 * 
		 */		
		public function updateVo(relVo:RelListItemSpVO, add:Boolean=true):void{
			
			if(!add)	//删除好友
			{
				for (var j:int = 0; j < list.numItem; j++) 
				{
					var tmp:DisplayObject = list.getItemAt(j);
					if((tmp is PersonListItem) && (tmp as PersonListItem).relatVo.rstdId == relVo.rstdId)
					{
						list.removeItemAt(j,true);
						break;
					}
				}
			}
			
			
			
			
			//处理list.showlist
			var relShowVo:ShowRootVo;
			for (var i:int = 0; i < list.showlist.length; i++) 
			{
				if(list.showlist[i].showItem.type == relVo.relaType)
				{
					relShowVo = list.showlist[i];
					
					if(add){//additem
						var item:PersonListItem = new PersonListItem(relVo);
						item.addEventListener("PerItemClick",itemClickHandle);
						list.addItemAt(item,(list.showlist[i].showIdx+list.showlist[i].showLen+1));
						
						list.showlist[i].showLen++;
						
					}else{
						list.showlist[i].showLen--;
						
					}
					
					break;
				}
			}
			
			if(relShowVo)
			{
				for (i = 0; i < list.showlist.length; i++) 
				{
					if((list.showlist[i].showItem.type != relShowVo.showItem.type) && (list.showlist[i].showIdx > relShowVo.showIdx))
					{
						if(add){
							list.showlist[i].showIdx++;
						}else{
							
							list.showlist[i].showIdx--;
						}
					}
				}
			}
			
			upOnNum();
		}
		
		
		//重置在线人数
		private function resetRootmap():void{
			for(var i:String in rootMap) 
			{
				rootMap[i] = 0;
			}
		}
		//更新在线人数
		private function upOnNum():void{
			for (var i:int = 0; i < rootList.length; i++) 
			{
				var numOn:int = rootMap[(rootList[i] as PersonListRootItem).type];
				var numTo:int = getNumByType((rootList[i] as PersonListRootItem).type);
				
				(rootList[i] as PersonListRootItem).updateNum(numOn,numTo);
			}
		}
		
		
		private var onArr:Array = [];
		
		/**
		 * 设置上线、离线 
		 * @param _onArr
		 * @param _offArr
		 * 
		 */		
		public function setOnOff(_onArr:Array, _offArr:Array):void{
			resetRootmap();
			
			var rootVo:ShowRootVo;
			var tmp:PersonListItem;
			
			onArr = [];
			onArr = _onArr.concat();
			
			for (var j:int = 0; j < _onArr.length; j++) 
			{
				for (var k:int = 0; k < relatVoList.length; k++) 
				{
					var _relVo:RelListItemSpVO = relatVoList[k] as RelListItemSpVO;
					if(_relVo.rstdId == _onArr[j])
					{
						//更新人数
						if(!rootMap[_relVo.relaType] || rootMap[_relVo.relaType] == null){
							rootMap[_relVo.relaType] = 0;
						}
						rootMap[_relVo.relaType]++;	
						
						//更新显示列表
						rootVo = getShowRootVoByType(_relVo.relaType);
						if(rootVo)
						{
							tmp = getItemByid(_onArr[j]);
							if(tmp)
							{
								tmp.isOn = true;
								tmp.visible = true;
								list.setItemIdx(tmp, rootVo.showIdx+1);
							}
						}
					}
				}
			}
			for (var i:int = 0; i < _offArr.length; i++) 
			{
				tmp = getItemByid(_offArr[i]);
				if(tmp)
				{
					tmp.isOn = false;
					rootVo = getShowRootVoByType(tmp.relatVo.relaType);
					if(rootVo)
					{
						//推到分组最下
						list.setItemIdx(tmp, rootVo.showIdx+rootVo.showLen);
					}
					
				}
			}
			upOnNum();
			
		}
		
		//根据operId取相应item
		private function getItemByid(_id):PersonListItem{
			if(!list){
				return null;
			}
			
			var item:DisplayObject;
			for (var i:int = 0; i < list.numItem; i++) 
			{
				item = list.getItemAt(i);
				if((item is PersonListItem) && (item as PersonListItem).relatVo.rstdId == _id)
				{
					return (item as PersonListItem);
				}
			}
			return null;
		}
		//根据item取其对应根目录
		private function getShowRootVoByType(type:String):ShowRootVo{
			if(!list){
				return null;
			}
			
			for (var i:int = 0; i < list.showlist.length; i++) 
			{
				if(type == list.showlist[i].showItem.type)
				{
					return list.showlist[i];
				}
				
			}
			return null;
		}
		
		
		
		/**
		 * 取当前分类的人数 
		 * @param type
		 * @return 
		 * 
		 */		
		private function getNumByType( type:String ):int{
			var num:int = 0;
			for (var i:int = 0; i < relatVoList.length; i++) 
			{
				if( (relatVoList[i] as RelListItemSpVO).relaType == type){
					
					num++;
				}
			}
			return num;
		}
		
		/**
		 * 取总共分类列表
		 * @return 
		 * 
		 */		
		private function getRootItems():Array{
			/*var roots:Array = [];
			var vo:RelListItemSpVO;
			
			for (var i:int = 0; i < relatVoList.length; i++) 
			{
				vo = relatVoList[i];
				if(roots.indexOf(vo.relaType) == -1){
					
					roots.push(vo.relaType);
					
				}
			}
			//排序== 我的好友 F-> 陌生人S  -> 其他
			roots.sort();*/
			
			var roots:Array = ["F", "S"];
			
			return roots;
		}
		
		public function get selectItem():PersonListItem{
			return clickItem;
		}
		
		public function get hadSelect():RelListItemSpVO{
			return clickItem ? clickItem.relatVo : null;
		}
		public function clearSelct():void{
			if(clickItem)
			{
				clickItem.isSelect = false;
				clickItem = null;
			}
		}
		
		
		
		override public function dispose():void
		{
			super.dispose();
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			removeChildren(0,-1,true);
		}
	}
}