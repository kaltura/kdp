package com.kaltura.kdpfl.plugin.model
{
	import org.osmf.vast.model.VASTNonLinearAd;
	import org.osmf.vast.parser.base.VAST2NonLinearElement;

	public class UniformVastNonLinearAd
	{
		
		public var id : String;
		public var width : Number;
		public var height : Number;
		public var expandedWidth : Number;
		public var expandedHeight : Number;
		public var code : String;
		public var scalable : Boolean;
		public var maintainAspectRatio : Boolean;
		public var apiFramework : String;
		public var creativeType : String;
		public var staticResource : String;
		public var htmlResource : String;
		public var iFrameResource : String;
		public var nonLinearClickThrough : String; //URL of the clickthrough  where to navigate if the ad is pressed
		public var nonLinearResource : String; //URL of the resource of the banner ad.
		public var adParameters : Object;
		public var impressions: Array;
		
		public var trackingEvents : Object = new Object(); //Tracking Events for the nonlinear ad.
		
		public function UniformVastNonLinearAd(vastNonLinearAd : Object, vastVersion : Number)
		{
			if (vastVersion == 1)
			{
				var vast1Ad : VASTNonLinearAd = vastNonLinearAd as VASTNonLinearAd;
				id = vast1Ad.id;
				width = vast1Ad.width;
				height = vast1Ad.height;
				expandedWidth = vast1Ad.expandedWidth;
				expandedHeight = vast1Ad.expandedHeight;
				code = vast1Ad.code;
				scalable = vast1Ad.scalable;
				maintainAspectRatio = vast1Ad.maintainAspectRatio;
				apiFramework = vast1Ad.apiFramework;
				creativeType = vast1Ad.creativeType;
				staticResource = vast1Ad.resourceType.resourceType;
				nonLinearClickThrough = vast1Ad.clickThroughURL;
				nonLinearResource = vast1Ad.url;
				adParameters = vast1Ad.adParameters;
			}
			
			else if (vastVersion == 2)
			{
				var vast2Ad : VAST2NonLinearElement = vastNonLinearAd as VAST2NonLinearElement;
				id = vast2Ad.id;
				width = vast2Ad.width;
				height = vast2Ad.height;
				expandedWidth = vast2Ad.expandedWidth;
				expandedHeight = vast2Ad.expandedHeight;
				scalable = vast2Ad.scalable;
				maintainAspectRatio = vast2Ad.maintainAspectRatio;
				apiFramework = vast2Ad.apiFramework;
				creativeType = vast2Ad.creativeType;
				staticResource = vast2Ad.resourceType;;
				nonLinearClickThrough = vast2Ad.nonLinearClickThrough;
				nonLinearResource = vast2Ad.URL;
				adParameters = vast2Ad.adParameters;
				htmlResource = vast2Ad.htmlResource;
				iFrameResource= vast2Ad.iframeResource;
			}
		}
	}
}