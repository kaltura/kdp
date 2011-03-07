/**
 * KVolumeBar
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @author Dan Bacon / www.baconoppenheim.com
 */
package com.kaltura.kdpfl.view.controls
{
	
import com.kaltura.kdpfl.component.IComponent;
import com.kaltura.kdpfl.view.containers.KHBox;
import com.kaltura.kdpfl.view.containers.KVBox;
import com.yahoo.astra.fl.containers.layoutClasses.AdvancedLayoutPane;

import fl.controls.ScrollPolicy;
import fl.core.InvalidationType;
import fl.core.UIComponent;
import fl.events.SliderEvent;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.net.SharedObject;
import flash.utils.Timer;
import flash.utils.getDefinitionByName;


public dynamic class KVolumeBar extends UIComponent implements IComponent
{

//--------------------------------------
//  Events
//--------------------------------------

	// TODO update comment
	/**
	 * Dispatched when the user ...
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	static public const EVENT_CHANGE:String = "eventChange";

//--------------------------------------
//  Properties
//--------------------------------------

	public static const LAYOUT_MODE_HORIZONTAL:String = "horizontal";
	public static const LAYOUT_MODE_VERTICAL:String = "vertical";
	public static const ICON_BUTTON:String = "iconButton";
	
	[Bindable]
	public var color1:Number = -1;
	[Bindable]
	public var color2:Number = -1;
	[Bindable]
	public var color3:Number = -1;
	[Bindable]
	public var color4:Number = -1;
	[Bindable]
	public var color5:Number = -1;
	
	public var buttonType:String = "normal";
	public var verticalDistance:Number = 0;
	
	static private var SLIDER_TIMER_DELAY:Number = 600; // ms
	protected var _slider:KSlider;
	protected var _sliderBackground:DisplayObject;
	protected var _volumeSlider:Sprite;
	protected var _button:KButton;
	protected var _sliderContainer:Sprite;
	
	protected var _setSkinSize:Boolean;
	
	protected var _layoutMode : String = "vertical";
	
	protected var _volumeBarContainer : AdvancedLayoutPane;
	
	protected var _buttonHeight : Number;
	protected var _buttonWidth : Number;
	protected var _hasExpanded : Boolean;
	protected var _volumeSliderTimer:Timer;
	protected var _shouldHideSlider : Boolean = true;
	private var _saveValue : Boolean = false;
	private var _enable:Boolean = true;
	protected var _volume:Number = 0;
	protected var _unmutedVolume:Number = 0;

	protected static var defaultStyles:Object =
	{
		sliderThumbUpSkin: "VolumeBar_sliderThumbUp_default",
		sliderThumbOverSkin : "VolumeBar_sliderThumbOver_default", 
		sliderThumbDownSkin: "VolumeBar_sliderThumbDown_default",
		sliderThumbDisabledSkin: "VolumeBar_sliderThumbDisabled_default",
		sliderTrackSkin: "VolumeBar_sliderTrack_default",
		sliderTrackDisabledSkin: "VolumeBar_sliderTrackDisabled_default",
		sliderProgressSkin: "VolumeBar_sliderProgress_default",
		sliderBackgroundSkin: "VolumeBar_sliderBackground_default",
		sliderVerticalGap: 5,
		buttonUpSkin: "VolumeBar_buttonUp_default",
		buttonOverSkin: "VolumeBar_buttonOver_default",
		buttonDownSkin: "VolumeBar_buttonDown_default",
		buttonDisabledSkin: "VolumeBar_buttonDisabled_default",
		buttonSelectedUpSkin: "VolumeBar_buttonSelectedUp_default",
		buttonSelectedOverSkin: "VolumeBar_buttonSelectedOver_default",
		buttonSelectedDownSkin: "VolumeBar_buttonSelectedDown_default",
		buttonSelectedDisabledSkin: "VolumeBar_buttonSelectedDisabled_default",
		buttonUpIcon: "VolumeBar_buttonUpIcon_default",
		buttonSelectedUpIcon: "VolumeBar_buttonSelectedUpIcon_default",
		focusRectSkin:null,
		focusRectPadding:null
	}
	
	/**
     * @private (protected)
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	protected static const BUTTON_STYLES:Object =
	{
		upSkin: "buttonUpSkin",
		overSkin: "buttonOverSkin",
		downSkin: "buttonDownSkin",
		disabledSkin: "buttonDisabledSkin",
		selectedUpSkin: "buttonSelectedUpSkin",
		selectedOverSkin: "buttonSelectedOverSkin",
		selectedDownSkin: "buttonSelectedDownSkin",
		selectedDisabledSkin: "buttonSelectedDisabledSkin",
		icon: "buttonUpIcon",
		upIcon: "buttonUpIcon",
		overIcon: "buttonUpIcon",
		selectedUpIcon: "buttonSelectedUpIcon",
		selectedOverIcon: "buttonSelectedUpIcon",
		focusRectSkin:null,
		focusRectPadding:null		
	}
			
	/**
     * @private (protected)
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	protected static const SLIDER_STYLES:Object =
	{
		thumbUpSkin: "sliderThumbUpSkin",
		thumbOverSkin : "sliderThumbOverSkin", 
		thumbDownSkin: "sliderThumbDownSkin",
		thumbDisabledSkin: "sliderThumbDisabledSkin",
		sliderTrackSkin: "sliderTrackSkin",
		sliderTrackDisabledSkin: "sliderTrackDisabledSkin",
		progress: "sliderProgressSkin",
		tickSkin: null,
		focusRectSkin:null,
		focusRectPadding:null
	}			
	
//--------------------------------------
//  Constructor
//--------------------------------------	
	
	public function KVolumeBar()
	{
		super();
	}

//--------------------------------------
//  Public Methods
//--------------------------------------
	
	public static function getStyleDefinition():Object
	{ 
		return( defaultStyles );
	}	
	/**
	 * Override the timer 
	 */
	public function delay(value:String):void
	{
		SLIDER_TIMER_DELAY = Number(value);
	}

	public function setSkin( skinName:String, setSkinSize:Boolean=false ):void
	{
		var styleType:String;
		var styleName:String;
		
		_setSkinSize = setSkinSize;
		
		for( var current:String in defaultStyles )
		{
			if( defaultStyles[current] is String && verifyStyle(defaultStyles[current]) )
			{
				styleType = getStyleType( defaultStyles[current] );
				styleName = styleType + "_" + skinName;
				setStyle( current, styleName );
			}
			// else case of Number values like style sliderVerticalGap
			// or skin not verified (possibly display object class not loaded to mem)
		}
		
	}
	
	private function getStyleType( styleName:String ):String
	{
		var type:String = styleName = styleName.slice( 0, styleName.lastIndexOf('_') );
		return( type );
	}
	
	private function verifyStyle( name:String ):Boolean
	{
		try
		{
			var styleClass:Class = getDefinitionByName(name) as Class;
		}
		catch( e:Error )
		{
			// TODO return warning of style not found
			return( false );
		}
		return( true );
	}
	
	override public function setStyle( type:String, name:Object ):void
	{
		if( verifyStyle(name as String) )
			super.setStyle( type, name );
	}	
	
	/*public function initialize():void 
	{
	
	}*/
	
	public function init():void
	{
		sliderContainer.addChild( _volumeSlider );
		setVolume( 1 );
	}
	
	public function initialize():void
	{
		if (!height && width)
		{
			this.height = this.width;			
		}
		if (_layoutMode == LAYOUT_MODE_VERTICAL)
		{
			_volumeBarContainer = new KVBox();
		}
		
		else
		{
			_volumeBarContainer = new KHBox();
		}
		_volumeBarContainer.verticalScrollPolicy = ScrollPolicy.OFF;
		this.addChild(_volumeBarContainer);
		_volumeBarContainer.height = this._height;
		_volumeSliderTimer = new Timer( SLIDER_TIMER_DELAY );
		
		_volumeSlider = new Sprite();
		if (layoutMode == LAYOUT_MODE_VERTICAL)
			_volumeSlider.rotation = -90;
		if (_shouldHideSlider)
			_volumeSlider.visible = false;
		
		_slider = new KSlider();
		
		_slider.maximum = 1;
		_slider.minimum = 0;
		_slider.snapInterval = 0.01;
		_slider.liveDragging = true;
		_slider.addEventListener( MouseEvent.MOUSE_UP, onSliderClick, false, 0, true );
		_slider.addEventListener( SliderEvent.CHANGE, onSliderChange, false, 0, true );
		_volumeSlider.addChild( _slider );
		
		_button = new KButton();
		//if there is a button type definitoin - use dynamic appstudio colors
		_button.label = "";
		_button.toggle = true;
		_button.useHandCursor = true;
		_button.addEventListener( MouseEvent.CLICK, onButtonClick, false, 0, true );
		_volumeBarContainer.addChild( _button );
		
		
		if (_shouldHideSlider)
		{
			_volumeSlider.addEventListener( MouseEvent.MOUSE_OVER, onRollOver, false, 0, true );
			_volumeSlider.addEventListener( MouseEvent.MOUSE_OUT, onRollOut, false, 0, true );
			this.addEventListener( MouseEvent.MOUSE_OVER, onRollOver, false, 0, true );
			this.addEventListener( MouseEvent.MOUSE_OUT, onRollOut, false, 0, true );
		}

		this.addEventListener( Event.REMOVED, onRemoved, false, 0, true );
		this.addEventListener(Event.ADDED, onAdded, false,0,true);
	}
	
	private function onAdded (e : Event) : void
	{
		
		if( e.target==this && sliderContainer && (!sliderContainer.contains(_volumeSlider)))
		{
			sliderContainer.addChild( _volumeSlider ); 
			
		}
	}
	
	protected function onButtonClick( evt:MouseEvent ):void
	{
		var volumeCookie : SharedObject = SharedObject.getLocal("KalturaVolume");
		if( _button.selected )
		{
			_unmutedVolume = _volume;
			changeVolume( 0 );			
			volumeCookie.data.volume = _slider.value;
			volumeCookie.flush();
		}
		else
		{
			//there is no sense in setting the _unmutedVolume to 0 and then click unmute,
			//it can happen in auto mute so the next line resolve this issue.
			if(_unmutedVolume == 0) _unmutedVolume = 1;
			
			_volume = _unmutedVolume;
			changeVolume( _volume );			
			volumeCookie.data.volume = _slider.value;
			volumeCookie.flush();
		}
	}
	
	// TODO make volume slider visible with animation
	// TODO make rollover area all slider background (not only slider itself)
	protected function onRollOver( evt:MouseEvent ):void
	{
		if(_enable && this.enabled)
		{
			if (layoutMode == LAYOUT_MODE_HORIZONTAL && !_hasExpanded)
			{
				_hasExpanded = true;
				this.width += _volumeSlider.width;
			}
			_volumeSlider.visible = true;
			_volumeSliderTimer.removeEventListener( TimerEvent.TIMER, hideVolumeSlider );
		}
	}
	
	// TODO not hide volume bar if still dragging thumb (even if mouse roll out)
	protected function onRollOut( evt:MouseEvent ):void
	{
		if(this.enabled)
		{
			_volumeSliderTimer.addEventListener( TimerEvent.TIMER, hideVolumeSlider, false, 0, true );
			_volumeSliderTimer.reset();
			_volumeSliderTimer.start();
		}
	}
	
	protected function hideVolumeSlider( evt:TimerEvent=null ):void
	{
		_volumeSliderTimer.removeEventListener( TimerEvent.TIMER, hideVolumeSlider );
		_volumeSliderTimer.reset();
		if (layoutMode == LAYOUT_MODE_HORIZONTAL)
		{
			_hasExpanded = false;
			this.width -= _volumeSlider.width;
		}
		_volumeSlider.visible = false;
	}
	
	/**
     * @private (protected)
     *
     * Make sure to clean up _volumeSlider from its container incase
     * this VolumeBar is removed from the display lost.
     * 
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */	
	protected function onRemoved( evt:Event ):void
	{
		if( _volumeSlider && _volumeSlider.parent && evt.target===this )
		{
			_volumeSlider.parent.removeChild( _volumeSlider ); 
			
		}
			
	}
		
	override protected function draw():void
	{
		if(color1!=-1)
			_slider.color1 = color1;
		if(color2!=-1)
			_slider.color2 = color2;
		if( isInvalid(InvalidationType.STYLES,InvalidationType.STATE) )
		{
			setStyles();
			drawSliderBackground();
			invalidate( InvalidationType.SIZE, false );
		}
		if ( isInvalid(InvalidationType.SIZE) )
		{
			drawLayout();
		}
		if( isInvalid(InvalidationType.SIZE,InvalidationType.STYLES) )
		{
			if (isFocused && focusManager.showFocusIndicator) { drawFocus(true); }
		}
		
		if(buttonType == ICON_BUTTON)
		{
			_button.buttonType = ICON_BUTTON;
			_button.color1 = color1;
			_button.color2 = color2;
			_button.color3 = color3;
			_button.color4 = color4;
		}
		
		validate(); // because we're not calling super.draw		
	}
	
	/**
     * @private (protected)
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	protected function setStyles():void
	{
		copyStylesToChild( _button, BUTTON_STYLES );
		copyStylesToChild( _slider, SLIDER_STYLES );
		// override slider default height (hardcoded to 4)
		// to its track skin height
		var sliderTrackSkin:DisplayObject = getDisplayObjectInstance( getStyleValue("sliderTrackSkin"));
		_slider.height = sliderTrackSkin.height;
		_slider.width = sliderTrackSkin.width;
	}	
	
	/**
     * @private (protected)
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	protected function drawSliderBackground():void
	{
		var oldBackground:DisplayObject = _sliderBackground;
		_sliderBackground = getDisplayObjectInstance( getStyleValue("sliderBackgroundSkin") );
		
		_sliderBackground.y = -_sliderBackground.height/2;
		_volumeSlider.addChildAt( _sliderBackground, 0 );
	}
	
	protected function drawLayout():void
	{
		// find volume slider positioning (above button and centered)
		// relative to sliderContainer coords
		var p:Point;
		if (layoutMode == LAYOUT_MODE_HORIZONTAL)
		{
			p = new Point( buttonWidth +3, height/2 );
			p = this.localToGlobal( p );
			p = sliderContainer.globalToLocal( p );
			
			// slider positioned inside _volumeSlider container
			// slider width/height set on drawLayout to slider skin size
			_slider.x = Number( getStyleValue("sliderVerticalGap") );
			_slider.y = -_slider.height/2;
			
			_volumeSlider.y = p.y;
			_volumeSlider.x = p.x ;//-verticalDistance;
			
			
		}
		else
		{
			p = new Point( width/2, 0 );
			p = this.localToGlobal( p );
			p = sliderContainer.globalToLocal( p );
			
			// slider positioned inside _volumeSlider container
			// slider width/height set on drawLayout to slider skin size
			_slider.x = Number( getStyleValue("sliderVerticalGap") );
			_slider.y = -_slider.height/2;
			
			_volumeSlider.y = p.y-verticalDistance;
			_volumeSlider.x = p.x ;//-verticalDistance;
		}
		
		_button.height = buttonHeight ? buttonHeight : height;
		_button.width = buttonWidth ? buttonWidth : width;
	}

	public function set sliderContainer( container:Sprite ):void
	{
		if( !container ) return;
		_sliderContainer = container;
		invalidate( InvalidationType.SIZE );
	}
	
	public function get sliderContainer():Sprite
	{
		if( _sliderContainer )
			return( _sliderContainer );
		else
			return( this );
	}
	
	override public function set visible( value:Boolean ):void
	{
		super.visible = value;
		_volumeSlider.visible = value;
	}
	
	override public function set alpha( value:Number ):void
	{
		super.alpha = value;
		_volumeSlider.alpha = value;
	}


	// TODO add setters sliderHeight / slightWidth
	// TODO add setter sliderVerticalGap

	override public function set x( value:Number ):void
	{
		super.x = value;
		invalidate( InvalidationType.SIZE );
	}
	
	override public function set y( value:Number ):void
	{
		super.y = value;
		invalidate( InvalidationType.SIZE );
	}
	
	public function changeVolume( volume:Number ):void
	{
		setVolume( volume );
		
		if( volume == 0 ) 
			_button.selected = true;
		else
			_button.selected = false;
			
		var evt:Event = new Event( KVolumeBar.EVENT_CHANGE, true, true );
		this.dispatchEvent( evt );
	}
	
	public function getVolume():Number
	{
		return( _slider.value );
	}
			
	/**
	 * 
	 * @param value 0 -> 1 (2 decimal points)
	 * 
	 */	
	protected function setVolume( value:Number ):void
	{
		value = Math.max( 0, Math.min(value,1) );
		
		_volume = value;
		_slider.value = value;
	}
	

	
	protected function onSliderChange( evt:SliderEvent ):void
	{
		evt.stopPropagation();
		changeVolume( evt.value );
		if(_saveValue)
		{
			_saveValue = false;
			var volumeCookie : SharedObject;
			try
			{
				volumeCookie= SharedObject.getLocal("KalturaVolume");
			}
			catch (e : Error)
			{
				trace ("No access to user's file system");
			}
			if (volumeCookie)
			{
				volumeCookie.data.volume = _slider.value;
				volumeCookie.flush();
			}
		}
	}
	
	override public function set enabled(arg0:Boolean):void
	{
		_enable =  arg0;
		_button.enabled = arg0
		super.enabled = arg0;
	}
	private function onSliderClick (e:MouseEvent) : void
	{
		//Save the selected volume as a shared object (cookie) on the user's computer
		_saveValue = true;
	}

	[Bindable]
	/**
	 * The layout of the volume slider. Expect one of 2 values -"horizontal" or "vertical".
	 * Default is "vertical". 
	 * @return 
	 * 
	 */	
	public function get layoutMode():String
	{
		return _layoutMode;
	}

	public function set layoutMode(value:String):void
	{
		if (value != LAYOUT_MODE_HORIZONTAL && value != LAYOUT_MODE_VERTICAL)
		{
			value = LAYOUT_MODE_VERTICAL;
		}
		_layoutMode = value;
	}
	[Bindable]
	public function get buttonHeight():Number
	{
		return _buttonHeight;
	}

	public function set buttonHeight(value:Number):void
	{
		_buttonHeight = value;
	}
	[Bindable]
	public function get buttonWidth():Number
	{
		return _buttonWidth;
	}

	public function set buttonWidth(value:Number):void
	{
		_buttonWidth = value;
	}
	
	[Bindable]
	/**
	 * This attribute indicates whether the volume slider should always be visible,
	 * or disappear after the allocated amount of time from the mouse ROLLOUT event. 
	 * The default is <code>true</code>.
	 * @return 
	 * 
	 */	
	public function get shouldHideSlider():String
	{
		return _shouldHideSlider.toString();
	}

	public function set shouldHideSlider(value:String):void
	{
		if (value == "true")
		{
			_shouldHideSlider = true;
		}
		else
		{
			_shouldHideSlider = false;
		}
	}


}
}