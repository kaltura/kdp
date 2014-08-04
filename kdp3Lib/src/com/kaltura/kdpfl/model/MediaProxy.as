package com.kaltura.kdpfl.model
{
	import com.kaltura.KalturaClient;
	import com.kaltura.kdpfl.model.strings.MessageStrings;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SourceType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.kdpfl.model.vo.MediaVO;
	import com.kaltura.kdpfl.model.vo.SequenceVO;
	import com.kaltura.kdpfl.model.vo.StorageProfileVO;
	import com.kaltura.kdpfl.util.KTextParser;
	import com.kaltura.kdpfl.util.URLUtils;
	import com.kaltura.kdpfl.view.controls.KTrace;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.osmf.buffering.DualThresholdBufferingProxyElement;
	import com.kaltura.osmf.events.KSwitchingProxyEvent;
	import com.kaltura.osmf.events.KSwitchingProxySwitchContext;
	import com.kaltura.osmf.image.TimedImageElement;
	import com.kaltura.osmf.kaltura.KalturaBaseEntryResource;
	import com.kaltura.osmf.proxy.KSwitchingProxyElement;
	import com.kaltura.types.KalturaMediaType;
	import com.kaltura.vo.KalturaFlavorAsset;
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.vo.KalturaMixEntry;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osmf.elements.F4MElement;
	import org.osmf.elements.F4MLoader;
	import org.osmf.elements.ImageElement;
	import org.osmf.elements.ImageLoader;
	import org.osmf.elements.ProxyElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.net.DynamicStreamingResource;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.StreamType;
	import org.osmf.net.StreamingURLResource;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * This class is the proxy for the media playing in the media player.
	 * 
	 */	
	public class MediaProxy extends Proxy
	{
		public static const NAME:String = "mediaProxy";
		
		/**
		 * represents the starting bitrate index, if exists
		 */		
		public var startingIndex:int;
		
		public var shouldCreateSwitchingProxy : Boolean = true;
		
		private var _sendMediaReady : Boolean;
		private var _flashvars : Object;
		private var _client : KalturaClient;
		private var _isElementLoaded : Boolean;
		/**
		 * indicates if this is a new media and we should wait for mediaElementReady notification
		 */		
		public var shouldWaitForElement:Boolean;
		
		private var _resource:URLResource;
		
		namespace xmlns = "http://ns.adobe.com/f4m/1.0";
		
		/**
		 *Constructor 
		 * @param data - value object of the Proxy.
		 * 
		 */		
		public function MediaProxy( data:Object=null )
		{
			super( NAME, new MediaVO()  );
			_flashvars = (facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy).vo.flashvars;
			
		}
		/**
		 * Function prepares a new media element according to the information from the kaltura MediaEntry
		 * @param seekFrom - optional parameter, passed if the video being loaded is a response to intelligent seeking.
		 * 
		 */		
		public function prepareMediaElement(seekFrom :uint = 0) : void
		{
			if (!_client)
				_client = (facade.retrieveProxy( ServicesProxy.NAME ) as ServicesProxy ).kalturaClient as KalturaClient;
			var resource:MediaResourceBase;
			var sourceType : String = _flashvars.sourceType;
			switch (sourceType) 
			{
				case SourceType.ENTRY_ID:
					
					var protocol : String;
					if((_flashvars.httpProtocol as String).indexOf("://") != -1)
					{
						protocol = (_flashvars.httpProtocol as String).replace("://", "");
					}
					
					var storageProfileId : String;
					if (_flashvars.storageId && _flashvars.storageId != "")
					{
						storageProfileId = _flashvars.storageId;
					}
					else if (vo.availableStorageProfiles && vo.availableStorageProfiles.length)
					{
						storageProfileId = (vo.availableStorageProfiles[0] as StorageProfileVO).storageProfileId;
					}
					
					//When using a mix entry the load is still done using flvclipper
					if (vo.entry is KalturaMixEntry)
					{
						resource = new URLResource(vo.entry.dataUrl);
						addMetadataToResource(resource);
						vo.media = vo.mediaFactory.createMediaElement(new KalturaBaseEntryResource( vo.entry ));
						break;
					}	
					
					//when loading a media entry we still use the flvclipper
					if((vo.entry is KalturaMediaEntry) && (vo.entry as KalturaMediaEntry).mediaType == KalturaMediaType.IMAGE)
					{
						if (vo.entry.width < 0)
						{
							vo.entry.width = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).kMediaPlayer.width; 
						}
						if (vo.entry.height < 0)
						{
							vo.entry.height = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).kMediaPlayer.height; 
						}
						var imgUrl:String = vo.entry.thumbnailUrl+"/width/" + vo.entry.width + "/height/"+vo.entry.height+"/.a.jpg" +  URLUtils.getThumbURLPostfix(_flashvars, _client.ks);  
						resource = new URLResource( imgUrl );
						addMetadataToResource (resource);
						if(vo.supportImageDuration)
						{
							///We load the vo.entry.downloadUrl as service and append ".a.jpg" to it in order to comply with
							// the OSMF need for an extensioned url. We assume every uploaded pic will be converted to a JPG file.
							var imgDuration:Number;
							if(_flashvars.imageDefaultDuration)
								imgDuration=Number(_flashvars.imageDefaultDuration);
							else
								imgDuration=vo.imageDefaultDuration;
							
							var timedImageElement: TimedImageElement = new TimedImageElement(new ImageLoader(),new URLResource(imgUrl),imgDuration);
							vo.media = timedImageElement; 
						}
						else
						{
							var imageElement : ImageElement = new ImageElement(new URLResource(imgUrl), new ImageLoader());
							vo.media = imageElement;	
						} 
					}
					else
					{
						var manifestUrl:String = getManifestUrl(seekFrom, storageProfileId); 
						
						//indicates we should parse manifest ourselves (used for playing HDS for example)
						if (vo.isHds)
						{
							if (vo.deliveryType == StreamerType.HDNETWORK) // hdnetwork + hds = hdnetworkmanifest, change manifest the URL accordingly
							{
								manifestUrl = manifestUrl.replace(StreamerType.HDNETWORK, StreamerType.HDNETWORK_HDS);
							}
							var urlLoader:URLLoader = new URLLoader();
							urlLoader.addEventListener(Event.COMPLETE, onUrlComplete);
							urlLoader.load(new URLRequest(manifestUrl));
						}
						else
						{
							if (vo.deliveryType == StreamerType.HDNETWORK) //in order to save roundtrip, request hdnetworksmil directly
							{
								manifestUrl = manifestUrl.replace(StreamerType.HDNETWORK, "hdnetworksmil");
								manifestUrl = manifestUrl.replace(".f4m",".smil");
							}
							createElement(manifestUrl);
						}
						return;
					}
					break;
				
				case SourceType.URL:
					switch (vo.deliveryType)
					{
						case StreamerType.LIVE:
							
							//Create resource for live streaming entry
							var liveStreamUrl : String = vo.entry.dataUrl;
							resource = new StreamingURLResource(liveStreamUrl, StreamType.LIVE);
							
							break;
						case StreamerType.RTMP:	
							var streamFormat : String = _flashvars.streamFormat ? (_flashvars.streamFormat + ":") : "";
							var rtmpUrl:String = vo.entry.dataUrl;
							if (!URLUtils.getProtocol(rtmpUrl)) // if we didn't get a full url, we build it
							{
								rtmpUrl = _flashvars.streamerUrl + "/" + streamFormat + rtmpUrl;
							}
							if (_flashvars.rtmpFlavors)
							{
								resource = new DynamicStreamingResource(rtmpUrl,StreamType.RECORDED);
							}
							else
							{
								resource = new StreamingURLResource(rtmpUrl,StreamType.RECORDED);
							}
							
							break;
						case StreamerType.HTTP:
						case StreamerType.HDNETWORK:
						case StreamerType.HDNETWORK_HDS:
						case StreamerType.HDS:
							var resourceUrl : String = vo.entry.dataUrl;
							resource = new StreamingURLResource( resourceUrl , StreamType.LIVE_OR_RECORDED );
							break;
					}
					addMetadataToResource(resource);
					var elem:MediaElement = vo.mediaFactory.createMediaElement(resource);
					if (elem.hasOwnProperty("smoothing")) {
						elem["smoothing"] = true;
					}
					
					vo.media = new DualThresholdBufferingProxyElement(vo.deliveryType == StreamerType.LIVE ? vo.initialLiveBufferTime :vo.initialBufferTime,vo.deliveryType == StreamerType.LIVE ? vo.expandedLiveBufferTime : vo.expandedBufferTime, elem);	
					break;
				case SourceType.F4M:
					var entryManifestUrl : String  = vo.entry.dataUrl;
					resource = new StreamingURLResource(entryManifestUrl);
					addMetadataToResource(resource);
					var f4mElement : F4MElement = new F4MElement (resource as URLResource, new F4MLoader(vo.mediaFactory));
					var dtbpElement : DualThresholdBufferingProxyElement = new DualThresholdBufferingProxyElement((vo.deliveryType == StreamerType.LIVE ? vo.initialLiveBufferTime : vo.initialBufferTime), (vo.deliveryType == StreamerType.LIVE ? vo.expandedLiveBufferTime : vo.expandedBufferTime), f4mElement);
					vo.media = dtbpElement;
					break;
			}
			
			saveResourceAndMedia(resource);
		}
		
		/**
		 * creates the proper media element according to the given resourceUrl 
		 * @param resourceUrl
		 * 
		 */		
		private function createElement(resourceUrl:String):void {
			var resource:MediaResourceBase;
			
			
			if (vo.deliveryType == StreamerType.HDNETWORK || vo.deliveryType == StreamerType.HDNETWORK_HDS || vo.isHds)
			{
				resource = new StreamingURLResource(resourceUrl, StreamType.LIVE_OR_RECORDED);
				addMetadataToResource(resource);
				var element:MediaElement = vo.mediaFactory.createMediaElement(resource);
				var adaptedHDElement : DualThresholdBufferingProxyElement = new DualThresholdBufferingProxyElement((vo.isLive ? vo.initialLiveBufferTime : vo.initialBufferTime), (vo.isLive ? vo.expandedLiveBufferTime : vo.expandedBufferTime), element);
				vo.media = adaptedHDElement;	
		
			}			
			else
			{
				var preferedIndex:int = getFlavorByBitrate(vo.preferedFlavorBR);	
				resource = new StreamingURLResource(resourceUrl);
				addMetadataToResource(resource);
				var f4mLoader : F4MLoader = new F4MLoader(vo.mediaFactory);
				//to set initial flavor we should disable auto switch, we return it after first play
				(facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player.autoDynamicStreamSwitch = false;
				if (preferedIndex!=-1)
				{
					resource.addMetadataValue(MetadataNamespaces.RESOURCE_INITIAL_INDEX, preferedIndex);
					startingIndex = preferedIndex;
				}
				f4mLoader.useRtmptFallbacks = _flashvars.useRtmptFallback == "false" ? false : true;				
				var f4mElem : F4MElement = new F4MElement (resource as URLResource, f4mLoader) ;
				
				var adaptedElement : DualThresholdBufferingProxyElement = new DualThresholdBufferingProxyElement((vo.isLive ? vo.initialLiveBufferTime : vo.initialBufferTime), (vo.isLive ? vo.expandedLiveBufferTime : vo.expandedBufferTime), f4mElem);
				vo.media = adaptedElement;				
			}
			
			saveResourceAndMedia(resource);
		}
		
		
		/**
		 * parses metadata from flashvars and add it to the given resource 
		 * relevant flashvars: metadataNamespace[i] = String, the namespace of the metadata
    	 * metadataValues[i] = String, The metadata to set. The syntax of this flashvar is comma seperated key=value strings. each key=value string represents a new metadata value.
    	 * for example: first=one,second=two,third=three
		 * 
		 */		
		private function addMetadataToResource(resource:MediaResourceBase):void
		{
			var i:int = 0;
			while (_flashvars.hasOwnProperty("metadataNamespace" + i) && _flashvars.hasOwnProperty("metadataValues" + i))
			{
				var metadata:Metadata = resource.getMetadataValue(_flashvars["metadataNamespace" + i]) as Metadata;	
				// if not created a new metadata object is created
				if (metadata == null)
				{
					metadata = new Metadata();
				}
				var valsArray:Array = (_flashvars["metadataValues" + i] as String).split(",");
				for (var k:int = 0; k<valsArray.length; k++)
				{
					var cur:String = valsArray[k];
					var index:int = cur.indexOf("=");
					if (index!=-1)
					{
						metadata.addValue(cur.substr(0, index), cur.substring(index+1) );
					}
				}
				resource.addMetadataValue(_flashvars["metadataNamespace" + i], metadata);
				i++;
			}
			
			//in case metadata values are represented as objects, they will be handled in this function
			addObjectMetadataToResource(resource);
		}
		
		/**
		 * parses resources metadata from flashvars and add the metadata on the given resource. Support JSON rperesentations for the metadata values 
		 * relevant flashvars: objMetadataNamespace[i] = String, the namespace of the metadata
    	 * objMetadataValues[i] = String, The metadata to set. The syntax of this flashvar is "&" seperated key=value strings. each key=value string represents a new metadata value.
    	 * for example: first=one&second=two&third=three
		 * metadata value can be a json object, for example: first={one:1,two:2}&second=bla
		 * 
		 */		
		private function addObjectMetadataToResource(resource:MediaResourceBase):void
		{
			var i:int = 0;
			while (_flashvars.hasOwnProperty("objMetadataNamespace" + i) && _flashvars.hasOwnProperty("objMetadataValues" + i))
			{
				var metadata:Metadata = resource.getMetadataValue(_flashvars["objMetadataNamespace" + i]) as Metadata;	
				// if not created a new metadata object is created
				if (metadata == null)
				{
					metadata = new Metadata();
				}
				var valsArray:Array = (_flashvars["objMetadataValues" + i] as String).split("&");
				for (var k:int = 0; k<valsArray.length; k++)
				{
					var cur:String = valsArray[k];
					var index:int = cur.indexOf("=");
					if (index!=-1)
					{
						var val:String = cur.substring(index+1);
						var valAsObj:Object = val;
						if (val.charAt(0)=="{" && val.charAt(val.length-1)=="}")
						{
							//array of all object properties
							var propsArr:Array = val.substr(1, val.length - 2).split(",");
							valAsObj = new Object();
							for (var j:int=0; j<propsArr.length; j++)
							{
								var property:String = propsArr[j];
								var ind:int = property.indexOf(":");
								var objKey:String = property.substr(0, ind);
								var objVal:String = property.substring(ind + 1, val.length);	
								//convert value to boolean or number or string
								valAsObj[objKey] = getValueObject(objVal);
							}
						}
						else
						{
							valAsObj = getValueObject(val);
						}

						metadata.addValue(cur.substr(0, index), valAsObj );
					}
				}
				resource.addMetadataValue(_flashvars["objMetadataNamespace" + i], metadata);
				i++;
			}
			
		}
		
		/**
		 * converts given object to boolean / number / object 
		 * @param val
		 * @return 
		 * 
		 */		
		private function getValueObject(val:String):Object
		{
			var valAsNum:Number = valAsNum = parseFloat(val);
			var valAsObj:Object = val=="true"? true: val=="false" ? false : isNaN(valAsNum) ? val : valAsNum;
			return valAsObj;
		}
		
		/**
		 * Getter for the MediaProxy data.
		 * @return returns the MediaVO of the MediaProxy.
		 * 
		 */		
		public function get vo():MediaVO  
		{  
			return data as MediaVO;  
		} 
		/**
		 * Setter for the proxy data.
		 * @param mediaVO new data to place in the MediaVO.
		 * 
		 */        
		public function set vo (mediaVO : MediaVO) : void
		{
			data = mediaVO;
		}
		/**
		 * Getter for the VideoElement of the media.
		 * @return VideoElement
		 * 
		 */        
		public function get videoElement () : VideoElement
		{
			var media : MediaElement = vo.media;
			
			while (media is ProxyElement)
			{
				media = (media as ProxyElement).proxiedElement;
			} 
			//In order to enable Intelligent Seeking in the video, we need to receive the key-frame array from the MetaData.
			if(media is VideoElement)
			{
				return media as VideoElement;
			}
			return null;
		}
		
		
		public function set videoElement (newElem : VideoElement) : void
		{
			var media : MediaElement = vo.media;
			
			while (media is ProxyElement)
			{
				media = (media as ProxyElement).proxiedElement;
			} 
			//In order to enable Intelligent Seeking in the video, we need to receive the key-frame array from the MetaData.
			if(media is VideoElement)
			{
				media = newElem;
			}
			
		}
		
		/**
		 * Getter for the MediaElement of the media.
		 * @return VideoElement
		 * 
		 */        
		public function get mediaElement () : MediaElement
		{
			var media : MediaElement = vo.media;
			
			while (media is ProxyElement)
			{
				media = (media as ProxyElement).proxiedElement;
			} 
			
			return media;
		}
		
		/**
		 * Function initiates the load of the video file that belongs to the Media Element,
		 * and indicates that a MEDIA_READY notification should be sent when the process is complete.
		 * 
		 */        
		public function loadWithMediaReady () : void
		{
			if (vo.media)
			{
				_isElementLoaded = false;
				vo.media.addEventListener(MediaErrorEvent.MEDIA_ERROR, onError);
				_sendMediaReady = true;
				
				sendNotification(NotificationType.SOURCE_READY);
			}
			
		}
		
		/**
		 * Function initates the load of the video file that belongs to the Media Element 
		 * and indicates that there is no need to send the MEDIA_READY notification when the process is complete.
		 * @param doPlay - flag signifying whether the video should begin playing on being loaded.
		 * 
		 */        
		public function loadWithoutMediaReady (doPlay : Boolean = false) : void
		{
			_isElementLoaded = false;
			vo.media.addEventListener(MediaErrorEvent.MEDIA_ERROR, onError);
			vo.playOnLoad = doPlay;
			_sendMediaReady = false;
			sendNotification(NotificationType.SOURCE_READY);
		}
		/**
		 * Function that handles the complete load of the video file that belongs to the media element.
		 * 
		 */        
		public function loadComplete() : void
		{
			if(!_isElementLoaded)
			{
				
				_isElementLoaded = true;
				if (mediaElement)
				{
					if (mediaElement.hasOwnProperty("smoothing"))
						mediaElement["smoothing"] = true;
					if (mediaElement.hasOwnProperty("client") && mediaElement["client"])
						mediaElement["client"].addHandler(NetStreamCodes.ON_META_DATA, onMetadata);
				}
				if (_sendMediaReady)
				{
					sendNotification(NotificationType.MEDIA_LOADED);	
				}
				else
				{
					if (vo.playOnLoad)
					{
						vo.playOnLoad = false;
						sendNotification(NotificationType.DO_PLAY);
					}
				}
			}
		}
		
		/**
		 * Function stores the array of key frames from the media meta data on the MediaVO.
		 * @param info the Meta Data for the kaltura media.
		 * 
		 */       
		private function onMetadata(info:Object):void// reads metadata..
		{
			vo.keyframeValuesArray=info.times; 
			sendNotification(NotificationType.VIDEO_METADATA_RECEIVED, {keyframeValuesArray: vo.keyframeValuesArray});
		}
		
		/**
		 * 
		 * @param evt
		 * 
		 */	   
		private function onError(evt:MediaErrorEvent):void
		{
			KTrace.getInstance().log("media error", evt.error ? evt.error.errorID: '', evt.error ? evt.error.detail: '');
			
			if(evt.type==MediaErrorEvent.MEDIA_ERROR)
			{
				if (evt.error && (evt.error.errorID == MediaErrorCodes.NETSTREAM_PLAY_FAILED)) 
				{
					KTrace.getInstance().log("media error", evt.error.errorID, evt.error.detail);
				}
				else 
				{
					sendNotification(NotificationType.MEDIA_ERROR , {errorEvent : evt});
					sendNotification(NotificationType.DO_STOP);
					sendNotification(NotificationType.ALERT,{message:MessageStrings.getString('CLIP_NOT_FOUND'),title:MessageStrings.getString('CLIP_NOT_FOUND_TITLE')})
				}
			}
		}
		
		protected function onSwitchPerformed (e : KSwitchingProxyEvent) : void
		{
			var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			var curContext:String;
			if (e.switchingProxySwitchContext == KSwitchingProxySwitchContext.SECONDARY)
			{
				sequenceProxy.vo.isInSequence = true;
				sequenceProxy.vo.isAdSkip = true;
				//we will replace to secondary, current is main
				curContext = KSwitchingProxySwitchContext.MAIN;
			}
			else
			{
				sequenceProxy.vo.isInSequence = false;
				sequenceProxy.vo.isAdSkip = false;
				curContext = KSwitchingProxySwitchContext.SECONDARY;
			}
			sendNotification(NotificationType.SWITCHING_MEDIA_ELEMENTS_STARTED, {currentContext: curContext});
		}
		
		protected function onSwitchCompleted (e: KSwitchingProxyEvent) : void 
		{
			sendNotification(NotificationType.SWITCHING_MEDIA_ELEMENTS_COMPLETED, {currentContext: e.switchingProxySwitchContext});
		}
		
		protected function onSwitchFailed (e: KSwitchingProxyEvent) : void 
		{
			sendNotification(NotificationType.SWITCHING_MEDIA_ELEMENTS_FAILED);
		}
		
		/**
		 * Finds the stream with the closest propName to the passed prefPropValue
		 * @param prefPropValue the prefered value of the prop by which to search for a stream
		 * @param propName The name of the property that the streamItems are sorted by. If no value is passed, the default is bitrate.
		 * @return the DynamicStreamingItem index. if a matching stream wasnt found return -1 (auto)
		 * 
		 */
		public function findDynamicStreamIndexByProp(preferedBitrate : int , propName : String="bitrate") : int
		{
			var foundStreamIndex:int = -1;
			if (!vo.kalturaMediaFlavorArray)
				return foundStreamIndex;
			
			if (vo.kalturaMediaFlavorArray.length > 0)
			{
				for(var i:int = 0; i < vo.kalturaMediaFlavorArray.length; i++)
				{
					var lastb:Number;
					if(i!=0)
					{
						lastb = vo.kalturaMediaFlavorArray[i-1].bitrate;
						lastb = Math.round(lastb/100) * 100;
					}
					
					var b:Number = vo.kalturaMediaFlavorArray[i].bitrate;
					b = Math.round(b/100) * 100;
					
					if (b == preferedBitrate)
					{
						//if we found it set it and leave
						foundStreamIndex = i;
						return foundStreamIndex;
					}
					else if(i == 0 && preferedBitrate < b)
					{
						//if the first is bigger then the prefered bitrate set it and leave
						foundStreamIndex = i;
						return foundStreamIndex;
					}
					else if( lastb && preferedBitrate < b  && preferedBitrate > lastb )
					{
						//if the prefered bit rate is between the last index and the current choose the closer one
						var topDelta : int = b - preferedBitrate;
						var bottomDelta : int = preferedBitrate - lastb;
						if(topDelta<=bottomDelta)
						{
							foundStreamIndex = i;
							return foundStreamIndex;
						}
						else
						{
							foundStreamIndex = i-1;
							return foundStreamIndex;
						}
					}
					else if(i == vo.kalturaMediaFlavorArray.length-1 && preferedBitrate >= b)
					{
						//if this is the last index and the prefered bitrate is still bigger then the last one
						foundStreamIndex = i;
						return foundStreamIndex;
					}
				}
			}
			
			return foundStreamIndex;	
		}
		
		/**
		 * returns the manifestURL according to current context 
		 * @param seekFrom - optional parameter, passed if the video being loaded is a response to intelligent seeking.
		 * @param storageProfileId - optional parameter
		 * @return a String represantation for the manifest url
		 * 
		 */		
		public function getManifestUrl(seekFrom :uint = 0, storageProfileId : String = null):String {
			//Media Manifest construction
			var entryManifestUrl : String = _flashvars.httpProtocol + _flashvars.host + "/p/" + _flashvars.partnerId + "/sp/" + _flashvars.subpId + "/playManifest/entryId/" + vo.entry.id + ((_flashvars.deliveryCode) ? "/deliveryCode/" + _flashvars.deliveryCode : "") + ((vo.deliveryType == StreamerType.HTTP && vo.selectedFlavorId) ? "/flavorId/" + vo.selectedFlavorId : "") + (seekFrom ? "/seekFrom/" + seekFrom*1000 : "") + "/format/" + (vo.deliveryType != StreamerType.LIVE ? vo.deliveryType : StreamerType.RTMP) + "/protocol/" + (vo.mediaProtocol) + (_flashvars.cdnHost ? "/cdnHost/" + _flashvars.cdnHost : "") + (storageProfileId ? "/storageId/" + storageProfileId : "") + (_client.ks ? "/ks/" + _client.ks : "") + (_flashvars.uiConfId ? "/uiConfId/" + _flashvars.uiConfId : "") + (_flashvars.referrerSig ? "/referrerSig/" + _flashvars.referrerSig : "") + (_flashvars.flavorTags ? "/tags/" + _flashvars.flavorTags : "") + "/a/a.f4m" + "?"+ (_flashvars.b64Referrer ? "referrer=" + _flashvars.b64Referrer : "") ;
			//in case it was configured to add additional parameter to manifest URL
			if (_flashvars.manifestParam && _flashvars.manifestParamValue)
			{
				entryManifestUrl += "&" + _flashvars.manifestParam + "=" + encodeURIComponent(_flashvars.manifestParamValue);
			}
			
			//In case partner has defined a template for the manifest URL
			if (_flashvars.manifestTemplate && _flashvars.manifestTemplate.indexOf("{") != -1)
			{
				var currVar : String = "";
				var replacedTemplate : String =_flashvars.manifestTemplate;
				var ccVarValue : Object = new Object();
				try{
					for (var i : int =0; i < _flashvars.manifestTemplate.length; i++)
					{
						if (_flashvars.manifestTemplate.charAt(i) == "{")
						{
							currVar = currVar.concat(_flashvars.manifestTemplate.charAt(i));
						}
						else if (_flashvars.manifestTemplate.charAt(i) == "}")
						{
							currVar = currVar.concat(_flashvars.manifestTemplate.charAt(i));
							
							ccVarValue = KTextParser.evaluate(facade["bindObject"], currVar );
							replacedTemplate = replacedTemplate.replace( currVar, ccVarValue );
							
							currVar = "";
						}
						else 
						{
							if (currVar != "" )
							{
								currVar = currVar.concat( _flashvars.manifestTemplate.charAt(i) );
							}
						}
					}
					
					entryManifestUrl =  replacedTemplate;
				}
				catch(e : Error)
				{
					
				}
				
			}
			
			return entryManifestUrl;
		}
		
		/**
		 *  
		 * @param bitrate
		 * @return index of the flavor with the closest bitrate to the given bitrate
		 * 
		 */		
		public function getFlavorByBitrate(bitrate:int):int {
			var foundStreamIndex:int = -1;
			var flavorsArr:Array = vo.kalturaMediaFlavorArray;
			if (flavorsArr && flavorsArr.length) {
				for(var i:int = 0; i < flavorsArr.length; i++)
				{
					var b:int = (flavorsArr[i] as KalturaFlavorAsset).bitrate;
					if ( b==bitrate)
						foundStreamIndex = i;
						
					else if (b>bitrate) {
						if (i==0) {
							foundStreamIndex = 0;
						}
						else {
							var oldb:int = (flavorsArr[i-1] as KalturaFlavorAsset).bitrate; 
							if ((bitrate - oldb) > (b - bitrate))
								foundStreamIndex = i;
							else
								foundStreamIndex = i-1;
						}
						break;
					}
					else if (i==flavorsArr.length-1) {
						foundStreamIndex = i;
					}
				}
			}
			
			return foundStreamIndex;
		}
		
		
		/**
		 * Set the starting index and notify KFlavorComboBox on the new index 
		 * @param index
		 * 
		 */		
		public function notifyStartingIndexChanged(index:int):void 
		{
			startingIndex = index;
			//to display correct value in KFlavorComboBox
			sendNotification( NotificationType.SWITCHING_CHANGE_COMPLETE, {newIndex : index, newBitrate: (vo.kalturaMediaFlavorArray[index] as KalturaFlavorAsset).bitrate}  );	
		}
		
		
		/**
		 * This is used when playing HDS content. We will parse the URL we get from the server and play it. 
		 * @param event
		 * 
		 */		
		private function onUrlComplete(event: Event): void
		{
			(event.target as URLLoader).removeEventListener(Event.COMPLETE, onUrlComplete);
			
			var manifest : XML = new XML((event.target as URLLoader).data);
			var children : XMLList = manifest.xmlns::media;
			var _resourceUrl:String = children[0].@url;
			
			createElement(_resourceUrl);
		}
		
		
		
		/**
		 * Function to determine whether the player is in autoPlay mode and should load and play the entry's video element
		 * or hold off.
		 * 
		 */		
		public function configurePlayback () : void
		{	
			var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			
			if (!vo.isMediaDisabled)
			{
				if (vo.isLive)
				{
					if (!vo.isHds)
						prepareMediaElement();
					sendNotification(NotificationType.ENABLE_GUI, {guiEnabled : false , enableType : EnableType.CONTROLS});
					sendNotification(NotificationType.LIVE_ENTRY, vo.resource);
				}
			}
			
			if ((_flashvars.autoPlay == "true" || vo.singleAutoPlay) && !vo.isMediaDisabled && (! sequenceProxy.vo.isInSequence))
			{
				if (vo.singleAutoPlay)
					vo.singleAutoPlay = false;
				sendNotification(NotificationType.DO_PLAY);
			}
			
		}
		
		/**
		 * This function ends the prepareMediaElement flow. Will save resource to mediaVo, create proper media elemenet and dispatch media ready if needed. 
		 * @return 
		 * 
		 */		
		private function saveResourceAndMedia(resource:MediaResourceBase) : void
		{
			vo.resource = resource;
			
			if (shouldCreateSwitchingProxy)
			{
				//wrap the media element created above in a KSwitcingProxy in order to enable midrolls.
				var switchingMediaElement : KSwitchingProxyElement = new KSwitchingProxyElement();
				switchingMediaElement.mainMediaElement = vo.media;
				//set the KSwitcingProxyElement as the vo.media
				vo.media = switchingMediaElement;
				//if its a new media and not a bumper entry
				var sequenceVo:SequenceVO = (facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy).vo;
				if (!sequenceVo.isInSequence)
					sequenceVo.mainMediaVO = null;
				//add event listener for a switch between the main and secondary elements in the KSwitcingProxyElement.
				vo.media.addEventListener(KSwitchingProxyEvent.ELEMENT_SWITCH_PERFORMED, onSwitchPerformed );
				vo.media.addEventListener(KSwitchingProxyEvent.ELEMENT_SWITCH_COMPLETED, onSwitchCompleted );
				vo.media.addEventListener(KSwitchingProxyEvent.ELEMENT_SWITCH_FAILED, onSwitchFailed );
				
				
			}
			
			if (shouldWaitForElement)
				shouldWaitForElement = false;
			
			sendNotification(NotificationType.MEDIA_ELEMENT_READY);
		}
		
	}
	
}