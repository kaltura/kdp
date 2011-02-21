package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConvartableJobData;

	[Bindable]
	public dynamic class KalturaRemoteConvertJobData extends KalturaConvartableJobData
	{
		public var srcFileUrl : String;

		public var destFileUrl : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('srcFileUrl');
			arr.push('destFileUrl');
			return arr;
		}
	}
}
