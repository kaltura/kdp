package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAsset;

	[Bindable]
	public dynamic class KalturaAttachmentAsset extends KalturaAsset
	{
		/** 
		* The filename of the attachment asset content		* */ 
		public var filename : String = null;

		/** 
		* Attachment asset title		* */ 
		public var title : String = null;

		/** 
		* The attachment format		* */ 
		public var format : String = null;

		/** 
		* The status of the asset
		* */ 
		public var status : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('filename');
			arr.push('title');
			arr.push('format');
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
