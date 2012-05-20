package com.kaltura.kdpfl.util
{
	import com.kaltura.kdpfl.model.vo.MediaVO;
	
	import flash.sampler.getMemberNames;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * This purpose of the class is to provide a utility to create a "shallow" clone of an instance of any class 
	 * @author Hila
	 * 
	 */	
	public class Cloner
	{
		public function Cloner()
		{
		}
		
		public  function clone (item : Object) : Object
		{
			var className : Class = getDefinitionByName( getQualifiedClassName(item) ) as Class;
			
			var clonedObject : Object = new className();
			
			var classStructure : Object = describeObject(item);
			for (var prop : String in classStructure)
			{
				clonedObject[prop] = item[prop];
			}
			
			return clonedObject;
		}
		
		/**
         * Return an object that holds all variables and properties and their values 
         * @param obj
         * @return 
         * 
         */
        public static function describeObject(obj:Object):Object 
        { 
        	 var ob:Object = new Object();
         
            var classInfo:XML = describeType(obj);
            //map all variables
            for each (var v:XML in classInfo..variable) 
            {
                ob[v.@name] = obj[v.@name];
            }
            //map all properties
            for each (var a:XML in classInfo..accessor) 
            {
                ob[a.@name] = obj[a.@name];
            } 
        	 return ob;
        }

	}
}