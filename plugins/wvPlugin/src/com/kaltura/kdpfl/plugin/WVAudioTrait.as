package com.kaltura.kdpfl.plugin
{
	import com.widevine.WvNetStream;
	
	import flash.media.SoundTransform;
	
	import org.osmf.traits.AudioTrait;
	
	public class WVAudioTrait extends AudioTrait
	{
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
			if(!newMuted)
			{
				_wvNetStream.soundTransform = new SoundTransform(0);
			}
		}
		
		
		private var _wvNetStream : WvNetStream;
	}
}