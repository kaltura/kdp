package com.kaltura.commands.genericDistributionProviderAction
{
	import com.kaltura.vo.KalturaGenericDistributionProviderAction;
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionUpdateByProviderIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderActionUpdateByProviderId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param genericDistributionProviderId int
		 * @param actionType int
		 * @param genericDistributionProviderAction KalturaGenericDistributionProviderAction
		 **/
		public function GenericDistributionProviderActionUpdateByProviderId( genericDistributionProviderId : int,actionType : int,genericDistributionProviderAction : KalturaGenericDistributionProviderAction )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
			action= 'updateByProviderId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('genericDistributionProviderId');
			valueArr.push(genericDistributionProviderId);
			keyArr.push('actionType');
			valueArr.push(actionType);
 			keyValArr = kalturaObject2Arrays(genericDistributionProviderAction, 'genericDistributionProviderAction');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderActionUpdateByProviderIdDelegate( this , config );
		}
	}
}
