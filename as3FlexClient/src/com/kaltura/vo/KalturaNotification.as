package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseJob;

	[Bindable]
	public dynamic class KalturaNotification extends KalturaBaseJob
	{
		public var puserId : String;
		public var type : int = int.MIN_VALUE;
		public var objectId : String;
		public var status : int = int.MIN_VALUE;
		public var notificationData : String;
		public var numberOfAttempts : int = int.MIN_VALUE;
		public var notificationResult : String;
		public var objType : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('puserId');
			propertyList.push('type');
			propertyList.push('objectId');
			propertyList.push('status');
			propertyList.push('notificationData');
			propertyList.push('numberOfAttempts');
			propertyList.push('notificationResult');
			propertyList.push('objType');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('puserId');
			arr.push('type');
			arr.push('objectId');
			arr.push('status');
			arr.push('notificationData');
			arr.push('numberOfAttempts');
			arr.push('notificationResult');
			arr.push('objType');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('puserId');
			arr.push('type');
			arr.push('objectId');
			arr.push('status');
			arr.push('notificationData');
			arr.push('numberOfAttempts');
			arr.push('notificationResult');
			arr.push('objType');
			return arr;
		}

	}
}
