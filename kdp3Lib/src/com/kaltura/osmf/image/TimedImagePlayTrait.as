package com.kaltura.osmf.image
{
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;

	public class TimedImagePlayTrait extends PlayTrait
	{
		private var _timedImageAdapter : TimedImageAdapter;
		
		public function TimedImagePlayTrait( timedImageAdapter : TimedImageAdapter )
		{
			super();
			_timedImageAdapter = timedImageAdapter;

		}
		
		override protected function playStateChangeStart(newPlayState:String):void
		{
			if (newPlayState == PlayState.PLAYING)
			{
				_timedImageAdapter.play();			
			}
			else if (newPlayState == PlayState.PAUSED)
			{
				_timedImageAdapter.pause();
			}				
			else if (newPlayState == PlayState.STOPPED)
			{
				_timedImageAdapter.stop();
			}	
		}
		
	}
}