package com.kaltura.kdpfl.plugin.component
{
	import flash.display.Sprite;
	import flash.xml.XMLDocument;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.system.Security;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class EMLoader extends Sprite
	{
		public var em:Loader;
		private var emask:Shape;
		public var bd:Bitmap;
		private var lc:LoaderContext;
		private var delay:Timer;
		//--------------------------------
		private var stat:String="off";
		private var anim:Boolean;
		private var stretch:Boolean;
		private var ww:Number;
		private var hh:Number;
		public var scale:Number=1;
		private var url:String;
		private var corner:int = 0;
		public static const EM_LOADED:String="em_loaded";
		public static const EM_DONE:String="em_done";
		public static const EM_VANISH:String="em_vanish";
		//---------------
		private var fileType:String="";
		
		public function EMLoader()
		{
			
		}
		
		private function onRemoved(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			//
			if(stat=="load")
			{
				try
				{
					em.close();
				}
				catch(errObject:Error)
				{
					trace(errObject.message);
				}
			}
		}
		
		public function loadPic(u:String,w:Number=0,h:Number=0,c:int=0,an:Boolean=false, strch:Boolean=false):void
		{
			if(u.length==0 || u==null)
			{
				// ERROR
			}
			else
			{
				stat="load";
				addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
				//
				anim=an;
				stretch = strch;
				ww=w;
				hh=h;
				url = u;
				corner = c;
				//-----------------------
				fileType = getFileType(url);
				//-----------------------
				bd=new Bitmap(new BitmapData(Math.max(ww,10),Math.max(ww,10),false,0));
				bd.name="bd";
				//-----------------------
				lc = new LoaderContext(true);
				lc.checkPolicyFile = true;
				//-----------------------
				if(em!=null)
				{
					em.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIOERROR);
					em.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
					em.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onLoadProgress);
					removeChild(em);
					em=null;
				}
				em = new Loader();
				em.name="em";
				addChild(em);
				em.mouseEnabled=false;
				em.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOERROR);
				em.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
				em.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onLoadProgress);
				em.load(new URLRequest(url),lc);
				//-----------------------
				delay = new Timer(1000,1);
				delay.addEventListener(TimerEvent.TIMER,onBuffer);
				delay.start();
				//-----------------------
				if(ww!=0 && hh!=0)
				{
					emask = new Shape();
					emask.name="emask";
					addChild(emask);
					setEmask();
					em.mask = emask;
				}
				//-----------------------
				if(anim)
				{
					em.alpha=0;
				}
			}
		}
		
		private function getFileType(str:String):String
		{
			var li:int = str.lastIndexOf(".");
			return str.substring(li+1).toLowerCase();
		}
		
		public function unloadPic():void
		{
			if(stat=="load")
			{
				em.close();
			}
			else if(stat=="on")
			{
				em.unload();
			}
		}
		
		private function onBuffer(event:TimerEvent):void
		{
			delay.stop();
			delay.removeEventListener(TimerEvent.TIMER,onBuffer);
		}
		
		private function setEmask():void
		{
			emask.graphics.clear();
			emask.graphics.beginFill(0x000000,1);
			emask.graphics.drawRoundRectComplex(0,0,ww,hh,corner,corner,corner,corner);
			emask.graphics.endFill();
		}
		
		private function onIOERROR(event:IOErrorEvent):void
		{
			//trace(event.text);
		}

		private function onLoadProgress(event:ProgressEvent):void
		{
			var bt:Number=event.bytesTotal;
			var bl:Number=event.bytesLoaded;
			var pc:Number=bl/bt;
			//---------
			this.dispatchEvent(new EMLoaderEvent(EMLoaderEvent.LOAD_PROGRESS,true,pc));
		}
		
		private function onComplete(event:Event):void
		{
			//trace("complete");
			this.removeEventListener(Event.ENTER_FRAME,onLoadProgress);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			stat="on";
			//--------
			delay.stop();
			if(fileType!="swf")
			{
				bd = Bitmap(em.content);
				bd.smoothing = true;
			}
			//--------
			setSize();
			//--------
			dispatchEvent(new Event(EMLoader.EM_LOADED,true));
			//------------
			if(anim)
			{
				this.addEventListener(Event.ENTER_FRAME,onFadeIn);
			}
		}
		
		private function onFadeIn(event:Event):void
		{
			if(em!=null)
			{
				em.alpha+=0.1;
				if(em.alpha >= 1)
				{
					em.alpha = 1;
					this.removeEventListener(Event.ENTER_FRAME,onFadeIn);
					dispatchEvent(new Event(EMLoader.EM_DONE,true));
				}
			}
		}
		
		public function fadeOut():void
		{
			if(em!=null)
			{
				em.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			}
			this.removeEventListener(Event.ENTER_FRAME,onFadeIn);
			if(em!=null)
			{
				this.addEventListener(Event.ENTER_FRAME,onFadeOut);
			}
			else
			{
				this.dispatchEvent(new Event(EMLoader.EM_VANISH,true));
			}
		}
		
		private function onFadeOut(event:Event):void
		{
			em.alpha-=0.1;
			if(em.alpha <= 0)
			{
				em.alpha = 0;
				this.removeEventListener(Event.ENTER_FRAME,onFadeOut);
				this.dispatchEvent(new Event(EMLoader.EM_VANISH,true));
			}
		}
		
		private function setSize():void
		{
			em.scaleX=1;
			em.scaleY=1;
			//------------
			var iw:Number = em.width;
			var ih:Number = em.height;
			var ir:Number = iw/ih;
			var sc:Number = 1;
			if(ww==0 && hh==0)
			{					
				sc = 1;
			}
			else if(ww==0)
			{
				//by height
				sc = hh/ih;
			}
			else if(hh==0)
			{
				//by width
				sc = ww/iw;
			}
			else
			{
				var fr:Number = ww/hh;
				// scale
				if(fr >= ir)
				{
					//by height
					sc = hh/ih;
				}
				else
				{
					//by width
					sc = ww/iw;
				}
			}
			if(!stretch)
			{
				sc = Math.min(sc,1);
			}
			//--------------
			scale = sc;
			em.scaleX = sc;
			em.scaleY = sc;
			// set pos --------
			if(ww==0)
			{
				em.x = 0;
			}
			else
			{
				em.x = (ww-em.width)/2;
			}
			if(hh==0)
			{
				em.y = 0;
			}
			else
			{
				em.y = (hh-em.height)/2;
			}
		}
		
		public function updateSize(w:Number, h:Number):void
		{
			ww=w;
			hh=h;
			//
			if(ww!=0 && hh!=0)
			{
				setEmask();
			}
			//
			if(stat=="on")
			{
				setSize();
			}
		}
	}
}