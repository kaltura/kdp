package com.kaltura.commands.metadata
{
	import com.kaltura.vo.KalturaMetadataFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.metadata.MetadataListDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaMetadataFilter
		 * @param pager KalturaFilterPager
		 **/
		public function MetadataList( filter : KalturaMetadataFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaMetadataFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'metadata_metadata';
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
			delegate = new MetadataListDelegate( this , config );
		}
	}
}
