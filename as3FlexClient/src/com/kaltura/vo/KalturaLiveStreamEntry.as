package com.kaltura.vo
{
	import com.kaltura.vo.KalturaMediaEntry;

	[Bindable]
	public dynamic class KalturaLiveStreamEntry extends KalturaMediaEntry
	{
		/** 
		* The message to be presented when the stream is offline
		* */ 
		public var offlineMessage : String = null;

		/** 
		* The stream id as provided by the provider
		* */ 
		public var streamRemoteId : String = null;

		/** 
		* The backup stream id as provided by the provider
		* */ 
		public var streamRemoteBackupId : String = null;

		/** 
		* Array of supported bitrates
		* */ 
		public var bitrates : Array = new Array();

		/** 
		* 		* */ 
		public var primaryBroadcastingUrl : String = null;

		/** 
		* 		* */ 
		public var secondaryBroadcastingUrl : String = null;

		/** 
		* 		* */ 
		public var streamName : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('offlineMessage');
			arr.push('bitrates');
			arr.push('primaryBroadcastingUrl');
			arr.push('secondaryBroadcastingUrl');
			arr.push('streamName');
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
