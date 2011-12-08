package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.flavorAsset.FlavorAssetGetByEntryId;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.vo.KalturaFlavorAsset;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class DownloadMediator extends Mediator
	{
		private var _flashvars:Object;
		public var flavorParamId:String="";
		private var _flavorById:String = "";
		
		public static const NAME:String = "downloadMediator";
		
		public function DownloadMediator(flavorParamId:String)
		{
			this.flavorParamId = flavorParamId;
			super(NAME);
		}
		
		override public function listNotificationInterests():Array
		{
			return ["doDownload"];
		} 
		
		override public function handleNotification(note:INotification):void
		{
			var entryId:String;
			var mediaProxy : MediaProxy;
			switch(note.getName())
			{
				case "doDownload":
					
					_flavorById = "";
					
					if(!flavorParamId)
					{
						// no specific entryId - go to download
						fetchFile();
					} else
					{
						// if got to this code - it means that we we have a definition for a specific flavor by
						// its id, and we need to list all flavors for this asset, and get the relevant assetid  
						mediaProxy = facade.retrieveProxy("mediaProxy") as MediaProxy;
						entryId=mediaProxy.vo.entry.id;
						var entry:Object = mediaProxy.vo.entry;
						var kClient : KalturaClient = facade.retrieveProxy("servicesProxy")["kalturaClient"] as KalturaClient;
						var flavorAssetByEntryId:FlavorAssetGetByEntryId = new FlavorAssetGetByEntryId(entryId);
						flavorAssetByEntryId.addEventListener(KalturaEvent.COMPLETE, result);
						flavorAssetByEntryId.addEventListener(KalturaEvent.FAILED, fault);
						kClient.post(flavorAssetByEntryId);
					}
					break;
			}	
		}
		
		
		protected function fetchFile():void
		{
			var entryId:String;
			var mediaProxy : MediaProxy;
			mediaProxy = facade.retrieveProxy("mediaProxy") as MediaProxy;
			entryId=mediaProxy.vo.entry.id;
			_flashvars= facade.retrieveProxy("configProxy")["vo"].flashvars;
			var cdnHost:String= _flashvars.cdnHost;
			var partner:String= _flashvars.partnerId;
			var subPartner:String= _flashvars.subpId;
			var flavor:String= mediaProxy.vo.selectedFlavorId;
			//override the asset ID from the one that was found (if there was a flavorParamId defined 
			if(_flavorById)
				flavor = _flavorById
			var url:String;
			
			
			//manifest code  
			//var entryManifestUrl:String  = _flashvars.httpProtocol + _flashvars.host+ "/p/" + _flashvars.partnerId+ "/sp/" + _flashvars.subpId + "/playManifest/entryId/" + entryId + ((_flashvars.deliveryCode) ? "/deliveryCode/" + _flashvars.deliveryCode : "")+ ((flavor) ? "/flavorId/" + flavor : "")+ "/format/url" + (_flashvars.cdnHost ? "/cdnHost/" + _flashvars.cdnHost : "")+ (_flashvars.storageId ? "/storageId/" + _flashvars.storageId : "") + (_flashvars.ks ? "/ks/" + _flashvars.ks : "")+(_flashvars.b64Referrer ? "/referrer/" + _flashvars.b64Referrer : "");
			
			if (flavor !=null){
				url=_flashvars.httpProtocol+cdnHost+"/p/"+partner+"/sp/"+subPartner+"/download/entry_id/"+entryId+"/flavor/"+flavor;		
			}
			else
			{
				url=_flashvars.httpProtocol+cdnHost+"/p/"+partner+"/sp/"+subPartner+"/download/entry_id/"+entryId;
			}
			
			if ( _flashvars.ks )
			{
				url += "/ks/" + _flashvars.ks;
			}
			
			trace ("Downloading");
			trace (url);
			
			
			var request:URLRequest= new URLRequest(url);
			navigateToURL(request, "_blank");
		}
		
		private function result( data : Object ) : void
		{
			//handle Error
			if(data.error)
			{
				trace("Error",data.error);
				// fallback use normal download. no flavors
				fetchFile();
				return;
			}
			
			
			for each (var o:KalturaFlavorAsset in data.data) 
			{
				if(flavorParamId && flavorParamId == o.flavorParamsId.toString() )
				{
					_flavorById = o.id;
					break;					
				}
			}
			//go fetch file if found matching asset or not. 
			fetchFile();
		}
		
		private function fault( data : Object ) : void
		{
			trace(data);
			//sendNotification("alert",{message:errorCaptureThumbnail,title:errorCaptureThumbnailTitle});
		}
		
	}
}