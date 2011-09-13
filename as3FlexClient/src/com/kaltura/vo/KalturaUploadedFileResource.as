package com.kaltura.vo
{
	import com.kaltura.vo.file;

	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaUploadedFileResource extends KalturaContentResource
	{
		public var fileData : file;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('fileData');
			return arr;
		}
	}
}
