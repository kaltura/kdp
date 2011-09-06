package com.kaltura.commands.genericDistributionProviderAction
{
	import com.kaltura.vo.KalturaGenericDistributionProviderAction;
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderActionAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param genericDistributionProviderAction KalturaGenericDistributionProviderAction
		 **/
		public function GenericDistributionProviderActionAdd( genericDistributionProviderAction : KalturaGenericDistributionProviderAction )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(genericDistributionProviderAction, 'genericDistributionProviderAction');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderActionAddDelegate( this , config );
		}
	}
}
