package com.kaltura.kdpfl.plugin.component
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

	public class PlaylistListItem extends Sprite
	{
		public var num:uint;
		private var object:Object;
		private var cdn:String;
		//
		private const itemWidth:Number = 194;
		private const itemHeight:Number = 318;
		private const imageWidth:Number = 178;
		private const imageHeight:Number = 262;
		private const footerHeight:Number = 42;
		//
		private var bg:Sprite;
		private var cardBg:Sprite;
		private var em:EMLoader;
		private var emMask:Sprite;
		private var playIcon:Sprite;
		private var playFader:Fader;
		private var icon:Sprite;
		private var title:Sprite;
		//
		public static const PLAYLIST_ITEM_CLICK:String = "playlist_item_click";
		
		public function PlaylistListItem(n:uint, obj:Object, cd:String)
		{
			num = n;
			object = obj;
			cdn = cd;
			//trace(cdn);
			//
			setBg();
			setEm();
			setTitle();
			setIcon();
			setPlay();
		}
		
		private function setBg():void
		{
			bg = new Sprite();
			addChild(bg);
			bg.mouseChildren=false;
			//
			bg.graphics.beginFill(0xFFFFFF,0);
			bg.graphics.drawRect(0,0,itemWidth,itemHeight);
			bg.graphics.endFill();
			//
			var cardBgClass:Class = getDefinitionByName("cardBg") as Class;
			cardBg = new cardBgClass() as Sprite;
			bg.addChild(cardBg);
			//
			setMouse();
		}
		
		private function setEm():void
		{
			em = new EMLoader();
			addChild(em);
			//
			var vars:Array = object["data"].toString().split("?")[1].split("&");
			var playlistId:String = "";
			for(var i:uint=0; i<vars.length; i++)
			{
				var item:Array = vars[i].split("=");
				if(item[0] == "playlist_id")
				{
					playlistId=item[1];
					break;
				}
			}
			var thumbnailUrl:String = "http://" + cdn + "/p/1/sp/100/thumbnail/entry_id/0_tcwisp6s/version/0"+"/width/" + imageWidth+"/height/"+imageHeight+"/type/3"
			trace("thumb: "+thumbnailUrl);
			em.loadPic(thumbnailUrl,0,imageHeight,0,true,true);
			em.mouseEnabled=false;
			em.mouseChildren=false;
			em.x = (itemWidth-imageWidth)/2;
			em.y = (itemHeight - footerHeight - imageHeight)/2;
			//
			emMask = new Sprite();
			addChild(emMask);
			emMask.x = em.x;
			emMask.y = em.y;
			emMask.graphics.beginFill(0x000000,1);
			emMask.graphics.drawRect(0,0,imageWidth,imageHeight);
			emMask.graphics.endFill();
			em.mask = emMask;
		}
		
		private function setTitle():void
		{
			var titleClass:Class = getClassFromRating("cardTitle") as Class;
			title = new titleClass() as Sprite;
			addChild(title);
			title.x = itemWidth/2;
			title.y = itemHeight - (footerHeight/2);
			//
			var txt:TextField = title.getChildByName("txt") as TextField;
			txt.text = object["label"].toString();
			if(txt.maxScrollH > 1)
			{
				txt.appendText("...");
				do
				{
					txt.text = txt.text.substring(0,txt.text.length-4)+"...";
				}
				while(txt.maxScrollH>1);
			}
		}
		
		private function setIcon():void
		{
			//trace("------------------------------");
			//trace("CAT: "+entry["categories"]);
			//trace("------------------------------");
			//var iconClass:Class = getClassFromRating(object["categories"]);
			var iconClass:Class;
			if(iconClass!=null)
			{
				icon = new iconClass() as Sprite;
				addChild(icon);
				posIcon();
			}
		}
		
		private function getClassFromRating(str:String):Class
		{
 			try
 			{
				var cls:Class = getDefinitionByName(str) as Class;
				return cls;
			}
			catch(ex:Error)
			{
				
			} 
			return null;
		}
		
		private function posIcon():void
		{
			if(icon!=null)
			{
				icon.scaleX = 1;
				icon.scaleY = 1;
				//
				var sc:Number = Math.min(30/icon.width,30/icon.height);
				//
				icon.scaleX = sc;
				icon.scaleY = sc;
				//
				icon.x = emMask.x + emMask.width - 30 - 10;
				icon.y = emMask.y + emMask.height - 30 - 10;
			}
		}
		
		private function setPlay():void
		{
			var playIconClass:Class = getDefinitionByName("bigPlay") as Class;
			playIcon = new playIconClass as Sprite;
			addChild(playIcon);
			playIcon.x = (itemWidth - playIcon.width)/2;
			playIcon.y = (itemHeight - playIcon.height)/2;
			playIcon.mouseEnabled=false;
			playIcon.visible=false;
			playIcon.alpha=0;
			//
			playFader = new Fader(playIcon,3);
		}
		
		/////////////////////////////////////////////////////
		// MOUSE
		private function unsetMouse():void
		{
			if(bg!=null)
			{
				bg.buttonMode=false;
				//
				bg.removeEventListener(MouseEvent.MOUSE_OVER,onBgOver);
				bg.removeEventListener(MouseEvent.MOUSE_OUT,onBgOut);
				bg.removeEventListener(MouseEvent.CLICK,onBgClick);
			}
		}
		
		private function setMouse():void
		{
			if(bg!=null)
			{
				unsetMouse();
				//
				bg.buttonMode=true;
				//
				bg.addEventListener(MouseEvent.MOUSE_OVER,onBgOver);
				bg.addEventListener(MouseEvent.MOUSE_OUT,onBgOut);
				bg.addEventListener(MouseEvent.CLICK,onBgClick);
			}
		}
		
		private function onBgOver(event:MouseEvent):void
		{
			playFader.fadeTo(1);
		}
		
		private function onBgOut(event:MouseEvent):void
		{
			playFader.fadeTo(0);
		}
		
		private function onBgClick(event:MouseEvent):void
		{
			dispatchEvent(new Event(PlaylistListItem.PLAYLIST_ITEM_CLICK,true));
		}
		
		/////////////////////////////////////////////////////
		// API
		public function select():void
		{
			unsetMouse();
			onBgOut(null);
			bg.filters = [new GlowFilter(0xFFFFFF,.7,8,8,8)];
			bg.alpha = .9;
		}
		
		public function unselect():void
		{
			setMouse();
			bg.filters = [];
			bg.alpha = 1;
		}
	}
}
