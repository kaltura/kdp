package com.kaltura.commands.metadataProfile
{
	import com.kaltura.vo.KalturaMetadataProfile;
	import com.kaltura.delegates.metadataProfile.MetadataProfileUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param metadataProfile KalturaMetadataProfile
		 * @param xsdData String
		 * @param viewsData String
		 **/
		public function MetadataProfileUpdate( id : int,metadataProfile : KalturaMetadataProfile,xsdData : String='',viewsData : String='' )
		{
			service= 'metadata_metadataprofile';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
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
			delegate = new MetadataProfileUpdateDelegate( this , config );
		}
	}
}
