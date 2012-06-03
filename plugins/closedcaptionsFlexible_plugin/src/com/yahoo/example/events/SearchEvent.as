/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.example.events
{
	import flash.events.Event;

	public class SearchEvent extends Event
	{
		public static const SEARCH:String = "search"
		
		public function SearchEvent(type:String, query:String)
		{
			super(type, false, false);
			this.query = query;
		}
		
		public var query:String;
		
		override public function clone():Event
		{
			return new SearchEvent(this.type, this.query);
		}
	}
}