package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.model.type.StreamerType;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	
	/**
	 * Class KFlavorComboBox represents the uinique Kaltura ComboBox which allows the user to toggle the
	 * video quality. This ComboBox wil be empty of flavor bitrate values in case the media playing in the KDP is a KalturaMixEntry. 
	 * The data in the ComboBox is displayed in units of kbps (kilo-bytes per second).
	 * @author Hila
	 * 
	 */	
	public class KFlavorComboBox extends KComboBox
	{
		public static const DATA_PROVIDER_CHANGE : String = "dataProviderChange";
		/**
		 * Property holds the value of the string displayed in the Combo Box when the player is in adaptive bitrate
		 * mode and the bitrate changes automatically. Default value is "HD Auto".
		 */		
		private var _autoString : String = "HD Auto";
		/**
		 * Property holds the value of the string displayed in the Combgo Box when the selected flavor
		 * has a bitrate greater than 2500kbps.
		 */		
		private var _hdOn : String = "HD On";
		/**
		 * Property holds the value of the string displayed in the Combgo Box when the selected flavor
		 * has a bitrate smaller than 2500kbps.
		 */		
		private var _hdOff : String = "HD Off";
		/**
		 * The post-fix displayed in the Combo Box. For instance, if the post fix is "k" then the displayed string will be bitrate+k.
		 */		
		public var bitratePostFix : String = "k";
	
		private var _flavorArray : Array;
		/**
		 * The bitrate for the user's prefered flavor. 
		 */		
		private var _preferedFlavorBR : int = -1;
		/**
		 * Flag indicating whether the player is currently in adaptive streaming mode (rtmp).
		 */		
		private var _isRtmp : Boolean = false;
		/**
		 * This property stands for the current transmission mode of the KDP. Values are "http" (progressive download), "rtmp" (adaptive streaming) or "live" (live streaming media).
		 */		
		private var _streamerType : String;
		/**
		 * The message displayed in the tooltip of the combo box.
		 */		
		private var _selectedMessage : String = "";
		/**
		 * The tooltip for the <code>_autoString</code>.
		 */		
		private var _autoMessage : String = "Automatically switches between bitrates";
		
		public var kisOpen : Boolean = false;
		/**
		 * Constructor 
		 * 
		 */	
		public function KFlavorComboBox()
		{
			super();
			this.labelFunction = flavorLabelFunction;
		}
		
		
			
		private function flavorLabelFunction (data : Object) : String
		{
			var labelLength : int = data.label.length-this.bitratePostFix.length;
			var preferedFlavorBitrate : int = parseInt(String(data.label).substr(0,labelLength));
			if(data == this.selectedItem && !kisOpen){ 
				if(this._streamerType != StreamerType.HTTP && (this.selectedIndex == 0 || this.selectedIndex == -1))
				{
					//Do nothing
				}
				else if(preferedFlavorBitrate >= 2500)
				{
					return this.hdOn;
				}else{
					return this.hdOff;
				}
			}
			return data.label;
		}
		
		/**
		 * Getter function for the data provider of the ComboBox 
		 * @return - Array which is the data provuder of the Combo Box.
		 * 
		 */			
		public function get flavorDataProvider():Array
		{
			return _flavorArray;
		}
		
		[Bindable]
		/**
		 * Setter function for the data provider of the Combo Box 
		 * @param arr
		 * 
		 */		
		public function set flavorDataProvider(arr:Array):void
		{
			if(_flavorArray == arr) return;
			
			_flavorArray = arr;
			
			var newDp : DataProvider = new DataProvider();
			
			if(_isRtmp)
				newDp.addItem( { label : autoString } );
			if(_flavorArray)
			{	
				for(var i:int=0;i<_flavorArray.length;i++)
				{
					var roundedBitrate : Number = (Math.round(Number(_flavorArray[i].bitrate)/100))*100;
					newDp.addItem( { label: roundedBitrate + bitratePostFix} );
				}
			}
			//var oldIndex : int = this.selectedIndex;
			super.dataProvider = newDp;
			//this.selectedIndex = oldIndex;
			dispatchEvent( new Event( DATA_PROVIDER_CHANGE ) );
		}
		/**
		 * Getter function for the <code>_preferedFlavorBR</code> property.
		 * @return 
		 * 
		 */		
		public function get preferedFlavorBR() : int { return _preferedFlavorBR; }
		
		[Bindable]
		/**
		 * Setter function for the <code>_preferedFlavorBR</code> property.
		 * @param preferedFlavor - the value to set into the the <code>_preferedFlavorBR</code> property.
		 * 
		 */		
		public function set preferedFlavorBR( preferedFlavor : int ) : void
		{
			if(preferedFlavor == _preferedFlavorBR) return;
			_preferedFlavorBR = preferedFlavor;
			//TODO: check if it's always acurate
			var foundFlavor : Boolean = false;
			for(var i:int=0; i<dataProvider.length; i++)
			{
				if(dataProvider.getItemAt(i).label == _preferedFlavorBR + bitratePostFix)	
				{
					this.selectedIndex = i;
					foundFlavor = true;
				}
			}
			
			//if i am rtmp, and i didn't found any flavor selected, i will be  in auto mode
			if( _isRtmp && !foundFlavor )
			{
				this.selectedIndex = 0;	
				this.selectedMessage = autoMessage;
			}
			else
			{
				if(_isRtmp && this.selectedIndex == 0)
					this.selectedMessage = autoMessage;
				else if (!_isRtmp && !foundFlavor)
					this.selectedMessage=""
				else
					this.selectedMessage = "Bitrate: " + _preferedFlavorBR;
			}
		}
		/**
		 * Getter function for the <code>_streamerType</code> property. 
		 * @return the value of property <code>_streamerType</code>.
		 * 
		 */		
		public function get streamerType() : String { return _streamerType; }
		
		[Bindable]
		/**
		 * Setter function for the <code>_streamerType</code> property. 
		 * @param value
		 * 
		 */		
		public function set streamerType( value : String ) :  void
		{
			_streamerType = value;
			//we check if this is RTMP so we need to add the auto mode
			_isRtmp = (_streamerType == StreamerType.RTMP || _streamerType == StreamerType.LIVE) ? true : false;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get hdOn () : String { return _hdOn; }
		
		[Bindable]
		/**
		 * Setter function for the <code>_hdOn</code> property. 
		 * @param value
		 * 
		 */		
		public function set hdOn ( hdOnMsg : String) : void
		{
			_hdOn = hdOnMsg;
		}
		
		public function get hdOff () : String { return _hdOff; }
		
		[Bindable]
		/**
		 * Setter function for the <code>_hdOff</code> property. 
		 * @param value
		 * 
		 */	
		public function set hdOff ( hdOffMsg : String ) : void
		{
			_hdOff = hdOffMsg;
		}
		
		public function get selectedMessage () : String{ return _selectedMessage; }
		
		[Bindable]
		
		public function set selectedMessage (newMsg : String) : void
		{
			_selectedMessage = newMsg;
		}
		
		public function get autoMessage () : String{ return _autoMessage; }
		
		[Bindable]
		public function set autoMessage (newMsg : String) : void
		{
			_autoMessage = newMsg;
		}
		
		public function get autoString () : String{ return _autoString; }
		
		[Bindable]
		public function set autoString (newMsg : String) : void
		{
			_autoString = newMsg;
			if(_isRtmp)
			{
				this.dataProvider.getItemAt(0).label = _autoString;
			}
		}
		[Bindable]
		public function set notVisible (arg:Boolean) :void
		{
			visible = !arg;
		}
		public function get notVisible () : Boolean
		{
			return !visible;
		}


	}
}