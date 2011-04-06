/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.containers
{
	import com.yahoo.astra.fl.containers.layoutClasses.AdvancedLayoutPane;
	import com.yahoo.astra.layout.modes.BoxLayout;
	import com.yahoo.astra.layout.modes.HorizontalAlignment;
	import com.yahoo.astra.layout.modes.VerticalAlignment;
	
	import fl.core.InvalidationType;
	
	/**
	 * A scrolling container that arranges its children one after the other
	 * in a row or column.
	 * 
	 * @example The following code configures a BoxPane container:
	 * <listing version="3.0">
	 * var pane:BoxPane = new BoxPane();
	 * pane.direction = "vertical";
	 * pane.verticalGap = 4;
	 * pane.verticalAlign = VerticalAlignment.MIDDLE;
	 * this.addChild( pane );
	 * </listing>
	 * 
	 * <p>This layout container supports advanced options specified through the
	 * <code>configuration</code> property.</p>
	 * 
	 * <p><strong>Available Configuration Options</strong></p>
	 * <dl>
	 * 	<dt><strong><code>target</code></strong> : DisplayObject</dt>
	 * 		<dd>A display object to be configured.</dd>
	 * 	<dt><strong><code>percentWidth</code></strong> : Number</dt>
	 * 		<dd>The target's width will be updated based on a percentage of the width specified in the layout bounds.</dd>
	 * 	<dt><strong><code>percentHeight</code></strong> : Number</dt>
	 * 		<dd>The target's width will be updated based on a percentage of the width specified in the layout bounds.</dd>
	 * 	<dt><strong><code>minWidth</code></strong> : Number</dt>
	 * 		<dd>The minimum width value to allow when resizing. The default value is <code>0</code>.</dd>
	 * 	<dt><strong><code>minHeight</code></strong> : Number</dt>
	 * 		<dd>The minimum height value to allow when resizing. The default value is <code>0</code>.</dd>
	 * 	<dt><strong><code>maxWidth</code></strong> : Number</dt>
	 * 		<dd>The maximum width value to allow when resizing. The default value is <code>10000</code>.</dd>
	 * 	<dt><strong><code>maxHeight</code></strong> : Number</dt>
	 * 		<dd>The maximum height value to allow when resizing. The default value is <code>10000</code>.</dd>
	 * 	<dt><strong><code>includeInLayout</code></strong> : Boolean</dt>
	 * 		<dd>If <code>false</code>, the target will not be included in layout calculations. The default value is <code>true</code>.</dd>
	 * </dl>
	 * @see com.yahoo.astra.layout.modes.BoxLayout
	 * @author Josh Tynjala
	 */
	public class BoxPane extends AdvancedLayoutPane
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 * 
		 * @param configuration		An Array of optional configurations for the layout container's children.
		 */
		public function BoxPane(configuration:Array = null)
		{
			super(new BoxLayout(), configuration);
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
		 * The direction in which children of this container are laid out. Valid
		 * direction values include <code>"vertical"</code> or <code>"horizontal"</code>.
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
		 * The number of pixels appearing between children when the direction
		 * is set to <code>"vertical"</code>.
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
		 * The number of pixels appearing between children when the direction
		 * is set to <code>"horizontal"</code>.
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
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var boxLayout:BoxLayout = this.layoutMode as BoxLayout;
			if(boxLayout)
			{
				//pass the various properties to the layout mode
				boxLayout.direction = this.direction;
				boxLayout.horizontalAlign = this.horizontalAlign;
				boxLayout.verticalAlign = this.verticalAlign;
				boxLayout.horizontalGap = this.horizontalGap;
				boxLayout.verticalGap = this.verticalGap;
			}
			
			super.draw();
		}
	}
}