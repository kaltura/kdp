package com.kaltura.vo
{
	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaProvisionJobData extends KalturaJobData
	{
		public var streamID : String;

		public var backupStreamID : String;

		public var rtmp : String;

		public var encoderIP : String;

		public var backupEncoderIP : String;

		public var encoderPassword : String;

		public var encoderUsername : String;

		public var endDate : int = int.MIN_VALUE;

		public var returnVal : String;

		public var mediaType : int = int.MIN_VALUE;

		public var primaryBroadcastingUrl : String;

		public var secondaryBroadcastingUrl : String;

		public var streamName : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('streamID');
			arr.push('backupStreamID');
			arr.push('rtmp');
			arr.push('encoderIP');
			arr.push('backupEncoderIP');
			arr.push('encoderPassword');
			arr.push('encoderUsername');
			arr.push('endDate');
			arr.push('returnVal');
			arr.push('mediaType');
			arr.push('primaryBroadcastingUrl');
			arr.push('secondaryBroadcastingUrl');
			arr.push('streamName');
			return arr;
		}
	}
}
