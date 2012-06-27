/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.controls.carouselClasses
{
	import fl.controls.listClasses.ListData;
	import fl.core.UIComponent;

	/**
	 * List data used by cell renderers that appear in a Carousel.
	 * 
	 * @see com.yahoo.astra.fl.controls.Carousel
	 * @author Josh Tynjala
	 */
	public class CarouselListData extends ListData
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function CarouselListData(label:String, source:Object, icon:Object, owner:UIComponent, index:uint, row:uint, col:uint=0)
		{
			super(label, icon, owner, index, row, col);
			this.source = source;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * The source used for a loaded image. Typically, a cell renderer will
		 * have a UILoader instance that uses this value.
		 */
		public var source:Object;
	}
}