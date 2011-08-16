package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaGenericDistributionProviderAction extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var genericDistributionProviderId : int = int.MIN_VALUE;

		public var action : int = int.MIN_VALUE;

		public var status : int = int.MIN_VALUE;

		public var resultsParser : int = int.MIN_VALUE;

		public var protocol : int = int.MIN_VALUE;

		public var serverAddress : String;

		public var remotePath : String;

		public var remoteUsername : String;

		public var remotePassword : String;

		public var editableFields : String;

		public var mandatoryFields : String;

		public var mrssTransformer : String;

		public var mrssValidator : String;

		public var resultsTransformer : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('resultsParser');
			arr.push('protocol');
			arr.push('serverAddress');
			arr.push('remotePath');
			arr.push('remoteUsername');
			arr.push('remotePassword');
			arr.push('editableFields');
			arr.push('mandatoryFields');
			return arr;
		}
	}
}
