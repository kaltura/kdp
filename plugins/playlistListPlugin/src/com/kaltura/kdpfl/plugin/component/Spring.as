package com.kaltura.kdpfl.plugin.component
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;

	public class Spring extends Shape
	{
		private var obj:DisplayObject;
		//
		private var endx:Number;
		private var endy:Number;
		private var ends:Number;
		//
		private var vx:Number=0;
		private var vy:Number=0;
		private var vs:Number=0;
		//
		private var devide:Number=3;
		private var friction:Number=0.8;
		//
		public static const SPRING_COMPLETE:String = "spring_complete";
		
		public function Spring(ob:DisplayObject, dev:Number=3, fric:Number=0.8)
		{
			obj = ob;
			devide = dev;
			friction = fric;
		}
		
		public function springTo(xx:Number, yy:Number):void
		{
			endx = xx;
			endy = yy;
			this.removeEventListener(Event.ENTER_FRAME,onSpringTo);
			this.removeEventListener(Event.ENTER_FRAME,onEaseTo);
			this.addEventListener(Event.ENTER_FRAME,onSpringTo);
		}
		
		public function springScale(sc:Number):void
		{
			ends = sc;
			this.removeEventListener(Event.ENTER_FRAME,onSpringScale);
			this.removeEventListener(Event.ENTER_FRAME,onEaseScale);
			this.addEventListener(Event.ENTER_FRAME,onSpringScale);
		}
		
		public function easeTo(xx:Number, yy:Number, dev:Number=3):void
		{
			devide=dev;
			vx=0;
			vy=0;
			endx = xx;
			endy = yy;
			this.removeEventListener(Event.ENTER_FRAME,onSpringTo);
			this.removeEventListener(Event.ENTER_FRAME,onEaseTo);
			this.addEventListener(Event.ENTER_FRAME,onEaseTo);
		}
		
		public function easeScale(sc:Number, dev:Number=3):void
		{
			devide=dev;
			vs=0;
			ends = sc;
			this.removeEventListener(Event.ENTER_FRAME,onSpringScale);
			this.removeEventListener(Event.ENTER_FRAME,onEaseScale);
			this.addEventListener(Event.ENTER_FRAME,onEaseScale);
		}
		
		private function onSpringTo(event:Event):void
		{
			var dx:Number = endx - obj.x;
			var dy:Number = endy - obj.y;
			vx += dx/devide;
			vy += dy/devide;
			vx *= friction;
			vy *= friction;
			obj.x += vx;
			obj.y += vy;
			dx = endx - obj.x;
			dy = endy - obj.y;
			if(Math.abs(dx)<2 && Math.abs(dy)<2 && Math.abs(vx)<2 && Math.abs(vy)<2)
			{
				obj.x = endx;
				obj.y = endy;
				vx = 0;
				vy = 0;
				this.removeEventListener(Event.ENTER_FRAME,onSpringTo);
				dispatchEvent(new EZEvent(Spring.SPRING_COMPLETE,true,endx+"~"+endy,0));
			}
		}
		
		private function onSpringScale(event:Event):void
		{
			var ds:Number = ends - obj.scaleX;
			vs += ds/devide;
			vs *= friction;
			obj.scaleX += vs;
			ds = ends - obj.scaleX;
			if(Math.abs(ds)<0.01 && Math.abs(vs)<0.01)
			{
				obj.scaleX = ends;
				vs = 0;
				this.removeEventListener(Event.ENTER_FRAME,onSpringScale);
				dispatchEvent(new EZEvent(Spring.SPRING_COMPLETE,true,"scale",ends));
			}
			else
			{
				if(obj.scaleX < 0)
				{
					obj.scaleX = ends;
					vs = 0;
					this.removeEventListener(Event.ENTER_FRAME,onSpringScale);
					dispatchEvent(new EZEvent(Spring.SPRING_COMPLETE,true,"scale",ends));
				}
			}
			obj.scaleY = obj.scaleX;
		}
		
		private function onEaseTo(event:Event):void
		{
			var dx:Number = endx - obj.x;
			var dy:Number = endy - obj.y;
			obj.x += dx/devide;
			obj.y += dy/devide;
			dx = endx - obj.x;
			dy = endy - obj.y;
			if(Math.abs(dx)<2 && Math.abs(dy)<2)
			{
				obj.x = endx;
				obj.y = endy;
				this.removeEventListener(Event.ENTER_FRAME,onEaseTo);
				dispatchEvent(new EZEvent(Spring.SPRING_COMPLETE,true,endx+"~"+endy,0));
			}
		}
		
		private function onEaseScale(event:Event):void
		{
			var ds:Number = ends - obj.scaleX;
			obj.scaleX += ds/devide;
			ds = ends - obj.scaleX;
			if(Math.abs(ds)<0.01)
			{
				obj.scaleX = ends;
				this.removeEventListener(Event.ENTER_FRAME,onEaseScale);
				dispatchEvent(new EZEvent(Spring.SPRING_COMPLETE,true,"scale",ends));
			}
			obj.scaleY = obj.scaleX;
		}
		
		public function jumpTo(xx:Number, yy:Number):void
		{
			this.removeEventListener(Event.ENTER_FRAME,onSpringTo);
			this.removeEventListener(Event.ENTER_FRAME,onEaseTo);
			obj.x = xx;
			obj.y = yy;
		}
		
		public function jumpScale(s:Number):void
		{
			this.removeEventListener(Event.ENTER_FRAME,onSpringScale);
			this.removeEventListener(Event.ENTER_FRAME,onEaseScale);
			obj.scaleX = s;
			obj.scaleY = s;
		}
		
		public function stopSpring():void
		{
			this.removeEventListener(Event.ENTER_FRAME,onSpringTo);
			this.removeEventListener(Event.ENTER_FRAME,onSpringScale);
			this.removeEventListener(Event.ENTER_FRAME,onEaseTo);
			this.removeEventListener(Event.ENTER_FRAME,onEaseScale);
			vx=0;
			vy=0;
			vs=0;
		}
	}
}
