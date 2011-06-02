package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaBulkUploadPluginData extends BaseFlexVo
	{
		public var field : String;

		public var value : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('field');
			arr.push('value');
			return arr;
		}
	}
}
