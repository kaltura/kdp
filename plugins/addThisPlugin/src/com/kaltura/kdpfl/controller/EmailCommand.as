package com.kaltura.kdpfl.controller
{
	import com.adobe.serialization.json.JSON;
	import com.kaltura.kdpfl.manager.AddThisManager;
	import com.kaltura.kdpfl.manager.IAddThisEmailDelegate;
	import com.kaltura.kdpfl.model.vo.AddThisEvent;
	import com.kaltura.kdpfl.plugin.component.IForm;
	import com.kaltura.kdpfl.view.controls.KTextField;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class EmailCommand extends AbstractCommand
	{
		public static const NAME:String	= "EmailCommand";
		private const COPY_SENDER:String	= "copySender";
		private const SENDER_EMAIL:String	= "senderEmail";
		private const RECIPIENTS:String		= "recipents";
		private const SENDER_NAME:String	= "senderName";
		private const MESSAGE:String		= "message";
		
		protected var _emailContent:Object			= {senderEmail:"",senderName:"",recipents:"",message:""};
		protected var _emailError:EmailError;
		
		private var _emailPattern:RegExp 			= /^[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,4}$/;
		private var trimPattern:RegExp				= /^\s+|\s+$/gs;
		private var _orgBorderColorsMap:Array		= new Array();
		
		private var _json:JSON						= new JSON();
		private var _addThisManager:AddThisManager	= new AddThisManager();
		
		public function EmailCommand(f:IFacade)
		{
			super(f);
			_addThisManager.addEventListener(AddThisEvent.ADD_THIS_MANAGER, onAddManagerResponse);
		}
		
		protected function validateFields():Boolean{
			var success:Boolean			= true;
			_emailError					= new EmailError();
			
			if(!validateEmailAddress(_emailContent.senderEmail)){
				_emailError.componentId.push(_form.formParams[SENDER_EMAIL]);
				success					= false;
			}
			
			for each(var email:String	in _emailContent.recipents){
				if(!validateEmailAddress(email)){
					_emailError.componentId.push(_form.formParams[RECIPIENTS]);
					success					= false;
					break;
				}
			}
			
			if(trim(_emailContent.senderName) == ""){
				_emailError.componentId.push(_form.formParams[SENDER_NAME]);
				success					= false;
			}
			
			if(trim(_emailContent.message) == ""){
				_emailError.componentId.push(_form.formParams[MESSAGE]);
				success					= false;
			}
			
			
			
			
			//reset borders back to normal
			for(var x:int= 0;x<_form.formComponents.length;x++){
				if(_form.formComponents[x] is KTextField)
					if(_form.formComponents[x].borderColor != _orgBorderColorsMap[x])
						_form.formComponents[x].borderColor	= _orgBorderColorsMap[x];
				
			}
			
			
			if(_emailError.componentId.length > 0){//if id's exist then we have errors
				for each(var id:String in _emailError.componentId){//for each id, match it to the physical component
					for(var i:int= 0;i<_form.formComponents.length;i++){
						if(_form.formComponents[i].name == id  && _form.formComponents[i] is KTextField){//then change the border to red
							_form.formComponents[i].borderColor				= 0xFF0000;
						}
					}
				}
			}
			
			return success;
			
		}
		
		private function validateEmailAddress(address:String):Boolean{
			var success:Boolean	= false;
			
			(_emailPattern.exec(address))?success = true:success=false;
				
			return success;
		}
		
		//this parses through the params, finds the physical component and grabs the text
		protected function assignContents():Boolean{
			var success:Boolean		= false;
			try{
				for(var i:int= 0;i<_form.formComponents.length;i++){
					for (var key:String	in _form.formParams){
						if(_form.formComponents[i].name	== _form.formParams[key]){
							switch(key){
								case RECIPIENTS:
									_emailContent[key]				= String(_form.formComponents[i].htmlText).split(",");
									break;
								case COPY_SENDER:
									_emailContent[key]				= _form.formComponents[i].selected;
									trace("COPY SENDER::::: "+_form.formComponents[i].selected);
									break;
								default:
									_emailContent[key]				= _form.formComponents[i].htmlText;
									break;
							}
						}
					}
					//retain the original border colors for textfields
					if(_form.formComponents[i] is KTextField)
						_orgBorderColorsMap.push(_form.formComponents[i].borderColor);
				}
				
				//if copy sender
				if(_emailContent[COPY_SENDER])
					_emailContent[RECIPIENTS].push(_emailContent[SENDER_EMAIL]);
				trace(_emailContent[RECIPIENTS]);
				
				
				success				= true;
			}catch(e:Error){
				trace("ERROR::: 	"+e);
				trace("AddThis Error: EmailCommand - problem assigning form textfields to expected email properties.  Please ensure email properties are correctly define.");
				success				= false;
			}
			return success;
		}
		
		protected function trim(str:String):String{
			return str.replace(trimPattern,"");
		}
		
		protected function joinRecipients():void{
			var recipients:String		= new String();
			for each(var recipient:String	 in _emailContent.recipents){
				recipients		+= (trim(recipient)+",");
			}
			
			_emailContent.recipents			= recipients;
		}
		
		
		private function onAddManagerResponse(e:AddThisEvent):void{
			var event:AddThisEvent		= new AddThisEvent(AbstractCommand.COMMAND_RESPONSE);
				event.data				= e.data;
				
			switch(e.codeType){
				case AddThisEvent.CAPTCHA_RESPONSE:
					event.codeType			= AddThisEvent.CAPTCHA_RESPONSE;
					break;
				case AddThisEvent.EMAIL_SENT:
					event.codeType			= AddThisEvent.EMAIL_SENT;
					break;
				case AddThisEvent.EMAIL_SEND_FAIL:
					event.codeType			= AddThisEvent.EMAIL_SEND_FAIL;
					break;
				default:
					event.codeType			= "UNKNOWN ADDTHIS EMAIL RESPONSE";
					break;
			}

			dispatchEvent(event);
		}
		
		override public function execute(form:IForm):void{
			var success:Boolean;
				_form	= form;
			
			success		= assignContents();
			success		= validateFields();
			
			joinRecipients();
			
			if(!success)
				throw _emailError;
			
			var urlVars:URLVariables		= new URLVariables();
			urlVars.to						= escape(_emailContent.recipents);
			urlVars.url						= escape(_form.url);
			urlVars.from					= escape(_emailContent.senderEmail);
			urlVars.note					= escape(_emailContent.message);
			urlVars.suppress_response_codes= "true"; //required by addThis for flash streams
			
			send(urlVars);
			
		}
		
		protected function send(urlVars:URLVariables):void{
			_addThisManager.sendEmail(urlVars);
		}

	}
}