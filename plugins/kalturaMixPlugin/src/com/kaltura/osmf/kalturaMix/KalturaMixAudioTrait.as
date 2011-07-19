package com.kaltura.osmf.kalturaMix
{
	import com.kaltura.components.players.eplayer.Eplayer;
	
	import org.osmf.traits.AudioTrait;

	public class KalturaMixAudioTrait extends AudioTrait
	{
		public var eplayer:Eplayer;

		public function KalturaMixAudioTrait(_eplayer:Eplayer)
		{
			eplayer = _eplayer;
			super();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function volumeChangeStart(newVolume:Number):void
		{
			eplayer.setOverAllVolume(muted ? 0 : newVolume);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function mutedChangeStart(newMuted:Boolean):void
		{
			eplayer.setOverAllVolume(newMuted ? 0 : volume);
		}
	}
}