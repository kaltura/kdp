package tv.freewheel.renderer.util {
	import flash.utils.describeType;
	
	public class StringUtil {
		public static function trim( str:String ):String {
			var res:String = str;
			res = StringUtil.ltrim(res);
			res = StringUtil.rtrim(res);

			return res;
		}

		public static function rtrim(str:String):String {
			if(StringUtil.isNullOrEmpty(str)) {
				return str;
			}
			var c:String;
			var index:Number = -1;
			for(var i:Number = str.length-1; i>=0; i--) {
				c = str.charAt(i);
				if(!(c == " " || c== "\t" || c == "\r" || c== "\n")) {
					break;
				} else {
					index = i;
				}			
			}			
			//like "    "
			if(index == 0) {
				return "";
			}
			// like " test"
			else if(index == -1) {
				return str;
			}
			//like " test "
			else {
				return str.substring(0,index);
			}			
		}

		public static function ltrim(str:String):String {
			if(StringUtil.isNullOrEmpty(str)) {
				return str;
			}

			var c:String;
			var index:Number = -1;
			for(var i:Number = 0; i<=str.length-1; i++) {
				c = str.charAt(i);
				if(!(c == " " || c== "\t" || c == "\r" || c== "\n")) {
					break;
				} else {
					index = i;
				}			
			}			
			//like "    "
			if(index == str.length-1) {
				return "";
			}
			// like "test  "
			else if(index == -1) {
				return str;
			}
			//like " test "
			else {
				return str.substring(index+1);
			}		

		}

		public static function isNullOrEmpty( str:String ):Boolean {
			if (str == null || str == "" ) {
				return true;
			}

			return false;
		}

		public static function isBlank( str:String ):Boolean {
			return isNullOrEmpty(str);
		}

		public static function equals(str1:String, str2:String, caseSensitive:Boolean = true):Boolean {
			if(str1 == null || str2 == null) {
				return str1 == str2 ? true : false;
			}

			if(caseSensitive) {
				return str1 == str2;
			} else {
				return str1.toLowerCase() == str2.toLowerCase();
			}
		}

		public static function isStartWith(inputStr:String, checkStr:String, caseSensitive:Boolean = true):Boolean {
			if(StringUtil.isNullOrEmpty(inputStr) || StringUtil.isNullOrEmpty(checkStr)) {
				return false;
			}

			if(caseSensitive) {
				return (inputStr.indexOf(checkStr) == 0);
			} else {
				return (inputStr.toLowerCase().indexOf(checkStr.toLowerCase()) == 0);
			}
		}
		
		/**
		 *	Determines whether the specified string begins with the specified prefix.
		 * 
		 *	@param input The string that the prefix will be checked against.
		 *	@param prefix The prefix that will be tested against the string.
		 *	@returns True if the string starts with the prefix, false if it does not, or one of them is empty.
		 */	
		public static function startsWith(input:String, prefix:String):Boolean
		{			
			return (!StringUtil.isNullOrEmpty(input) && !StringUtil.isNullOrEmpty(prefix) && 
				prefix == input.substring(0, prefix.length));
		}	
		
		/**
		 *	Determines whether the specified string ends with the specified suffix.
		 * 
		 *	@param input The string that the suffic will be checked against.
		 *	@param suffix The suffix that will be tested against the string.
		 *	@returns True if the string ends with the suffix, false if it does not, or one of them is empty.
		 */	
		public static function endsWith(input:String, suffix:String):Boolean
		{
			return (!StringUtil.isNullOrEmpty(input) && !StringUtil.isNullOrEmpty(suffix) && 
				suffix == input.substring(input.length - suffix.length));
		}	

		public static function nullToEmpty(str:String):String {
			return str ? str : "";
		}

		/**
		 * Encode string with hex values, so it is safe to be used in JS document.write call
		 * See http://www.c-point.com/javascript_tutorial/special_characters.htm
		 * See http://stackoverflow.com/questions/97578/how-do-i-escape-a-string-inside-javascript-inside-an-onclick-handler
		 */
		public static function encodeToHex(str:String):String{
			var r:String = "";
			var e:Number = str.length;
			var c:Number = 0;
			var h:String;
			while(c < e){
				h=str.charCodeAt(c++).toString(16);
				while(h.length < 2) h = "0" + h;
				if(h.length == 2){ // 2 digits
					r += "\\x";
					r += h;
				} else { // Unicode char, 4 digits
					while(h.length < 4) h = "0" + h;
					r += "\\u";
					r += h;
				}
			}
			return r;
		}

		public static function replaceAll(str:String, old:String, replacement:String):String{
			if(str == null || old == null || replacement == null){
				return str;
			}
			return str.split(old).join(replacement);
		}


		/**
		 * Replace various stuff in the content, make it ready to be wrapped by double-quote as a JavaScript string
		 * Ported from codes from json.org
		 */
		public static function enquote(s:String):String {
			if (isBlank(s)) return ""; 
			var c:String; 
			var ret:String = ""; 
			for (var i:Number = 0; i < s.length; i++)  
			{ 
				c = s.charAt(i); 
				if ((c == '\\') || (c == '"') || (c == '>')) 
				{ 
					ret += '\\'; 
					ret += c; 
				} 
				else if (c == '\b') 
					ret += "\\b"; 
				else if (c == '\t') 
					ret += "\\t"; 
				else if (c == '\n') 
					ret += "\\n"; 
				else if (c == '\f') 
					ret += "\\f"; 
				else if (c == '\r') 
					ret += "\\r"; 
				else 
				{ 
					if (c < ' ')  
					{ 
						//t = "000" + Integer.toHexString(c); 
						ret += encodeToHex(c);
					}  
					else  
					{ 
						ret += c;
					} 
				} 
			} 
			return ret;
		}

		public static function intToColor(i:int):String {
			return zeroPad(i.toString(16), 6);
			
		}

		public static function zeroPad(number:Object, width:int):String {
			var ret:String = "" + number;
			while( ret.length < width )
				ret="0" + ret;
			return ret;
		}
		
		public static function objectToString(obj:Object, name:String = "", depth:int = 0):String{
			if (depth >= 5)
				return "";
			depth++;
			var a:Array = [];
			var typ:String = typeof(obj);
			var needBracket:Boolean = false;
			if (typ == "object"){
				if (obj is Array){
					a.push("[" + (obj as Array).map(function(o:Object, i:int, a:Array):String{return objectToString(o, "", depth);}).join(", ") + "]");
				}
				else{
					needBracket = true;
					for (var i:String in obj)
						a.push(i + " : " + objectToString(obj[i], "", depth));
				}
			}
			else if (typ == "string")
				a.push('"' + obj + '"');
			else if (name.indexOf("Color") > -1 && obj is int)
				a.push(obj.toString(16));
			else
				a.push(obj);
			if (needBracket)
				return (name ? name + " : " : "") + "{" + a.join(", ") + "}";
			else
				return (name ? name + " : " : "") + a.join(", ");
		}
		
		public static function instanceToString(obj:Object):String{
			var a:Array = [];
			var desc:XML = describeType(obj);
			var vars:XMLList = desc.variable;
			for each (var variable:XML in vars){
				a.push(objectToString(obj[variable.@name], variable.@name));
			}
			return desc.@name+ ": {" + a.join(", ") + "}";
		}

	}
}
