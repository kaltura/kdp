package org.osmf.vast.media
{
	import flash.geom.Rectangle;
	
	import org.osmf.elements.ProxyElement;
	import org.osmf.elements.SWFLoader;
	import org.osmf.elements.VideoElement;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.Metadata;
	import org.osmf.vast.model.VAST2MediaFile;
	import org.osmf.vast.model.VAST2Translator;
	import org.osmf.vast.model.VAST3Translator;
	import org.osmf.vast.model.VASTDataObject;
	import org.osmf.vast.model.VASTTrackingEvent;
	import org.osmf.vast.model.VASTTrackingEventType;
	import org.osmf.vast.model.VASTUrl;
	import org.osmf.vast.parser.base.VAST2CompanionElement;
	import org.osmf.vpaid.elements.VPAIDElement;
	import org.osmf.vpaid.metadata.VPAIDMetadata;
	
	public class VAST3MediaGenerator
	{
		private var _vast2MediaGen:VAST2MediaGenerator;
		
		public function VAST3MediaGenerator(mediaFileResolver:IVAST2MediaFileResolver=null, mediaFactory:MediaFactory=null)
		{
			_vast2MediaGen = new VAST2MediaGenerator(mediaFileResolver, mediaFactory);
		}
		
		/**
		 * Creates all relevant MediaElements from the specified VAST document.
		 * 
		 * @param vastDocument The VASTDocument that holds the raw VAST information.
		 * 
		 * @returns A Vector of MediaElements, where each MediaElement
		 * represents a different VASTAd within the VASTDocument. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function createMediaElements(vast3Document:VAST3Translator, vastPlacement:String = null,playerSize:Rectangle = null):Vector.<MediaElement>
		{
			var mediaElements:Vector.<MediaElement> = new Vector.<MediaElement>();
			var cacheBuster:CacheBuster = new CacheBuster();
			
		//	this.vastDocument = vastDocument;
		//	vastDocument.adPlacement = (vastPlacement == null)?vastDocument.PLACEMENT_LINEAR:vastPlacement;
			if (!vast3Document.vastObjects)
				return mediaElements;
			
			for each (var vastDocument:VAST2Translator in vast3Document.vastObjects)
			{
				mediaElements = mediaElements.concat(_vast2MediaGen.createMediaElements(vastDocument, vastPlacement, playerSize));	
			}
				
			return mediaElements;
		}
	}
}