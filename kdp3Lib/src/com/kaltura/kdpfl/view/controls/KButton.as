package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.component.IComponent;
	import com.kaltura.kdpfl.style.FontManager;
	import com.kaltura.kdpfl.style.TextFormatManager;
	import com.kaltura.kdpfl.util.KColorUtil;
	import com.yahoo.astra.fl.controls.containerClasses.AutoSizeButton;
	
	import fl.events.ComponentEvent;
	
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Class KButton is the default class for a button in the KDP GUI.
	 * @author Eitan
	 * 
	 */	
	[Bindable]
	public dynamic class KButton extends AutoSizeButton implements IComponent
	{
		// text format 
		private var tf:TextFormat;
		private var currentTf:TextFormat;
		private var iconWidth:int = 0;
		private var iconHeight:int = 0;
		private var recalcSize:Boolean = false;
		private var changeTextformatOnce:Boolean;
		private var _alwaysDisabled:Boolean = false;
		private var _origIcon : DisplayObject;
		private var _allowDisable : Boolean = true;	
		private var _minWidth:Number = 0;
		private var _minHeight:Number = 0;
		private var _maxWidth:Number = 100000;
		private var _maxHeight:Number= 100000;
		private var _origWidth:Number=0;
		private var _origHeight:Number=0;
		
		/**
		 * Constant representing type of button that has an icon.
		 */		
		public static const ICON_BUTTON:String = "iconButton";
		/**
		 * Constant representing type of button that has an label (text).
		 */		
		public static const LABEL_BUTTON:String = "labelButton";
		/**
		 * Constant representing type of button that appears on the video area.
		 */		
		public static const ON_SCREEN:String = "onScreenButton";
			
		public static const NORMAL:String = "normal";
		
		public var color1:uint;
		public var color2:uint;
		public var color3:uint;
		public var color4:uint;
		public var color5:uint;
		public var font:String;
		public var textPadding:String;
		public var buttonType:String = NORMAL ;
		public var upTooltip : String = "";
		public var selectedTooltip : String = "";
	
		
		public var showSkin:String = "false";
		
		private var setSkinSize:Boolean;

		/**
		 * Constructor 
		 * 
		 */		
		public function KButton()
		{
			super();
			width = 1;
			height = 1;
			useHandCursor = true;
			setSkin("default");
			this.label = ""; //clear the default "Label"
			super.setStyle("focusRectPadding",0);
			
		}

		public function initialize():void
		{
			this.buttonMode = true;
			
			if (upTooltip.length == 0 && selectedTooltip.length != 0)
			{
				upTooltip = selectedTooltip;
			}
			else if (upTooltip.length != 0 && selectedTooltip.length == 0)
			{
				selectedTooltip = upTooltip;
			}
			else if (upTooltip.length == 0 && selectedTooltip.length == 0)
			{
				upTooltip = tooltip;
				selectedTooltip = tooltip;	
			}
			
			this.tooltip = upTooltip;
			if (this.accessibilityName != null || this.accessibilityDesc != null)
			{
				var accessProps:AccessibilityProperties = new AccessibilityProperties();
				accessProps.name = (this.accessibilityName == null ? "" : this.accessibilityName);
				accessProps.description = (this.accessibilityDesc == null ? "" : this.accessibilityDesc);
				accessibilityProperties = accessProps;
			}
		}
		
		//////////////////////////////////////////////////////////////////////
		
		/**
		 * Function associates different button states with specific skins. 
		 * @param styleName - the state of the button to set the skin for.
		 * @param setSkinSize - flag signifying whether to set the button size according to the size of the skin.
		 * 
		 */			
		public function setSkin( styleName : String , setSkinSize : Boolean = true) : void
		{
			this.setSkinSize = setSkinSize;
			//skins
			setStyle("upSkin", "Button_upSkin_" + styleName);
 			setStyle("overSkin", "Button_overSkin_" + styleName);
			setStyle("downSkin", "Button_downSkin_" + styleName);
			setStyle("emphasizedSkin", "Button_emphasizedSkin_" + styleName);
			setStyle("disabledSkin", "Button_disabledSkin_" + styleName); 
 			setStyle("selectedUpSkin", "Button_selectedUpSkin_" + styleName);
			setStyle("selectedOverSkin", "Button_selectedOverSkin_" + styleName);
			setStyle("selectedDownSkin", "Button_selectedDownSkin_" + styleName);
			setStyle("selectedDisabledSkin", "Button_selectedDisabledSkin_" + styleName); 
			setStyle("emphasizedUpSkin", "Button_emphasizedUpSkin_" + styleName);
			setStyle("emphasizedOverSkin", "Button_emphasizedOverSkin_" + styleName);
			setStyle("emphasizedDownSkin", "Button_emphasizedDownSkin_" + styleName);
			setStyle("emphasizedDisabledSkin", "Button_emphasizedDisabledSkin_" + styleName); 
			setStyle("emphasizedSelectedUpSkin", "Button_emphasizedSelectedUpSkin_" + styleName);
			setStyle("emphasizedSelectedOverSkin", "Button_emphasizedSelectedOverSkin_" + styleName);
			setStyle("emphasizedSelectedDownSkin", "Button_emphasizedSelectedDownSkin_" + styleName);
			setStyle("emphasizedSelectedDisabledSkin", "Button_emphasizedSelectedDisabledSkin_" + styleName); 
			// buttons icons
			setStyle("upIcon", "Button_upIcon_" + styleName);
			setStyle("overIcon", "Button_overIcon_" + styleName);
			setStyle("downIcon", "Button_downIcon_" + styleName);
			setStyle("emphasizedIcon", "Button_emphasizedIcon_" + styleName);
			setStyle("disabledIcon", "Button_disabledIcon_" + styleName);
			setStyle("selectedUpIcon", "Button_selectedUpIcon_" + styleName);
			setStyle("selectedOverIcon", "Button_selectedOverIcon_" + styleName);
			setStyle("selectedDownIcon", "Button_selectedDownIcon_" + styleName);
			setStyle("selectedDisabledIcon", "Button_selectedDisabledIcon_" + styleName);
			setStyle("emphasizedUpIcon", "Button_emphasizedUpIcon_" + styleName);
			setStyle("emphasizedOverIcon", "Button_emphasizedOverIcon_" + styleName);
			setStyle("emphasizedDownIcon", "Button_emphasizedDownIcon_" + styleName);
			setStyle("emphasizedDisabledIcon", "Button_emphasizedDisabledIcon_" + styleName);
			setStyle("emphasizedSelectedUpIcon", "Button_emphasizedSelectedUpIcon_" + styleName);
			setStyle("emphasizedSelectedOverIcon", "Button_emphasizedSelectedOverIcon_" + styleName);
			setStyle("emphasizedSelectedDownIcon", "Button_emphasizedSelectedDownIcon_" + styleName);
			setStyle("emphasizedSelectedDisabledIcon", "Button_emphasizedSelectedDisabledIcon_" + styleName);
			// buttons labels styling
			formatFont("Button_Label_default");
			if(styleName)
				formatFont("Button_Label_" + styleName);
			
			if(setSkinSize)
				setDefaultSize( "Button_upSkin_" + styleName);
			// text padding (for Icon & label)
			if(textPadding)	
				super.setStyle("textPadding", Number(textPadding));
				
		}
		 
		/**
		 * Get a class from given argument, and try to load the label from 
		 * it. 
		 */
		private function formatFont(fontClassName:String):void
		{
			tf = TextFormatManager.getInstance().getTextFormat( fontClassName );
			
			setFont();
				
			//forcing the label to get the 1st color if this is a label button
			if(buttonType == LABEL_BUTTON)
			{
				tf.color = color1;
			}
			
			super.setStyle( "textFormat", tf );
			super.setStyle( "disabledTextFormat", tf );
			
			recalcSize = true;
			draw();
		}
		
		private function setFont() : void
		{
			var item : Font = FontManager.getInstance().getEmbeddedFont( font );
			if(item)
				tf.font = item.fontName;
			else
				tf.font = font;
		}
		
		/**
		 * set the pre assign textformat to the textfield
		 */
		private function formatFontLater(evt:Event):void
		{
			removeEventListener(Event.ENTER_FRAME , formatFontLater);
			setFont();
			super.setStyle("textFormat",tf);
			super.setStyle("disabledTextFormat",tf);
			if(!changeTextformatOnce)
			{
				recalcSize = true;
				draw();
				changeTextformatOnce = true;
			}
			textField.setTextFormat(tf);
		} 
		
		/**
		 * This override is to try and improve the label positioning and buttons width 
		 */
		override public function set label(value:String):void
		{
			super.label = value;
			recalcSize = true;
			draw();
		}
		
		/**
		 * This override is to fix the autosize button and label bug
		 */
		override protected function draw():void
		{
			if (recalcSize)
			{
				recalcSize = false;
				this.textField.text = this._label;
		
				var tempWidth:Number = this.textField.width + (this.getStyleValue("textPadding") as Number) * 2;
				var tempHeight:Number = this.textField.height + (this.getStyleValue("textPadding") as Number) * 2;
				
				if (this.labelPlacement == "top" || this.labelPlacement == "bottom")
				{
					tempHeight += iconHeight;
					tempHeight+=(this.getStyleValue("textPadding") as Number);
				}
				else
					tempWidth += iconWidth;
				//setting max width/height
				width = Math.max(tempWidth , _minWidth);
				height = Math.max(tempHeight,_minHeight); 
				
				//setting min width/height
				width = Math.min(width , _maxWidth);
				height = Math.min(height , _maxHeight);
				
				
				if(this.textField.text != this._label)
					this.dispatchEvent(new ComponentEvent(ComponentEvent.LABEL_CHANGE));
			}

			if (tf != currentTf)
			{
				currentTf = tf;
/* 				if(font)
				{
					tf.font = font;
				} */
				setFont();
					
 				textField.setTextFormat(tf);
				addEventListener(Event.ENTER_FRAME , formatFontLater); 	 
			}
			
			
			super.draw();
			var itemClassName:String;
			var i:uint;
			var child:DisplayObject; 
			//fix minimum 24 pix icon bug. TODO check if this os OK 
			if (width==24)
			{
				for (i = 0 ; i<this.numChildren ; i++)
				{
					//get current child from all childrens
					itemClassName = getQualifiedClassName(getChildAt(i));
					child = getChildAt(i);
					// find the icon. 
					if(itemClassName.indexOf("con") > -1)
					{
						width = child.width; 
					}				
				}					
			}			
			//setMinMaxDImentions();
			// setting buttons behavior 
			switch (buttonType)
			{
				case ICON_BUTTON:
				case LABEL_BUTTON:
				// this is a button on the controller - with just an icon, no label
				
				for ( i = 0 ; i<this.numChildren ; i++)
				{
					//get current child from all childrens
					itemClassName = getQualifiedClassName(getChildAt(i));
					child = getChildAt(i);
					// find the icon or the textfield
					if(itemClassName.indexOf("con") > -1 || itemClassName.indexOf("ext") > -1)
					{
						if(mouseState == "over" || mouseState == "down")
						{
							KColorUtil.colorDisplayObject(child,color2);
							if (buttonType == ICON_BUTTON)
							{
								child.alpha =2 ;
							}
						}
						else
						{
							KColorUtil.colorDisplayObject(child,color1);
							if (buttonType == ICON_BUTTON)
							{
								child.alpha = 1 ;
							}					
							
						}
					}				
					//found a skin - hide it
					if(itemClassName.indexOf("kin") > -1 && buttonType == ICON_BUTTON )
					{
						if (showSkin != "true")
							child.alpha = 0;
					}				
				}
				break;

				// this is an on screen video button 
				case ON_SCREEN:
					for ( i = 0 ; i<this.numChildren ; i++)
						{
						itemClassName = getQualifiedClassName(getChildAt(i))
						child = getChildAt(i);
						// find the icon and the textfield
						if(itemClassName.indexOf("con") > -1 || itemClassName.indexOf("ext") > -1)
						{
							KColorUtil.colorDisplayObject(child,color5);
							if(itemClassName.indexOf("con") > -1)
							{
								child.alpha = 2;
							}
						}	
						//found a skin - up is color 3, over is color 4
						if(itemClassName.indexOf("kin") > -1)
						{
							if(mouseState == "over")
								KColorUtil.colorDisplayObject(child,color4);
							else
								KColorUtil.colorDisplayObject(child,color3);
							
						}
					}
				break;
			}
		}
		
		/**
		 * if the component doesn't have defualt hight or width set to the size of the skin 
		 * @param skin
		 * 
		 */		
		private function setDefaultSize( skin:String ):void
		{
			try
			{
				var cls:Class = getDefinitionByName(skin) as Class;
				var mc:MovieClip = new cls();
				this.width = Math.max(mc.width , _minWidth)
				this.height = mc.height;
			}catch(ex:Error){}
		}
		
		override public function setStyle(type:String, name:Object):void
		{
			try{
				var cls:* = getDefinitionByName(name.toString()) as Class;
				if (type == "upIcon")
				{
					var mc:MovieClip = new cls as MovieClip;
					iconWidth = Math.max(iconWidth, mc.width);
					iconHeight = Math.max(iconHeight, mc.height);
					recalcSize = true;
 				}
				super.setStyle(type, name);
			}catch(e:Error){
				//trace('couldnt');
			}
		}
		
		/**
		 * Setter for the <code>_minWidth</code> property. This property exsits to ensure that the button in question
		 * maintains form with the buttons around it. 
		 * @param value - the minimum required width of the button.
		 * 
		 */		
		public function get minWidth():Object
		{
			return _minWidth;
		}
		/**
		 * @private
		 */		
		public function set minWidth(value:Object):void
		{
			_minWidth = Number(value);
		}
		
		/**
		 * Setter for the <code>_minHeight</code> property. This property exists to ensure that the button in question
		 * maintains form with the buttons around it. 
		 * @param value - the minimum required height of the button.
		 * 
		 */	
		public function get minHeight():Object
		{
			return _minHeight;
		}
		/**
		 * @private
		 */
		public function set minHeight(value:Object):void
		{
			_minHeight = Number(value);
			setMinMaxDImentions();
		}
		/**
		 * Setter for the <code>_maxWidth</code> property. This property exists to ensure that the button in question
		 * maintains form with the buttons around it. 
		 * @param value - the maximum required width of the button.
		 * 
		 */	
		public function get maxWidth():Object
		{
			return _maxWidth;
		}
		/**
		 * @private
		 */
		public function set maxWidth(value:Object):void
		{
			_maxWidth = Number(value);
			setMinMaxDImentions();
		}
		
		/**
		 * Setter for the <code>_maxHeight</code> property. This property exists to ensure that the button in question
		 * maintains form with the buttons around it. 
		 * @param value - the maximum required height of the button.
		 * 
		 */	
		public function get maxHeight():Object
		{
			return _maxHeight;
		}
		/**
		 * @private
		 */
		public function set maxHeight(value:Object):void
		{
			_maxHeight = Number(value);
			setMinMaxDImentions();
		}
		
		/**
		 * handle min/max width/height dimenssions if they were changed
		 */
		private function setMinMaxDImentions():void
		{
			if (_minWidth && width < _minWidth)
			{
				width = _minWidth;
			}
			if (_maxWidth && width > _maxWidth)
			{
				width = _maxWidth;
			}
			if (_minHeight && height < _minHeight)
			{
				height = _minHeight;
			}
			if (_maxHeight && height > _maxHeight)
			{
				height = _maxHeight;
			}
		}
		
		public function set isSelected (value : String):void
		{
			if(!enabled)
			{
			 	enabled=true;
			 	var check : Boolean = true;
			}
			if(value == "true")
			{
				selected = true;	
			}else{
				selected = false;
			} 
			if(check) enabled = false;
				
		}
		
		public function get isSelected () :String
		{
			return selected.toString();
		}
		
		
		public function set mouseEnable (value : String) : void
		{
			if(value == "true" ){
				mouseEnabled = true;
			}else{
				mouseEnabled = false;
			}
			_alwaysDisabled = true;
		}
		public function get mouseEnable () : String
		{
			return mouseEnabled.toString();
		}
		
		override public function set mouseEnabled(enabled:Boolean):void
		{
			if(!_alwaysDisabled)
			{
				super.mouseEnabled = enabled;
			}
		}
		
		/**
		 * Override ofthe <code>selected</code> proeprty setter, in order to iclude the possibility that bthe button shows different tooltips
		 * when it is in selected/unselected states. 
		 * @param arg0 - <code>true</code> if the button is selected, <code>false</code> otherwise.
		 * 
		 */		
		override public function set selected(arg0:Boolean):void
		{
			super.selected = arg0;
			if( this.selectedTooltip && this.upTooltip){
				if ( selected )
					this.tooltip = this.selectedTooltip;
				else
					this.tooltip = this.upTooltip;
			}	
		}
		
		/**
		 * Setter for the <code>allowDisable</code> property. 
		 * @param value - <code>true</code> if the button can be disabled; <code>false</code> otherwise.
		 * 
		 */		
		public function set allowDisable (value : String) : void
		{
			if (value == "true")
				_allowDisable = true;
			else
				_allowDisable = false;
		}

		public function get allowDisable () : String
		{
			return _allowDisable.toString();	
		}
		
		/**
		 * Override the <code>enabled<code> property setter, to include the case where a button must not be disabled
		 * even in the case of a type-FULL GUI disable. 
		 * @param arg0
		 * 
		 */		
		override public function set enabled(arg0:Boolean):void
		{
			if (!arg0)
			{
				if (_allowDisable)
				{
					super.enabled = arg0;
					this.alpha = 0.3;
				}
			}
			else
			{
				super.enabled = arg0;
				this.alpha = 1;
			}
		}
		override protected function getStyleValue(name:String):Object
		{
			var emphasizedImages:Array = new Array ("upIcon", "overIcon", "downIcon", "disabledIcon",
				"selectedUpIcon", "selectedOverIcon", "selectedDownIcon", "selectedDisabledIcon",
				"upSkin", "overSkin", "downSkin", "disabledSkin",
				"selectedUpSkin", "selectedOverSkin", "selectedDownSkin", "selectedDisabledSkin");
			
			var emphasizedStyleName : String;
			if (this.emphasized && emphasizedImages.indexOf(name) > -1)
			{
				emphasizedStyleName = "emphasized" + name.substr(0, 1).toUpperCase() + name.substr(1);
			}
			
			var emphasizedStyle : Object = super.getStyleValue (emphasizedStyleName);
			
			if (!emphasizedStyle)
			{
				return super.getStyleValue( name);
			}
			
			return emphasizedStyle;
			
		}
		
		override protected function focusInHandler(event:FocusEvent):void
		{
			emphasized = true;
		}
		override protected function focusOutHandler(event:FocusEvent):void
		{
			emphasized = false;
		}


	}
}