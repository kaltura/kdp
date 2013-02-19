package com.kaltura.kdpfl.plugin
{
	import flash.display.DisplayObject;
	
	import org.osmf.traits.DisplayObjectTrait;
	
	public class WVDisplayObjectTrait extends DisplayObjectTrait
	{
		public function WVDisplayObjectTrait(displayObject:DisplayObject, mediaWidth:Number=0, mediaHeight:Number=0)
		{
			super(displayObject, mediaWidth, mediaHeight);
		}
	}
}