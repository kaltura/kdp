package com.kaltura.commands.genericDistributionProviderAction
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionAddMrssTransformFromFileDelegate;

	public class GenericDistributionProviderActionAddMrssTransformFromFile extends KalturaFileCall
	{
		public var xslFile:Object;

		/**
		 * @param id int
		 * @param xslFile Object - FileReference or ByteArray
		 **/
		public function GenericDistributionProviderActionAddMrssTransformFromFile( id : int,xslFile : Object )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
			action= 'addMrssTransformFromFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			this.xslFile = xslFile;
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new GenericDistributionProviderActionAddMrssTransformFromFileDelegate( this , config );
		}
	}
}
