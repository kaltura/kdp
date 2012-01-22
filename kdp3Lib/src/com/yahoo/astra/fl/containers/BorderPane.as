/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.containers
{
	import com.yahoo.astra.fl.containers.layoutClasses.AdvancedLayoutPane;
	import com.yahoo.astra.layout.modes.BorderLayout;
	
	import fl.core.InvalidationType;

	/**
	 * A container that arranges its children similar to a non-scrolling document
	 * page. Top and bottom constraints define headers and footers. Left and
	 * right constraints define sidebars, and a center constraint stetches the
	 * main contents to fill the remaining space.
	 * 
	 * <p>This layout container supports advanced options specified through the
	 * <code>configuration</code> property.</p>
	 * 
	 * <p><strong>Available Configuration Options</strong></p>
	 * <dl>
	 * 	<dt><strong><code>target</code></strong> : DisplayObject</dt>
	 * 		<dd>A display object to be configured.</dd>
	 * 	<dt><strong><code>constraint</code></strong> : String</dt>
	 * 		<dd>The BorderConstraints value to be used on the target by the layout algorithm. The default
	 * 		value is <code>BorderConstraints.CENTER</code>.</dd>
	 * 	<dt><strong><code>maintainAspectRatio</code></strong> : Boolean</dt>
	 * 		<dd>If true, the aspect ratio of the target will be maintained if it is resized.</dd>
	 * 	<dt><strong><code>horizontalAlign</code></strong> : String</dt>
	 * 		<dd>The horizontal alignment used when positioning the target. Used in combination with
	 * 		<code>maintainAspectRatio</code>.</dd>
	 * 	<dt><strong><code>verticalAlign</code></strong> : String</dt>
	 * 		<dd>The vertical alignment used when positioning the target. Used in combination with
	 * 		<code>maintainAspectRatio</code>.</dd>
	 * 	<dt><strong><code>aspectRatio</code></strong> : Number</dt>
	 * 		<dd>The desired aspect ratio to use with <code>maintainAspectRatio</code>. This value is optional.
	 * 		If no aspect ratio is provided, it will be determined based on the target's original width and height.</dd>
	 * 	<dt><strong><code>includeInLayout</code></strong> : Boolean</dt>
	 * 		<dd>If <code>false</code>, the target will not be included in layout calculations. The default value is <code>true</code>.</dd>
	 * </dl>
	 * 
	 * @example The following code sets the configuration options for a BorderPane
	 * <listing version="3.0">
	 * pane.configuration =  [
	 * 	{ target: headerSprite, constraint: BorderContstraints.TOP },
	 * 	{ target: contentSprite, constraint: BorderConstraints.CENTER,
	 * 		maintainAspectRatio: true, horizontalAlign: "center",
	 * 		verticalAlign: "middle" }
	 * ];
	 * </listing>
	 * 
	 * @see com.yahoo.astra.layout.BorderConstraints
	 * @see com.yahoo.astra.layout.HorizontalAlignment
	 * @see com.yahoo.astra.layout.VerticalAlignment
	 * 
	 * @author Josh Tynjala
	 */
	public class BorderPane extends AdvancedLayoutPane
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 * 
		 * @param configuration		An Array of optional configurations for the layout container's children.
		 */
		public function BorderPane(configuration:Array = null)
		{
			super(new BorderLayout(), configuration);
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
		 * Storage for the verticalGap property.
		 */
		private var _verticalGap:Number = 0;
		
		/**
		 * The number of vertical pixels between each item displayed by this
		 * container.
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
		 * The number of horizontal pixels between each item displayed by this
		 * container.
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
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var borderLayout:BorderLayout = this.layoutMode as BorderLayout;
			if(borderLayout)
			{	
				borderLayout.horizontalGap = this.horizontalGap;
				borderLayout.verticalGap = this.verticalGap;
			}
			
			super.draw();
		}
		
	}
}