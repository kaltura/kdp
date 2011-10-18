package com.kaltura.commands.metadataBatch
{
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.metadataBatch.MetadataBatchUpgradeMetadataObjectsDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataBatchUpgradeMetadataObjects extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataBatchUpgradeMetadataObjects( metadataProfileId : int,srcVersion : int,destVersion : int,pager : KalturaFilterPager=null )
		{
			if(pager== null)pager= new KalturaFilterPager();
			service= 'metadata_metadatabatch';
			action= 'upgradeMetadataObjects';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'metadataProfileId' );
			valueArr.push( metadataProfileId );
			keyArr.push( 'srcVersion' );
			valueArr.push( srcVersion );
			keyArr.push( 'destVersion' );
			valueArr.push( destVersion );
 			keyValArr = kalturaObject2Arrays(pager,'pager');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataBatchUpgradeMetadataObjectsDelegate( this , config );
		}
	}
}
