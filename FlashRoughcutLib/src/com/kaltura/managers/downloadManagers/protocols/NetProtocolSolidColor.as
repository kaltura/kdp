package com.kaltura.managers.downloadManagers.protocols
{
	import com.kaltura.application.KalturaApplication;
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.managers.downloadManagers.protocols.interfaces.INetProtocol;
	import com.kaltura.net.loaders.interfaces.IMediaSourceLoader;
	//xxx import com.kaltura.utils.colors.ColorsUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;

	public class NetProtocolSolidColor extends EventDispatcher implements INetProtocol
	{
		public var _asset:AbstractAsset;
		private var _roughcutEntryId:String = '-1';
		private var _roughcutEntryVersion:int = -1;

		public function get roughcutEntryId ():String
		{
			return _roughcutEntryId;
		}

		public function get roughcutEntryVersion ():int
		{
			return _roughcutEntryVersion;
		}

		public function get asset ():AbstractAsset
		{
			return _asset;
		}

		public function NetProtocolSolidColor(roughcut_entry_Id:String, roughcut_entry_version:int)
		{
			super();
			_roughcutEntryId = roughcut_entry_Id;
			_roughcutEntryVersion = roughcut_entry_version;
		}

		/**
		 *instantiates a bitmapData and bitmap and set it to the asset.
		 * @param k		the solid asset to create it's bitmap.
		 * @return 		null.
		 */
		public function load(source_asset:AbstractAsset):IMediaSourceLoader
		{
			_asset = source_asset;
			var bd:BitmapData = new BitmapData (KalturaApplication.getInstance().initPlayerWidth,
								KalturaApplication.getInstance().initPlayerHeight, false, uint(_asset.thumbnailURL));
			var bmp:Bitmap = new Bitmap (bd);
			var colorName:String = "";//xxx ColorsUtil.getName(uint(_asset.thumbnailURL))[1];
			_asset.entryName = MediaTypes.getLocaleMediaType(MediaTypes.SOLID) + " (" + colorName + ")";
			_asset.thumbBitmap = bmp;
			_asset.mediaSource = bd;
			return null;
		}
	}
}