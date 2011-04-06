package com.kaltura.commands.virusScanBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.delegates.virusScanBatch.VirusScanBatchUpdateExclusiveConvertJobSubTypeDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanBatchUpdateExclusiveConvertJobSubType extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param lockKey KalturaExclusiveLockKey
		 * @param subType int
		 **/
		public function VirusScanBatchUpdateExclusiveConvertJobSubType( id : int,lockKey : KalturaExclusiveLockKey,subType : int )
		{
			service= 'virusscan_virusscanbatch';
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
			delegate = new VirusScanBatchUpdateExclusiveConvertJobSubTypeDelegate( this , config );
		}
	}
}
