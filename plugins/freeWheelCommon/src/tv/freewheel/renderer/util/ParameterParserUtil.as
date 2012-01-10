package tv.freewheel.renderer.util {
	import tv.freewheel.renderer.util.StringUtil;

	public class ParameterParserUtil {
		/**
		 *	parse string with some options
		 *	
		 *	Parameters:
		 *		value			-	the string to be parsed
		 *      defaultValue    -   default value if value is null or ""
		 *      caseConvert     -   0:no change, 1: upper, -1: lower, default to 0
		 *      trim			-   -1:no trim, 0: trim, 1:left trim, 2: right trim, default to 0
		 * 		allowEmpty      -   true:allow empty string, false: do not allow empty string, default to false
		 * 	
		 * 	common use cases:
		 *	1.parseString(" abc ") = "abc"
		 *	2.parseString(" abc ",null,0,1) = "abc "
		 *	3.parseString(" abc ",null,0,2) = " abc"
		 *	4.parseString(" ", "abc") = "abc"
		 *	5.parseString(null, "abc") = "abc"
		 *	6.parseString(" ", "a", 0, 0, true) =""
		 *	7.parseString("abc",null,1) = "ABC" 	
		 * 	
		 */
		public static function parseString(value:String, defaultValue:String=null, caseConvert:int=0, trim:int=0, allowEmpty:Boolean=false):String {
			if(value == null) {
				return defaultValue;
			}

			var res:String = value;
			// step one: trim
			switch(trim) {
				case 1:
					res = StringUtil.ltrim(res);
					break;
				case 2:
					res = StringUtil.rtrim(res);
					break;
				case -1:
					break;
				default:
					res = StringUtil.trim(res);
			}

			//step two: case convert
			switch(caseConvert) {
				case 1:
					res = res.toUpperCase();
					break;
				case -1:
					res = res.toLowerCase();
					break;
				default:
					// do nothing here
			}

			//step three: default		
			if(!allowEmpty) {
				if(StringUtil.trim(res) == "") {
					res = defaultValue;
				}				
			}

			return res;
		}

		/**
		 *	parse string to limited options(acceptalbe values, trime and case-insensitive)
		 *	
		 *	Parameters:
		 *		value			-	the string to be parsed
		 *      candidate       -   array of acceptable values
		 *      defaultValue    -   if candidate is empty or null, or value is not in candidate, use this value
		 *  return:
		 *  	string
		 *  
		 * common use cases:
		 * 1.parseEnum("any string",[],"freewheel") = "freewheel"
		 * 2.parseEnum("any string",null,"freewheel") = "freewheel"
		 * 3.parseEnum(null,[null],"freewheel") = null
		 * 4.parseEnum("red",['Red','Blue'],"Black") = 'Red'
		 * 5.parseEnum(" red ",['Red','Blue'],"Black") = 'Red'
		 * 6.parseEnum("green",['Red','Blue'],"Black") = 'Black'
		 */		
		public static function parseEnum(value:String, candidate:Array, defaultValue:String=null):String {
			if(!candidate || candidate.length ==0 ) {
				return defaultValue;
			}			

			var newValue:String = value? (StringUtil.trim(value)).toLowerCase():value;			
			var item:String; 			
			for(var i:Number =0;i<candidate.length;i++) {
				item = candidate[i];
				item = item? item.toLowerCase():item;
				if(newValue == item) {
					return candidate[i];
				}				
			}

			return defaultValue;
		}

		/**
		 *	parse string to Number with range(trim applied to input value)
		 *	
		 *	Parameters:
		 *		value			-	the string to be parsed
		 *      defaultValue    -   default value will be used when value is empty, can not be converted to int or out of range [min,max]
		 * 		min             - 	min value 
		 * 		max				-   max value
		 * 	return:
		 * 	    Number
		 * 	common use cases:
		 * 	1. parseNumber("31.1") = 31.1
		 * 	2. parseNumber("a31.1",0) = 0
		 * 	3. parseNumber("31.1",150,100,200) = 150
		 * 	4. parseNumber("31",10,0,100) = 31
		 * 	
		 */		
		public static function parseNumber(value:String, defaultValue:Number=NaN, min:Number= -1.79769313486232e+308, max:Number=Number.MAX_VALUE):Number {
			var str:String = StringUtil.trim(value);
			var res:Number = Number(str);
			if(StringUtil.isNullOrEmpty(str) || isNaN(res) || res > max || res < min) {
				res = defaultValue;
			}

			return res; 
		}
		/**
		 *	parse string to int with range(trim applied to input value)
		 *	
		 *	Parameters:
		 *		value			-	the string to be parsed
		 *      defaultValue    -   default value will be used when value is empty, can not be converted to int or out of range [min,max]
		 * 		min             - 	min value 
		 * 		max				-   max value
		 * 	return:
		 * 	    int
		 * 	common use cases:
		 * 	1. parseInt("0x1f") = 31
		 * 	2. parseInt("1f",0) = 0
		 * 	3. parseInt("0x1f",150,100,200) = 150
		 * 	4. parseInt("31",10,0,100) = 31
		 * 	
		 */
		public static function parseInt(value:String, defaultValue:int=0, min:int=int.MIN_VALUE, max:int=int.MAX_VALUE):int {
			var str:String = StringUtil.trim(value);
			var res:Number = Number(str);
			if(StringUtil.isNullOrEmpty(str) || isNaN(res) || res > max || res < min) {
				res = defaultValue;
			}

			return int(res);
		}

		/**
		 *	parse string to boolean with default value(trim and caseInsesitive applied to input value)
		 *	
		 *	Parameters:
		 *		value			-	the string to be parsed, 'true'/'on'/'yes' means true, 'false'/'off'/'no' means false, 
		 *      defaultValue    -  0 means false,1 means true
		 *      				   default value will be used when value is empty or null
		 *  return:
		 *      Number			-  0 means false,1 means true
		 *  
		 *  common use cases:
		 *  1. parseBoolean("",0) = 0
		 *  2. parseBoolean(null,0) = 0
		 *  3. parseBoolean("other value") = 0
		 *  4. parseBoolean(" Ture") = 1 //same for on/yes
		 *  5. parseBoolean("true ") = 1 //same for on/yes
		 *  6. parseBoolean("False") = 0 //same for no/off
		 *  7. parseBoolean("false") = 0 //same for no/off
		 */

		public static function parseBoolean(value:String, defaultValue:int=0):int {
			var str:String = StringUtil.trim(value);
			var res:int = defaultValue;
			if(!StringUtil.isNullOrEmpty(str)) {
				str = str.toLowerCase();
				if(str == 'true' || str == 'on' || str == 'yes') {
					res = 1;

				} else if(str == 'false' || str == 'off' || str == 'no') {
					res = 0;

				}
			}

			return res;
		}

		/**
		 *	parse string url with default value(trim applied)
		 *	
		 *	Parameters:
		 *		value			-	the string to be parsed
		 *      defaultValue    -   default value will be used when value is empty, or do not contains "://" / "mailto:"
		 *  return:
		 *      string
		 *  
		 *  common use cases:
		 *  1. parseURL("","http://www.freewheel.tv") ="http://www.freewheel.tv"
		 *  2. parseURL(null,"http://www.freewheel.tv") = "http://www.freewheel.tv"
		 *  3. parseURL("www.abc.com","http://www.freewheel.tv") = "http://www.freewheel.tv"
		 *  4. parseURL(" http://www.google.com ","http://www.freewheel.tv") = "http://www.google.com"
		 *  5. parseURL(" mailto:xdeng@freewheel.tv ","http://www.freewheel.tv") = "mailto:xdeng@freewheel.tv"
		 */

		public static function parseURL(value:String, defaultValue:String=null):String {
			var res:String = StringUtil.trim(value);
			if(!StringUtil.isNullOrEmpty(res)) {
				if(res.indexOf("://") < 0 && res.toLowerCase().indexOf("mailto:") < 0) {
					res = defaultValue;
				}		
			} else {
				res = defaultValue;
			}

			return res;
		}
		
		/**
		 * parse array from a string with user-defined delimiters and other options
		 * 
		 * Parameters:
		 * 		value			-	the string to be parsed
		 * 		delimiter		-	the delimiter character or string, default ','
		 * 		trim			-	-1: do not trim, 0: trim, 1: left trim, 2: right trim. default 0
		 * 		allowEmpty		-	true: allow empty string to be returned in the returned array; false: otherwise. default false
		 * return:
		 * 		Array
		 * 
		 * common use cases:
		 * 1. parseArray("hello, world,, 	from,freewheel") = ["hello", "world", "from", "freewheel"]
		 * 2. parseArray("hello|world ", "|", -1) = ["hello", "world "]
		 * 3. parseArray("hello") = ["hello"]
		 * 4. parseArray("hello,,world", ",", 0, true) = ["hello", "", "world"]
		 * 5. parseArray("") = []
		 * 6. parseArray("", ",", 2, true) = [""]
		 */
		public static function parseArray(value:String, delimiter:String=",", trim:int=0, allowEmpty:Boolean=false):Array{
			if (value == null)
				return [];
			var csv:Array = value.split(delimiter);
			
			if (allowEmpty){
				switch (trim){
					case -1:
						return csv;
					case 1:
						return csv.map(function(str:String, idx:int, arr:Array):String{return StringUtil.ltrim(str);});
					case 2:
						return csv.map(function(str:String, idx:int, arr:Array):String{return StringUtil.rtrim(str);});
					case 0:
					default:
						return csv.map(function(str:String, idx:int, arr:Array):String{return StringUtil.trim(str);});
				}
			}
			else{
				switch (trim){
					case -1:
						return csv.filter(function(str:String, idx:int, arr:Array):Boolean{return !StringUtil.isBlank(str);});
					case 1:
						return csv.map(function(str:String, idx:int, arr:Array):String{return StringUtil.ltrim(str);}).filter(function(str:String, idx:int, arr:Array):Boolean{return !StringUtil.isBlank(str);});
					case 2:
						return csv.map(function(str:String, idx:int, arr:Array):String{return StringUtil.rtrim(str);}).filter(function(str:String, idx:int, arr:Array):Boolean{return !StringUtil.isBlank(str);});
					case 0:
					default:
						return csv.map(function(str:String, idx:int, arr:Array):String{return StringUtil.trim(str);}).filter(function(str:String, idx:int, arr:Array):Boolean{return !StringUtil.isBlank(str);});
				}
			}
			return csv.map(function(str:String, idx:int, arr:Array):String{return StringUtil.trim(str);}).filter(function(str:String, idx:int, arr:Array):Boolean{return !StringUtil.isBlank(str);});
		}
	}
}
