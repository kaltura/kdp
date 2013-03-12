package com.kaltura.kdpfl.plugin
{
	import com.widevine.WvNetStream;
	
	import flash.media.SoundTransform;
	
	import org.osmf.traits.AudioTrait;
	
	public class WVAudioTrait extends AudioTrait
	{
		
		private var _wasMuted:Boolean;
		
		public function WVAudioTrait(netStream : WvNetStream)
		{
			super();
			_wvNetStream = netStream;
		}
		
		override protected function volumeChangeStart(newVolume:Number):void
		{
			if (_wvNetStream.soundTransform.volume != newVolume)
			{
				_wvNetStream.soundTransform = new SoundTransform(newVolume);
			}
		}
		
		override protected function mutedChangeStart(newMuted:Boolean):void
		{
			if(!newMuted && _wasMuted)
			{
				_wvNetStream.soundTransform = new SoundTransform(1);
				_wasMuted = false;
				
			}
			else if (_wasMuted)
			{
				_wvNetStream.soundTransform = new SoundTransform(0);
				_wasMuted = true;
			}
				
		}
		
		
		private var _wvNetStream : WvNetStream;
	}
}