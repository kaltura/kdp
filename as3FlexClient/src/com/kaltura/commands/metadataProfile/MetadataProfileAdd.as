package com.kaltura.commands.metadataProfile
{
	import com.kaltura.vo.KalturaMetadataProfile;
	import com.kaltura.delegates.metadataProfile.MetadataProfileAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param metadataProfile KalturaMetadataProfile
		 * @param xsdData String
		 * @param viewsData String
		 **/
		public function MetadataProfileAdd( metadataProfile : KalturaMetadataProfile,xsdData : String,viewsData : String='' )
		{
			service= 'metadata_metadataprofile';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(metadataProfile, 'metadataProfile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('xsdData');
			valueArr.push(xsdData);
			keyArr.push('viewsData');
			valueArr.push(viewsData);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataProfileAddDelegate( this , config );
		}
	}
}
