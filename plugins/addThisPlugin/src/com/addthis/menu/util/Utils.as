package com.addthis.menu.util
{
	/**
	* Util class
	**/   
	public class Utils
	{
		//Constructor
		public function Utils(){}
		
		/**
		* Gets the property count of an object
		**/  
		public static function getObjectCount(obj:Object):int{
			var i:int = 0;
			for(var item:String in obj){
				i++;} 
			return i; 
		} 
		
		/**
		* Getting the upper bound on divide
		* ie, return  4 if 3.01 is the divided answer 
		**/  
		public static function getUpperRoundedValue(servicesCount:int,rowCount:int):int{
			var result:Number;
			result = servicesCount / rowCount;
			result = result.toString().indexOf(".") > 0 ? result + 1 : result;
			return int(result);
		} 
		
	}
}