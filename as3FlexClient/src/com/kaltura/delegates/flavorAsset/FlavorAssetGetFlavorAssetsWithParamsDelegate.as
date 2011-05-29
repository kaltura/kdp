package com.kaltura.delegates.flavorAsset
{
	import com.kaltura.vo.KalturaFlavorAssetWithParams;KalturaFlavorAssetWithParams;;

	import com.kaltura.core.KClassFactory;

	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class FlavorAssetGetFlavorAssetsWithParamsDelegate extends WebDelegateBase
	{
		public function FlavorAssetGetFlavorAssetsWithParamsDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

		override public function parse(result:XML) : *
		{
			var arr : Array = new Array();
			for( var i:int=0; i<result.result.children().length() ; i++)
			{
				var cls : Class = getDefinitionByName('com.kaltura.vo.'+ result.result.children()[i].objectType) as Class;
				var obj : * = (new KClassFactory( cls )).newInstanceFromXML( XMLList(result.result.children()[i]) );
				arr.push(obj);
			}
			return arr;
		}

	}
}
