package com.kaltura.vo
{
	import com.kaltura.vo.KalturaRemoteDropFolder;

	[Bindable]
	public dynamic class KalturaSshDropFolder extends KalturaRemoteDropFolder
	{
		/** 
		* 		* */ 
		public var host : String = null;

		/** 
		* 		* */ 
		public var port : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var username : String = null;

		/** 
		* 		* */ 
		public var password : String = null;

		/** 
		* 		* */ 
		public var privateKey : String = null;

		/** 
		* 		* */ 
		public var publicKey : String = null;

		/** 
		* 		* */ 
		public var passPhrase : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('host');
			arr.push('port');
			arr.push('username');
			arr.push('password');
			arr.push('privateKey');
			arr.push('publicKey');
			arr.push('passPhrase');
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
