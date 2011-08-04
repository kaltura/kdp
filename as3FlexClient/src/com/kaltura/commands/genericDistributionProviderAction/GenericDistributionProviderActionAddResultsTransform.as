package com.kaltura.commands.genericDistributionProviderAction
{
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionAddResultsTransformDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderActionAddResultsTransform extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param transformData String
		 **/
		public function GenericDistributionProviderActionAddResultsTransform( id : int,transformData : String )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
			action= 'addResultsTransform';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('transformData');
			valueArr.push(transformData);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderActionAddResultsTransformDelegate( this , config );
		}
	}
}
