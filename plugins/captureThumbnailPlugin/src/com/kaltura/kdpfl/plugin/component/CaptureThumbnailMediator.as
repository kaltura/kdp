package com.kaltura.kdpfl.plugin.component
{
	import com.adobe.images.JPGEncoder;
	import com.kaltura.commands.baseEntry.BaseEntryUpdateThumbnailJpeg;
	import com.kaltura.types.KalturaMediaType;
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.vo.KalturaMixEntry;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class CaptureThumbnailMediator extends Mediator
	{
		public static const NAME:String = "CaptureThumbnailMediator";
		
		//Error texts should be overriten form uiconf
		/////////////////////////////////////////////
		public var errorCaptureThumbnail : String = "An error occurred while trying to capture thumbnail.";
		public var errorCaptureThumbnailTitle : String = "Error Capture Thumbnail";
		
		public var captureThumbnailDone : String = "New thumbnail has been set.";
		public var captureThumbnailNotAllowed : String = "Capture Thumbnail is not supported for this media";
		public var captureThumbnailDoneTitle : String = "Capture Thumbnail";
		private var bitmapData:BitmapData;
		/////////////////////////////////////////////
		
		public function CaptureThumbnailMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
					 "captureThumbnail"
					];
		} 
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case "captureThumbnail":
					var servicesProxy : Object =  facade.retrieveProxy("servicesProxy");
					var kc : KalturaClient = servicesProxy.kalturaClient;
					
					var mediaProxy : Object = facade.retrieveProxy("mediaProxy");
					var player : Object = facade.retrieveMediator( "kMediaPlayerMediator" )["player"];
					var playerView : DisplayObject;
					if( mediaProxy.vo.entry is KalturaMediaEntry &&
						((mediaProxy.vo.entry as KalturaMediaEntry).mediaType == KalturaMediaType.IMAGE || 
					    (mediaProxy.vo.entry as KalturaMediaEntry).mediaType == KalturaMediaType.AUDIO))
					{	
						sendNotification("alert",{message:captureThumbnailNotAllowed,title:captureThumbnailDoneTitle});
					}
					else
					{
					if( player && player.displayObject)
						 playerView = facade.retrieveMediator( "kMediaPlayerMediator" )["player"].displayObject;
					else 
						return; //can't capture the player if the view is unreachable
					

					var videoWidth : Number = playerView["videoWidth"];
					var videoHeight : Number = playerView["videoHeight"]

					bitmapData  = new BitmapData( videoWidth  , videoHeight , false , 0x000000);
					var a : Number = videoWidth/(playerView.width/playerView.scaleX); // videoWidth/unscaledWidth
					var d : Number = videoHeight/(playerView.height/playerView.scaleY);// videoHeight/unscaledHeight
					var matrix : Matrix = new Matrix( a , 0 , 0 , d );
					bitmapData.draw( playerView , matrix , null , null, null , true);
					
			        var encoder : JPGEncoder = new JPGEncoder(85);
					var thumbnail : ByteArray = encoder.encode( bitmapData );
					var updateThumbnailJpeg : BaseEntryUpdateThumbnailJpeg = new BaseEntryUpdateThumbnailJpeg( mediaProxy.vo.entry.id , thumbnail );
					updateThumbnailJpeg.addEventListener( "complete" , result );
					updateThumbnailJpeg.addEventListener( "failed" , fault );
					kc.post( updateThumbnailJpeg );
					}
				break;
			}	
		}

		
		private function result( data : Object ) : void
		{
			sendNotification("thumbnailSaved");
			sendNotification("alert",{message:captureThumbnailDone,title:captureThumbnailDoneTitle});
			bitmapData.dispose();
		}
		
		private function fault( data : Object ) : void
		{
			sendNotification("thumbnailFailed");
			sendNotification("alert",{message:errorCaptureThumbnail,title:errorCaptureThumbnailTitle});
		}
	}
}