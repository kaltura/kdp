package com.kaltura.osmf.kalturaMix
{
	import com.kaltura.components.players.eplayer.Eplayer;
	import com.kaltura.roughcut.events.RoughcutStatusEvent;
	
	import flash.events.Event;
	
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;

	public class KalturaMixPlayTrait extends PlayTrait
	{
		public var eplayer:Eplayer;
		private var _roughCutReady : Boolean = false;
		private var _playing : Boolean = false;
		
		public function KalturaMixPlayTrait(_eplayer:Eplayer)
		{
			super();
			eplayer = _eplayer;
			//wait to get an hold on the roughcut to listen to it
			eplayer.addEventListener( "roughcutReady" , onRoughcutReady );
		}
		
		private function onRoughcutReady( event : Event ) : void
		{
			eplayer.removeEventListener( "roughcutReady" , onRoughcutReady );
			//listen to the first frame loaded of the roughcut to now that we can play for sure
			//eplayer.roughcut.addEventListener( RoughcutStatusEvent.FIRST_FRAME_LOADED , onFirstFrameLoaded );
			_roughCutReady = true;
			
			//if it's autoplay so we bypassed the play until this moment we need to call play again
			if(_playing) 
				playStateChangeStart(PlayState.PLAYING);
		}
		
		private function onFirstFrameLoaded( event : RoughcutStatusEvent ) :void
		{
			eplayer.roughcut.removeEventListener( RoughcutStatusEvent.FIRST_FRAME_LOADED , onFirstFrameLoaded );
			//_firstFrameLoaded = true;
			
			//if it's autoplay so we bypassed the play until this moment we need to call play again
			if(_playing) 
				playStateChangeStart(PlayState.PLAYING);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function playStateChangeStart(newPlayState:String):void
		{
			
			if (newPlayState == PlayState.PLAYING)
			{
				_playing = true;
				//if the first frame isn't loaded yet don't play
				if(!_roughCutReady) {
					dispatchEvent(new Event("playBeforeLoaded"));
					return;
				}
				
				if (streamStarted)
				{
					
					eplayer.resumePlaySequence();
					// resume
					streamStarted = false;				
				}
				else
				{
					// start
					eplayer.resumePlaySequence();
					streamStarted = true;
				}					
			}
			else // PAUSED || STOPPED
			{
				_playing = false;
				eplayer.pauseSequence();
				// pause
			}
		}
			
		private var streamStarted:Boolean;
	}
}