package com.kaltura.kdpfl.plugin.model
{
	import com.kaltura.kdpfl.plugin.model.type.VASTAdResourceType;
	
	import org.osmf.vast.model.VASTCompanionAd;
	import org.osmf.vast.parser.base.VAST2CompanionElement;

	public class UniformCompanionAd
	{
		public var id : String;
		public var width : Number;
		public var height : Number;
		public var expandedWidth : Number;
		public var expandedHeight : Number;
		public var code : String;
		public var companionClickThrough : String;
		public var companionResource : String;
		public var creativeType : String;
		public var altText : String;
		public var adParameters : String;
		public var apiFramework : String;
		public var iframeResource : String;
		public var staticResource : String;
		public var htmlResource : String;
		public var resourceType : String;
		public var creativeViewTrack : String;
		
		public var trackingEvents : Object;
		
		public function UniformCompanionAd(vastCompanionAd : Object, vastVersion : int)
		{
			if (vastVersion == 2)
			{
				var vast2Companion : VAST2CompanionElement = vastCompanionAd as VAST2CompanionElement;
				id = vast2Companion.id;
				width = vast2Companion.width;
				height = vast2Companion.height;
				expandedHeight = vast2Companion.expandedHeight;
				expandedWidth = vast2Companion.expandedWidth;
				companionClickThrough = vast2Companion.companionClickThrough;
				companionResource = vast2Companion.URL;
				creativeType = vast2Companion.creativeType;
				altText = vast2Companion.AltText;
				adParameters = vast2Companion.adParameters;
				apiFramework = vast2Companion.apiFramework;
				iframeResource = vast2Companion.iframeResource;
				resourceType = vast2Companion.resourceType;
				staticResource = vast2Companion.staticResource;
				htmlResource = vast2Companion.htmlResource;
				creativeViewTrack = vast2Companion.creativeViewTrack;
			}
			else if (vastVersion == 1)
			{
				var vast1CompanionAd : VASTCompanionAd = vastCompanionAd as VASTCompanionAd;
				id = vast1CompanionAd.id;
				width = vast1CompanionAd.width;
				height = vast1CompanionAd.height;
				expandedHeight = vast1CompanionAd.expandedHeight;
				expandedWidth = vast1CompanionAd.expandedWidth;
				companionClickThrough = vast1CompanionAd.clickThroughURL;
				companionResource = vast1CompanionAd.url;
				creativeType = vast1CompanionAd.creativeType;
				altText = vast1CompanionAd.altText;
				adParameters = vast1CompanionAd.adParameters;
				apiFramework = vast1CompanionAd.adParameters;
				//resourceType = vast1CompanionAd.resourceType;
				code= vast1CompanionAd.code;
				switch (resourceType)
				{
					case VASTAdResourceType.HTML:
						htmlResource = code;
						break;
					case VASTAdResourceType.STATIC:
						staticResource = code;
						break;
					case VASTAdResourceType.IFRAME:
						iframeResource = code;
						break;
				}
			}
		}
		
	}
}