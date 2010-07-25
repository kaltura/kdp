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
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('mediaType');
			propertyList.push('conversionQuality');
			propertyList.push('sourceType');
			propertyList.push('searchProviderType');
			propertyList.push('searchProviderId');
			propertyList.push('creditUserName');
			propertyList.push('creditUrl');
			propertyList.push('mediaDate');
			propertyList.push('dataUrl');
			propertyList.push('flavorParamsIds');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('mediaType');
			arr.push('conversionQuality');
			arr.push('sourceType');
			arr.push('searchProviderType');
			arr.push('searchProviderId');
			arr.push('creditUserName');
			arr.push('creditUrl');
			arr.push('mediaDate');
			arr.push('dataUrl');
			arr.push('flavorParamsIds');
			return arr;
		}

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
