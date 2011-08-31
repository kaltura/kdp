package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearchOperator;

	[Bindable]
	public dynamic class KalturaMetadataSearchItem extends KalturaSearchOperator
	{
		/** 
		* 		* */ 
		public var metadataProfileId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var orderBy : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('metadataProfileId');
			arr.push('orderBy');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
