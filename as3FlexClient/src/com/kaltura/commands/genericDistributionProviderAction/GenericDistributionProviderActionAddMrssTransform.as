package com.kaltura.commands.genericDistributionProviderAction
{
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionAddMrssTransformDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderActionAddMrssTransform extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param xslData String
		 **/
		public function GenericDistributionProviderActionAddMrssTransform( id : int,xslData : String )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
			action= 'addMrssTransform';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('xslData');
			valueArr.push(xslData);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderActionAddMrssTransformDelegate( this , config );
		}
	}
}
