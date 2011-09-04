package com.kaltura.commands.genericDistributionProvider
{
	import com.kaltura.delegates.genericDistributionProvider.GenericDistributionProviderGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function GenericDistributionProviderGet( id : int )
		{
			service= 'contentdistribution_genericdistributionprovider';
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
			delegate = new GenericDistributionProviderGetDelegate( this , config );
		}
	}
}
