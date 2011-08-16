package com.kaltura.commands.genericDistributionProvider
{
	import com.kaltura.delegates.genericDistributionProvider.GenericDistributionProviderDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function GenericDistributionProviderDelete( id : int )
		{
			service= 'contentdistribution_genericdistributionprovider';
			action= 'delete';

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
			delegate = new GenericDistributionProviderDeleteDelegate( this , config );
		}
	}
}
