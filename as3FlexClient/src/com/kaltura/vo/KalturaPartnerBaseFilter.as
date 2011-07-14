package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaPartnerBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var idEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var idIn : String;

		/** 
		* 		* */ 
		public var nameLike : String;

		/** 
		* 		* */ 
		public var nameMultiLikeOr : String;

		/** 
		* 		* */ 
		public var nameMultiLikeAnd : String;

		/** 
		* 		* */ 
		public var nameEqual : String;

		/** 
		* 		* */ 
		public var statusEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var statusIn : String;

		/** 
		* 		* */ 
		public var partnerPackageEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerPackageGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerPackageLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerNameDescriptionWebsiteAdminNameAdminEmailLike : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('nameLike');
			arr.push('nameMultiLikeOr');
			arr.push('nameMultiLikeAnd');
			arr.push('nameEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('partnerPackageEqual');
			arr.push('partnerPackageGreaterThanOrEqual');
			arr.push('partnerPackageLessThanOrEqual');
			arr.push('partnerNameDescriptionWebsiteAdminNameAdminEmailLike');
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
