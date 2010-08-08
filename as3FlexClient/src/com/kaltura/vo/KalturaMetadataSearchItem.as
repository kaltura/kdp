package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearchOperator;

	[Bindable]
	public dynamic class KalturaMetadataSearchItem extends KalturaSearchOperator
	{
		public var metadataProfileId : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('metadataProfileId');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('metadataProfileId');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('metadataProfileId');
			return arr;
		}

	}
}
