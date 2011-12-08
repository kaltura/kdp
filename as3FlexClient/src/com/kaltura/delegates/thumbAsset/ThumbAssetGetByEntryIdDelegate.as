package com.kaltura.delegates.thumbAsset
{
	import com.kaltura.vo.KalturaThumbAsset;KalturaThumbAsset;;

	import com.kaltura.core.KClassFactory;

	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class ThumbAssetGetByEntryIdDelegate extends WebDelegateBase
	{
		public function ThumbAssetGetByEntryIdDelegate(call:KalturaCall, config:KalturaConfig)
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
