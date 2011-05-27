package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaStatsKmcEvent extends BaseFlexVo
	{
		public var clientVer : String;

		public var kmcEventActionPath : String;

		public var kmcEventType : int = int.MIN_VALUE;

		public var eventTimestamp : Number = NaN;

		public var sessionId : String;

		public var partnerId : int = int.MIN_VALUE;

		public var entryId : String;

		public var widgetId : String;

		public var uiconfId : int = int.MIN_VALUE;

		public var userId : String;

		public var userIp : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('clientVer');
			arr.push('kmcEventActionPath');
			arr.push('kmcEventType');
			arr.push('eventTimestamp');
			arr.push('sessionId');
			arr.push('partnerId');
			arr.push('entryId');
			arr.push('widgetId');
			arr.push('uiconfId');
			arr.push('userId');
			return arr;
		}
	}
}
