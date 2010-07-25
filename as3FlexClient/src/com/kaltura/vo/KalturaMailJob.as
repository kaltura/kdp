package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseJob;

	[Bindable]
	public dynamic class KalturaMailJob extends KalturaBaseJob
	{
		public var mailType : int = int.MIN_VALUE;
		public var mailPriority : int = int.MIN_VALUE;
		public var status : int = int.MIN_VALUE;
		public var recipientName : String;
		public var recipientEmail : String;
		public var recipientId : int = int.MIN_VALUE;
		public var fromName : String;
		public var fromEmail : String;
		public var bodyParams : String;
		public var subjectParams : String;
		public var templatePath : String;
		public var culture : int = int.MIN_VALUE;
		public var campaignId : int = int.MIN_VALUE;
		public var minSendDate : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('mailType');
			propertyList.push('mailPriority');
			propertyList.push('status');
			propertyList.push('recipientName');
			propertyList.push('recipientEmail');
			propertyList.push('recipientId');
			propertyList.push('fromName');
			propertyList.push('fromEmail');
			propertyList.push('bodyParams');
			propertyList.push('subjectParams');
			propertyList.push('templatePath');
			propertyList.push('culture');
			propertyList.push('campaignId');
			propertyList.push('minSendDate');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('mailType');
			arr.push('mailPriority');
			arr.push('status');
			arr.push('recipientName');
			arr.push('recipientEmail');
			arr.push('recipientId');
			arr.push('fromName');
			arr.push('fromEmail');
			arr.push('bodyParams');
			arr.push('subjectParams');
			arr.push('templatePath');
			arr.push('culture');
			arr.push('campaignId');
			arr.push('minSendDate');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('mailType');
			arr.push('mailPriority');
			arr.push('status');
			arr.push('recipientName');
			arr.push('recipientEmail');
			arr.push('recipientId');
			arr.push('fromName');
			arr.push('fromEmail');
			arr.push('bodyParams');
			arr.push('subjectParams');
			arr.push('templatePath');
			arr.push('culture');
			arr.push('campaignId');
			arr.push('minSendDate');
			return arr;
		}

	}
}
