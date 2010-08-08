package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.vo.KalturaBaseEntry;
	
	import fl.data.DataProvider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;

	public class PlaylistList extends Sprite
	{
		public var ww:Number=100;
		public var hh:Number=100;
		private var cdn:String;
		//
		private var holder:Sprite;
		private var bg:Sprite;
		private var spring:Spring;
		private var msk:Sprite;
		private var items:Sprite;
		//
		private var isPlaylist:Boolean=false;
		public var list:DataProvider;
		private var numItems:uint=0;
		private var curItem:int=-1;
		//
		private const itemWidth:Number = 194;
		private const itemHeight:Number = 319;
		private const itemSpace:Number = 16;
		private const itemMargin:Number = 16;
		//
		private var itemsWidth:Number = 0;
		private var speed:Number = 0;
		
		public function PlaylistList(w:Number, h:Number, cd:String)
		{
			ww = w;
			hh = h;
			cdn = cd;
			//
			setBg();
		}
		
		/////////////////////////////////////
		// BG
		private function setBg():void
		{
			holder = new Sprite();
			addChild(holder);
			holder.x = 0;
			holder.y = 0;
			//
			var cls:Class = getDefinitionByName("playlistBg") as Class;
			bg = new cls() as Sprite;
			holder.addChild(bg);
			bg.width = ww;
			bg.height = hh;
			//
			items = new Sprite();
			holder.addChild(items);
			items.addEventListener(PlaylistListItem.PLAYLIST_ITEM_CLICK,onItemClick);
			//
			msk = new Sprite();
			addChild(msk);
			msk.x = 0;
			msk.y = 0;
			//
			holder.mask = msk;
			//
			spring = new Spring(holder);
			//
			posBg();
		}
		
		private function posBg():void
		{
			holder.graphics.clear();
			holder.graphics.beginFill(0x000000,1);
			holder.graphics.drawRect(0,0,ww,hh);
			holder.graphics.endFill();
			//
			bg.width = ww;
			bg.height = hh;
			//
			msk.graphics.clear();
			msk.graphics.beginFill(0x000000,1);
			msk.graphics.drawRect(0,0,ww,hh);
			msk.graphics.endFill();
			//
			if(isPlaylist)
			{
				holder.y = 0;
			}
			else
			{
				holder.y = hh;
			}
		}
		
		//////////////////////////////////////////////
		// ITEMS
		private function removeItems():void
		{
			items.graphics.clear();
			itemsWidth=0;
			items.x = 0;
			//
			unsetMouse();
			//
			if(items.numChildren>0)
			{
				do
				{
					items.removeChildAt(0);
				}
				while(items.numChildren>0);
			}
			numItems=0;
			curItem=-1;
		}
		
		private function drawItems():void
		{
			removeItems();
			//
			numItems = list.length;
			//
			for(var i:uint=0; i<numItems; i++)
			{
				var object:Object = list.getItemAt(i) as Object;
				var item:PlaylistListItem = new PlaylistListItem(i,object,cdn);
				item.name = "item"+i;
				item.x = itemMargin + (i*(itemWidth+itemSpace));
				item.y = (hh-itemHeight)/2;
				items.addChild(item);
			}
			//
			itemsWidth = (itemMargin * 2) + (numItems * (itemWidth+itemSpace)) - itemSpace;
			items.graphics.beginFill(0x000000,0);
			items.graphics.drawRect(0,0,itemsWidth,hh);
			items.graphics.endFill();
			//
			if(itemsWidth > ww)
			{
				setMouse();
			}
			else
			{
				items.x = (ww-itemsWidth)/2;
			}
			//
			selectItem(0);
		}
		
		private function onItemClick(event:Event):void
		{
			//var item:HorzPlaylistItem = event.target as HorzPlaylistItem;
			//trace("CLICK: "+item.num);
		}
		
		/////////////////////////////////////////////
		// MOUSE
		private function unsetMouse():void
		{
			items.removeEventListener(MouseEvent.MOUSE_OVER,onItemsOver);
			items.removeEventListener(MouseEvent.MOUSE_OUT,onItemsOut);
			items.removeEventListener(MouseEvent.MOUSE_MOVE,onItemsMove);
		}
		
		private function setMouse():void
		{
			unsetMouse();
			//
			items.addEventListener(MouseEvent.MOUSE_OVER,onItemsOver);
		}
		
		private function onItemsOver(event:MouseEvent):void
		{
			items.addEventListener(MouseEvent.MOUSE_OUT,onItemsOut);
			items.addEventListener(MouseEvent.MOUSE_MOVE,onItemsMove);
			addEventListener(Event.ENTER_FRAME,onItemsFrame);
		}
		
		private function onItemsOut(event:MouseEvent):void
		{
			items.removeEventListener(MouseEvent.MOUSE_OUT,onItemsOut);
			items.removeEventListener(MouseEvent.MOUSE_MOVE,onItemsMove);
			removeEventListener(Event.ENTER_FRAME,onItemsFrame);
		}
		
		private function onItemsMove(event:MouseEvent):void
		{
			//trace(holder.mouseX);
			var pc:Number = holder.mouseX/ww;
			if(pc < 1/3)
			{
				speed = ((1/3) - pc) * 30;
			}
			else if(pc < 2/3)
			{
				speed = 0;
			}
			else
			{
				speed = ((2/3) - pc) * 30;
			}
		}
		
		private function onItemsFrame(event:Event):void
		{
			var pos:Number = items.x + speed;
			pos = Math.max(pos,ww-itemsWidth);
			pos = Math.min(pos,0);
			items.x = pos;
		}
		
		//////////////////////////////////////////////
		// API
		public function doPlaylist(w:Boolean):void
		{
			isPlaylist=w;
			if(isPlaylist)
			{
				spring.easeTo(0,0,3);
			}
			else
			{
				spring.easeTo(0,hh,3);
			}
		}
		
		public function updateList(dp:DataProvider):void
		{
			list = dp;
			drawItems();
		}
		
		public function doResize():void
		{
			posBg();
		}
		
		public function selectItem(index:int=-1):void
		{
			if(numItems>0)
			{
				var item:PlaylistListItem;
				//
				if(curItem > -1)
				{
					item = items.getChildByName("item"+curItem) as PlaylistListItem;
					item.unselect();
				}
				//
				curItem = index;
				//
				if(curItem > -1)
				{
					item = items.getChildByName("item"+curItem) as PlaylistListItem;
					item.select();
					//
					var pos:Number = 0 - (curItem*(itemWidth+itemSpace));
					pos = Math.max(pos,ww-itemsWidth);
					pos = Math.min(pos,0);
					items.x = pos;
					if(itemsWidth <= ww)
					{
						items.x = (ww-itemsWidth)/2;
					}
				}
			}
		}
	}
}
