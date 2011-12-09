package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUrlResource;

	[Bindable]
	public dynamic class KalturaSshUrlResource extends KalturaUrlResource
	{
		/** 
		* SSH private key		* */ 
		public var privateKey : String = null;

		/** 
		* SSH public key		* */ 
		public var publicKey : String = null;

		/** 
		* Passphrase for SSH keys		* */ 
		public var keyPassphrase : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('privateKey');
			arr.push('publicKey');
			arr.push('keyPassphrase');
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
