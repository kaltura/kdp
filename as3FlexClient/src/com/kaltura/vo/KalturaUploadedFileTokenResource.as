package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDataCenterContentResource;

	[Bindable]
	public dynamic class KalturaUploadedFileTokenResource extends KalturaDataCenterContentResource
	{
		/** 
		* Token that returned from upload.upload action or uploadToken.add action. 		* */ 
		public var token : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('token');
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
