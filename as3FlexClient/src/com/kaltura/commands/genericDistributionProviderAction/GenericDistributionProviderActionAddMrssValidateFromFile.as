package com.kaltura.commands.genericDistributionProviderAction
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionAddMrssValidateFromFileDelegate;

	public class GenericDistributionProviderActionAddMrssValidateFromFile extends KalturaFileCall
	{
		public var xsdFile:Object;

		/**
		 * @param id int
		 * @param xsdFile Object - FileReference or ByteArray
		 **/
		public function GenericDistributionProviderActionAddMrssValidateFromFile( id : int,xsdFile : Object )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
			action= 'addMrssValidateFromFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			this.xsdFile = xsdFile;
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderActionAddMrssValidateFromFileDelegate( this , config );
		}
	}
}
