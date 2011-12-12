package com.kaltura.commands.genericDistributionProviderAction
{
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionAddMrssValidateDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderActionAddMrssValidate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param xsdData String
		 **/
		public function GenericDistributionProviderActionAddMrssValidate( id : int,xsdData : String )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
			action= 'addMrssValidate';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('xsdData');
			valueArr.push(xsdData);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderActionAddMrssValidateDelegate( this , config );
		}
	}
}
