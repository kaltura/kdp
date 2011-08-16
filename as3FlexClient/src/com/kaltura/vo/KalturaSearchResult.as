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
