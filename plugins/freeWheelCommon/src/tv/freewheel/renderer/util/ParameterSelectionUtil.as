package tv.freewheel.renderer.util {
	public class ParameterSelectionUtil {
		public static function parseString(paramName:String, paramsTable:Array, defaultValue:String = null, caseConvert:int = 0, trim:int = 0, allowEmpty:Boolean = false):String {
			var result:String = null;

			for(var i:int = 0; i < paramsTable.length; i++) {
				var parameters:Object = paramsTable[i];
				
				if(parameters == null) {
					continue;
				}
				
				result = ParameterParserUtil.parseString(parameters[paramName], null, caseConvert, 0, allowEmpty);

				if(result != null) {
					break;
				}
			}

			if(result == null) {
				result = ParameterParserUtil.parseString(parameters[paramName], defaultValue, caseConvert, 0, allowEmpty);
			}

			return result;
		}
		
		public static function parseObject(paramName:String, paramsTable:Array):Object{
			var result:Object = new Object();
			for (var i:int = 0; i < paramsTable.length; i++){
				var parameters:Object = paramsTable[i];
				if (parameters == null){
					continue;
				}
				result = parameters[paramName];
				if (result != null){
					break;
				}
			}
			return result;
		}

		public static function parseEnum(paramName:String, paramsTable:Array, candidate:Array, defaultValue:String = null):String {
			var result:String = null;

			for(var i:int = 0; i < paramsTable.length; i++) {
				var parameters:Object = paramsTable[i];
				
				if(parameters == null) {
					continue;
				}
				
				result = ParameterParserUtil.parseEnum(parameters[paramName], candidate);

				if(result != null) {
					break;
				}
			}

			if(result == null) {
				result = ParameterParserUtil.parseEnum(parameters[paramName], candidate, defaultValue);
			}

			return result;
		}

		public static function parseNumber(paramName:String, paramsTable:Array, defaultValue:Number = NaN, min:Number = -1.79769313486232e+308, max:Number = Number.MAX_VALUE):Number {
			var result:Number = NaN;

			for(var i:int = 0; i < paramsTable.length; i++) {
				var parameters:Object = paramsTable[i];
				
				if(parameters == null) {
					continue;
				}
				
				result = ParameterParserUtil.parseNumber(parameters[paramName], NaN, min, max);

				if(!isNaN(result)) {
					break;
				}
			}

			if(isNaN(result)) {
				result = ParameterParserUtil.parseNumber(parameters[paramName], defaultValue, min, max);
			}

			return result;
		}

		public static function parseInt(paramName:String, paramsTable:Array, defaultValue:int = 0, min:int = int.MIN_VALUE, max:int = int.MAX_VALUE):int {
			var result:int = 0;

			for(var i:int = 0; i < paramsTable.length; i++) {
				var parameters:Object = paramsTable[i];
				
				if(parameters == null) {
					continue;
				}
				
				result = ParameterParserUtil.parseInt(parameters[paramName], 0, min, max);

				if(result != 0) {
					break;
				}
			}

			if(result == 0) {
				result = ParameterParserUtil.parseInt(parameters[paramName], defaultValue, min, max);
			}

			return result;
		}

		public static function parseBoolean(paramName:String, paramsTable:Array, defaultValue:int = 0):int {
			var result:int = -1;

			for(var i:int = 0; i < paramsTable.length; i++) {
				var parameters:Object = paramsTable[i];
				
				if(parameters == null) {
					continue;
				}
				
				result = ParameterParserUtil.parseBoolean(parameters[paramName], -1);

				if(result != -1) {
					break;
				}
			}

			if(result == -1) {
				result = ParameterParserUtil.parseBoolean(parameters[paramName], defaultValue);
			}

			return result;
		}

		public static function parseURL(paramName:String, paramsTable:Array, defaultValue:String = null):String {
			var result:String = null;

			for(var i:int = 0; i < paramsTable.length; i++) {
				var parameters:Object = paramsTable[i];
				
				if(parameters == null) {
					continue;
				}
				
				result = ParameterParserUtil.parseURL(parameters[paramName], null);

				if(result != null) {
					break;
				}
			}

			if(result == null) {
				result = ParameterParserUtil.parseURL(parameters[paramName], defaultValue);
			}

			return result;
		}
	}
}
