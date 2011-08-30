package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaLocalFileResource extends KalturaContentResource
	{
		public var localFilePath : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('localFilePath');
			return arr;
		}
	}
}
