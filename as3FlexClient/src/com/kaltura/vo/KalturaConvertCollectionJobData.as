package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConvartableJobData;

	[Bindable]
	public dynamic class KalturaConvertCollectionJobData extends KalturaConvartableJobData
	{
		public var destDirLocalPath : String;
		public var destDirRemoteUrl : String;
		public var destFileName : String;
		public var inputXmlLocalPath : String;
		public var inputXmlRemoteUrl : String;
		public var commandLinesStr : String;
		public var flavors : Array = new Array();
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('destDirLocalPath');
			propertyList.push('destDirRemoteUrl');
			propertyList.push('destFileName');
			propertyList.push('inputXmlLocalPath');
			propertyList.push('inputXmlRemoteUrl');
			propertyList.push('commandLinesStr');
			propertyList.push('flavors');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('destDirLocalPath');
			arr.push('destDirRemoteUrl');
			arr.push('destFileName');
			arr.push('inputXmlLocalPath');
			arr.push('inputXmlRemoteUrl');
			arr.push('commandLinesStr');
			arr.push('flavors');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('destDirLocalPath');
			arr.push('destDirRemoteUrl');
			arr.push('destFileName');
			arr.push('inputXmlLocalPath');
			arr.push('inputXmlRemoteUrl');
			arr.push('commandLinesStr');
			arr.push('flavors');
			return arr;
		}

	}
}
