package com.kaltura.utils.parsers
{
	/**
	 * DateParser holds method for parsing dates.
	 */	
	public class DateParser
	{
		
		/**
		 * parses a string date in yyyy-mm-dd hh:mm:ss to a Date object
		 * @param d
		 * @return
		 *
		 */
		public static function parse1(sDate:String):Date
		{
			//2008-12-07 18:16:32
			var dateTime:Array = sDate.split(" ");
			var allFields:Array = [].concat(dateTime[0].split("-"), dateTime[1].split(":"));
			var year:int = parseInt(allFields[0]);
			var month:int = parseInt(allFields[1]) - 1;
			var day:int = parseInt(allFields[2]);
			var hours:int = parseInt(allFields[3]);
			var minutes:int = parseInt(allFields[4]);
			var seconds:int = parseInt(allFields[5]);
			var d:Date = new Date(year, month, day, hours, minutes, seconds);
			return d;
		}
	}
}