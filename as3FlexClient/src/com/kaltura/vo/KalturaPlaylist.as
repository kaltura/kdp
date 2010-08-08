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
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('playlistContent');
			propertyList.push('filters');
			propertyList.push('totalResults');
			propertyList.push('playlistType');
			propertyList.push('plays');
			propertyList.push('views');
			propertyList.push('duration');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('playlistContent');
			arr.push('filters');
			arr.push('totalResults');
			arr.push('playlistType');
			arr.push('plays');
			arr.push('views');
			arr.push('duration');
			return arr;
		}

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
