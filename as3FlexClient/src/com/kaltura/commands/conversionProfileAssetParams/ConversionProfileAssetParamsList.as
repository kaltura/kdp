package com.kaltura.commands.conversionProfileAssetParams
{
	import com.kaltura.vo.KalturaConversionProfileAssetParamsFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.conversionProfileAssetParams.ConversionProfileAssetParamsListDelegate;
	import com.kaltura.net.KalturaCall;

	public class ConversionProfileAssetParamsList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaConversionProfileAssetParamsFilter
		 * @param pager KalturaFilterPager
		 **/
		public function ConversionProfileAssetParamsList( filter : KalturaConversionProfileAssetParamsFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'conversionprofileassetparams';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			if (filter) { 
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
 			if (pager) { 
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ConversionProfileAssetParamsListDelegate( this , config );
		}
	}
}
