package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	import com.kaltura.vo.KalturaResource;

	[Bindable]
	public dynamic class KalturaAssetParamsResourceContainer extends KalturaResource
	{
		public var resource : KalturaContentResource;

		public var assetParamsId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('resource');
			arr.push('assetParamsId');
			return arr;
		}
	}
}
