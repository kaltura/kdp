package
{
	public class DateFormat
	{
		public static var MONTHS:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		public static var DAYS:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		
		/**
		 * Receives a string with specific caracters and replace them with date information based on the Date Object passed.
		 * @param formatStyle a string with or more of the caracters bellow (starting at line 15). <br />
		 * @param date the Date object with the date you want to format
		 * 
		 * The folowing caracters are the ones to be replaced:
		 * <ul>
		 * 		<li><strong>d:</strong> Day of the month, 2 digits with leading zeros. Ex.: 01 to 31</li>
		 * 		<li><strong>D:</strong> A textual representation of a day, three letters. Ex.: Mon through Sun</li>
		 * 		<li><strong>j:</strong> Day of the month without leading zeros. Ex.: 1 to 31</li>
		 * 		<li><strong>l:</strong> A full textual representation of the day of the week. Ex.: Sunday through Saturday</li>
		 * 		<li><strong>w:</strong> Numeric representation of the day of the week. Ex.: 0 (for Sunday) through 6 (for Saturday)</li>
		 * 		<li><strong>z:</strong> The day of the year (starting from 0). Ex.: 0 through 365</li>
		 * 		<li><strong>F:</strong> A full textual representation of a month, such as January or March. Ex.: January through December</li>
		 * 		<li><strong>m:</strong> Numeric representation of a month, with leading zeros. Ex.: 01 through 12</li>
		 * 		<li><strong>M:</strong> A short textual representation of a month, three letters. Ex.: Jan through Dec</li>
		 * 		<li><strong>n:</strong> Numeric representation of a month, without leading zeros. Ex.: 1 through 12</li>
		 * 		<li><strong>t:</strong> Number of days in the given month. Ex.: 28 through 31</li>
		 * 		<li><strong>L:</strong> Whether it's a leap year. Ex.: 1 if it is a leap year, 0 otherwise.</li>
		 * 		<li><strong>Y:</strong> A full numeric representation of a year, 4 digits. Ex.: 1999 or 2003.</li>
		 * 		<li><strong>y:</strong> A two digit representation of a year. Ex.: 99 or 03.</li>
		 * 		<li><strong>a:</strong> Lowercase Ante meridiem and Post meridiem. Ex.: am or pm.</li>
		 * 		<li><strong>A:</strong> Uppercase Ante meridiem and Post meridiem. Ex.: AM or PM.</li>
		 * 		<li><strong>g:</strong> 12-hour format of an hour without leading zeros. Ex.: 1 through 12.</li>
		 * 		<li><strong>G:</strong> 24-hour format of an hour without leading zeros. Ex.: 0 through 23.</li>
		 * 		<li><strong>h:</strong> 12-hour format of an hour with leading zeros. Ex.: 01 through 12.</li>
		 * 		<li><strong>H:</strong> 24-hour format of an hour with leading zeros. Ex.: 00 through 23.</li>
		 * 		<li><strong>i:</strong> Minutes with leading zeros. Ex.: 00 to 59.</li>
		 * 		<li><strong>s:</strong> Seconds, with leading zeros. Ex.: 00 through 59.</li>
		 * 		<li><strong>u:</strong> Milliseconds. Ex.: 654.</li>
		 * 		<li><strong>U:</strong> Milliseconds since the Unix Epoch (January 1 1970 00:00:00 GMT). Ex.: 1309986224468.</li>
		 * </ul>
		 * @example
		 * <pre>
		 * var d:Date = new Date(2011, 7, 6, 14, 1, 58, 220);
		 * trace(DateUtil.formatDate("z - l - d/m/Y = h:i:s:u A", d)); // outputs: "186 - Wednesday - 06/07/2011 - 02:01:58:220 PM"
		 * </pre>
		 * @see http://php.net/manual/en/function.date.php
		 */
		public static function formatDate(formatStyle:String, date:Date):String
		{
			var dateFormated:String = formatStyle;
			dateFormated = dateFormated.replace(/d/g, leadZero(date.date));
			dateFormated = dateFormated.replace(/j/g, String(date.date));
			dateFormated = dateFormated.replace(/w/g, String(date.day));
			if(dateFormated.search("z") != -1) dateFormated = dateFormated.replace(/z/g, String(DateFormat.dayOfYear(date.month, date.date)));
			dateFormated = dateFormated.replace(/m/g, leadZero(date.month + 1));
			dateFormated = dateFormated.replace(/n/g, String(date.month + 1));
			if(dateFormated.search("t") != -1) dateFormated = dateFormated.replace(/t/g, String(DateFormat.numberOfDaysInMonth(date.month, DateFormat.leapYear(date.fullYear))));
			dateFormated = dateFormated.replace(/L/g, DateFormat.leapYear(date.fullYear) ? "1" : "0");
			dateFormated = dateFormated.replace(/Y/g, String(date.fullYear));
			dateFormated = dateFormated.replace(/y/g, String(date.fullYear).substr(2));
			dateFormated = dateFormated.replace(/g/g, date.hours <= 12 ? date.hours : date.hours - 12);
			dateFormated = dateFormated.replace(/G/g, date.hours);
			dateFormated = dateFormated.replace(/h/g, leadZero(date.hours <= 12 ? date.hours : date.hours - 12));
			dateFormated = dateFormated.replace(/H/g, leadZero(date.hours));
			dateFormated = dateFormated.replace(/i/g, leadZero(date.minutes));
			dateFormated = dateFormated.replace(/s/g, leadZero(date.seconds));
			dateFormated = dateFormated.replace(/u/g, leadZero(date.milliseconds));
			dateFormated = dateFormated.replace(/U/g, String(date.time));
			
			dateFormated = dateFormated.replace(/a/g, "[{(a)}]");
			dateFormated = dateFormated.replace(/A/g, "[{(A)}]");
			dateFormated = dateFormated.replace(/D/g, "[{(D)}]");
			dateFormated = dateFormated.replace(/l/g, "[{(l)}]");
			dateFormated = dateFormated.replace(/M/g, "[{(M)}]");
			dateFormated = dateFormated.replace(/F/g, "[{(F)}]");
			dateFormated = dateFormated.replace(/\[\{\(a\)\}\]/g, date.hours < 12 ? "am" : "pm");
			dateFormated = dateFormated.replace(/\[\{\(A\)\}\]/g, date.hours < 12 ? "AM" : "PM");
			dateFormated = dateFormated.replace(/\[\{\(D\)\}\]/g, String(DateFormat.DAYS[date.day]).substr(0, 3));
			dateFormated = dateFormated.replace(/\[\{\(l\)\}\]/g, DateFormat.DAYS[date.day]);
			dateFormated = dateFormated.replace(/\[\{\(M\)\}\]/g, String(DateFormat.MONTHS[date.month]).substr(0, 3));
			dateFormated = dateFormated.replace(/\[\{\(F\)\}\]/g, DateFormat.MONTHS[date.month]);
			
			function leadZero(num:int):String
			{
				return (num < 10) ? "0" + String(num) : String(num);
			}
			return dateFormated;
		}
		public static function dayOfYear(month:uint, day:uint):uint
		{
			if(month == 0) return day - 1;
			var total:uint = 0;
			for(var i:uint = 0; i < month; i++)
			{
				total += DateFormat.numberOfDaysInMonth(i);
			}
			return total + day - 1;
		}
		public static function leapYear(year:uint):Boolean
		{
			return (year % 4 == 0 && year % 100 != 0) || year % 100 == 0;
		}
		public static function numberOfDaysInMonth(month:uint, isLeapYear:Boolean = false):uint
		{
			if(month == 1)
			{
				return isLeapYear ? 29 : 28;
			}
			else if(month <= 6 && (month & 1) == 1)
			{
				return 30;
			}
			else if(month > 6 && (month & 1) == 0)
			{
				return 30;
			}
			return 31;
		}
	}
}