package com.kaltura.kdpfl.plugin.component
{
	//import com.kaltura.kdpfl.component.IComponent;
	
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
		 

 
	public class AudioDescription extends Sprite //implements IComponent
	{
		private var _sound:Sound = null;
		private var _soundChannel:SoundChannel = null;
		private var _position:Number = 0;
		private var _isActive:Boolean = true;
		private var _volume:Number = 1;

		public function AudioDescription()
		{
			_isActive = true;
		}
		
		public function loadFile (file:String):void
		{
			_sound = new Sound (new URLRequest (file));
		}
				
		public function play ():void
		{
			if (_soundChannel == null)
			{
				var soundTransform:SoundTransform = new SoundTransform (_isActive ? _volume : 0);
				_soundChannel = _sound.play(_position, 0, soundTransform);
			}
		}
				
		public function setVolume (volume:Number):void
		{
			_volume = volume;
		}
				
		public function setSeek (pos:Number):void
		{
			_position = pos;
		}
				
		public function pause ():void
		{
			if (_soundChannel != null)
			{
				_position = _soundChannel.position;
				_soundChannel.stop();
				_soundChannel = null;
			}
		}
		
		public function audioDescriptionClicked ():void
		{
			_isActive = !_isActive;

			if (_soundChannel != null)
			{
				var soundTransform:SoundTransform = new SoundTransform (_isActive ? _volume : 0);
				_soundChannel.soundTransform = soundTransform;
			}
		}
				
		public function initialize():void
		{
/* 			this.columnWidth = 215;
			this.rowHeight = 86;
			//(uiComponent as TileList).columnCount = 1;
			this.direction = ScrollBarDirection.VERTICAL; */
		}
		
		public function setSkin(skinName:String, setSkinSize:Boolean=false):void
		{
			//this.setStyle("cellRenderer", CustomImageCacheCell);
		}
		
		public function setSize(width:Number, height:Number):void
		{
//			this.width = width;
//			this.height = height;
		}
	}
}