package com.kaltura.kdpfl.controller
{
	import org.puremvc.as3.interfaces.IFacade;

	public class SimpleFactory
	{
		public function SimpleFactory()
		{
			
		}
		
		//TODO: this unneccessarily creates multiple objects
		//consider passing reference to an existing object.
		public function getCommand(name:String,f:IFacade):ICommand{
			var command:ICommand;
			switch (name){
				case CopyCommand.NAME:
					command	= new CopyCommand(f);
					break;
				case EmailCommand.NAME:
					command	= new EmailCommand(f);
					break;
				case EmbedCommand.NAME:
					command	= new EmbedCommand(f);		
					break;
				case CaptchaCommand.NAME:
					command	= new CaptchaCommand(f);		
					break;
				case InteractiveCommand.NAME:
					command	= new InteractiveCommand(f);		
					break;
				default:
					trace("ADDTHIS ERROR:  No command name found matching name - "+name);
					break;
			}
			
			return command;
		}
	}
}