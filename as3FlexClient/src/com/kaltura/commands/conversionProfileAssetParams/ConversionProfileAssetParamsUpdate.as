package com.kaltura.commands.conversionProfileAssetParams
{
	import com.kaltura.vo.KalturaConversionProfileAssetParams;
	import com.kaltura.delegates.conversionProfileAssetParams.ConversionProfileAssetParamsUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class ConversionProfileAssetParamsUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param conversionProfileId int
		 * @param assetParamsId int
		 * @param conversionProfileAssetParams KalturaConversionProfileAssetParams
		 **/
		public function ConversionProfileAssetParamsUpdate( conversionProfileId : int,assetParamsId : int,conversionProfileAssetParams : KalturaConversionProfileAssetParams )
		{
			service= 'conversionprofileassetparams';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('conversionProfileId');
			valueArr.push(conversionProfileId);
			keyArr.push('assetParamsId');
			valueArr.push(assetParamsId);
 			keyValArr = kalturaObject2Arrays(conversionProfileAssetParams, 'conversionProfileAssetParams');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ConversionProfileAssetParamsUpdateDelegate( this , config );
		}
	}
}
