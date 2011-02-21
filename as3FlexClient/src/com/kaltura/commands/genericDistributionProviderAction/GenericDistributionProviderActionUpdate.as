package com.kaltura.commands.genericDistributionProviderAction
{
	import com.kaltura.vo.KalturaGenericDistributionProviderAction;
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderActionUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param genericDistributionProviderAction KalturaGenericDistributionProviderAction
		 **/
		public function GenericDistributionProviderActionUpdate( id : int,genericDistributionProviderAction : KalturaGenericDistributionProviderAction )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(genericDistributionProviderAction, 'genericDistributionProviderAction');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderActionUpdateDelegate( this , config );
		}
	}
}
