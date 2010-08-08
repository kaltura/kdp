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
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('offlineMessage');
			propertyList.push('streamRemoteId');
			propertyList.push('streamRemoteBackupId');
			propertyList.push('bitrates');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('offlineMessage');
			arr.push('streamRemoteId');
			arr.push('streamRemoteBackupId');
			arr.push('bitrates');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('offlineMessage');
			arr.push('bitrates');
			return arr;
		}

	}
}
