package com.kaltura.utils
{
	
	import com.kaltura.utils.parsers.DateParser;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class KConfigUtil
	{
		//TODO: merge getDefaultValue2 & getDefaultValue into one function that can get either default property name or data type class
		//TODO: add multiple fallbacks support, for example, the function could be called passing it (flashvars, uiconf, default hardcoded value) in single call instead of two.
		public static function getDefaultValue2(givenVal:String, defaultValObj:Object, defaultValPropertyName:String):*
		{
			var description:XML = describeType(defaultValObj);
			var variableXml:XML = description.variable.(attribute("name") == defaultValPropertyName)[0];
			var accessorXml:XML = description.accessor.(attribute("name") == defaultValPropertyName)[0]
			
			if (variableXml || accessorXml)
			{
				var className:String = (variableXml || accessorXml).@type;
				var clazz:Class = getDefinitionByName(className) as Class;
			}
			else
			{
				clazz = String;
			}
			return getDefaultValue(givenVal, defaultValObj[defaultValPropertyName], clazz);
			
		}
		
		
		public static function getDefaultValue(givenVal:String, defaultVal:*, dataTypeClass:Class = null):*
		{
			if (!givenVal)
				return defaultVal;
			
			var castedGivenValue:*;
			
			if (!dataTypeClass)
			{
				if (defaultVal == null)
				{
					dataTypeClass = String;
				}
				else
				{
					dataTypeClass = getDefinitionByName(getQualifiedClassName(defaultVal)) as Class;
				}
			}
			switch(dataTypeClass as Class)
			{
				case Boolean:
					castedGivenValue = (givenVal != "false" && givenVal != "0");
					break;
				
				case Number:
				case int:
					castedGivenValue = parseFloat(givenVal);
					break;
				case Date:
					castedGivenValue = DateParser.parse1(givenVal);
					break;
				
				default: 
					castedGivenValue = givenVal;
					break;
			}
			return castedGivenValue;
		}
	}
}