package com.kaltura.utils
{
	public class KStringUtil
	{
	    /**
	     *  Camel case a hyphenated string.  Ex.  “chicken_head” becomes “chickenHead”,
	     *  and “_chicken_head” becomes “ChickenHead”.
	     *
	     *  @param underscoreString The String to be camelized.
	     *  @param lowerCamelized by default is true if set to false the result will be upper camelize
	     *
	     *  @return The string, camelized.
	     */
		public static function camelize( underscoreString : String , lowerCamelized : Boolean = true ) : String
		{
			var strArr : Array = underscoreString.split('_');
			var camelizeStr : String = new String();

			for(var i:int=0;i<strArr.length;i++)
			{
				if(i == 0 && lowerCamelized)
					camelizeStr = camelizeStr.concat( strArr[i].toLowerCase() );
				else
					camelizeStr = camelizeStr.concat( KStringUtil.capitalize(strArr[i]) );
			}

			return camelizeStr;
		}

		/**
	     *  Converting all the Strings in an Object to be camelize
	     *
	     *  @param underscoreObject The Object containing all the Strings to be camelized.
	     *  @param lowerCamelized by default is true if set to false the result will be upper camelize
	     *
	     *  @return The string, camelized.
	     */
		public static function camelizeObjectParams( underscoreObject : Object , lowerCamelized : Boolean = true ) : Object
		{
			for(var param:String  in underscoreObject)
				 underscoreObject[camelize(param , lowerCamelized)] =  underscoreObject[param]	;

			return underscoreObject;
		}

		/**
	     *  Underscore a Camel case a string.  Ex. “chickenHead” becomes “chicken_head”,
	     *
	     *  @param camelizeString The String to be underscored.
	     *
	     *  @return The String, underscored.
	     */
		public static function underscore( camelizeString :String ) : String
		{
			var pattern : RegExp = new RegExp('(?<=\\w)([A-Z])', 'g');
			var strArr : Array = camelizeString.match(pattern);

			for(var i:int=0; i<strArr.length ; i++)
				camelizeString = camelizeString.replace( strArr[i] , '_'+strArr[i]);

       	 	return camelizeString.toLowerCase();
    	}

    	/**
	     *  Converting all the Strings in an Object to be underscore
	     *
	     *  @param underscoreObject The Object containing all the Strings to be underscored.
	     *
	     *  @return The string, underscore.
	     */
    	public static function underscoreObjectParams ( camelizeObject :Object ) : Object
    	{
    		for(var param:String  in camelizeObject)
				 camelizeObject[underscore(param)] = camelizeObject[param];

			return camelizeObject;
    	}

    	/**
	     *  capitalize a string.  Ex. “chicken” becomes “Chicken”,
	     *
	     *  @param str The String to be capitalize.
	     *
	     *  @return The String, capitalized.
	     */
    	public static function capitalize( str : String ) : String
    	{
   			return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase();
    	}
	}
}