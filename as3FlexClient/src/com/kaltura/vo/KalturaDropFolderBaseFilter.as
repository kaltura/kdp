package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaDropFolderBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var idEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var idIn : String;

		/** 
		* 		* */ 
		public var partnerIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerIdIn : String;

		/** 
		* 		* */ 
		public var nameLike : String;

		/** 
		* 		* */ 
		public var typeEqual : String;

		/** 
		* 		* */ 
		public var typeIn : String;

		/** 
		* 		* */ 
		public var statusEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var statusIn : String;

		/** 
		* 		* */ 
		public var conversionProfileIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var conversionProfileIdIn : String;

		/** 
		* 		* */ 
		public var dcEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var dcIn : String;

		/** 
		* 		* */ 
		public var pathLike : String;

		/** 
		* 		* */ 
		public var fileHandlerTypeEqual : String;

		/** 
		* 		* */ 
		public var fileHandlerTypeIn : String;

		/** 
		* 		* */ 
		public var fileNamePatternsLike : String;

		/** 
		* 		* */ 
		public var fileNamePatternsMultiLikeOr : String;

		/** 
		* 		* */ 
		public var fileNamePatternsMultiLikeAnd : String;

		/** 
		* 		* */ 
		public var tagsLike : String;

		/** 
		* 		* */ 
		public var tagsMultiLikeOr : String;

		/** 
		* 		* */ 
		public var tagsMultiLikeAnd : String;

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
			arr.push('partnerIdEqual');
			arr.push('partnerIdIn');
			arr.push('nameLike');
			arr.push('typeEqual');
			arr.push('typeIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('conversionProfileIdEqual');
			arr.push('conversionProfileIdIn');
			arr.push('dcEqual');
			arr.push('dcIn');
			arr.push('pathLike');
			arr.push('fileHandlerTypeEqual');
			arr.push('fileHandlerTypeIn');
			arr.push('fileNamePatternsLike');
			arr.push('fileNamePatternsMultiLikeOr');
			arr.push('fileNamePatternsMultiLikeAnd');
			arr.push('tagsLike');
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
