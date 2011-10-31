package com.kaltura.kdpfl.plugin
{
	import com.yahoo.astra.animation.AnimationEvent;
	import com.yahoo.astra.fl.controls.carouselClasses.SlidingCarouselRenderer;
	import com.yahoo.astra.fl.controls.carouselClasses.astra_carousel_internal;
	
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ICellRenderer;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class KSlidingCarouselRenderer extends SlidingCarouselRenderer
	{
		public function KSlidingCarouselRenderer()
		{
			super();
		}

		/**
		 * Override for the "draw" function. It ensures that the component (Carousel) is not redrawn 
		 * when the slide animation is on-going. 
		 * 
		 */		
		override protected function draw():void
		{
			if (this.slide)
			{
				return;
			}
			else{
			
				super.draw();
			}
		}
		
		/**
		 * Moves the sliding carousel to the left (revealing the right side). 
		 * 
		 */		
		public function nextSlide () : void
		{
			this.carousel.selectedIndex = Math.min(this.carousel.length -1,  this.carousel.selectedIndex + 1);
			dispatchEvent(new Event(Event.CHANGE) );
		}
		/**
		 * Moves the sliding carousel to the right (revealing the left side). 
		 * 
		 */		
		public function prevSlide() : void
		{
			this.carousel.selectedIndex = Math.max(0,  this.carousel.selectedIndex - 1);
			dispatchEvent(new Event(Event.CHANGE) );
		}
		
		

	}
}