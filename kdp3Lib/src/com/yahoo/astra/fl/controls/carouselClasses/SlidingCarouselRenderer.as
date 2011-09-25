/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.controls.carouselClasses
{
	import com.yahoo.astra.animation.Animation;
	import com.yahoo.astra.animation.AnimationEvent;
	
	import fl.controls.listClasses.ICellRenderer;
	import fl.core.UIComponent;
	import fl.transitions.easing.Regular;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * A Carousel renderer that displays items in a horizontal row or a vertical
	 * column. When the Carousel's selectedIndex changes, the selected cell
	 * renderer slides into view.
	 * 
	 * @see com.yahoo.astra.fl.controls.Carousel
	 * @author Josh Tynjala
	 */
	public class SlidingCarouselRenderer extends BoxCarouselRenderer implements ICarouselLayoutRenderer
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function SlidingCarouselRenderer()
		{
			super();
			this.scrollRect = new Rectangle();
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * Storage for the animationDuration property.
		 */
		private var _animationDuration:int = 500;
		
		/**
		 * The duration of the fading animation.
		 */
		public function get animationDuration():int
		{
			return this._animationDuration;
		}
		
		/**
		 * @private
		 */
		public function set animationDuration(value:int):void
		{
			this._animationDuration = value;
		}
		
		/**
		 * @private
		 * Storage for the animationEasingFunction property.
		 */
		private var _animationEasingFunction:Function = Regular.easeOut;
		
		/**
		 * The function used to ease the fading animation used by this layout
		 * renderer type.
		 */
		public function get animationEasingFunction():Function
		{
			return this._animationEasingFunction;
		}
		
		/**
		 * @private
		 */
		public function set animationEasingFunction(value:Function):void
		{
			this._animationEasingFunction = value;
		}
		
		/**
		 * @private
		 * A reference to the animation used to slide items in and out.
		 */
		protected var slide:Animation;
		
		/**
		 * @private
		 * The last value of the selectedItem;
		 */
		protected var previouslySelectedItem:Object;
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			//in all cases, we want to stop the previous animation
			if(this.slide)
			{
				this.slide.pause();
				this.slide.removeEventListener(AnimationEvent.UPDATE, slideUpdateHandler);
				this.slide.removeEventListener(AnimationEvent.COMPLETE, slideCompleteHandler);
				this.slide = null;
			}
			
			super.draw();
			
			if(this.carousel.length == 0 || this.carousel.selectedIndex < 0)
			{
				//nothing to draw
				return;
			}
			
			var selectedRenderer:ICellRenderer = this.carousel.itemToCellRenderer(this.carousel.selectedItem);
			this.moveToRenderer(selectedRenderer);
			
			this.previouslySelectedItem = this.carousel.selectedItem;
		}
		
		/**
		 * @private
		 * Creates the required renderers.
		 */
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
					UIComponent(renderer).drawNow();
				}
				renderers.push(renderer);
			}
			this.carousel.astra_carousel_internal::validateCellRenderers();
			
			return renderers;
		}
		
		/**
		 * @private
		 * Animates the scrollRect to display the specified renderer. Generally,
		 * this is the selected item.
		 */
		protected function moveToRenderer(renderer:ICellRenderer):void
		{	
			var displayedRenderer:DisplayObject = DisplayObject(renderer);
			var rendererX:Number = displayedRenderer.x;
			var rendererY:Number = displayedRenderer.y;
			if(this.direction == "vertical")
			{
				switch(this.verticalAlign)
				{
					case "middle":
					{
						rendererY -= (this.height - displayedRenderer.height) / 2;
						break;
					}
					case "right":
					{
						rendererY -= (this.height - displayedRenderer.height);
						break;
					}
				}
			}
			else //horizontal
			{
				switch(this.horizontalAlign)
				{
					case "center":
					{
						rendererX -= (this.width - displayedRenderer.width) / 2;
						break;
					}
					case "right":
					{
						rendererX -= (this.width - displayedRenderer.width);
						break;
					}
				}
			}
			
			var prevRendererX:Number = rendererX;
			var prevRendererY:Number = rendererY;
			if(this.previouslySelectedItem)
			{
				var prevRenderer:DisplayObject = this.carousel.itemToCellRenderer(this.previouslySelectedItem) as DisplayObject;
				if(prevRenderer)
				{
					prevRendererX = prevRenderer.x;
					prevRendererY = prevRenderer.y;
					if(this.direction == "vertical")
					{
						switch(this.verticalAlign)
						{
							case "middle":
							{
								prevRendererY -= (this.height - prevRenderer.height) / 2;
								break;
							}
							case "right":
							{
								prevRendererY -= (this.height - prevRenderer.height);
								break;
							}
						}
					}
					else //horizontal
					{
						switch(this.horizontalAlign)
						{
							case "center":
							{
								prevRendererX -= (this.width - prevRenderer.width) / 2;
								break;
							}
							case "right":
							{
								prevRendererX -= (this.width - prevRenderer.width);
								break;
							}
						}
					}
				}
			}
			
			//we miss the first update from animation, so let's initialize the scroll rect
			var scrollRect:Rectangle = this.scrollRect;
			scrollRect.x = prevRendererX;
			scrollRect.y = prevRendererY;
			this.scrollRect = scrollRect;
			
			this.slide = new Animation(this.animationDuration,
				{x: prevRendererX, y: prevRendererY},
				{x: rendererX, y: rendererY});
				
			this.slide.easingFunction = this.animationEasingFunction;
			this.slide.addEventListener(AnimationEvent.UPDATE, slideUpdateHandler);
			this.slide.addEventListener(AnimationEvent.COMPLETE, slideCompleteHandler);
			
		}
		
	//--------------------------------------
	//  Protected Event Handlers
	//--------------------------------------
		
		/**
		 * @private
		 * Updates the scroll rect of this layout renderer to show the currently
		 * selected item.
		 */
		protected function slideUpdateHandler(event:AnimationEvent):void
		{
			var scrollRect:Rectangle = this.scrollRect;
			scrollRect.x = event.parameters.x;
			scrollRect.y = event.parameters.y;
			this.scrollRect = scrollRect;
		}
		
		/**
		 * @private
		 * When the animation completes, clean it up for garbage collection.
		 */
		protected function slideCompleteHandler(event:AnimationEvent):void
		{
			this.slideUpdateHandler(event);
			this.slide.removeEventListener(AnimationEvent.UPDATE, slideUpdateHandler);
			this.slide.removeEventListener(AnimationEvent.COMPLETE, slideCompleteHandler);
			this.slide = null;
		}
		
	}
}