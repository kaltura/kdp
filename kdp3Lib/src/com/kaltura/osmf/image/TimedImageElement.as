package com.kaltura.osmf.image
{
	import org.osmf.elements.ImageElement;
	import org.osmf.elements.ImageLoader;ImageLoader;
	import org.osmf.media.URLResource;
	import org.osmf.traits.MediaTraitType;
	
	public class TimedImageElement extends ImageElement
	{
		private var _timedImageAdapter : TimedImageAdapter;
		private var _imgDuration : int = 2;
		
		public function TimedImageElement(loader:ImageLoader, resource:URLResource=null, imgDuration : int = 2 )
		{
			super(resource, loader);
			_imgDuration = imgDuration;
		}
		
		override protected function processReadyState():void
		{
			super.processReadyState();
			_timedImageAdapter = new TimedImageAdapter(null,_imgDuration);
			
			var timeTrait:TimedImageTimeTrait = new TimedImageTimeTrait(_timedImageAdapter) 
			
			if(! hasTrait(MediaTraitType.PLAY))
			{
				addTrait(MediaTraitType.PLAY , new TimedImagePlayTrait(_timedImageAdapter) );
				addTrait(MediaTraitType.TIME , timeTrait );
			}
			//addTrait(MediaTraitType.BUFFER, new TimedImageBufferTrait(_timedImageAdapter) );

		}
		
	}
}