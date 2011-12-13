/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.containers.layoutClasses
{
	import com.yahoo.astra.fl.utils.UIComponentUtil;
	import com.yahoo.astra.layout.ILayoutContainer;
	import com.yahoo.astra.layout.LayoutContainer;
	import com.yahoo.astra.layout.LayoutManager;
	import com.yahoo.astra.layout.events.LayoutEvent;
	import com.yahoo.astra.layout.modes.ILayoutMode;
	import com.yahoo.astra.utils.NumberUtil;
	
	import fl.containers.BaseScrollPane;
	import fl.controls.ScrollBar;
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	/**
	 * A variation on the ScrollPane container that accepts children
	 * to be arranged using a layout algorithm.
	 * 
	 * @see fl.containers.ScrollPane
	 * 
	 * @author Josh Tynjala
	 */
	public class BaseLayoutPane extends BaseScrollPane
	{
		
	//--------------------------------------
	//  Static Properties
	//--------------------------------------
	
		/**
		 * @private
		 * New invalidation type to capture when debug mode changes.
		 */
		protected static const INVALIDATION_TYPE_DEBUG_MODE:String = "debugModeInvalid";
	
		/**
		 * @private
		 * New invalidation type to capture when something will affect the layout.
		 */
		protected static const INVALIDATION_TYPE_LAYOUT:String = "layoutInvalid";
	
        /**
         * @private
         */
		private static var defaultStyles:Object =
		{
			skin: Shape, //transparent background skin
			focusRectSkin: null,
			focusRectPadding: null,
			contentPadding: 0 //recommended to use padding properties of the layout mode, if available
		}

	//--------------------------------------
	//  Static Methods
	//--------------------------------------
	
        /**
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
         * @see fl.core.UIComponent#getStyle() UIComponent.getStyle()
         * @see fl.core.UIComponent#setStyle() UIComponent.setStyle()
         * @see fl.managers.StyleManager StyleManager
         */
		public static function getStyleDefinition():Object
		{
			return mergeStyles(defaultStyles, BaseScrollPane.getStyleDefinition());
		}
		
		/**
		 * @private
		 * Tell the LayoutManager which events from the Flash CS3 UIComponents
		 * should trigger a layout update.
		 */
		private static function initializeLayoutEvents():void
		{
			LayoutManager.registerInvalidatingEvents(UIComponent, [ComponentEvent.MOVE, ComponentEvent.RESIZE]);
			
			try
			{
				//if the UILoader component is available, register Event.COMPLETE
				var uiLoader:Class = getDefinitionByName("fl.containers.UILoader") as Class;
				if(uiLoader)
				{
					LayoutManager.registerInvalidatingEvents(uiLoader, [Event.COMPLETE]);
				}
			}
			catch(error:Error)
			{
				//do nothing
			}
		}
		initializeLayoutEvents();
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 * 
		 * @param mode				An instance of an ILayoutMode implementation.
		 */
		public function BaseLayoutPane(mode:ILayoutMode = null)
		{
			super();
			
			this.layoutMode = mode;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * The generic container used for the children. 
		 */
		protected var layoutContainer:ILayoutContainer;
		
		/**
		 * @private
		 * Flag indicating that children added to the BaseLayoutPane
		 * may actually be added to the layout container.
		 */
		private var _uiConfigured:Boolean = false;
		
		/**
		 * @private
		 * Storage for the layoutMode property.
		 */
		private var _layoutMode:ILayoutMode;
		
		/**
		 * The algorithm used to layout children of this container (no default).
		 */
		public function get layoutMode():ILayoutMode
		{
			return this._layoutMode;
		}
		
		/**
		 * @private
		 */
		public function set layoutMode(value:ILayoutMode):void
		{
			this._layoutMode = value;
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Indicates whether the width has been explicitly set. If not, the
		 * stored value will be NaN.
		 */
		protected var explicitWidth:Number = NaN;
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			this.setSize(value, this.explicitHeight);
		}
		
		/**
		 * @private
		 * Indicates whether the height has been explicitly set. If not, the
		 * stored value will be NaN.
		 */
		protected var explicitHeight:Number = NaN;
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			this.setSize(this.explicitWidth, value);
		}
		
		/**
		 * @private
		 * Overrode this because the original Adobe version led to infinite loops.
		 */
		override public function get horizontalPageScrollSize():Number
		{
			return (this._horizontalPageScrollSize == 0 && !isNaN(this.availableWidth)) ? this.availableWidth : this._horizontalPageScrollSize;
		}
		
		/**
		 * @private
		 * Overrode this because the original Adobe version led to infinite loops.
		 */
		override public function get verticalPageScrollSize():Number
		{
			return (this._verticalPageScrollSize == 0 && !isNaN(this.availableHeight)) ? this.availableHeight : this._verticalPageScrollSize;
		}
		
		/**
		 * @private
		 * If the UI has been configured, return the child count from the
		 * ILayoutContainer instead.
		 */
		override public function get numChildren():int
		{
			if(!this._uiConfigured)
			{
				return super.numChildren;
			}
			
			var container:DisplayObjectContainer = DisplayObjectContainer(this.layoutContainer);
			return container.numChildren;
		}
		
		/**
		 * @private
		 * Storage for the autoSize property.
		 */
		private var _autoSize:Boolean = false;
		
		/**
		 * If true, the container will automatically calculate the ideal width
		 * and height for itself. Any attempts to set the width and height
		 * values manually while autoSize is set to true will be ignored.
		 * 
		 * <p>Note: If you want only one dimension to automatically resize,
		 * autoSize must be false, and you should set the width or height
		 * property to the value of <code>NaN</code>.
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
			this.invalidate(InvalidationType.SIZE);
		}
		
		/**
		 * @private
		 * Used for displaying debug data.
		 */
		protected var debugCanvas:Sprite;
		
		/**
		 * @private
		 * Storage for the debug mode property.
		 */
		private var _debugMode:Boolean = false;
		
		/**
		 * If true, a simple border around the layout pane will identify
		 * its bounds.
		 */
		public function get debugMode():Boolean
		{
			return this._debugMode;
		}
		
		/**
		 * @private
		 */
		public function set debugMode(value:Boolean):void
		{
			this._debugMode = value;
			this.invalidate(INVALIDATION_TYPE_DEBUG_MODE);
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * @private
		 * If the UI has been configured, then all children are added to the
		 * ILayoutContainer instead.
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(!this._uiConfigured)
			{
				return super.addChild(child);
			}
			
			var container:DisplayObjectContainer = DisplayObjectContainer(this.layoutContainer);
			child = container.addChild(child);
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
			return child;
		}
		
		/**
		 * @private
		 * If the UI has been configured, then all children are added to the
		 * ILayoutContainer instead.
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(!this._uiConfigured)
			{
				return super.addChildAt(child, index);
			}
			
			var container:DisplayObjectContainer = DisplayObjectContainer(this.layoutContainer);
			child = container.addChildAt(child, index);
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
			return child;
		}
		
		/**
		 * @private
		 * If the UI has been configured, then all children are removed from the
		 * ILayoutContainer instead.
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if(!this._uiConfigured)
			{
				return super.removeChild(child);
			}
			
			var container:DisplayObjectContainer = DisplayObjectContainer(this.layoutContainer);
			child = container.removeChild(child);
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
			return child;
		}
		
		/**
		 * @private
		 * If the UI has been configured, then all children are removed from the
		 * ILayoutContainer instead.
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			if(!this._uiConfigured)
			{
				return super.removeChildAt(index);
			}
			
			var container:DisplayObjectContainer = DisplayObjectContainer(this.layoutContainer);
			var child:DisplayObject = container.removeChildAt(index);
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
			return child;
		}
		
		/**
		 * @private
		 * If the UI has been configured, then all children are actually in the layoutContainer.
		 */
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			if(!this._uiConfigured)
			{
				super.setChildIndex(child, index);
				return;
			}
			var container:DisplayObjectContainer = DisplayObjectContainer(this.layoutContainer);
			container.setChildIndex(child, index);
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * If the UI has been configured, then all children are actually in the layoutContainer.
		 */
		override public function getChildAt(index:int):DisplayObject
		{
			if(!this._uiConfigured)
			{
				return super.getChildAt(index);
			}
			var container:DisplayObjectContainer = DisplayObjectContainer(this.layoutContainer);
			return container.getChildAt(index);
		}
		
		/**
		 * @private
		 * If the UI has been configured, then all children are actually in the layoutContainer.
		 */
		override public function getChildByName(name:String):DisplayObject
		{
			if(!this._uiConfigured)
			{
				return super.getChildByName(name);
			}
			var container:DisplayObjectContainer = DisplayObjectContainer(this.layoutContainer);
			return container.getChildByName(name);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * <p>Setting the width or height of the container to the value of <code>NaN</code>
		 * will cause it to automatically determine the ideal size for that
		 * dimension. Additionally, the <code>autoSize</code> property can be
		 * set to <code>true</code> to force both the width and height values to
		 * be automatically calculated based on the content.
		 * 
		 * @see autoSize
		 */
		override public function setSize(w:Number, h:Number):void
		{
			this.explicitWidth = w;
			this.explicitHeight = h;
			
			//but we don't want NaN after this point. use the existing _width
			//and _height values with super.setSize() like Adobe already does.
			if(isNaN(w))
			{
				w = this._width;
			}
			if(isNaN(h))
			{
				h = this._height;
			}
			
			super.setSize(w, h);
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function configUI():void
		{
			//save the avatar because super.configUI() removes it
			if(this.numChildren > 0)
			{
				var avatar:DisplayObject = this.getChildAt(0);
			}
			
			super.configUI();
			
			//if there was no avatar, then we can setSize() with NaN as width and height (for autosize).
			//if the user dragged this component on stage, then the size is explicitly set because that's
			//all Flash CS3 can do. if they made it programmatically, then there is no avatar.
			if(!avatar)
			{
				this.setSize(NaN, NaN);
			}
			
			if(!this.layoutContainer)
			{
				this.layoutContainer = new LayoutContainer();
				LayoutContainer(this.layoutContainer).autoMask = false;
				this.layoutContainer.addEventListener(LayoutEvent.LAYOUT_CHANGE, layoutChangeHandler);
				var container:DisplayObject = DisplayObject(this.layoutContainer);
				container.scrollRect = contentScrollRect;
				container.visible = false;
				this.addChild(container);
			} 
			
			if(!this.debugCanvas)
			{
				this.debugCanvas = new Sprite();
				this.addChild(this.debugCanvas);
			}
			
			this._horizontalScrollPolicy = ScrollPolicy.AUTO;
			this._verticalScrollPolicy = ScrollPolicy.AUTO;
			
			//now all children can be added to the ILayoutContainer
			this._uiConfigured = true;
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{	
			//fix for document class constructor/Event.RENDER bug in CS3 architecture
			DisplayObject(this.layoutContainer).visible = true;
			
			//we have to draw all children once before layout
			//to get initial sizing
			this.redrawUIComponentChildren();
				
			//ensure that we only update the layout if the dimensions have changed
			//or if one of the layout properties has changed. this is very, very expensive!
			if(this.isInvalid(InvalidationType.SIZE, INVALIDATION_TYPE_LAYOUT))
			{
				var oldWidth:Number = this.width;
				var oldHeight:Number = this.height;
				
				var container:DisplayObjectContainer = DisplayObjectContainer(this.layoutContainer);
				
				this.layoutContainer.layoutMode = this.layoutMode;
				
				//the first measurement will be based on explicit values or autosizing (with NaN)
				//this is the ideal sizing without scrollbars
				if(this.autoSize || isNaN(this.explicitWidth))
				{
					container.width = NaN;
				}
				else
				{
					container.width = this.explicitWidth;
				}
				if(this.autoSize || isNaN(this.explicitHeight))
				{
					container.height = NaN;
				}
				else
				{
					container.height = this.explicitHeight;
				}
				
				this.layoutContainer.validateLayout();
					
				//floor it because Flash CS3 components are pixel constrained and that may
				//cause the scrollbars to appear when they should not!
				this.setContentSize(Math.floor(this.layoutContainer.contentWidth), Math.floor(this.layoutContainer.contentHeight));
				
				//determine if scrollbars are needed
				this.calculateAvailableSize();
	
				var loopCount:int = 0;
				do
				{
					//scrollbars may be present now that we're working with available dimensions
					//instead of explicit values. we loop in case the scrollbars change again.
					
					var oldAvailableWidth:Number = this.availableWidth;
					var oldAvailableHeight:Number = this.availableHeight;
					
					container.width = this.availableWidth;
					container.height = this.availableHeight;
					this.layoutContainer.validateLayout();
					
					//if the width and height haven't been set explicitly,
					//the layout pane will resize to fit its contents (no scrollbars, obviously).
					if(isNaN(this.explicitWidth) || this.autoSize)
					{
						var generatedWidth:Number = this.layoutContainer.contentWidth;
						if(this.vScrollBar)
						{
							generatedWidth += ScrollBar.WIDTH;
						}
						this._width = Math.round(generatedWidth);	
					}
					
					if(isNaN(this.explicitHeight) || this.autoSize)
					{
						var generatedHeight:Number = this.layoutContainer.contentHeight;
						if(this.hScrollBar)
						{
							generatedHeight += ScrollBar.WIDTH;
						}
						this._height = Math.round(generatedHeight);
					}
						
					this.setContentSize(Math.floor(this.layoutContainer.contentWidth), Math.floor(this.layoutContainer.contentHeight));
					this.calculateAvailableSize();
				
					loopCount++
				}
				while((!NumberUtil.fuzzyEquals(oldAvailableWidth, this.availableWidth, 10) || !NumberUtil.fuzzyEquals(oldAvailableHeight, this.availableHeight)) &&
					loopCount < 10)
				//if we've gone through this loop 10 times, it should be safe to assume that we need to kill an infinite loop
	
				//draw again after layout to ensure proper sizing
				this.redrawUIComponentChildren();
	
				//draw a transparent background so that the mouse scrollwheel works
				//when the skin is empty.
				this.graphics.clear();
				if(this.width > 0 && this.height > 0)
				{
					this.graphics.beginFill(0xff00ff, 0);
					this.graphics.drawRect(0, 0, this.width, this.height);
					this.graphics.endFill();
				}
				
				//dispatch a resize event if we've grown or shrunk
				if(!NumberUtil.fuzzyEquals(oldWidth, this.width) || !NumberUtil.fuzzyEquals(oldHeight, this.height))
				{
					this.dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE));
				}
			}
			
			if(this.debugMode && this.isInvalid(INVALIDATION_TYPE_DEBUG_MODE, InvalidationType.SIZE, INVALIDATION_TYPE_LAYOUT))
			{
				this.debugCanvas.graphics.clear();
				this.debugCanvas.graphics.lineStyle(1, 0xff00ff);
				this.debugCanvas.graphics.drawRect(0, 0, this.width, this.height);
			}
			this.debugCanvas.visible = this.debugMode;
			
			super.draw();
		}
		
		/**
		 * @private
		 * Update the scrollRect of the ILayoutContainer
		 */
		override protected function drawLayout():void
		{
			super.drawLayout();
			
			var container:DisplayObject = DisplayObject(this.layoutContainer);
			
			this.contentScrollRect = container.scrollRect;
			this.contentScrollRect.width = this.availableWidth;
			this.contentScrollRect.height = this.availableHeight;
			
			container.cacheAsBitmap = useBitmapScrolling;
			container.scrollRect = this.contentScrollRect;
		}
		
		/**
		 * @private
		 * Make sure the background isn't in the layout container
		 */
		override protected function drawBackground():void
		{
			var bg:DisplayObject = this.background;
			
			this.background = UIComponentUtil.getDisplayObjectInstance(this, this.getStyleValue("skin"));
			this.background.width = this.width;
			this.background.height = this.height;
			super.addChildAt(this.background,0);
			
			if(bg != null && bg != background)
			{
				super.removeChild(bg);
			}
		}
		
		/**
		 * @private
		 * Call drawNow() on any Flash UIComponent children this container holds.
		 */
		protected function redrawUIComponentChildren():void
		{
			var container:DisplayObjectContainer = DisplayObjectContainer(this.layoutContainer);
			for(var i:int = 0; i < container.numChildren; i++)
			{
				var child:UIComponent = container.getChildAt(i) as UIComponent;
				if(child)
				{
					child.drawNow();
				}
			}
		}
		
        /**
         * @private
		 * Update the scrollRect of the ILayoutContainer
         */
		override protected function setVerticalScrollPosition(scrollPos:Number, fireEvent:Boolean=false):void
		{	
			var container:DisplayObject = DisplayObject(this.layoutContainer);
			
			var contentScrollRect:Rectangle = container.scrollRect;
			contentScrollRect.y = scrollPos;
			container.scrollRect = contentScrollRect;
		}

        /**
         * @private
		 * Update the scrollRect of the ILayoutContainer
         */
		override protected function setHorizontalScrollPosition(scrollPos:Number, fireEvent:Boolean=false):void
		{
			var container:DisplayObject = DisplayObject(this.layoutContainer);
			
			var contentScrollRect:Rectangle = container.scrollRect;
			contentScrollRect.x = scrollPos;
			container.scrollRect = contentScrollRect;
		}
		
		/**
		 * @private
		 * Custom calculation of the available size
		 */
		override protected function calculateAvailableSize():void
		{
			super.calculateAvailableSize();
			
			//if we're autosizing, available dimensions are the same as the content
			if(isNaN(this.explicitWidth) || this.autoSize)
			{
				this.availableWidth = this.layoutContainer.contentWidth;
				this.hScrollBar = false;
			}
			if(isNaN(this.explicitHeight) || this.autoSize)
			{
				this.availableHeight = this.layoutContainer.contentHeight;
				this.vScrollBar = false;
			}
		}
		
	//--------------------------------------
	//  Protected Event Handlers
	//--------------------------------------
	
		/**
		 * @private
		 * If the layout has changed, we're probably in Flash Player's
		 * render phase. If the UIComponent initiated it, this control
		 * is drawing and we don't need to redraw. If the layout container
		 * initiated it, then we should draw immediately because we
		 * may not get a render event...
		 */
		protected function layoutChangeHandler(event:LayoutEvent):void
		{
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
	}
}