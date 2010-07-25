package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaControlPanelCommandFilter extends KalturaFilter
	{
		public var idEqual : int = int.MIN_VALUE;
		public var idIn : String;
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;
		public var createdByIdEqual : int = int.MIN_VALUE;
		public var typeEqual : int = int.MIN_VALUE;
		public var typeIn : String;
		public var targetTypeEqual : int = int.MIN_VALUE;
		public var targetTypeIn : String;
		public var statusEqual : int = int.MIN_VALUE;
		public var statusIn : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('idEqual');
			propertyList.push('idIn');
			propertyList.push('createdAtGreaterThanOrEqual');
			propertyList.push('createdAtLessThanOrEqual');
			propertyList.push('createdByIdEqual');
			propertyList.push('typeEqual');
			propertyList.push('typeIn');
			propertyList.push('targetTypeEqual');
			propertyList.push('targetTypeIn');
			propertyList.push('statusEqual');
			propertyList.push('statusIn');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('createdByIdEqual');
			arr.push('typeEqual');
			arr.push('typeIn');
			arr.push('targetTypeEqual');
			arr.push('targetTypeIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('createdByIdEqual');
			arr.push('typeEqual');
			arr.push('typeIn');
			arr.push('targetTypeEqual');
			arr.push('targetTypeIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			return arr;
		}

	}
}
