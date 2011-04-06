/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.kdpfl.util
{
	//import com.kaltura.kdp.managers.KdpManager;
	import com.kaltura.kdpfl.model.ConfigProxy;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.Application;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class KTextParser
	{
		// enumeration for different parsing methods

		// evaluate the expression now
		private static const PARSER_MODE_EVAL:int = 1;

		// parse the expression and bind it
		private static const PARSER_MODE_BIND:int = 2;

		// execute the expression now. the expression MUST be function and doesnt have to be sorrounded by curly braces {}
		private static const PARSER_MODE_EXECUTE:int = 3;

		private static var mode:int;

		private static var debugMode:Boolean;
		// object to hold all the quoted strings within the text:
		// in "{format(this.name, '2')}" the '2' is a quoted string
		private var quotedStrings:Object = null;

		// count of quoted string
		private var quotedStringsCount:int = 0;

		public function KTextParser(_mode:int)
		{
			mode = _mode;
			var cp:ConfigProxy = Facade.getInstance().retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			if (cp.vo.flashvars.debugMode=='true')
				debugMode = true;
				
		}

		// remove white space on both ends of the given string
		private function trim(s:String):String
		{
			return s.replace(/\s/, "");
		}

		// the function runs on a given string and replaces the signle quoted strings ('xxx')
		// with __n where n is an incremented number.
		// e.g: "aa,'xyz','qwe',bb" will result in "aa,'__1','__2',bb"
		// the quotedStrings object will contain:
		//	__1:'xyz'
		//  __2:'qwe'
		//
		private function replaceQuotedStrings(s:String):String
		{
			var i:int;
			var quoted_string:String = null;
			var currentChar:String = "";
			var nextChar:String = s.charAt(0);

			quotedStrings = new Object();

			var newString:String = "";

			while(i < s.length)
			{
				currentChar = nextChar;
				++i;
				nextChar = s.charAt(i);

				if (currentChar == "\\" && nextChar == "'")
				{
					currentChar = "'";
					++i;
					nextChar = s.charAt(i);
				}
				else if (currentChar == '\'')
				{
					if (quoted_string == null)
					{
						quoted_string = "";
						continue;
					}
					else
					{
						var strName:String = "__" + ++quotedStringsCount;
						newString += strName;
						quotedStrings[strName] = quoted_string;

						quoted_string = null;
						continue;
					}
				}

				if (quoted_string == null)
				{
					newString += currentChar;
				}
				else
					quoted_string += currentChar;
			}

			return newString;
		}

		// the function runs on a given string and extract the constant parts and curly braces parts
		// into an array:
		// e.g.: ab{format(this.name, '2')}{this.url}{testModule.func(testModule.test)}cd"
		// will return ["ab", "{format(this.name, '2')}", "{this.url}", "{testModule.func(testModule.test)}" ,"cd"]
		private function extractCurlyBraces(s:String):Array
		{
			var parts:Array = new Array();

			var i:int;
			var newString:String = "";

			while(i < s.length)
			{
				var currentChar:String = s.charAt(i);
				++i;

				if (currentChar == '{')
				{
					if (newString)
					{
						parts.push(newString)
						newString = "";
					}
				}

				newString += currentChar;

				if (currentChar == '}')
				{
					parts.push(newString)
					newString = "";
				}
			}

			if (newString.length)
				parts.push(newString)

			return parts;
		}

		// parse a given literal and return either a string constant or a chain (array)
		// that represents it
		// the host variable is the root object to follow the chain from
		private function parseLiteral(host:Object, argString:String):*
		{
			argString = trim(argString);

			// treat numeric constants as regular strings
			if (argString.charAt(0) >= '0' && argString.charAt(0) <= '9')
				return argString;
				
			if (argString.substr(0,2) == "__") // handle quoted constant strings
			{
				var s:String = quotedStrings[argString];
				return s;
			}

			var chain:Array = argString.split(".");

			// an argument which start with "this" will have the "data" property as the
			// first element in the chain
			if (chain.length && chain[0] == "this")
			{
				chain = chain.splice(1);
				chain.unshift(host);
			}
			else
			{
				chain.unshift(host);
			}

			// normalize the chain and the return it
			return chain;
		}

		// parse am argument and add it to the given Functor
		private function parseFunctionArg(f:Functor, host:Object, argString:String):void
		{
			var arg:Object = parseLiteral(host, argString);
			f.addArgument(arg);
		}

		// parse an argument and bind the given site and prop to it
		// the host is the root object the argument belongs to
		private function parseBindingArg(site:Object, prop:String, host:Object, argString:String):Object
		{
			var arg:Object = parseLiteral(host, argString);

			if (arg is Array)
			{
				// in case the site is a Functor (created internaly by kTextParser for concatenating texts)
				// add the argument to the Functor
				if (site is Functor)
					(site as Functor).addArgument(arg);
				else
				{
					var chain:Array = arg as Array;

					if (mode == PARSER_MODE_EVAL) // extract and return the value now
					{
						var obj:Object = chain.shift();
						for each(var name:Object in chain)
						{
							obj = obj[name];
							if (obj == null)
								break;
						}

						return obj
					}
					else
					{
						host = (arg as Array).shift();
						BindingUtils.bindProperty(site, prop, host, arg);
					}
				}

				return null;
			}
			else
			{
				site[prop] = arg;
				return site[prop];
			}
		}

		// execute a given text (should describe a function)
		// the host is the root object the text belongs to
		static public function execute(host:Object, text:String):Object
		{
			var parser:KTextParser = new KTextParser(PARSER_MODE_EXECUTE);
			return parser.parse(null, null, host, text);
		}

		// evaluate a given text (should describe a function)
		// the host is the root object the text belongs to
		static public function evaluate(host:Object, text:String):Object
		{
			var parser:KTextParser = new KTextParser(PARSER_MODE_EVAL);
			return parser.parse(null, null, host, text);
		}

		// bind a text to the given site and property
		// the host is the root object the text belongs to
		static public function bind(site:Object, prop:String, host:Object, text:String):Object
		{
			var parser:KTextParser = new KTextParser(PARSER_MODE_BIND);
			return parser.parse(site, prop, host, text);
		}

		static private function concat(...args):String
		{
			return args.join('');
		}
		
		static private function setProperty(site:Object, prop:String, value:*):*
		{
			
			try {
				if (site.hasOwnProperty(prop))
				{
					if (site[prop] is Boolean)
					{
						value = value == "true" || int(value);
					}
				}
			}
			catch(e:Error)
			{
				if(debugMode)
					trace("setProperty: " , site , ":" + prop , "=" , value, " ", e); 
			}
				
			return site[prop] = value;
		}
		
		// prepare text by removing quoted strings and extracting curly braces parts, then call internalParse
		private function parse(site:Object, prop:String, host:Object, text:String):Object
		{
			// if we dont have curly braces, grab the value and we are done
			if (text.indexOf("{") == -1)
			{
				if (mode == PARSER_MODE_BIND)
				{
					return setProperty(site, prop, text);
				}
				else if (mode == PARSER_MODE_EVAL)
					return text;
	 		}
	 		else if (text.indexOf("{ks}") != -1) // hack for disregarding {ks} 
				return setProperty(site, prop, text);

			// replace the single quoted strings with markers (__n)
			var strippedString:String = replaceQuotedStrings(text);
			
			// in case of binding separate the {} parts from the literals and create a functor to concatenate them
			// label="name: {this.name} at {formatDate(this.date)}"
			if (mode != PARSER_MODE_EXECUTE)
			{
				var parts:Array = extractCurlyBraces(strippedString);

				if (parts.length > 1)
				{
					var f:Functor = new Functor([null, concat], true);

					for each(var s:String in parts)
					{
						if (s.indexOf("{") == -1)
							f.addArgument(s);
						else
						{
							var result:Object = internalParse(f, null, host, s);
							if (mode == PARSER_MODE_EVAL) // or add the result
								f.addArgument(result);
						}
					}

					if (mode == PARSER_MODE_BIND)
						BindingUtils.bindProperty(site, prop, f, "result");

					// flag the functor as ready
					f.ready = true;

					// call function for setting its value right now
					return f.callFunction();
				}
			}

			// in case of plain string or executing a function just continue as usual
			return internalParse(site, prop, host, strippedString);
		}

		// parse the given text and either execute or bind it to the given site and property
		private function internalParse(site:Object, prop:String, host:Object, strippedString:String):Object
		{
			if (strippedString.charAt(0) == '{')
				strippedString = strippedString.substr(1, strippedString.length - 2);

			// split multiple commands
			var commands:Array = strippedString.split(";");
			var objects:Array;

			for each(var command:String in commands)
			{
				//trace("command: ", command);

				// split command into type (deprecated), command and arguments

				var regex:RegExp = /((?P<type>[^:]*):)?(?P<funcname>[^(]*)\((?P<args>[^)]*)\)|(?P<variable>[^(].*)/g;
				var params:Object = regex.exec(command);

				var funcType:String = trim(params.type);
				var funcName:String = trim(params.funcname);

				// decide if we should we handle a fucntion or a variable
				if (funcName)
				{
					var argsStr:String = trim(params.args);

					//trace("cmdType [", commandType, "] cmd [", commandStr, "] args (", argsStr, ")");

					// create a functor object based on the given host and function name
					var f:Functor = new Functor(parseLiteral(host, funcName), mode == PARSER_MODE_BIND);

					// parse the function arguments

					if (argsStr.length)
					{
						var args:Array = argsStr.split(",");
						for each(var arg:String in args)
						{
							//trace("  arg : ", arg);
							parseFunctionArg(f, host, arg);
						}
					}

					// bind function result if necessary
					if (mode == PARSER_MODE_BIND)
					{
						// in case the site is a Functor (created internaly by kTextParser for concatenating texts)
						// add the result to the Functor as an argument
						if (site is Functor)
							(site as Functor).addArgument([f, "result"]);
						else
							BindingUtils.bindProperty(site, prop, f, "result");
					}

					// flag the functor as ready
					f.ready = true;

					// call function for setting its value right now
					var result:* = f.callFunction();

					// if we're executing the function we may have several of them separated by ";".
					// just execute and dont return the value
					if (mode != PARSER_MODE_EXECUTE)
						return result;
				}
				else // bind the variable to the given site and prop
				{
					//trace("data: ", params.data);
					return parseBindingArg(site, prop, host, params.variable);
				}
			}
			//trace("done");

			return null;
		}

	}
}
