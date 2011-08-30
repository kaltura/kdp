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
		
		var hours:Number = time / ( 60 * 60 );
		
		remainder = hours - (Math.floor ( hours ));
		
		hours = Math.floor ( hours );
		
		var minutes:Number = remainder * 60;
		
		remainder = minutes - (Math.floor ( minutes ));
		
		minutes = Math.floor ( minutes );
		
		var seconds:Number = remainder * 60;
		
		remainder = seconds - (Math.round ( seconds ));
		
		seconds = Math.floor ( seconds );
		
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