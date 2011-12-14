package com.kaltura.kdpfl.plugin.component
{
	//import com.kaltura.kdpfl.component.IComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	import org.puremvc.as3.interfaces.IFacade;

 
	public class Volume508 extends Sprite //implements IComponent
	{
		private var _mcVolume:MovieClip;
		private var _volume:Number = 1;
		private var _volumeWidth:Number;
		private var _textVolume:TextField;
		private var _isMute:Boolean = false;
		
		public function Volume508()
		{	
			try
			{
				var cls:* = getDefinitionByName("volume_track") as Class;
				var mc:MovieClip = new cls as MovieClip;
				mc.visible = true;
				mc.x = 0;
				mc.y = 17;
				addChild (mc);

				cls = getDefinitionByName("volume_indicator") as Class;
				_mcVolume = new cls as MovieClip;
				_mcVolume.visible = true;
				_mcVolume.x = 1;
				_mcVolume.y = 1;
				_volumeWidth = _mcVolume.width;
				_mcVolume.scrollRect = new Rectangle (0, 0, _volumeWidth, _mcVolume.height);
				mc.addChild (_mcVolume);
				
				_textVolume = new TextField ();
				_textVolume.x = 0;
				_textVolume.y = 10;
				_textVolume.width = mc.width;
				_textVolume.type = TextFieldType.DYNAMIC;
				_textVolume.text = "100%";
				_textVolume.setTextFormat (new TextFormat ("Arial", 12, 0x000000, true, null, null, null, null, "center"));
				mc.addChild (_textVolume);
			}catch(e:Error){
			
			}
		}

		public function volumeChanged(vol:Number):void
		{
			if (_isMute)
			{
				return;
			}
			
			_volume = vol;

			_textVolume.text = Math.round(vol * 100) + "%";
			_textVolume.setTextFormat (new TextFormat ("Arial", 12, 0x000000, true, null, null, null, null, "center"));

			_mcVolume.scrollRect = new Rectangle (0, 0, _volumeWidth * _volume, _mcVolume.height);
		}

		public function volumeDown(facade:IFacade):void
		{
			if (_volume == 0 || _isMute)
			{
				return;
			}
			
			_volume -= 0.1;
			if (_volume < 0)
			{
				_volume = 0;
			}
			
			if (!_isMute)
			{
				facade.sendNotification("changeVolume", _volume);
			}
		}

		public function volumeUp(facade:IFacade):void
		{
			if (_volume == 1 || _isMute)
			{
				return;
			}
			
			_volume += 0.1;
			if (_volume > 1)
			{
				_volume = 1;
			}
			
			if (!_isMute)
			{
				facade.sendNotification("changeVolume", _volume);
			}
		}

		public function volumeMute(facade:IFacade):void
		{
			_isMute = !_isMute;
			var setVol:Number = (_isMute ? 0 : _volume)
			
			facade.sendNotification("changeVolume", setVol);
		}
				
		public function initialize():void
		{
		}
		
		public function setSkin(skinName:String, setSkinSize:Boolean=false):void
		{
		}
		
		public function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
		}
	}
}