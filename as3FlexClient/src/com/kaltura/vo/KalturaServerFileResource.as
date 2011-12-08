package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDataCenterContentResource;

	[Bindable]
	public dynamic class KalturaServerFileResource extends KalturaDataCenterContentResource
	{
		/** 
		* Full path to the local file 		* */ 
		public var localFilePath : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('localFilePath');
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
