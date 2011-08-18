/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.controls.carouselClasses
{
	import com.yahoo.astra.animation.Animation;
	import com.yahoo.astra.animation.AnimationEvent;
	import com.yahoo.astra.fl.controls.Carousel;
	
	import fl.controls.listClasses.ICellRenderer;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	import fl.transitions.easing.Regular;
	
	import flash.display.DisplayObject;

	/**
	 * A Carousel renderer that displays one item at a time. When the Carousel's
	 * selectedIndex changes, the previously selected cell renderer fades out
	 * and the newly selected cell renderer fades in.
	 * 
	 * @see com.yahoo.astra.fl.controls.Carousel
	 * @author Josh Tynjala
	 */
	public class StackCarouselRenderer extends UIComponent implements ICarouselLayoutRenderer
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
		
		/**
		 * Constructor.
		 */
		public function StackCarouselRenderer()
		{
			super();
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * The selected index from the last time the renderer redrew.
		 */
		private var _lastSelectedIndex:int = -1;
		
		/**
		 * @private
		 * The renderer for the currently selected item.
		 */
		protected var renderer:ICellRenderer;
		
		/**
		 * @private
		 * The renderer for the previously selected item. May be null if no
		 * item was previously selected.
		 */
		protected var previousRenderer:ICellRenderer;
		
		/**
		 * @private
		 * Storage for the carousel property.
		 */
		private var _carousel:Carousel;
		
		/**
		 * @inheritDoc
		 */
		public function get carousel():Carousel
		{
			return this._carousel;
		}
		
		/**
		 * @private
		 */
		public function set carousel(value:Carousel):void
		{
			this._carousel = value;
			this.invalidate(InvalidationType.DATA);
		}
		
		/**
		 * @private
		 * A reference to the animation used to fade items in and out.
		 */
		private var _fade:Animation;
		
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
		 * Storage for the forceCreationOfAllRenderers property.
		 */
		private var _drawAllRenderers:Boolean = false;
		
		/**
		 * Forces the creation of a renderer for every item in the Carousel,
		 * regardless of whether each particular item is currently visible.
		 * Useful for cases where the renderer displays externally-loaded
		 * content. Network requests for images and other data may cause delays
		 * in rendering, even when something has been loaded once and the
		 * cache is already primed.
		 * 
		 * <p>The visual effect of such rendering delays is often compared to
		 * "flickering".</p>
		 */
		public function get drawAllRenderers():Boolean
		{
			return this._drawAllRenderers;
		}
		
		/**
		 * @private
		 */
		public function set drawAllRenderers(value:Boolean):void
		{
			this._drawAllRenderers = value;
			this.invalidate(InvalidationType.DATA);
		}
		
		/**
		 * @private
		 * Storage for the autoSize property.
		 */
		private var _autoSize:Boolean = false;
		
		/**
		 * If true, the renderer will resize to fit the content.
		 * 
		 * @default false
		 */
		public function get autoSize():Boolean
		{
			return this._autoSize;
		}
		
		/**
		 * @private
		 */
		public function set autoSize(value:Boolean):void
		{
			this._autoSize = value;
			this.invalidate(InvalidationType.DATA);
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * @private
		 * @inheritDoc
		 */
		public function cleanUp():void
		{
			//nothing to clean up in this implementation
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			//in all cases, we want to stop the previous animation
			if(this._fade)
			{
				this._fade.pause();
				this._fade.removeEventListener(AnimationEvent.UPDATE, fadeUpdateHandler);
				this._fade.removeEventListener(AnimationEvent.COMPLETE, fadeCompleteHandler);
				this._fade = null;
			}
			
			this.carousel.astra_carousel_internal::invalidateCellRenderers();
			
			if(this.carousel.selectedIndex < 0 || this.carousel.length == 0)
			{
				this.carousel.astra_carousel_internal::validateCellRenderers();
				return;
			}
			
			var oldWidth:Number = this.width;
			var oldHeight:Number = this.height;
			
			var renderers:Array = [];
			if(this.drawAllRenderers)
			{
				var itemCount:int = this.carousel.length;
				for(var i:int = 0; i < itemCount; i++)
				{
					var item:Object = this.carousel.dataProvider.getItemAt(i);
					var renderer:ICellRenderer = this.carousel.astra_carousel_internal::createCellRenderer(item);
					DisplayObject(renderer).alpha = 0;
					renderers.push(renderer);
				}
			}
			
			this.previousRenderer = null;
			if(this._lastSelectedIndex >= 0 && this._lastSelectedIndex != this.carousel.selectedIndex)
			{
				if(this.drawAllRenderers)
				{
					this.previousRenderer = ICellRenderer(renderers[this._lastSelectedIndex]);
				}
				else
				{
					var previousItem:Object = this.carousel.dataProvider.getItemAt(this._lastSelectedIndex);
					this.previousRenderer = this.carousel.astra_carousel_internal::createCellRenderer(previousItem);
				}
			}
			
			if(this.drawAllRenderers)
			{
				this.renderer = ICellRenderer(renderers[this.carousel.selectedIndex]);
			}
			else
			{
				var selectedItem:Object = this.carousel.dataProvider.getItemAt(this.carousel.selectedIndex);
				this.renderer = this.carousel.astra_carousel_internal::createCellRenderer(selectedItem);
			}
			
			if(this._lastSelectedIndex != this.carousel.selectedIndex)
			{
				DisplayObject(this.renderer).alpha = 0;
				if(this.previousRenderer)
				{
					DisplayObject(this.previousRenderer).alpha = 1;
				}
				this._fade = new Animation(this.animationDuration, {alpha: 0}, {alpha: 1});
				this._fade.easingFunction = this.animationEasingFunction;
				this._fade.addEventListener(AnimationEvent.UPDATE, fadeUpdateHandler);
				this._fade.addEventListener(AnimationEvent.COMPLETE, fadeCompleteHandler);
				
				this._lastSelectedIndex = this.carousel.selectedIndex;
			}
			else
			{
				DisplayObject(this.renderer).alpha = 1;
			}
			
			if(this.autoSize)
			{
				this._width = DisplayObject(this.renderer).width;
				this._height = DisplayObject(this.renderer).height;
			}
			
			this.renderer.setSize(this.width, this.height);
			if(this.renderer is UIComponent)
			{
				UIComponent(this.renderer).drawNow();
			}
			if(this.previousRenderer)
			{
				this.previousRenderer.setSize(this.width, this.height);
				if(this.previousRenderer is UIComponent)
				{
					UIComponent(this.previousRenderer).drawNow();
				}
			}
			
			super.draw();
			
			if(this.width != oldWidth || this.height != oldHeight)
			{
				this.dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE));
			}
			
			this.carousel.astra_carousel_internal::validateCellRenderers();
		}
		
	//--------------------------------------
	//  Private Event Handlers
	//--------------------------------------
		
		/**
		 * @private
		 * Updates the alpha values for the currently displayed renderers. The
		 * renderer for the previously selected item fades out and the renderer
		 * for the currently selected item fades in.
		 */
		private function fadeUpdateHandler(event:AnimationEvent):void
		{
			DisplayObject(this.renderer).alpha = event.parameters.alpha;
			if(this.previousRenderer)
			{
				DisplayObject(this.previousRenderer).alpha = 1 - event.parameters.alpha;
			}
		}
		
		/**
		 * @private
		 * When the animation completes, clean it up for garbage collection.
		 */
		private function fadeCompleteHandler(event:AnimationEvent):void
		{
			this.fadeUpdateHandler(event);
			
			this._fade.removeEventListener(AnimationEvent.UPDATE, fadeUpdateHandler);
			this._fade.removeEventListener(AnimationEvent.COMPLETE, fadeCompleteHandler);
			this._fade = null;
		}
		
	}
}