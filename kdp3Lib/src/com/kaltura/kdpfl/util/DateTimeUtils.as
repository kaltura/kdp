package com.kaltura.kdpfl.util
{
	
public class DateTimeUtils
{
	
	/**
	 * returns time in hh:mm:ss format from seconds
	 * 
	 * @param time in seconds
	 * @param format "hh:mm:ss" or "mm:ss"
	 * 
	 * @author Dani Bacon / www.baconoppenheim.com
	 * @author Andrew Wright
	 */
 	public static function formatTime( time:Number, format:String="mm:ss" ):String
	{
		var remainder:Number;
		
		var hours : int = Math.floor( time/3600);
		
		var minutes : int = Math.floor((time % 3600)/60);
		
		var seconds : int = (time % 3600)%60;
		
		
		
		var hString:String = hours < 10 ? "0" + hours : "" + hours;	
		var mString:String = minutes < 10 ? "0" + minutes : "" + minutes;
		var sString:String = seconds < 10 ? "0" + seconds : "" + seconds;
					
		if ( time < 0 || isNaN(time))
			return( format.toLowerCase()=="hh:mm:ss" ? "00:00:00" : "00:00" );			
					
		if ( hours > 0 || format.toLowerCase()=="hh:mm:ss" )
		{			
			return hString + ":" + mString + ":" + sString;
		}
		else
		{
			return mString + ":" + sString;
		}
	}
	
	//TODO: IMPLEMENT
	public static function formatDate( dateObject : Object , format : String ) : String
	{
		//TODO: IMPLEMENT SUPPORT IN FORMATS
		return new Date( Number(dateObject) ).toDateString();;
	}
}
}