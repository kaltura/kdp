package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaEntryDistributionBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var idEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var idIn : String = null;

		/** 
		* 		* */ 
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var submittedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var submittedAtLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var entryIdEqual : String = null;

		/** 
		* 		* */ 
		public var entryIdIn : String = null;

		/** 
		* 		* */ 
		public var distributionProfileIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var distributionProfileIdIn : String = null;

		/** 
		* 		* */ 
		public var statusEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var statusIn : String = null;

		/** 
		* 		* */ 
		public var dirtyStatusEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var dirtyStatusIn : String = null;

		/** 
		* 		* */ 
		public var sunriseGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var sunriseLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var sunsetGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var sunsetLessThanOrEqual : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('submittedAtGreaterThanOrEqual');
			arr.push('submittedAtLessThanOrEqual');
			arr.push('entryIdEqual');
			arr.push('entryIdIn');
			arr.push('distributionProfileIdEqual');
			arr.push('distributionProfileIdIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('dirtyStatusEqual');
			arr.push('dirtyStatusIn');
			arr.push('sunriseGreaterThanOrEqual');
			arr.push('sunriseLessThanOrEqual');
			arr.push('sunsetGreaterThanOrEqual');
			arr.push('sunsetLessThanOrEqual');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
