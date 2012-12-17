package com.kaltura.kdpfl.plugin.model
{
	import flash.media.Sound;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * 
	 * @author Atar
	 * 
	 */	
	public class SoundProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "sound_proxy";
		
		public static const PLAY_RANDOM_SOUND:String = "play_random_sound";
		
		//TODO docs
		
		// embed sounds
		[Embed(source="assets/105.mp3")]
		private var FirstSoundClass:Class;
		
		[Embed(source="assets/106.mp3")]
		private var SecondSoundClass:Class;
		
		[Embed(source="assets/107.mp3")]
		private var ThirdSoundClass:Class;
		
		
		// sound objects:		
		private var _firstSound:Sound;
		private var _secondSound:Sound;
		private var _thirdSound:Sound;
		
		/**
		 * @copy #entryDuration 
		 */		
		private var _entryDuration:Number;

		
		public function SoundProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
			_firstSound = new FirstSoundClass() as Sound;
			_secondSound = new SecondSoundClass() as Sound;
			_thirdSound = new ThirdSoundClass() as Sound;
		}
		
		
		/**
		 * Plays a sound 
		 * @param n		number of sound to play
		 */		
		public function playSound(n:int):void {
			switch (n) {
				case 1:
					_firstSound.play();
					break;
				case 2:	
					_secondSound.play();
					break;
				case 3:	
					_thirdSound.play();
					break;
			}
		}
		
		
		/**
		 * Chooses a random sound to play 
		 */		
		public function playRandomSound():void {
			var n:int = Math.ceil(Math.random()*3);
			playSound(n);
		}

		/**
		 * duration of the entry currently playing in KDP 
		 */
		public function get entryDuration():Number
		{
			return _entryDuration;
		}

		/**
		 * @private
		 */
		public function set entryDuration(value:Number):void
		{
			_entryDuration = value;
		}
		
		
	}
}