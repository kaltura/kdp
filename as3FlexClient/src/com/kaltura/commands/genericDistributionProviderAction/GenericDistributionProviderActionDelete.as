package com.kaltura.commands.genericDistributionProviderAction
{
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderActionDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function GenericDistributionProviderActionDelete( id : int )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
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
			delegate = new GenericDistributionProviderActionDeleteDelegate( this , config );
		}
	}
}
