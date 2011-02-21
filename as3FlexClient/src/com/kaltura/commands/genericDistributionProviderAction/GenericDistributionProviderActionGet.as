package com.kaltura.commands.genericDistributionProviderAction
{
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderActionGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function GenericDistributionProviderActionGet( id : int )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderActionGetDelegate( this , config );
		}
	}
}
