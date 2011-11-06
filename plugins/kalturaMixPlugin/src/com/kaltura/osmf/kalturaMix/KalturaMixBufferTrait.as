package com.kaltura.osmf.kalturaMix
{
	import com.kaltura.components.players.eplayer.Eplayer;
	import com.kaltura.components.players.events.PlayerBufferEvent;
	import com.kaltura.components.players.states.BufferStatuses;
	
	import org.osmf.traits.BufferTrait;

	public class KalturaMixBufferTrait extends BufferTrait
	{
		public var eplayer:Eplayer;

		public function KalturaMixBufferTrait(_eplayer:Eplayer)
		{
			eplayer = _eplayer;
			
			//This is a hack - since mixes do not buffer via the OSMF but through the eplayer,
			//I have given the bufferTrait a garbage bufferLength value.
			setBufferLength(10);
			super();
			
			eplayer.addEventListener(PlayerBufferEvent.PLAYER_BUFFER_STATUS, onBufferStatus);
		}
		
		private function onBufferStatus(e:PlayerBufferEvent):void
		{
			setBuffering(e.bufferingStatus == BufferStatuses.BUFFERING);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			eplayer.removeEventListener(PlayerBufferEvent.PLAYER_BUFFER_STATUS, onBufferStatus);
		}
	}
}