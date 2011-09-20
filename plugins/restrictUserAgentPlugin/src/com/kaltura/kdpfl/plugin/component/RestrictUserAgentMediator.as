package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import flash.system.Capabilities;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class RestrictUserAgentMediator extends Mediator
	{
		public static const NAME : String = "restrictUserAgentMediator";
				
		public function RestrictUserAgentMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			var array : Array = [NotificationType.ENTRY_READY];
			
			return array;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
			if ( Number(mediaProxy.vo.entryExtraData.isUserAgentRestricted) || isUserAgentRestricted())
			{
				mediaProxy.vo.isMediaDisabled = true;
				sendNotification(NotificationType.ALERT , {title: (viewComponent as RestrictUserAgentPluginCode).restrictedUserAgentTitle , message : (viewComponent as RestrictUserAgentPluginCode).restrictedUserAgentMessage});
			}
		}
		
		private function isUserAgentRestricted () : Boolean
		{
			var caps : Capabilities;
			
			var userAgentsToLowerCase : String = (viewComponent as RestrictUserAgentPluginCode).restrictedUserAgents.toLowerCase(); 
			
			var userAgents : Array = userAgentsToLowerCase.split( "," );
			
			var osToLowerCase : String = Capabilities.os.toLowerCase();
			
			var verToLowerCase : String = Capabilities.version.toLowerCase();
			
			for each ( var userAgent : String in userAgents)
			{
				if ( userAgent.indexOf(osToLowerCase) != -1 || userAgent.indexOf(verToLowerCase) != -1)
				{
					return true;
				}
				
				if (osToLowerCase.search( RegExp(userAgent) )!= -1 || verToLowerCase.search( RegExp(userAgent) )!= -1)
				{
					return true;
				}
			}
			
			return false;
		}
	}
}  