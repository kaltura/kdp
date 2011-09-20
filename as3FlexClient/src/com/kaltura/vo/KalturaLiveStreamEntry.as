package com.kaltura.vo
{
	import com.kaltura.vo.KalturaMediaEntry;

	[Bindable]
	public dynamic class KalturaLiveStreamEntry extends KalturaMediaEntry
	{
		public var offlineMessage : String;

		public var streamRemoteId : String;

		public var streamRemoteBackupId : String;

		public var bitrates : Array = new Array();

		public var primaryBroadcastingUrl : String;

		public var secondaryBroadcastingUrl : String;

		public var streamName : String;

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
	}
}
