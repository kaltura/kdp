package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaPermissionBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var idEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var idIn : String = null;

		/** 
		* 		* */ 
		public var typeEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var typeIn : String = null;

		/** 
		* 		* */ 
		public var nameEqual : String = null;

		/** 
		* 		* */ 
		public var nameIn : String = null;

		/** 
		* 		* */ 
		public var friendlyNameLike : String = null;

		/** 
		* 		* */ 
		public var descriptionLike : String = null;

		/** 
		* 		* */ 
		public var statusEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var statusIn : String = null;

		/** 
		* 		* */ 
		public var partnerIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerIdIn : String = null;

		/** 
		* 		* */ 
		public var dependsOnPermissionNamesMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var dependsOnPermissionNamesMultiLikeAnd : String = null;

		/** 
		* 		* */ 
		public var tagsMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var tagsMultiLikeAnd : String = null;

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

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('typeEqual');
			arr.push('typeIn');
			arr.push('nameEqual');
			arr.push('nameIn');
			arr.push('friendlyNameLike');
			arr.push('descriptionLike');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('partnerIdEqual');
			arr.push('partnerIdIn');
			arr.push('dependsOnPermissionNamesMultiLikeOr');
			arr.push('dependsOnPermissionNamesMultiLikeAnd');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
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
