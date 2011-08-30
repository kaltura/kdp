package com.kaltura.commands.metadataProfile
{
	import com.kaltura.vo.KalturaMetadataProfileFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.metadataProfile.MetadataProfileListDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaMetadataProfileFilter
		 * @param pager KalturaFilterPager
		 **/
		public function MetadataProfileList( filter : KalturaMetadataProfileFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaMetadataProfileFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'metadata_metadataprofile';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataProfileListDelegate( this , config );
		}
	}
}
