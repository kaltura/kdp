package com.kaltura.vo
{
	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaNotificationJobData extends KalturaJobData
	{
		public var userId : String;
		public var type : int = int.MIN_VALUE;
		public var typeAsString : String;
		public var objectId : String;
		public var status : int = int.MIN_VALUE;
		public var data : String;
		public var numberOfAttempts : int = int.MIN_VALUE;
		public var notificationResult : String;
		public var objType : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('userId');
			propertyList.push('type');
			propertyList.push('typeAsString');
			propertyList.push('objectId');
			propertyList.push('status');
			propertyList.push('data');
			propertyList.push('numberOfAttempts');
			propertyList.push('notificationResult');
			propertyList.push('objType');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('userId');
			arr.push('type');
			arr.push('typeAsString');
			arr.push('objectId');
			arr.push('status');
			arr.push('data');
			arr.push('numberOfAttempts');
			arr.push('notificationResult');
			arr.push('objType');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('userId');
			arr.push('type');
			arr.push('typeAsString');
			arr.push('objectId');
			arr.push('status');
			arr.push('data');
			arr.push('numberOfAttempts');
			arr.push('notificationResult');
			arr.push('objType');
			return arr;
		}

	}
}
