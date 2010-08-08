package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaPartnerUsage extends BaseFlexVo
	{
		public var hostingGB : Number = NaN;
		public var Percent : Number = NaN;
		public var packageBW : int = int.MIN_VALUE;
		public var usageGB : int = int.MIN_VALUE;
		public var reachedLimitDate : int = int.MIN_VALUE;
		public var usageGraph : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('hostingGB');
			propertyList.push('Percent');
			propertyList.push('packageBW');
			propertyList.push('usageGB');
			propertyList.push('reachedLimitDate');
			propertyList.push('usageGraph');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('hostingGB');
			arr.push('Percent');
			arr.push('packageBW');
			arr.push('usageGB');
			arr.push('reachedLimitDate');
			arr.push('usageGraph');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
