/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.data{
	import flash.events.EventDispatcher;
	
	import fl.events.DataChangeEvent;
	import fl.events.DataChangeType;
	import fl.data.DataProvider;
	
	import com.yahoo.astra.fl.utils.XMLUtil;
	
	import RangeError;
	//--------------------------------------
	//  Class description
	//--------------------------------------
	/**
	 * The XMLDataProvider class provides a way to use hierarchical XML data in a control
	 *
	 * @author Alaric Cole
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0 
	 */
	public class XMLDataProvider extends DataProvider 
	{
		/**
		 * Creates a new XMLDataProvider object using a list, XML instance or an array of data objects
		 * as the data source. 
		 * 
		 * @param data The data that is used to create the XMLDataProvider.
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function XMLDataProvider(value:Object=null) 
		{
			super(value);
		}
		/**
		 * @private (protected)
		 * Overrides DataProvider's main method for parsing objects
		 * to allow for hierarchical XML
		 *
		 * @see com.yahoo.astra.fl.utils.XMLUtil
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override protected function getDataFromObject(obj:Object):Array 
		{
			var retArr:Array;
			if (obj is Array) 
			{
				var arr:Array = obj as Array;
				if (arr.length > 0) 
				{
					if (arr[0] is String || arr[0] is Number) 
					{
						retArr = [];
						// convert to object array.
						for (var i:uint = 0; i < arr.length; i++) 
						{
							var o:Object = {label:String(arr[i]),data:arr[i]
						}
							retArr.push(o);
						}
						return retArr;
					}
				}
				return obj.concat();
			} 
			
			else if (obj is DataProvider) 
			{
				return obj.toArray();
			} 
			else if (obj is XML) 
			{
				var xml:XML = obj as XML;
				var nodes:XMLList = xml.*;
				//create hierarchical XML instead of a flat list
				retArr = XMLUtil.createArrayFromXML(nodes);
				return retArr;
			} 
			else 
			{
				throw new TypeError("Error: Type Coercion failed: cannot convert " + obj + " to Array or DataProvider.");
				return null;
			}
		}
	}
}