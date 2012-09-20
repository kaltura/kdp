package com.kaltura.osmf.kalturaMix
{
	import flash.display.DisplayObject;
	
	import org.osmf.traits.DisplayObjectTrait;

	public class KalturaMixViewTrait extends DisplayObjectTrait
	{
		
		public var isSpriteLoaded : Boolean = false;
		public function KalturaMixViewTrait(view:DisplayObject, mediaWidth:Number=0, mediaHeight:Number=0)
		{
			super(view, mediaWidth, mediaHeight);
   			//view.width = info.width;
   			//view.height = info.height;
    				
			//setMediaDimensions(info.width, info.height);
			
		}
		
		public function loadAssets () : void
		{
			(displayObject as KalturaMixSprite).loadAssets();
		}
		
		public function get isReadyForLoad () : Boolean
		{
			return (displayObject as KalturaMixSprite).isReady;
		}
		
		
	}
}