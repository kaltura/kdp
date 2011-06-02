/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.utils{
	/**
	 *  The XMLUtil class is an all-static class
	 *  with methods for working with XML within Flash.
	 *  Not to be confused with fl.utils.XMLUtil.
	 *  You do not create instances of XMLUtil;
	 *  instead you simply call static methods such as
	 *  the <code>XMLUtil.createArrayFromXML()</code> method.
	 *
	 *  @author Alaric Cole
	 *  @see com.yahoo.astra.fl.data.XMLDataProvider 
	 */
	public class XMLUtil 
	{
		/**
		 * Creates an object with properties extracted from XML attributes
		 * @param node 
		 */
		public static function createObjectFromXMLAttributes(node:XML):Object 
		{
			//create an object and give it props from this nodes attributes
			var obj:Object = {};
			var attrs:XMLList = node.attributes();
			for each (var attr:XML in attrs) 
			{
				obj[attr.localName()] = attr.toString();
			}
			return obj;
		}
		/**
		 * Creates a hierarchical array from XML or an XMLList
		 * @param xml An XML or XMLList object
		 */
		public static function createArrayFromXML(xml:Object):Array 
		{
			var nodes:XMLList;
			var ar:Array = [];
			if (xml is XML) 
			{
				nodes = XML(xml).children();
			} else if (xml is XMLList) 
			{
				nodes = xml as XMLList;
			} else 
			{
				throw new TypeError("Error: Type Coercion failed: cannot convert " + xml + " to XML or XMLList.");
				return null;
			}
			//loop through top level nodes
			for each (var node:XML in nodes) 
			{
				var obj:Object = createObjectFromXMLAttributes(node);
				//loop through any nodes in this node
				var propNodes:XMLList = node.*;
				var data:Array = createArrayFromXML(propNodes);
				if (data.length) 
				{
					obj.data = data;
				}
				ar.push(obj);
			}
			return ar;
		}
	}
}