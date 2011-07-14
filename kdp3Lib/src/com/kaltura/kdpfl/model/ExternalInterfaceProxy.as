package com.kaltura.kdpfl.model
{
	import com.kaltura.kdpfl.model.vo.ExternalInterfaceVO;
	import com.kaltura.kdpfl.util.KTextParser;
	
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * ExternalInterfaceProxy wraps ExternalInterface service to allow
	 * javascript to listen to KDP notifications and dispatch them.
	 */
	public class ExternalInterfaceProxy extends Proxy
	{
		public static const NAME:String = "externalInterfaceProxy";
		
		public static const ADD_JS_LISTENER : String = "addJsListener";
		public static const REMOVE_JS_LISTENER : String = "removeJsListener";
		public static const SEND_NOTIFICATION : String = "sendNotification";
		public static const EVALUATE : String = "evaluate";
		public static const SET_ATTRIUBUTE : String = "setKDPAttribute";
		//public static const JS_CALLBACK_READY : String = "jsCallbackReady";
		public var jsCallBackReadyFunc : String = "jsCallbackReady";
		
		private var _jsEvents:Object = new Object();
		private var _flashvars : Object;
		
		
		/**
		 * Constructor 
		 * @param proxyName
		 * @param data
		 * 
		 */		
		public function ExternalInterfaceProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new ExternalInterfaceVO() );
			_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
		}
		
		/**
		 * Function wraps the <code>call</code> function of class ExternalInterface. This is done in order to prevent
		 * the call being made if flashvar <code>ExternalInterfaceDisabled</code> is set to <code>true</code> 
		 * @param functionName - the name of the javascript function to call.
		 * @param parameters - array of parameters to pass the javascript function
		 * 
		 */		
		public function call( functionName : String, ...parameters ) : *
		{
			if(vo.enabled)
			{
				try {
					if (parameters.length)
						return ExternalInterface.call(functionName , parameters, ExternalInterface.objectID );
					else
						return ExternalInterface.call(functionName , ExternalInterface.objectID );
				}
				catch(e:Error)
				{
				} 
			}
			
			return null;
		}
		
		/**
		 * Function wraps the addCallback function of class <code>ExternalInterface</code>  
		 * @param functionName - the name by which the html wrapper triggers the AS function.
		 * @param closure - the Action Script function triggered by the external wrapper.
		 * 
		 */				
		public function addCallback( functionName : String, closure : Function ) : void
		{
			if(vo.enabled)
				ExternalInterface.addCallback( functionName , closure );
		}
		
		/**
		 * This function does 1 of 2 possible things:
		 * 1. If the flashvar <code>jsInterfaceReadyFunc</code> is set to <code>true</code>, this function waits until the <body> tag of the html page surrounding the player
		 * is ready before registering the KDP callbacks. It does so by starting the <code>callbackTimer</code>, and re-calling this funcion when the timer fires the COMPLETE event.
		 * 2. If the flashvar <code>jsInterfaceReadyFunc</code> is set to <code>false</code>, this function simply registers the KDP callbacks, without waiting for the page to report that it's ready.
		 * 
		 */		
		public function registerKDPCallbacks() : void
		{
			if(vo.enabled)
			{
				if(_flashvars.jsInterfaceReadyFunc)
				{
					var containerReady : Boolean = isContainerReady();
					if(containerReady){
						callBackRegistration();
					}else{
						var callbackTimer : Timer = new Timer(100,1);
						callbackTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCallbackTimer);
						callbackTimer.start();
					}
				}else{
					callBackRegistration();
				}
					
			}
		}
		/**
		 * Function checks whether the html <body> tag is ready, to be sure that the javascript jsListeners are ready for the KDP events.
		 * @return - <code>true</code> if the <body> tag is ready, <code>false</code> otherwise.
		 * 
		 */		
		private function isContainerReady () : Boolean
		{
			var result : Boolean = ExternalInterface.call(_flashvars.jsInterfaceReadyFunc);
			return result;
		}
		/**
		 * Handler for the TimerEvent.COMPLETE of the <code>callbackTimer</code>. This handler re-calls the <code>registerKDPCallbacks</code>
		 * function. 
		 * @param e TimerEvent.
		 * 
		 */		
		private function onCallbackTimer ( e : TimerEvent) : void
		{
			(e.target as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE, onCallbackTimer);
			registerKDPCallbacks();
		}
		/**
		 * Function which registers the KDP callbacks.
		 * 
		 */		
		private function callBackRegistration() : void
		{
			addCallback( SEND_NOTIFICATION , extSendNotification );
			addCallback( EVALUATE , evaluate );
			addCallback( SET_ATTRIUBUTE , setAttribute );
			addCallback( ADD_JS_LISTENER , addJsListener );
			addCallback( REMOVE_JS_LISTENER , removeJsListener );
			call( jsCallBackReadyFunc );
		}
		
		/**
		 * Function adds a JavaScript listener function to the listener array of a specific notification.
		 * @param listenerString	the notification to listen to
		 * @param jsFunctionName	name of the js function to trigger on the event
		 */		
		public function addJsListener(listenerString:String, jsFunctionName:String):void
		{
			var funcs:Array = _jsEvents[listenerString];
			if (funcs)
			{
				if (funcs.indexOf(jsFunctionName) != -1)
					return; // listener already registered				
			}
			else
				_jsEvents[listenerString] = funcs = new Array();
				
			funcs.push(jsFunctionName);
		
		}
		
		/**
		 * Function removes a JavaScript listener function from the listener array of a specific notification.
		 * @param listenerString	notification name
		 * @param jsFunctionName	function that the notification triggers and should be removed from the listener array
		 * 
		 */		
		public function removeJsListener(listenerString:String, jsFunctionName:String):void
		{
			var funcs:Array = _jsEvents[listenerString];
			if (!funcs)
				return;

			var i:int = funcs.indexOf(jsFunctionName);
			if (i != -1)
				funcs.splice(i, 1);			
		}

		/**
		 * notify JS listeners of a notification. 
		 * @param notificationName	notification
		 * @param body				notification extra data
		 */		
		public function notifyJs(notificationName:String, body:Object):void
		{
			if (vo.enabled)
			{
				var funcs:Array = _jsEvents[notificationName];
				if (!funcs)
					return;

				for each(var jsFunctionName:String in funcs)
				{
					try {
						if (body)
							ExternalInterface.call(jsFunctionName, body, ExternalInterface.objectID);
						else
							ExternalInterface.call(jsFunctionName, ExternalInterface.objectID);
					} catch(e:Error)
					{
					}
				}
			}
		}
		
		/**
		 * triger any notification from the html wapper  
		 * @param notificationName
		 * @param body
		 * 
		 */		
		public function extSendNotification( notificationName : String , body : Object = null ) : void
		{
			sendNotification(notificationName,body);
		} 
		
		/**
		 * KDP 3 Provide a way to get any data that is in the bindObject to JS
		 * @param expression
		 * @return 
		 * 
		 */		
		public function evaluate(expression:String):Object
		{
			return KTextParser.evaluate(facade['bindObject'], expression);
		}
		
		/**
		 * KDP 3 Provide a way to set any data attribute using this function from JS
		 * @param componentName
		 * @param prop
		 * @param newValue
		 * 
		 */		
		public function setAttribute(componentName : String , prop : String , newValue : String):void
		{
			if ( !_flashvars.blockExternalInterference )
			{
				var site : Object =  KTextParser.evaluate(facade['bindObject'], '{' + componentName + '}');
				KTextParser.bind( site , prop , facade['bindObject'], newValue);
			}
		}
		
		/**
		 * return the data object
		 * @return 
		 * 
		 */		
		public function get vo():ExternalInterfaceVO  
        {  
        	return data as ExternalInterfaceVO;  
        }  
		
	}
}