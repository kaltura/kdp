package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntry;

	[Bindable]
	public dynamic class KalturaPlaylist extends KalturaBaseEntry
	{
		public var playlistContent : String;

		public var filters : Array = new Array();

		public var totalResults : int = int.MIN_VALUE;

		public var playlistType : int = int.MIN_VALUE;

		public var plays : int = int.MIN_VALUE;

		public var views : int = int.MIN_VALUE;

		public var duration : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('playlistContent');
			arr.push('filters');
			arr.push('totalResults');
			arr.push('playlistType');
			return arr;
		}
	}
}
