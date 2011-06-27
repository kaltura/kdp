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
		
		override protected function createRenderers():Array
		{
			this.carousel.astra_carousel_internal::invalidateCellRenderers();
			
			var startIndex:int = 0;
			var rendererCount:int = this.carousel.length;
			if(!this.drawAllRenderers)
			{
				var selectedRenderer:DisplayObject = this.carousel.astra_carousel_internal::createCellRenderer(this.carousel.selectedItem);
				var pageItemCount:int = this.displayedItemCount;
				if(this.displayedItemCount == 0)
				{
					if(this.direction == "horizontal")
					{
						pageItemCount = Math.ceil(this.width / (selectedRenderer.width + this.horizontalGap));
					}
					else
					{
						pageItemCount = Math.ceil(this.height / (selectedRenderer.height + this.verticalGap));
					}
				}
				
				if((this.direction == "horizontal" && this.horizontalAlign == "center") ||
					(this.direction == "vertical" && this.verticalAlign == "middle"))
				{
					pageItemCount++;
				}
				
				var oldIndex:int = this.carousel.dataProvider.getItemIndex(this.previouslySelectedItem);
				var newIndex:int = this.carousel.selectedIndex;
				if(oldIndex < 0)
				{
					oldIndex = newIndex;
				}
				startIndex = Math.min(oldIndex, newIndex);
				var endIndex:int = Math.max(oldIndex, newIndex);
				
				rendererCount = Math.abs(oldIndex - newIndex) + pageItemCount;
				if(this.direction == "horizontal")
				{
					switch(this.horizontalAlign)
					{
						case "center":
						{
							startIndex -= ((pageItemCount - 1) / 2);
							startIndex = Math.max(startIndex, 0);
							if(oldIndex == 0 || oldIndex == this.carousel.length - 1)
							{
								rendererCount--;
							}
							if((newIndex == 0 || newIndex == this.carousel.length - 1) && newIndex != oldIndex)
							{
								rendererCount--;
							}
							break;
						}
						case "right":
						{
							startIndex -= (pageItemCount - 1);
							startIndex = Math.max(startIndex, 0);
							if(newIndex == 0 || oldIndex == 0)
							{
								rendererCount--;
							}
							break;
						}
						default: //left
						{
							if(oldIndex == this.carousel.length - 1 || newIndex == this.carousel.length - 1)
							{
								rendererCount--;
							}
							break;
						}
					}
				}
			}
			
			var renderers:Array = [];
			for(var i:int = 0; i < rendererCount; i++)
			{
				var index:int = startIndex + i;
				if(index >= this.carousel.length)
				{
					break;
				}
				
				var item:Object = this.carousel.dataProvider.getItemAt(index);
				var renderer:ICellRenderer = this.carousel.astra_carousel_internal::createCellRenderer(item);
				Sprite(renderer).addEventListener(MouseEvent.CLICK, rendererClickHandler, false, 0, true);
				if(renderer is UIComponent)
				{
					UIComponent(renderer).invalidate();
					UIComponent(renderer).drawNow();
				}
				renderers.push(renderer);
			}
			this.carousel.astra_carousel_internal::validateCellRenderers();
			
			return renderers;
		}

	}
}