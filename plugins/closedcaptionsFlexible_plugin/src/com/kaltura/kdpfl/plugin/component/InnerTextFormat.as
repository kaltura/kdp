package com.kaltura.kdpfl.plugin.component
{
	import flash.text.TextFormat;

	/**
	 * This class represents a textFormat within the paragraph 
	 * @author michalr
	 * 
	 */	
	public class InnerTextFormat
	{
		/**
		 * the start index whithin the paragraph for this text format  
		 */		
		public var startIndex:int;
		/**
		 * the end index whithin the paragraph of this text format 
		 */		
		public var endIndex:int;
		/**
		 * the textFormat 
		 */		
		public var textFormat:TextFormat;
		
		public function InnerTextFormat(startIndex:int, endIndex:int, textFormat:TextFormat)
		{
			this.startIndex = startIndex;
			this.endIndex = endIndex;
			this.textFormat = textFormat;
		}
	}
}