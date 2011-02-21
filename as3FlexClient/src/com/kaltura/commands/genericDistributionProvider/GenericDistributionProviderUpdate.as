package com.kaltura.commands.genericDistributionProvider
{
	import com.kaltura.vo.KalturaGenericDistributionProvider;
	import com.kaltura.delegates.genericDistributionProvider.GenericDistributionProviderUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param genericDistributionProvider KalturaGenericDistributionProvider
		 **/
		public function GenericDistributionProviderUpdate( id : int,genericDistributionProvider : KalturaGenericDistributionProvider )
		{
			service= 'contentdistribution_genericdistributionprovider';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(genericDistributionProvider, 'genericDistributionProvider');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderUpdateDelegate( this , config );
		}
	}
}
