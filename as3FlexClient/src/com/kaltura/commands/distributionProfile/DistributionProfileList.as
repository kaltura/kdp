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
			if(filter== null)filter= new KalturaDistributionProfileFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'contentdistribution_distributionprofile';
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
			delegate = new DistributionProfileListDelegate( this , config );
		}
	}
}
