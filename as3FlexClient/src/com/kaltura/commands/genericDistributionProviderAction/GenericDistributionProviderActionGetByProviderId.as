package com.kaltura.commands.genericDistributionProviderAction
{
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionGetByProviderIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderActionGetByProviderId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param genericDistributionProviderId int
		 * @param actionType int
		 **/
		public function GenericDistributionProviderActionGetByProviderId( genericDistributionProviderId : int,actionType : int )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
			action= 'getByProviderId';

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
			delegate = new GenericDistributionProviderActionGetByProviderIdDelegate( this , config );
		}
	}
}
