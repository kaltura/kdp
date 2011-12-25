package com.kaltura.commands.contentDistributionBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.delegates.contentDistributionBatch.ContentDistributionBatchUpdateExclusiveConvertJobSubTypeDelegate;
	import com.kaltura.net.KalturaCall;

	public class ContentDistributionBatchUpdateExclusiveConvertJobSubType extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param lockKey KalturaExclusiveLockKey
		 * @param subType int
		 **/
		public function ContentDistributionBatchUpdateExclusiveConvertJobSubType( id : int,lockKey : KalturaExclusiveLockKey,subType : int )
		{
			service= 'contentdistribution_contentdistributionbatch';
			action= 'updateExclusiveConvertJobSubType';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(lockKey, 'lockKey');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('subType');
			valueArr.push(subType);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ContentDistributionBatchUpdateExclusiveConvertJobSubTypeDelegate( this , config );
		}
	}
}
