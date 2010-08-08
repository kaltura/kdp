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
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('streamID');
			propertyList.push('backupStreamID');
			propertyList.push('rtmp');
			propertyList.push('encoderIP');
			propertyList.push('backupEncoderIP');
			propertyList.push('encoderPassword');
			propertyList.push('encoderUsername');
			propertyList.push('endDate');
			propertyList.push('returnVal');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('streamID');
			arr.push('backupStreamID');
			arr.push('rtmp');
			arr.push('encoderIP');
			arr.push('backupEncoderIP');
			arr.push('encoderPassword');
			arr.push('encoderUsername');
			arr.push('endDate');
			arr.push('returnVal');
			return arr;
		}

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
			return arr;
		}

	}
}
