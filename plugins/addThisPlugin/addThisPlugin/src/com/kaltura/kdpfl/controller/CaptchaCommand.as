package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.manager.AddThisManager;
	import com.kaltura.kdpfl.plugin.component.Form;
	import com.kaltura.kdpfl.plugin.component.IForm;
	
	import flash.net.URLVariables;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class CaptchaCommand extends EmailCommand implements ICommand
	{
		public static const NAME:String	= "CaptchaCommand";
		private var _addThisManager:AddThisManager	= new AddThisManager();
		
		public function CaptchaCommand(f:IFacade)
		{
			super(f);
		}
		
		private function processCaptcha():void{
			
		}
		
		private function validateCaptchaField():Boolean{
			var success:Boolean			= true;
			
			if(trim(_emailContent.captchaResponse) == ""){
				_emailError.componentId.push(_form.formParams["captchaResponse"]);
				success					= false;
			}
			
			return success;
		}

		
		override public function execute(form:IForm):void{
			var success:Boolean;
			_form	= form;
			
			success		= validateFields();
			success		= assignContents();
			success		= validateCaptchaField();
			
			joinRecipients();
			
			if(!success)
				throw _emailError;
			
			//trace("MY FORM DATA		"+form.data.error.attachment);
			var urlVars:URLVariables		= new URLVariables();
			urlVars.to						= escape(_emailContent.recipents);
			urlVars.url						= escape(_form.url);
			urlVars.from					= escape(_emailContent.senderEmail);
			urlVars.note					= escape(_emailContent.message);
			urlVars.token					= _form.data.error.attachment.token;
			urlVars.answer					= escape(_emailContent.captchaResponse);
			urlVars.suppress_response_codes= "true"; //required by addThis for flash streams
			
			trace("URLVARS::::to 						"+urlVars.to);
			trace("URLVARS::::url 						"+urlVars.url);
			trace("URLVARS::::from 						"+urlVars.from);
			trace("URLVARS::::note 						"+urlVars.note);
			trace("URLVARS::::challengeToken 			"+urlVars.token);
			trace("URLVARS::::challengeAnswer 			"+urlVars.answer);
			trace("URLVARS::::suppress_response_codes 	"+urlVars.suppress_response_codes);
			
			send(urlVars);
			
		}
		
	}
}