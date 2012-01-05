package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDataCenterContentResource;

	[Bindable]
	public dynamic class KalturaDropFolderFileResource extends KalturaDataCenterContentResource
	{
		/** 
		* Id of the drop folder file object		* */ 
		public var dropFolderFileId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('dropFolderFileId');
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
