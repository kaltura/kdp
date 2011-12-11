/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.controls.carouselClasses
{
	import fl.containers.UILoader;
	import fl.controls.listClasses.CellRenderer;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 * The padding that separates the edge of the cell from the edge of the text, 
	 * in pixels.
	 *
     * @default 3
	 */
	[Style(name="textPadding", type="Number", format="Length")]
	
	/**
	 * The padding that separates the edge of the cell from the edge of the image, 
	 * in pixels.
	 *
     * @default 1
	 */
	[Style(name="imagePadding", type="Number", format="Length")]

    /**
     *  The TextFormat object to use to render the component label when an item is selected.
     *
     *  @default TextFormat("_sans", 12, 0x000000, false, false, false, '', '', TextFormatAlign.LEFT, 0, 0, 0, 0)
     *
     *  @see flash.text.TextFormat TextFormat
     */
	[Style(name="selectedTextFormat", type="flash.text.TextFormat")]
	
	/**
	 * The default cell renderer for the Carousel control.
	 * 
	 * @see com.yahoo.astra.fl.controls.Carousel
	 * @author Josh Tynjala 
	 */
	public class CarouselCellRenderer extends CellRenderer
	{
		
	//--------------------------------------
	//  Static Properties
	//--------------------------------------
	
		/**
         * @private
		 */
		private static var defaultStyles:Object =
		{
			imagePadding: 1,
			textPadding: 3,
			upSkin: "CarouselCellRenderer_upSkin",
			overSkin: "CarouselCellRenderer_overSkin",
			downSkin: "CarouselCellRenderer_downSkin",
			disabledSkin: "CarouselCellRenderer_disabledSkin",
			selectedUpSkin: "CarouselCellRenderer_selectedUpSkin",
			selectedOverSkin: "CarouselCellRenderer_selectedOverSkin",
			selectedDownSkin: "CarouselCellRenderer_selectedDownSkin",
			selectedDisabledSkin: "CarouselCellRenderer_selectedDisabledSkin",
			selectedTextFormat: new TextFormat("_sans", 12, 0x000000, false, false, false, "", "", TextFormatAlign.CENTER, 0, 0, 0, 0)
		}
				
	//--------------------------------------
	//  Static Methods
	//--------------------------------------
				
        /**
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
         * @see fl.core.UIComponent#getStyle()
         * @see fl.core.UIComponent#setStyle()
         * @see fl.managers.StyleManager
         */
		public static function getStyleDefinition():Object
		{
			return mergeStyles(defaultStyles, CellRenderer.getStyleDefinition());
		}
			
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */								
		public function CarouselCellRenderer()
		{
			super();
			this.setStyle("textFormat", new TextFormat("_sans", 12, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER, 0, 0, 0, 0));
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
		 */
		protected var loader:UILoader;
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function configUI():void
		{
			super.configUI();
			
			if(!this.loader)
			{
				this.loader = new UILoader();
				this.loader.scaleContent = true;
				this.loader.maintainAspectRatio = true;
				this.addChild(this.loader);
			}
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var loaderSource:Object = CarouselListData(this.listData).source;
			if(this.loader.source != loaderSource)
			{
				this.loader.source = loaderSource;
			}
			
			super.draw();
			
			//we size the loader based on the textField size
			//since CellRenderer only resizes when the label
			//has a value, we need to manually make the textField
			//smaller when there is no label.
			if(this.label.length == 0)
			{
				this.textField.width = 0;
				this.textField.height = 0;
			}
			
			var textPadding:Number = this.getStyleValue("textPadding") as Number;
			this.textField.y = this.height - this.textField.height - textPadding;
			if(this.selected)
			{
				
			}
			
			var imagePadding:Number = this.getStyleValue("imagePadding") as Number;
			var loaderWidth:Number = this.width - 2 * imagePadding;
			var loaderHeight:Number = this.textField.y - imagePadding - Math.max(imagePadding, textPadding);
			this.loader.setSize(loaderWidth, loaderHeight);
			this.loader.drawNow();
			
			super.draw();
		}
		
		/**
		 * @private
		 * Expands on the default implementation to include a TextFormat
		 * used when the item is selected.
		 */
		override protected function drawTextFormat():void
		{
			super.drawTextFormat();
			if(this.selected)
			{
				var selectedTextFormat:TextFormat = this.getStyleValue("selectedTextFormat") as TextFormat;
				if(selectedTextFormat)
				{
					this.textField.setTextFormat(selectedTextFormat);
					this.textField.defaultTextFormat = selectedTextFormat;
				}
			}
		}
	}
}