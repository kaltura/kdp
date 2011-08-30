package com.kaltura.commands.storageProfile
{
	import com.kaltura.vo.KalturaStorageProfileFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.storageProfile.StorageProfileListDelegate;
	import com.kaltura.net.KalturaCall;

	public class StorageProfileList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaStorageProfileFilter
		 * @param pager KalturaFilterPager
		 **/
		public function StorageProfileList( filter : KalturaStorageProfileFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'storageprofile';
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
			delegate = new StorageProfileListDelegate( this , config );
		}
	}
}
