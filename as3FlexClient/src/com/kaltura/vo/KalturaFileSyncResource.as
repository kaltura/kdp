package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaFileSyncResource extends KalturaContentResource
	{
		public var fileSyncObjectType : int = int.MIN_VALUE;

		public var objectSubType : int = int.MIN_VALUE;

		public var objectId : int = int.MIN_VALUE;

		public var version : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('fileSyncObjectType');
			arr.push('objectSubType');
			arr.push('objectId');
			arr.push('version');
			return arr;
		}
	}
}
