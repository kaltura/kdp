package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaDropFolderFileBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var idEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var idIn : String = null;

		/** 
		* 		* */ 
		public var partnerIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerIdIn : String = null;

		/** 
		* 		* */ 
		public var dropFolderIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var dropFolderIdIn : String = null;

		/** 
		* 		* */ 
		public var fileNameEqual : String = null;

		/** 
		* 		* */ 
		public var fileNameIn : String = null;

		/** 
		* 		* */ 
		public var fileNameLike : String = null;

		/** 
		* 		* */ 
		public var statusEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var statusIn : String = null;

		/** 
		* 		* */ 
		public var parsedSlugEqual : String = null;

		/** 
		* 		* */ 
		public var parsedSlugIn : String = null;

		/** 
		* 		* */ 
		public var parsedSlugLike : String = null;

		/** 
		* 		* */ 
		public var parsedFlavorEqual : String = null;

		/** 
		* 		* */ 
		public var parsedFlavorIn : String = null;

		/** 
		* 		* */ 
		public var parsedFlavorLike : String = null;

		/** 
		* 		* */ 
		public var errorCodeEqual : String = null;

		/** 
		* 		* */ 
		public var errorCodeIn : String = null;

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
			arr.push('dropFolderIdEqual');
			arr.push('dropFolderIdIn');
			arr.push('fileNameEqual');
			arr.push('fileNameIn');
			arr.push('fileNameLike');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('parsedSlugEqual');
			arr.push('parsedSlugIn');
			arr.push('parsedSlugLike');
			arr.push('parsedFlavorEqual');
			arr.push('parsedFlavorIn');
			arr.push('parsedFlavorLike');
			arr.push('errorCodeEqual');
			arr.push('errorCodeIn');
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
