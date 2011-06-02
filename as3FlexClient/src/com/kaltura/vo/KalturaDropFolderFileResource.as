package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaDropFolderFileResource extends KalturaContentResource
	{
		public var dropFolderFileId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('dropFolderFileId');
			return arr;
		}
	}
}
