package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntry;

	[Bindable]
	public dynamic class KalturaPlaylist extends KalturaBaseEntry
	{
		/** 
		* Content of the playlist - 
XML if the playlistType is dynamic 
text if the playlistType is static 
url if the playlistType is mRss 		* */ 
		public var playlistContent : String = null;

		/** 
		* 		* */ 
		public var filters : Array = new Array();

		/** 
		* 		* */ 
		public var totalResults : int = int.MIN_VALUE;

		/** 
		* Type of playlist  		* */ 
		public var playlistType : int = int.MIN_VALUE;

		/** 
		* Number of plays		* */ 
		public var plays : int = int.MIN_VALUE;

		/** 
		* Number of views		* */ 
		public var views : int = int.MIN_VALUE;

		/** 
		* The duration in seconds		* */ 
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

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
