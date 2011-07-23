package com.kaltura.kdpfl.model
{
	import com.kaltura.kdpfl.util.DateTimeUtils;
	
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 *  The class FuncsProxy contains general functions used by the KDP. It can be accessed by the alias
	 * Functor.globalsFunctionsObject .
	 * 
	 */	
	public dynamic class FuncsProxy extends Proxy
	{
		public static const NAME:String = "FuncsProxy";
		/**
		 * Constructor 
		 * 
		 */		
		public function FuncsProxy()
		{
			super(NAME);
		}
		/**
		 *  
		 * @param url
		 * @return 
		 * 
		 */		
		public function encodeUrl(url : String) : String
		{
			return encodeURI(url);
		}
		
		/**
		 * The function creates a date using a dateObject and a format. 
		 * @param dateObject
		 * @param format - the desired format of the date. For instance DD/MM/YY.
		 * @return The function returns a date as a String of the required format.
		 * 
		 */		
		public function formatDate(dateObject:*, format:String):String
		{
			if (!dateObject)
				return "";
				
			//TODO: unmark this when the datetimeutils.formattime will work in milisec and not in sec	
/* 			var dateNumber:Number = parseInt(dateObject);
			if(!isNaN(dateNumber))
			{
				// date is probably in seconds and needs to be converted to milliseconds
				if (dateNumber < 1e10)
				{
					if (dateNumber < 86400)
						dateNumber+=(new Date().getTimezoneOffset()*60);
					
					dateNumber *= 1000;
				}
			
				if (dateNumber)
			  		dateObject = new Date(dateNumber);
			}  */
    
			format = format.toLowerCase();
			
			//TODO: THIS IS A WORK AROUND WE NEED TO CHENGE MM IN DateTimeUtils TO NN like in flex
			if(format == "nn:ss") format = "mm:ss";
			if(format == "hh:nn:ss") format = "hh:mm:ss";
			///////////////////////////////////////////////////////////////////
			
			if(format == "mm:ss" || format == "hh:mm:ss")
			{
				return DateTimeUtils.formatTime( dateObject , format );
			}
			else if(  format == "dd/mm/yyy" || format == "DD/MM/YYY") 
			{	
				//TODO: Extract this code to work with time as well after we will
				//fix the DateTimeUtils.formatTime to work in milisec and not in sec
				//////////////////////////////////////////////////////////
				///////////////////////////////////////////////////////////
				var dateNumber:Number = parseInt(dateObject);
				if(!isNaN(dateNumber))
				{
					// date is probably in seconds and needs to be converted to milliseconds
					if (dateNumber < 1e10)
					{
						if (dateNumber < 86400)
							dateNumber+=(new Date().getTimezoneOffset()*60);
						
						dateNumber *= 1000;
					}
				
					if (dateNumber)
				  		dateObject = new Date(dateNumber);
				} 
				///////////////////////////////////////////////////////////
				///////////////////////////////////////////////////////////
				
				
				return DateTimeUtils.formatDate( dateObject , format );
			}
			else
				return "";
		}
			
		/**
		 * This function reverses a boolean value, or a string value with casting to boolean. 
		 * @param obj - the object to reverse
		 * @param defaultValue - the default in case a string is received and it is not 'true' and not 'false'
		 * @return 
		 * 
		 */	
		public function not(obj:*,defaultValue:Boolean=false):Boolean
		{
			if(obj is Boolean)
			{
				return ! Boolean(obj);
			}
			if(obj is String)
			{
				if (obj == "true")
					return false;
				if (obj == "false")
					return true;
			}
			return defaultValue;
		}
		/**
		 * a wrapper to navigateToURL to avoid runtime errors.
		 * @param url	url to navigate to
		 * @param window	the window in which to open this url
		 */		
		public function navigate(url:String, window:String = null):void
		{
			var request:URLRequest = new URLRequest(url);
			try
			{
				navigateToURL(request, window);
			}
			catch (e:Error)
			{
				trace("failed navigating to "+url+"/n"+e.message);
			}
		}
		
		/**
		 * The function calls an external js function and injects it with parameters from within the KDP. 
		 * @param args the arguments passed to the js function.
		 * 
		 */		
		public function jsCall(...args):*
		{
			//Send notification that a js function is called for statistics or to notify other objects that intrest in 
			//this call (for example edit button is pressed and a statistic plug in want to know about it)
			if(args.length) sendNotification(args[0]);
			
			var externalInterfaceProxy:ExternalInterfaceProxy = facade.retrieveProxy( ExternalInterfaceProxy.NAME ) as ExternalInterfaceProxy;
			if (!externalInterfaceProxy.vo.enabled)
				return;
				
			var layoutProxy:LayoutProxy = facade.retrieveProxy( LayoutProxy.NAME ) as LayoutProxy;
			
			//xxx dispatchEvent(new CommandEvents(CommandEvents.CLOSE_FULL_SCREEN));

		  	var jsFuncName:String = args.shift();

			var functionBody:String = "";

			var xml:XML = layoutProxy.vo.layoutXML.javaScript[0];
			if (xml)
			{
				xml = xml.descendants().(attribute("id") == jsFuncName)[0];
			
				if (xml)
					functionBody = String(xml.children()[0]);
			}

			var argsString:String = "";
			for each(var arg:String in args)
			{
				argsString += "'" + arg + "',";
			}
			if (args.length)
				argsString = argsString.substr(0, argsString.length - 1);

			var commentPattern:RegExp = /(\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\/)|((^|[^:\/])(\/\/.*))/g;
			
			functionBody += jsFuncName + '(' + argsString + ')';
			functionBody = functionBody.replace(commentPattern, "");
			var value : * = ExternalInterface.call( "eval", functionBody );
			
			if (value)
			{
				return value;
			}
			
			return null;
		  }
	}
}