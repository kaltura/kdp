package com.kaltura.commands.distributionProfile
{
	import com.kaltura.vo.KalturaDistributionProfileFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.distributionProfile.DistributionProfileListDelegate;
	import com.kaltura.net.KalturaCall;

	public class DistributionProfileList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaDistributionProfileFilter
		 * @param pager KalturaFilterPager
		 **/
		public function DistributionProfileList( filter : KalturaDistributionProfileFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'contentdistribution_distributionprofile';
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
			delegate = new DistributionProfileListDelegate( this , config );
		}
	}
}
