package com.kaltura.components.players.vo
{
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.base.IDisposable;

	public class DelayedInsertVO implements IDisposable
	{

		public var formerStartTime:Number;

		public var asset:AbstractAsset;

		public function DelayedInsertVO(former_start_time:Number, _asset:AbstractAsset)
		{
			formerStartTime = former_start_time;
			asset = _asset;
		}

		public function dispose ():void
		{
			asset = null;
		}
	}
}