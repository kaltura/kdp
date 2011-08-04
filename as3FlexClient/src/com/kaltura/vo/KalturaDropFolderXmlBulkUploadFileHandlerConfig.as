package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDropFolderFileHandlerConfig;

	[Bindable]
	public dynamic class KalturaDropFolderXmlBulkUploadFileHandlerConfig extends KalturaDropFolderFileHandlerConfig
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
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
