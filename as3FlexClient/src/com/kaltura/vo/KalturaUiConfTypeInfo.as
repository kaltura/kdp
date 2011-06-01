package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaUiConfTypeInfo extends BaseFlexVo
	{
		public var type : int = int.MIN_VALUE;

		public var versions : Array = new Array();

		public var directory : String;

		public var filename : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('type');
			arr.push('versions');
			arr.push('directory');
			arr.push('filename');
			return arr;
		}
	}
}
