package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaFlavorAsset extends BaseFlexVo
	{
		public var id : String;
		public var entryId : String;
		public var partnerId : int = int.MIN_VALUE;
		public var status : int = int.MIN_VALUE;
		public var flavorParamsId : int = int.MIN_VALUE;
		public var version : int = int.MIN_VALUE;
		public var width : int = int.MIN_VALUE;
		public var height : int = int.MIN_VALUE;
		public var bitrate : int = int.MIN_VALUE;
		public var frameRate : int = int.MIN_VALUE;
		public var size : int = int.MIN_VALUE;
		public var isOriginal : Boolean;
		public var tags : String;
		public var isWeb : Boolean;
		public var fileExt : String;
		public var containerFormat : String;
		public var videoCodecId : String;
		public var createdAt : int = int.MIN_VALUE;
		public var updatedAt : int = int.MIN_VALUE;
		public var deletedAt : int = int.MIN_VALUE;
		public var description : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('entryId');
			propertyList.push('partnerId');
			propertyList.push('status');
			propertyList.push('flavorParamsId');
			propertyList.push('version');
			propertyList.push('width');
			propertyList.push('height');
			propertyList.push('bitrate');
			propertyList.push('frameRate');
			propertyList.push('size');
			propertyList.push('isOriginal');
			propertyList.push('tags');
			propertyList.push('isWeb');
			propertyList.push('fileExt');
			propertyList.push('containerFormat');
			propertyList.push('videoCodecId');
			propertyList.push('createdAt');
			propertyList.push('updatedAt');
			propertyList.push('deletedAt');
			propertyList.push('description');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('entryId');
			arr.push('partnerId');
			arr.push('status');
			arr.push('flavorParamsId');
			arr.push('version');
			arr.push('width');
			arr.push('height');
			arr.push('bitrate');
			arr.push('frameRate');
			arr.push('size');
			arr.push('isOriginal');
			arr.push('tags');
			arr.push('isWeb');
			arr.push('fileExt');
			arr.push('containerFormat');
			arr.push('videoCodecId');
			arr.push('createdAt');
			arr.push('updatedAt');
			arr.push('deletedAt');
			arr.push('description');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('isOriginal');
			arr.push('tags');
			arr.push('isWeb');
			arr.push('fileExt');
			arr.push('containerFormat');
			arr.push('videoCodecId');
			arr.push('createdAt');
			arr.push('updatedAt');
			arr.push('deletedAt');
			arr.push('description');
			return arr;
		}

	}
}
