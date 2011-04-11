package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUrlResource;

	[Bindable]
	public dynamic class KalturaRemoteStorageResource extends KalturaUrlResource
	{
		public var storageProfileId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('storageProfileId');
			return arr;
		}
	}
}
