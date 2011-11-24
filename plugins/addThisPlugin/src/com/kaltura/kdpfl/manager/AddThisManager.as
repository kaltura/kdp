package com.kaltura.kdpfl.manager
{
	import com.adobe.serialization.json.JSON;
	import com.kaltura.kdpfl.controller.EmailError;
	import com.kaltura.kdpfl.model.vo.AddThisEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class AddThisManager extends EventDispatcher
	{
		private var _services:Array			= ["email","socialSites"];
		private var _endPoint:String		= "http://api-test.addthis.com/oexchange/0.8/send/mail.json";
		private var _urlRequest:URLRequest	= new URLRequest();
		private var _urlLoader:URLLoader	= new URLLoader();
		private var _delegate:IAddThisEmailDelegate;
		private var _addThisEvent:AddThisEvent;
		public function AddThisManager()
		{
		
		}
		
		private function connect(variables:URLVariables):void{
			_urlRequest.url					= _endPoint;			
			_urlRequest.data				= variables;
			_urlRequest.method				= URLRequestMethod.POST;
			
			_urlLoader.dataFormat			= URLLoaderDataFormat.TEXT;
			
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_urlLoader.addEventListener(Event.COMPLETE, onResponse);
			
			_urlLoader.load(_urlRequest);
		}
		
		private function onIOError(e:IOErrorEvent):void{trace("IO ERROR::: "+e);}
		private function onSecurityError(e:SecurityErrorEvent):void{trace("SECURITY ERROR::: "+e);}
		
		private function onResponse(e:Event):void{
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_urlLoader.removeEventListener(Event.COMPLETE, onResponse);
			
			var data:String				= e.target.data;
			
			var response:*				= JSON.decode(data);

			_addThisEvent				= new AddThisEvent(AddThisEvent.ADD_THIS_MANAGER);
			if(response.error){
				_addThisEvent.codeType	= AddThisEvent.CAPTCHA_RESPONSE;
			}else if(response.emailSent){
				_addThisEvent.codeType	= AddThisEvent.EMAIL_SENT;
			}else if(!response.emailSent){
				_addThisEvent.codeType	= AddThisEvent.EMAIL_SEND_FAIL;
			}
			_addThisEvent.data			= response;
			
			dispatchEvent(_addThisEvent);
		}
		
		private function onError():void{
			
		}
		
		public function sendEmail(variables:URLVariables):void{
				connect(variables);
		}
		
		
	}
}