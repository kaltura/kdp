package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaDistributionValidationError extends BaseFlexVo
	{
		public var action : int = int.MIN_VALUE;

		public var errorType : int = int.MIN_VALUE;

		public var description : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('action');
			arr.push('errorType');
			arr.push('description');
			return arr;
		}
	}
}
