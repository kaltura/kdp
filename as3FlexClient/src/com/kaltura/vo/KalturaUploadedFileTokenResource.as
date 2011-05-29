package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaUploadedFileTokenResource extends KalturaContentResource
	{
		public var token : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('token');
			return arr;
		}
	}
}
