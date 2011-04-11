package com.kaltura.commands.genericDistributionProviderAction
{
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionDeleteByProviderIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderActionDeleteByProviderId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param genericDistributionProviderId int
		 * @param actionType int
		 **/
		public function GenericDistributionProviderActionDeleteByProviderId( genericDistributionProviderId : int,actionType : int )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
			action= 'deleteByProviderId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('genericDistributionProviderId');
			valueArr.push(genericDistributionProviderId);
			keyArr.push('actionType');
			valueArr.push(actionType);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderActionDeleteByProviderIdDelegate( this , config );
		}
	}
}
