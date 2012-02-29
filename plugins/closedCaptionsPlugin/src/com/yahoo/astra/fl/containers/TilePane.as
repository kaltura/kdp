/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.containers
{
	import com.yahoo.astra.fl.containers.layoutClasses.AdvancedLayoutPane;
	import com.yahoo.astra.layout.modes.HorizontalAlignment;
	import com.yahoo.astra.layout.modes.TileLayout;
	import com.yahoo.astra.layout.modes.VerticalAlignment;
	
	import fl.core.InvalidationType;

	/**
	 * A scrolling container that arranges its children using a tiling
	 * algorithm where the largest child determines the size of the tiles.
	 * 
	 * @example The following code configures a TilePane container:
	 * <listing version="3.0">
	 * var pane:FlowPane = new TilePane();
	 * pane.direction = "horizontal";
	 * pane.horizontalGap = 4;
	 * pane.verticalGap = 4;
	 * pane.horizontalAlign = HorizontalAlignment.CENTER;
	 * pane.verticalAlign = VerticalAlignment.MIDDLE;
	 * this.addChild( pane );
	 * </listing>
	 * 
	 * <p>This layout container supports advanced options specified through the
	 * <code>configuration</code> property.</p>
	 * 
	 * <dl>
	 * 	<dt><strong><code>target</code></strong> : DisplayObject</dt>
	 * 		<dd>A display object to be configured.</dd>
	 * 	<dt><strong><code>includeInLayout</code></strong> : Boolean</dt>
	 * 		<dd>If <code>false</code>, the target will not be included in layout calculations. The default value is <code>true</code>.</dd>
	 * </dl>
	 * @see com.yahoo.astra.layout.modes.TileLayout
	 * @author Josh Tynjala
	 */
	public class TilePane extends AdvancedLayoutPane
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 * 
		 * @param configuration		An Array of optional configurations for the layout container's children.
		 */
		public function TilePane(configuration:Array = null)
		{
			super(new TileLayout(), configuration);
		}

	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
		 * Storage for the direction property.
		 */
		private var _direction:String = "horizontal";
		
		/**
		 * The direction in which children of this container are laid out. Once
		 * the edge of the container is reached, the children will begin
		 * appearing on the next row or column. Valid direction values include
		 * <code>"vertical"</code> or <code>"horizontal"</code>.
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
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Storage for the verticalGap property.
		 */
		private var _verticalGap:Number = 0;
		
		/**
		 * The number of pixels appearing between the container's children
		 * vertically.
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
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Storage for the horizontalGap property.
		 */
		private var _horizontalGap:Number = 0;
		
		/**
		 * The number of pixels appearing between the container's children
		 * horizontally.
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
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Storage for the verticalAlign property.
		 */
		private var _verticalAlign:String = VerticalAlignment.TOP;
		
		/**
		 * The vertical alignment of children displayed in the container.
		 * 
		 * @see com.yahoo.astra.layout.VerticalAlignment
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
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Storage for the horizontalAlign property.
		 */
		private var _horizontalAlign:String = HorizontalAlignment.LEFT;
		
		/**
		 * The horizontal alignment of children displayed in the container.
		 * 
		 * @see com.yahoo.astra.layout.HorizontalAlignment
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
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Storage for the tileWidth property.
		 */
		private var _tileWidth:Number = NaN;
		
		/**
		 * The width of tiles displayed in the target. If NaN, the tile width
		 * will be calculated based on the maximum width among the target's children.
		 */
		public function get tileWidth():Number
		{
			return this._tileWidth;
		}
		
		/**
		 * @private
		 */
		public function set tileWidth(value:Number):void
		{
			this._tileWidth = value;
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
		/**
		 * @private
		 * Storage for the tileHeight property.
		 */
		private var _tileHeight:Number = NaN;
		
		/**
		 * The height of tiles displayed in the target. If NaN, the tile height
		 * will be calculated based on the maximum height among the target's children.
		 */
		public function get tileHeight():Number
		{
			return this._tileHeight;
		}
		
		/**
		 * @private
		 */
		public function set tileHeight(value:Number):void
		{
			this._tileHeight = value;
			this.invalidate(INVALIDATION_TYPE_LAYOUT);
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var tileLayout:TileLayout = this.layoutMode as TileLayout;
			
			if(tileLayout)
			{
				//pass the various properties to the layout mode
				tileLayout.direction = this.direction;
				tileLayout.horizontalAlign = this.horizontalAlign;
				tileLayout.verticalAlign = this.verticalAlign;
				tileLayout.horizontalGap = this.horizontalGap;
				tileLayout.verticalGap = this.verticalGap;
				tileLayout.tileWidth = this.tileWidth;
				tileLayout.tileHeight = this.tileHeight;
			}
			
			super.draw();
		}
		
	}
}