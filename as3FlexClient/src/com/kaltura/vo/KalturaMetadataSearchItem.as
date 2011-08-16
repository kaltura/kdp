package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearchOperator;

	[Bindable]
	public dynamic class KalturaMetadataSearchItem extends KalturaSearchOperator
	{
		public var metadataProfileId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('metadataProfileId');
			return arr;
		}
	}
}
