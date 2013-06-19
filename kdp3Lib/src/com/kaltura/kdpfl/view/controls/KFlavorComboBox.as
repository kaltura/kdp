package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.StreamerType;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	/**
	 * Class KFlavorComboBox represents the uinique Kaltura ComboBox which allows the user to toggle the
	 * video quality. This ComboBox wil be empty of flavor bitrate values in case the media playing in the KDP is a KalturaMixEntry. 
	 * The data in the ComboBox is displayed in units of kbps (kilo-bytes per second).
	 * @author Hila
	 * 
	 */	
	public class KFlavorComboBox extends KComboBox
	{
		public static const HD_LIMIT:int = 540;
		public static const HEIGHT_ARRAY:Array = [240, 360, 480, 540, 720, 1080];
		
		public static const DATA_PROVIDER_CHANGE : String = "dataProviderChange";
		/**
		 * Property holds the value of the string displayed in the Combo Box when the player is in adaptive bitrate
		 * mode and the bitrate changes automatically. Default value is "HD Auto".
		 */		
		private var _autoString : String = "Auto";
		/**
		 * DEPRECATED
		 * Property holds the value of the string displayed in the Combgo Box when the selected flavor
		 * has a bitrate greater than 2500kbps.
		 */		
		private var _hdOn : String = "HD On";
		/**
		 * DEPRECATED
		 * Property holds the value of the string displayed in the Combgo Box when the selected flavor
		 * has a bitrate smaller than 2500kbps.
		 */		
		private var _hdOff : String = "HD Off";
		/**
		 * Property holds the value of the string displayed in the Combgo Box when the switch to the selected bitrate is in process
		 */		
		private var _switchingMessage : String = "Switch in Progress..."
		/**
		 * The post-fix displayed in the Combo Box. For instance, if the post fix is "k" then the displayed string will be bitrate+k.
		 */		
		public var bitratePostFix : String = "k";
		/**
		 * The post-fix displayed in the Combo Box. For instance, if the post fix is "p" then the displayed string will be height+p.
		 */		
		public var pixelsPostFix : String = "p";
		
		private var _flavorArray : Array;
		/**
		 * The bitrate for the user's prefered flavor. 
		 */		
		private var _preferedFlavorBR : int;
		/**
		 * Flag indicating whether the player is currently in adaptive streaming mode (rtmp).
		 */		
		private var _isRtmp : Boolean = false;
		/**
		 * Flag indicating whether the player is currently in http streaming mode (hdnetwork).
		 */		
		private var _isHttpStreaming : Boolean = false;
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
		private var _autoMessage : String = "Automatically Switches Between Bitrates";
		
		public var kisOpen : Boolean = false;
		
		/**
		 * whether the dropdown is currently displayed 
		 */		
		private var _isOnDropdown:Boolean = false;
		
		private var _dropdownTimer:Timer;
		/**
		 * time in milliseconds to wait before disappearing the dropdown
		 * */
		static private var DROPDOWN_TIMER_DELAY:Number = 600; // ms
		
		/**
		 * prefix for HD bitrates 
		 */		
		public var hdPrefix:String = "HD ";
		/**
		 * prefix for SD bitrates 
		 */		
		public var sdPrefix:String = "SD ";
		/**
		 * length of bitrate prefix string 
		 */		
		public var prefixLength:int = 3;
		/**
		 * string that indicates adaptive switching is currently on 
		 */		
		public var adaptiveAuto:String = "Auto on";
		/**
		 * string that indicates adaptive switching is currently off 
		 */		
		public var adaptiveOff:String = "Auto off";
		/**
		 * string that indicates the flavor has low height 
		 */		
		public var lowHeight:String = "Low";
		/**
		 * indicate if we are autoSwitching flavors (relevant for RTMP or HDNetwork) 
		 */		
		private var _isAutoSwitch:Boolean;
		/**
		 * index of last item that was selected 
		 */		
		public var lastSelectedIndex:int;
		
		public var usePixels:Boolean;
		
		private var _bitrateDetectionMessage:String = "Detecting Your Bandwidth";
		
		private var _switchPausedMessage:String = "Switching is Paused";

		
		/**
		 * Constructor 
		 * 
		 */	
		public function KFlavorComboBox()
		{
			super();
			this.labelFunction = flavorLabelFunction;
			
			//listeners to close dropdown on mouse rollout
			this.addEventListener(MouseEvent.ROLL_OVER, onCBRollover);
			this.addEventListener(MouseEvent.ROLL_OUT, onCBRollout);
			this.dropdown.addEventListener(MouseEvent.ROLL_OVER, onDropdownRollover);
			this.dropdown.addEventListener(MouseEvent.ROLL_OUT, onDropdownRollout);
		}
		
		[Bindable]
		public function get isAutoSwitch():Boolean
		{
			return _isAutoSwitch;
		}
		
		public function set isAutoSwitch(value:Boolean):void
		{
			_isAutoSwitch = value;
			if (isDynamic() && (dataProvider && dataProvider.length))
			{
				//replace the auto message
				var item:Object;
				if (_isAutoSwitch)
					item = {label: adaptiveAuto, value: -2};
				else
					item = {label: adaptiveOff, value: -2};
				dataProvider.replaceItemAt(item, dataProvider.length -1)
			}
		}
		
		[Bindable]
		public function get bitrateDetectionMessage():String
		{
			return _bitrateDetectionMessage;
		}
		
		/**
		 * The message that will be displayd as the tooltip when bitrate detection is in progress 
		 * @param value
		 * 
		 */		
		public function set bitrateDetectionMessage(value:String):void
		{
			_bitrateDetectionMessage = value;
		}
		
		[Bindable]
		public function get switchPausedMessage():String
		{
			return _switchPausedMessage;
		}
		
		/**
		 * The message that will be displayed as the tooltip when player is paused during switching process 
		 * @param value
		 * 
		 */		
		public function set switchPausedMessage(value:String):void
		{
			_switchPausedMessage = value;
		}
		
		
		/**
		 * On mouse rollover remove redundant listeners 
		 * @param event
		 * 
		 */		
		protected function onCBRollover(event:MouseEvent):void {
			_dropdownTimer.removeEventListener( TimerEvent.TIMER, hideDropdown );
		}
		
		/**
		 * Wait DROPDOWN_TIMER_DELAY milliseconds and close the dropdown   
		 * @param event
		 * 
		 */		
		protected function onCBRollout(event:MouseEvent):void {
			_dropdownTimer.addEventListener( TimerEvent.TIMER, hideDropdown, false, 0, true );
			_dropdownTimer.reset();
			_dropdownTimer.start();
		}
		
		private function onDropdownRollover(event:MouseEvent):void {
			_isOnDropdown = true;
		}
		
		private function onDropdownRollout(event:MouseEvent):void {
			_isOnDropdown = false;
		}
		
		/**
		 *  Handler for the TimerEvent indicating that the <code>_dropdownTimer</code> has finished counting down, and that the dropdown 
		 * needs to be closed.
		 * @param evt - TimerEvent
		 * 
		 */	
		public function hideDropdown( evt:TimerEvent=null ):void
		{
			_dropdownTimer.removeEventListener( TimerEvent.TIMER, hideDropdown );
			_dropdownTimer.reset();
			//close the dropdown only if we are not on the combo box or its dropdown
			if (!_isOnDropdown) {
				close();
			}
			
			
		}
		
		
		private function flavorLabelFunction (data : Object) : String
		{
			var labelLength : int = data.label.length-this.bitratePostFix.length;
			var preferedFlavorBitrate : int = parseInt(String(data.label).substr(0,labelLength));
			if(data == this.selectedItem && !kisOpen){ 
				if (!_flavorArray || !_flavorArray.length)
				{
					return "";
				}
				else if(isDynamic())
				{
					if (isAutoSwitch)
					{
						return autoString;
					}
				}
				
				/*if (usePixels)
				{
				var labelArr:Array = (data.label as String).split(" ");
				if (labelArr.length == 2)
				{
				return labelArr[0] + "\n" + labelArr[1] //prefix, new line, pixels 	
				}					
				}
				return data.label;*/
			}
			return data.label;
		}
		
		
		/////////////////////////////////////////////////////////////////
		/////////////////////PUBLIC METHODS//////////////////////////////
		/////////////////////////////////////////////////////////////////
		
		override public function initialize():void
		{
			if (_isRtmp)
			{
				this.selectedMessage = autoMessage;
			}
				
			else if (this.selectedItem)
			{
				this.selectedMessage = this.selectedItem.label;
			}
			
			_dropdownTimer = new Timer( DROPDOWN_TIMER_DELAY );
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
			
			var newDPArray:Array = new Array();
			
			if(_flavorArray && _flavorArray.length)
			{	
				var sortedFlavorArray:Array = (_flavorArray.concat());
				//descending sort of flavors according to bitrate
				sortedFlavorArray.sortOn("bitrate", Array.NUMERIC | Array.DESCENDING);
				var usedPixelsArr:Array;
				// will be true if "SD Low" label was already added to flavors list 
				var usedLowHeight:Boolean = false;
				if (usePixels)
				{
					//this array indicates if we already inserted the corresponding height to the data provider
					usedPixelsArr = new Array();
					for (var k:int = 0; k < HEIGHT_ARRAY.length; k++)
					{
						usedPixelsArr.push(false);
					}
				}
				
				for(var i:int=0; i<sortedFlavorArray.length; i++)
				{	
					var label:String;
					//find proper prefix according to BR
					var roundedBitrate : Number = (Math.round(Number(sortedFlavorArray[i].bitrate)/100))*100;
					var heightIndex:int = -1;
					if (usePixels)
					{
						//find closest pixels value:
						var height: int = sortedFlavorArray[i].height;
						
						for (var j:int = 0; j < HEIGHT_ARRAY.length; j++)
						{
							if (height == HEIGHT_ARRAY[j])
							{
								heightIndex = j;
								break;
							}
							if (HEIGHT_ARRAY[j]>height)
							{
								if (j==0)
								{
									heightIndex = -1;
									break;
								}	
								if ((height - HEIGHT_ARRAY[j-1]) > (HEIGHT_ARRAY[j] - height))
									heightIndex = j;
								else
									heightIndex = j-1;
								
								break;
							}
							else if (j==HEIGHT_ARRAY.length-1)
							{
								heightIndex = j;
							}
						}			
						
						if (heightIndex == -1)
						{
							label = lowHeight;
							//if we already inserted the "SD Low" label, don't insert another one
							if (usedLowHeight)
								continue;
							
							usedLowHeight = true;
						}
						else
						{
							label = HEIGHT_ARRAY[heightIndex] + pixelsPostFix;
							//if we already inserted such height, it was with heighest bitrate (the array is sorted), so we won't insert this value too
							if (usedPixelsArr[heightIndex])
								continue;
							
							usedPixelsArr[heightIndex] = true;
						}
						var prefix:String = (sortedFlavorArray[i].height > HD_LIMIT) ? hdPrefix : sdPrefix;
						label = prefix + label;
					}
					else
					{
						label = roundedBitrate + bitratePostFix;
					}
					
					newDPArray.push( { label: label, value: height, bitrate: roundedBitrate} );
				}
				
				if(isDynamic() )
					newDPArray.push({label : isAutoSwitch ? adaptiveAuto : adaptiveOff, value: -2, bitrate: -2});
				
				if (usePixels)
					newDPArray.sortOn("value", Array.NUMERIC | Array.DESCENDING); 	
			}
			else
			{
				return;
			}
			
			super.dataProvider = new DataProvider(newDPArray);
			dispatchEvent( new Event( DATA_PROVIDER_CHANGE ) );
			
			this.selectedIndex = dataProvider.length - 1;
			if (_preferedFlavorBR)
			{
				setSelectedItem(_preferedFlavorBR);
			}
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
			if(!dataProvider || !dataProvider.length || (preferedFlavor == _preferedFlavorBR)) 
				return;
			
			_preferedFlavorBR = (Math.round(Number(preferedFlavor)/100))*100;
			setSelectedItem(_preferedFlavorBR);
		}
		
		/**
		 * finds the item with the same bitrate and set it as the selected item 
		 * @param bitrate
		 * 
		 */		
		private function setSelectedItem(bitrate:int):void
		{
			var item:Object = getItemByBitrate(bitrate);
			if (item)
			{
				this.selectedItem = item;
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
			_isHttpStreaming = (_streamerType == StreamerType.HDNETWORK || _streamerType == StreamerType.HDNETWORK_HDS || _streamerType == StreamerType.HDS) ;
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
			if(isDynamic())
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
		
		/**
		 *The string for the message shown when the switch between bitrates is in process. 
		 */
		public function get switchingMessage():String
		{
			return _switchingMessage;
		}
		
		/**
		 * @private
		 */
		public function set switchingMessage(value:String):void
		{
			_switchingMessage = value;
		}
		
		public function determineEnabled (isSwitching:Boolean = false) : void
		{
			if (!this._flavorArray || !this._flavorArray.length || isSwitching)
			{
				this.enabled = false;
			}
			else
			{
				this.enabled = true;
				
				if (isDynamic())
				{
					this.selectedMessage = autoMessage;
				}
				else if (preferedFlavorBR != -1)
				{
					this.selectedMessage = this.selectedItem.label;
				}
			}
		}
		
		/**
		 * return the suitable item from the data provider, according to the given bitrate
		 * Saves the found index as "lastSelectedIndex"
		 * @param bitrate
		 * @return 
		 * 
		 */		
		public function getItemByBitrate(bitrate:int):Object
		{
			if(!dataProvider || !dataProvider.length)
				return null;
			
			//if we are in pixels mode represents the desired height
			var preferedHeight:int = -1;	
			if (usePixels)
			{
				//find the matching height of this flavor
				for (var j:int = 0; j< _flavorArray.length; j++)
				{
					if ((Math.round(Number(_flavorArray[j].bitrate)/100) * 100) == bitrate)
					{
						preferedHeight = _flavorArray[j].height;
						break;
					}
				}
			}
			
			for(var i:int=0; i<dataProvider.length; i++)
			{
				if (usePixels)
				{
					if (dataProvider.getItemAt(i).value == preferedHeight)
					{
						lastSelectedIndex = i;
						return dataProvider.getItemAt(i);
					}
					
				}
				else if(dataProvider.getItemAt(i).bitrate == bitrate)	
				{
					lastSelectedIndex = i;
					return dataProvider.getItemAt(i);
				}
			}
			
			return null;
		}
		
		private function isDynamic():Boolean 
		{
			return (_isRtmp || _isHttpStreaming || (Facade.getInstance().retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.forceDynamicStream)
		}
		
	}
}