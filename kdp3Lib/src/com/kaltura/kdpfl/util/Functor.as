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
	import com.kaltura.kdpfl.view.controls.KTrace;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.utils.ObjectUtil;

	/**
	 *  The Functor class encapsulates a function, its calling object and given parameteres
	 *  The class is used in two cases:
	 *    1. calling a given function immidiately  
	 *    2. binding the function arguments and calling the function each time they have changed
	 */
	public class Functor
	{
		// variable to hold the result of a bindable function
		private var _result:Object;

		// the object to which the actual function belong		
		private var host:Object;
		
		// the actual function name (or an internal function like KTextParser concat)		
		private var funcName:Object;
		
		// the properties chain leading to the actual function
		private var funcChain:Array;
		
		// the function arguments which may be constant or binded by watchers
		private var args:Array = new Array();
		
		// flags if the function should bind to its arguments
		private var bindArguments:Boolean
		
		// ready is set to true when all the function arguments have been parsed and
		// the function may be called safely
		public var ready:Boolean;
		
		// a global function object for calling predefined function such as formatDate etc..
		static public var globalsFunctionsObject : Object = null; 
		
		// create the functor object
		// the _funcChain array first element is the object from which the search for
		// the function should begin. The rest are property names leading to the function itself
		// which name is the last element in the array
		// when the bindArguments parameter is true the non-constant function arguments
		// will be binded otherwise they will be evaluted immidately once added to the Functor 
		public function Functor(_funcChain:Array, _bindArguments:Boolean)
		{
			bindArguments = _bindArguments
			funcChain = _funcChain;
			host = funcChain.shift();
			funcName = funcChain.pop();
		}

		// the bindable result function returns the pre calculated function result 
		[Bindable]
		public function get result():*
		{
			return _result;
		}

		// add an argument to the arguments array and try to evaluate it for setting an initial value
		// in case the value wont changed later (and no propery change event will be sent) 
		// if the given value is a string this is a cosntant argument otherwise its a property chain
		// the first element in the chain array is the host object to start from
		public function addArgument(value:*):void
		{
			if (value is String)
			{
	          	args.push(value);
	          	return;
	  		}
	          	
			var chain:Array = value as Array;
			
			// grab the root object 
			var argHost:Object = chain.shift();

        	var n:int = args.length;
        	
			// check if the arguments should be binded or evaluated immidately 			
			if (bindArguments)
			{
				// place a watcher on the argument
		        var w:ChangeWatcher =
	            	ChangeWatcher.watch(argHost, chain, null, false);
	            	
		        if (w != null)
		        {
					// make the watcher handler set the respective argument and reavulate the function
		            var assign:Function = function(event:*):void
		            {
		            	args[n] = w.getValue();
		            	callFunction();
		            };
		            w.setHandler(assign);
		            
		        }			
		 	}
		    
			// if the variable already exists set its value for the first time
			for each(var name:String in chain)
			{
				
				argHost = argHost[name];
				
				if (argHost == null)
					break;	
			}
			
			args[n] = argHost;
  
		}
		
		public function set result(value:*):void
		{
			_result = value;
		}
		
		// call the function using the object host and the current arguments 
		public function callFunction():Object
		{
			// dont call the function till all its arguments have been set
			// otherwise an execption on # of argument mismatch will be thrown  
			if (!ready)
				return null;

			var func:Object; 
			var obj:Object = host;
			
			// in case of an internal kTextParser function like concat
			// we just want to execute the code
			if (funcName is Function) 
			{
				func = funcName;
			}
			else
			{
				// follow the chain to arrive at the last object and actual function
				 			
				for each(var name:String in funcChain)
				{
					obj = obj[name];
					if (obj == null)
						return null;
				}
				
				// try to retrieve the real object from the data model using the _owner property
				// this will allow us to call functions without implicitly specifying them using
				// _proxy["funcname"] = funcname.
				// if the _owner property doesnt exist try to fetch the function from the data model

				if (obj.hasOwnProperty("_owner"))
					obj = obj["_owner"];
				else
					obj = globalsFunctionsObject;
						
				func = obj[funcName];
				if (func == null)
					return null;
			}

			// call the function and set the result to the bindable result variable
			try	{		
				result = (func as Function).apply(obj, args);
			}
			catch(e:Error)
			{
				//trace(ObjectUtil.toString(e));
				KTrace.getInstance().log(ObjectUtil.toString(e));
			}
			
			return result;
		}
	}
}