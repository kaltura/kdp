package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaEntryResource extends KalturaContentResource
	{
		public var entryId : String;

		public var flavorParamsId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('entryId');
			arr.push('flavorParamsId');
			return arr;
		}
	}
}
