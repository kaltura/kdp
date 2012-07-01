/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.controls.carouselClasses
{
	import com.yahoo.astra.fl.controls.Carousel;
	import com.yahoo.astra.layout.modes.BoxLayout;
	
	import fl.controls.listClasses.ICellRenderer;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * A Carousel renderer that displays items in a horizontal row or a vertical
	 * column. Resizes so that all cell renderers are displayed.
	 * 
	 * @see com.yahoo.astra.fl.controls.Carousel
	 * @author Josh Tynjala
	 */
	public class BoxCarouselRenderer extends UIComponent implements ICarouselLayoutRenderer
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function BoxCarouselRenderer()
		{
			super();
			this.scrollRect = new Rectangle();
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * The active cell renderers being used by this layout renderer.
		 */
		protected var renderers:Array = [];
		
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
		 * Storage for the direction property.
		 */
		private var _direction:String = "horizontal";
		
		/**
		 * The direction in which item renderers are positioned.
		 * May be <code>"vertical"</code> or <code>"horizontal"</code>.
		 */
		public function get direction():String
		{
			return this._direction;
		}
		
		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			this._direction = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		/**
		 * @private
		 * Storage for the horizontalGap property.
		 */
		private var _horizontalGap:Number = 0;
		
		/**
		 * The number of extra pixels placed between each cell renderer
		 * when <code>direction</code> is set to <code>"horizontal"</code>.
		 */
		public function get horizontalGap():Number
		{
			return this._horizontalGap;
		}
		
		/**
		 * @private
		 */
		public function set horizontalGap(value:Number):void
		{
			this._horizontalGap = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		/**
		 * @private
		 * Storage for the verticalGap property.
		 */
		private var _verticalGap:Number = 0;
		
		/**
		 * The number of extra pixels placed between each cell renderer
		 * when <code>direction</code> is set to <code>"vertical"</code>.
		 */
		public function get verticalGap():Number
		{
			return this._verticalGap;
		}
		
		/**
		 * @private
		 */
		public function set verticalGap(value:Number):void
		{
			this._verticalGap = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		/**
		 * @private
		 * Storage for the horizontalAlign property.
		 */
		private var _horizontalAlign:String = "center";
		
		/**
		 * When <code>direction</code> is set to <code>"horizontal"</code>,
		 * this value indicates the alignment of the selected item. Accepted
		 * values include <code>"left"</code>, <code>"center"</code>, and
		 * <code>"right"</code>
		 * 
		 * @default "center"
		 */
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}
		
		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			this._horizontalAlign = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		/**
		 * @private
		 * Storage for the verticalAlign property.
		 */
		private var _verticalAlign:String = "middle";
		
		/**
		 * When <code>direction</code> is set to <code>"vertical"</code>,
		 * this value indicates the alignment of the selected item. Accepted
		 * values include <code>"top"</code>, <code>"middle"</code>, and
		 * <code>"bottom"</code>
		 * 
		 * @default "middle"
		 */
		public function get verticalAlign():String
		{
			return this._verticalAlign;
		}
		
		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			this._verticalAlign = value;
			this.invalidate(InvalidationType.STATE);
		}
		
		/**
		 * @private
		 * Storage for the displayedItemCount property.
		 */
		private var _displayedItemCount:int = 0;
		
		/**
		 * Sets a specific number of items to display in the carousel at one
		 * time and resizes the carousel to make them all visible. This property
		 * is useful for developers who want to display carousel items in
		 * "pages" with a specific number of items per page.</p>
		 * 
		 * <p>The default value is <code>0</code> (zero), which means that no
		 * changes to the width and height will be made. Some items may only
		 * be partially visible (cut off).</p>
		 */
		public function get displayedItemCount():int
		{
			return this._displayedItemCount;
		}
		
		/**
		 * @private
		 */
		public function set displayedItemCount(value:int):void
		{
			this._displayedItemCount = value;
			this.invalidate(InvalidationType.DATA);
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
		 * Storage for the clickToSelect property.
		 */
		private var _clickToSelect:Boolean = true;
		
		/**
		 * If true, clicking on an item renderer will select its item. If false,
		 * selection must be changed by setting selectedIndex or selectedItem on
		 * the Carousel from an external interaction.
		 */
		public function get clickToSelect():Boolean
		{
			return this._clickToSelect;
		}
		
		/**
		 * @private
		 */
		public function set clickToSelect(value:Boolean):void
		{
			this._clickToSelect = value;
			//no need to validate
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * @private
		 */
		public function cleanUp():void
		{
			//nothing to clean up in this implementation
			var rendererCount:int = this.renderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				var renderer:Sprite = Sprite(this.renderers[i]);
				renderer.removeEventListener(MouseEvent.CLICK, rendererClickHandler);
			}
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var oldWidth:Number = this.width;
			var oldHeight:Number = this.height;
			
			if(this.carousel.length == 0 || this.carousel.selectedIndex < 0)
			{
				//nothing to draw
				this._width = 0;
				this._height = 0;
			}
			else
			{
				this.renderers = this.createRenderers();
				this.layoutRenderers(this.renderers);
				this.calculateDimensions(this.renderers);
			}
			
			var scrollRect:Rectangle = this.scrollRect;
			scrollRect.width = this.width;
			scrollRect.height = this.height;
			this.scrollRect = scrollRect;
			
			super.draw();
			
			if(this.displayedItemCount > 0 && (oldWidth != this.width || oldHeight != this.height))
			{
				this.dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE));
			}
		}
	
		/**
		 * @private
		 * Under certain conditions, this renderer will update its own width and
		 * height to ensure that a specific number of renderers are displayed.
		 */
		protected function calculateDimensions(renderers:Array):void
		{
			var selectedRenderer:DisplayObject = DisplayObject(this.carousel.itemToCellRenderer(this.carousel.selectedItem));
			if(this.displayedItemCount > 0)
			{
				if(this.direction == "horizontal")
				{
					this._width = selectedRenderer.width * this.displayedItemCount + this.horizontalGap * (this.displayedItemCount - 1);
					this._height = selectedRenderer.height;
				}
				else
				{
					this._width = selectedRenderer.width;
					this._height = selectedRenderer.height * this.displayedItemCount + this.verticalGap * (this.displayedItemCount - 1);
				} 
			}
		}
		
		/**
		 * @private
		 * Creates the required renderers.
		 */
		protected function createRenderers():Array
		{
			this.carousel.astra_carousel_internal::invalidateCellRenderers();
			
			var renderers:Array = [];
			var rendererCount:int = this.carousel.length;
			for(var i:int = 0; i < rendererCount; i++)
			{	
				var item:Object = this.carousel.dataProvider.getItemAt(i);
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
		 * Determines the number of renderers that will be displayed.
		 */
		protected function calculateRendererCount():int
		{
			var rendererCount:int = this.carousel.length;
			if(rendererCount > 0 && !this.drawAllRenderers)
			{
				var firstItem:Object = this.carousel.dataProvider.getItemAt(0);
				var firstRenderer:DisplayObject = this.carousel.astra_carousel_internal::createCellRenderer(firstItem);
				var totalDisplayedItemCount:int = this.displayedItemCount;
				if(this.displayedItemCount == 0)
				{
					if(this.direction == "horizontal")
					{
						totalDisplayedItemCount = Math.ceil(this.width / firstRenderer.width);
					}
					else
					{
						totalDisplayedItemCount = Math.ceil(this.height / firstRenderer.height);
					} 
				}
				rendererCount = totalDisplayedItemCount;
			}
			
			return Math.min(this.carousel.length, rendererCount);
		}
		
		/**
		 * @private
		 * Positions the renderers.
		 */
		protected function layoutRenderers(renderers:Array):void
		{
			var boxLayout:BoxLayout = new BoxLayout();
			boxLayout.direction = this.direction;
			boxLayout.verticalGap = this.verticalGap;
			boxLayout.horizontalGap = this.horizontalGap;
			boxLayout.layoutObjects(renderers, new Rectangle(0, 0, this.width, this.height));
		}
		
		/**
		 * @private
		 * Updates the carousel's selection when an item is clicked.
		 */
		protected function rendererClickHandler(event:MouseEvent):void
		{
			if(!this.clickToSelect)
			{
				return;
			}
			
			var renderer:ICellRenderer = ICellRenderer(event.currentTarget);
			this.carousel.selectedItem = renderer.data;
			this.carousel.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}