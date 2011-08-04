package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPlayableEntry;

	[Bindable]
	public dynamic class KalturaMediaEntry extends KalturaPlayableEntry
	{
		/** 
		* The media type of the entry
		* */ 
		public var mediaType : int = int.MIN_VALUE;

		/** 
		* Override the default conversion quality
DEPRECATED - use conversionProfileId instead		* */ 
		public var conversionQuality : String;

		/** 
		* The source type of the entry 		* */ 
		public var sourceType : int = int.MIN_VALUE;

		/** 
		* The search provider type used to import this entry		* */ 
		public var searchProviderType : int = int.MIN_VALUE;

		/** 
		* The ID of the media in the importing site		* */ 
		public var searchProviderId : String;

		/** 
		* The user name used for credits		* */ 
		public var creditUserName : String;

		/** 
		* The URL for credits		* */ 
		public var creditUrl : String;

		/** 
		* The media date extracted from EXIF data (For images) as Unix timestamp (In seconds)		* */ 
		public var mediaDate : int = int.MIN_VALUE;

		/** 
		* The URL used for playback. This is not the download URL.		* */ 
		public var dataUrl : String;

		/** 
		* Comma separated flavor params ids that exists for this media entry
		* */ 
		public var flavorParamsIds : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('creditUserName');
			arr.push('creditUrl');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('mediaType');
			arr.push('conversionQuality');
			arr.push('sourceType');
			arr.push('searchProviderType');
			arr.push('searchProviderId');
			return arr;
		}

	}
}
