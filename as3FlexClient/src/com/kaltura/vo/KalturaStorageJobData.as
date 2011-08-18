package com.kaltura.vo
{
	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaStorageJobData extends KalturaJobData
	{
		public var serverUrl : String;

		public var serverUsername : String;

		public var serverPassword : String;

		public var ftpPassiveMode : Boolean;

		public var srcFileSyncLocalPath : String;

		public var srcFileSyncId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('serverUrl');
			arr.push('serverUsername');
			arr.push('serverPassword');
			arr.push('ftpPassiveMode');
			arr.push('srcFileSyncLocalPath');
			arr.push('srcFileSyncId');
			return arr;
		}
	}
}
