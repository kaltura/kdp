package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaStatsEvent extends BaseFlexVo
	{
		public var clientVer : String;
		public var eventType : int = int.MIN_VALUE;
		public var eventTimestamp : Number = NaN;
		public var sessionId : String;
		public var partnerId : int = int.MIN_VALUE;
		public var entryId : String;
		public var uniqueViewer : String;
		public var widgetId : String;
		public var uiconfId : int = int.MIN_VALUE;
		public var userId : String;
		public var currentPoint : int = int.MIN_VALUE;
		public var duration : int = int.MIN_VALUE;
		public var userIp : String;
		public var processDuration : int = int.MIN_VALUE;
		public var controlId : String;
		public var seek : Boolean;
		public var newPoint : int = int.MIN_VALUE;
		public var referrer : String;
		public var isFirstInSession : Boolean;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('clientVer');
			propertyList.push('eventType');
			propertyList.push('eventTimestamp');
			propertyList.push('sessionId');
			propertyList.push('partnerId');
			propertyList.push('entryId');
			propertyList.push('uniqueViewer');
			propertyList.push('widgetId');
			propertyList.push('uiconfId');
			propertyList.push('userId');
			propertyList.push('currentPoint');
			propertyList.push('duration');
			propertyList.push('userIp');
			propertyList.push('processDuration');
			propertyList.push('controlId');
			propertyList.push('seek');
			propertyList.push('newPoint');
			propertyList.push('referrer');
			propertyList.push('isFirstInSession');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('clientVer');
			arr.push('eventType');
			arr.push('eventTimestamp');
			arr.push('sessionId');
			arr.push('partnerId');
			arr.push('entryId');
			arr.push('uniqueViewer');
			arr.push('widgetId');
			arr.push('uiconfId');
			arr.push('userId');
			arr.push('currentPoint');
			arr.push('duration');
			arr.push('userIp');
			arr.push('processDuration');
			arr.push('controlId');
			arr.push('seek');
			arr.push('newPoint');
			arr.push('referrer');
			arr.push('isFirstInSession');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('clientVer');
			arr.push('eventType');
			arr.push('eventTimestamp');
			arr.push('sessionId');
			arr.push('partnerId');
			arr.push('entryId');
			arr.push('uniqueViewer');
			arr.push('widgetId');
			arr.push('uiconfId');
			arr.push('userId');
			arr.push('currentPoint');
			arr.push('duration');
			arr.push('processDuration');
			arr.push('controlId');
			arr.push('seek');
			arr.push('newPoint');
			arr.push('referrer');
			arr.push('isFirstInSession');
			return arr;
		}

	}
}
