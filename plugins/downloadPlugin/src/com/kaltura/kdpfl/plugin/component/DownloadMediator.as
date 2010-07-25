package com.kaltura.kdpfl.plugin.component
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class DownloadMediator extends Mediator
	{
		private var _flashvars:Object;
		
		public function DownloadMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
			
		override public function listNotificationInterests():Array
		{
			return [
					 "doDownload"
					];
		} 

       override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case "doDownload":
					var mediaProxy : Object = facade.retrieveProxy("mediaProxy");
					var entry:String=mediaProxy.vo.entry.id;
					_flashvars= facade.retrieveProxy("configProxy")["vo"].flashvars;
					var cdnHost:String= _flashvars.cdnHost;
					var partner:String= _flashvars.partnerId;
					var subPartner:String= _flashvars.subpId;
					var flavor:String= _flashvars.flavorId;
					var url:String;
					if (flavor !=null){
					  url="http://"+cdnHost+"/p/"+partner+"/sp/"+subPartner+"/download/entry_id/"+entry+"/flavor/"+flavor;		
					}
					else
					{
					  url="http://"+cdnHost+"/p/"+partner+"/sp/"+subPartner+"/download/entry_id/"+entry
					}	
					var request:URLRequest= new URLRequest(url);
					navigateToURL(request, "_blank");
				break;
			}	
		}
		
		private function result( data : Object ) : void
		{
			//sendNotification("thumbnailSaved");
			//sendNotification("alert",{message:captureThumbnailDone,title:captureThumbnailDoneTitle});
		}
		
		private function fault( data : Object ) : void
		{
			//sendNotification("thumbnailFailed");
			//sendNotification("alert",{message:errorCaptureThumbnail,title:errorCaptureThumbnailTitle});
		}

	}
}