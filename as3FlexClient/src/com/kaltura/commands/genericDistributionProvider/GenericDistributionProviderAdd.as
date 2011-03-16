package com.kaltura.commands.genericDistributionProvider
{
	import com.kaltura.vo.KalturaGenericDistributionProvider;
	import com.kaltura.delegates.genericDistributionProvider.GenericDistributionProviderAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param genericDistributionProvider KalturaGenericDistributionProvider
		 **/
		public function GenericDistributionProviderAdd( genericDistributionProvider : KalturaGenericDistributionProvider )
		{
			service= 'contentdistribution_genericdistributionprovider';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(genericDistributionProvider, 'genericDistributionProvider');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderAddDelegate( this , config );
		}
	}
}
