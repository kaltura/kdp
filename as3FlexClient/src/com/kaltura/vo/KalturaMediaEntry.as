package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPlayableEntry;

	[Bindable]
	public dynamic class KalturaMediaEntry extends KalturaPlayableEntry
	{
		public var mediaType : int = int.MIN_VALUE;

		public var conversionQuality : String;

		public var sourceType : int = int.MIN_VALUE;

		public var searchProviderType : int = int.MIN_VALUE;

		public var searchProviderId : String;

		public var creditUserName : String;

		public var creditUrl : String;

		public var mediaDate : int = int.MIN_VALUE;

		public var dataUrl : String;

		public var flavorParamsIds : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('creditUserName');
			arr.push('creditUrl');
			return arr;
		}
	}
}
