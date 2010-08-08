package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearch;

	[Bindable]
	public dynamic class KalturaSearchResult extends KalturaSearch
	{
		public var id : String;
		public var title : String;
		public var thumbUrl : String;
		public var description : String;
		public var tags : String;
		public var url : String;
		public var sourceLink : String;
		public var credit : String;
		public var licenseType : int = int.MIN_VALUE;
		public var flashPlaybackType : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('title');
			propertyList.push('thumbUrl');
			propertyList.push('description');
			propertyList.push('tags');
			propertyList.push('url');
			propertyList.push('sourceLink');
			propertyList.push('credit');
			propertyList.push('licenseType');
			propertyList.push('flashPlaybackType');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('id');
			arr.push('title');
			arr.push('thumbUrl');
			arr.push('description');
			arr.push('tags');
			arr.push('url');
			arr.push('sourceLink');
			arr.push('credit');
			arr.push('licenseType');
			arr.push('flashPlaybackType');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('id');
			arr.push('title');
			arr.push('thumbUrl');
			arr.push('description');
			arr.push('tags');
			arr.push('url');
			arr.push('sourceLink');
			arr.push('credit');
			arr.push('licenseType');
			arr.push('flashPlaybackType');
			return arr;
		}

	}
}
