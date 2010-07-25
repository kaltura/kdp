package com.kaltura.kdpfl.plugin.component
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;

	public class Fader extends Shape
	{
		private var obj:DisplayObject;
		//
		private var enda:Number;
		//
		private var devide:Number=3;
		//
		public static const FADE_COMPLETE:String = "fade_complete";
		
		public function Fader(ob:DisplayObject, dev:Number=3)
		{
			obj = ob;
			devide = dev;
		}
		
		public function fadeTo(aa:Number):void
		{
			if(obj.visible==false)
			{
				obj.alpha=0;
			}
			obj.visible=true;
			//
			enda = aa;
			this.removeEventListener(Event.ENTER_FRAME,onFrame);
			this.addEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		private function onFrame(event:Event):void
		{
			var da:Number = enda - obj.alpha;
			obj.alpha += da/devide;
			if(Math.abs(da)<(0.005*devide))
			{
				obj.alpha = enda;
				this.removeEventListener(Event.ENTER_FRAME,onFrame);
				fadeComplete();
				//trace("Fade Complete: "+obj.toString()+" - "+obj.name);
			}
		}
		
		public function doFade(aa:Number):void
		{
			this.removeEventListener(Event.ENTER_FRAME,onFrame);
			enda = aa;
			obj.alpha = aa;
			fadeComplete();
		}
		
		private function fadeComplete():void
		{
			dispatchEvent(new EZEvent(Fader.FADE_COMPLETE,true,"fade",enda));
			if(enda==0)
			{
				obj.visible=false;
			}
		}
		
		public function close():void
		{
			this.removeEventListener(Event.ENTER_FRAME,onFrame);
			obj=null;
		}
	}
}
