/**
 * Scrubber
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @author Dan X Bacon		baconoppenheim.com
 * @author Dwight Bridges 	astra.yahoo.com 
 */
package com.kaltura.kdpfl.view.controls 
{

import com.kaltura.kdpfl.component.IComponent;
import com.kaltura.kdpfl.util.KColorUtil;

import fl.controls.BaseButton;
import fl.core.InvalidationType;
import fl.core.UIComponent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getDefinitionByName;

/**
 * Class KScrubber 
 * 
 */
public dynamic class KScrubber extends UIComponent implements IComponent
{			

	static public const EVENT_SEEK:String 		= "seek";
	static public const EVENT_SEEK_START:String	= "seekStart";
	static public const EVENT_SEEK_END:String 	= "seekEnd";
	static public const EVENT_DRAG:String 		= "drag";
	static public const EVENT_DRAG_END:String 	= "dragEnd";
	
	public var color1:Number = -1;
	public var color2:Number = -1;
	
//--------------------------------------
//  Properties
//--------------------------------------

	/**
	 * @private (protected)
	 * background bar for the Scrubber
	 */
	protected var _durationIndicator:Sprite;
	
	/**
	 * @private (protected)
	 * bar indicating the percentage of the media that has loaded
	 */		
	protected var _loadIndicator:Sprite;

	/**
	 * @private (protected)
	 * bar indicating the progress of the media's playback
	 */
	protected var _progressIndicator:Sprite;

	/**
	 * @private (protected)
	 * knob used to seek the media
	 */
	protected var _thumb:BaseButton;

	/**
	 * @private (protected)
	 * hot spot for clicking to seek the media
	 */
	protected var _clickStrip:Sprite;
	
	/**
	 * Indicates if the scrubber thumb was clicked or not
	 */
	protected var _isDragging:Boolean;

	/**
	 * @private (protected)
	 * TODO  
	 * 
	 */
	protected var _duration:Number = 0;
	
	/**
	 * @private (protected)
	 * distance that the _scrubButton can travel  
	 * Equal to the _durationIndicator's width minus the _scrubButton
	 */
	protected var _range:Number;


	/**
	 * @private (protected)
	 * boolean indicating whether or not the user is scrubbing the media  
	 */
	protected var _scrubbing:Boolean;

	/**
	 * @private (protected)
	 * indicates the x coordinate of the _scrubButton that user pressed
	 */
	protected var _mouseDownX:Number;

	/**
	 * @private (protected)
	 * indicates the amount of space to the right of the cursor on the _scrubButton
	 */
	protected var _mouseDownRightPadding:Number;
	
	private var _allowMouseClicks : Boolean = true;
	
	/**
	 * @private
	 */
	protected static var defaultStyles:Object =
	{
		durationIndicatorSkin: "Scrubber_track_default",
		loadIndicatorSkin: "Scrubber_buffer_default",
		progressIndicatorSkin: "Scrubber_progress_default",
		thumbUpSkin: "Scrubber_thumbUp_default",
		thumbOverSkin: "Scrubber_thumbOver_default",
		thumbDownSkin: "Scrubber_thumbDown_default",
		thumbDisabledSkin: "Scrubber_thumbDisabled_default",
		focusRectSkin:null,
		focusRectPadding:null		
	};			

	/**
	 * @private 
	 */
	protected static var THUMB_STYLES:Object =
	{
		upSkin: "thumbUpSkin",
		downSkin: "thumbDownSkin",
		overSkin: "thumbOverSkin",
		disabledSkin: "thumbDisabledSkin"
//		selectedUpSkin: "thumbUpSkin",
//		selectedDownSkin: "thumbDownSkin",
//		selectedOverSkin: "thumbOverSkin"						
//		selectedDisabledSkin: "thumbDisabledSkin",
	}
	
	/**
	 * @private (protected)
	 * 
	 * 0->1
	 */
	protected var _loadProgress:Number = 0;
	
	/**
	 * @private (protected)
	 * TODO
	 */
	protected var _seekToLoaded:Boolean = false;
		
	/**
	 * @private (protected)
	 * TODO
	 */
	protected var _liveScrubbing:Boolean = true;

//--------------------------------------
//  Public Methods
//--------------------------------------

	/**
	 * Constructor
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	public function KScrubber()
	{
		super();
		_scrubbing = false;
		
		// load temp static scrubber skin
		// TODO remove
//		var _tempSkin:ScrubberTempSkin = new ScrubberTempSkin;
	}

	public static function getStyleDefinition():Object
	{ 
		return( defaultStyles );
	}	

	public function setSkin( skinName:String, setSkinSize:Boolean=false ):void
	{
		var styleType:String;
		var styleName:String;
		
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

	/**
     * @private (protected)
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	protected function setStyles():void
	{
		copyStylesToChild( _thumb, THUMB_STYLES );
	}
	
	public function initialize():void 
	{

	}
	
	override protected function configUI():void
	{
		super.configUI();
		_thumb = new BaseButton();
		addChild( _thumb );
		// the rest of the UI is added in draw since 
		// they are not based yet on UIComponents due 
		// to originating from astra scrubber component		
	}		

	override protected function draw():void
	{
		if( isInvalid(InvalidationType.STYLES, InvalidationType.STATE) )
		{
			// scrubber button added in configUI
			setStyles();
			drawDurationIndicator();
			drawLoadIndicator();
			drawProgressIndicator();
			
			_thumb.enabled = _enabled;
			this.mouseChildren = _enabled;
			this.mouseEnabled = _enabled;			
			
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
		validate(); // because we're not calling super.draw		
	}
	
	override public function set enabled(value:Boolean):void
	{
		super.enabled = value;
		this.mouseChildren = value;	
		if (enabled)
			this.alpha = 1;
		else
			this.alpha = 0.5;
	}
	
	/**
     * @private (protected)
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	protected function drawDurationIndicator():void
	{
		var oldIndicator:Sprite = _durationIndicator;
		_durationIndicator = getDisplayObjectInstance(getStyleValue("durationIndicatorSkin")) as Sprite;
		
		_durationIndicator.width = width+_thumb.width;
		addChildAt( _durationIndicator, 0 );
		
		if (oldIndicator!=null && oldIndicator!=_durationIndicator) { removeChild(oldIndicator); }		
	}
	
	/**
     * @private (protected)
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	protected function drawLoadIndicator():void
	{
		var oldIndicator:Sprite = _loadIndicator;
		_loadIndicator = getDisplayObjectInstance(getStyleValue("loadIndicatorSkin")) as Sprite;

		_loadIndicator.width = 0;
		addChildAt( _loadIndicator, 1 );
		
		if (oldIndicator!=null && oldIndicator!=_loadIndicator) { removeChild(oldIndicator); }		
	}
	
	/**
     * @private (protected)
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	protected function drawProgressIndicator():void
	{
		//trace(" >>>>>>>>>>> drawProgressIndicator")
		var oldIndicator:Sprite = _progressIndicator;
		var oldClickStrip:Sprite = _clickStrip;
		_progressIndicator = getDisplayObjectInstance(getStyleValue("progressIndicatorSkin")) as Sprite;

		_progressIndicator.width = 0;
		addChildAt(_progressIndicator, 2);
		
		_clickStrip = getDisplayObjectInstance(getStyleValue("progressIndicatorSkin")) as Sprite;
		_clickStrip.width = 0;
		_clickStrip.alpha = 0;
		if (_allowMouseClicks)
		{
			_clickStrip.buttonMode = true;
			_clickStrip.useHandCursor = true;		
			_clickStrip.addEventListener(MouseEvent.MOUSE_DOWN, clickStripHandler);
		}
		else
		{
			_clickStrip.buttonMode = false;
			_clickStrip.useHandCursor = false;
		}
		addChildAt(_clickStrip, 3);
				
		if (oldIndicator!=null && oldIndicator!=_loadIndicator)
		{
			removeChild( oldIndicator );
			removeChild( oldClickStrip );
		}		
	}
		
	protected function drawLayout():void
	{
		
		var thumbStyleName:String = getStyleValue( "thumbUpSkin" ) as String;
		var thumbStyle:Sprite = getDisplayObjectInstance( thumbStyleName ) as Sprite;
		_thumb.setSize( thumbStyle.width, thumbStyle.height );
		//_thumb.setSize( 1, thumbStyle.height );
		if( _seekToLoaded ) 
			_clickStrip.width = _loadIndicator.width = width;
		else
			_clickStrip.width = width;
			
		_durationIndicator.width = width;	
		_range = width - _thumb.width;
//		_progressIndicator.height = _durationIndicator.height =  _loadIndicator.height = height/4;
		_progressIndicator.y = _durationIndicator.y = _loadIndicator.y = (height - _durationIndicator.height)/2;
		_clickStrip.height = _durationIndicator.height;
		_clickStrip.y = _durationIndicator.y;
//		_scrubButton.height = _scrubButton.width = height/2;
		_thumb.y = (height - _thumb.height)/2;	
		_range = width - _thumb.width;
		// this displayobject is the buffering sprite
		if(_loadIndicator && color1!=-1)
			KColorUtil.colorDisplayObject(_loadIndicator , color1);

		// this displayobject is the track displayObject
  		if(_progressIndicator && color2!=-1)
			KColorUtil.colorDisplayObject(_progressIndicator , color2);   
	}
		
	/**
	 * @public
	 *
	 * @param value new playhead position in seconds 
	 */
	public function setPosition( value:Number ):void
	{
	 	// moves the _scrubButton and _progressIndicator to represent
	 	// the correct position of the media's playhead	
		if(!_scrubbing && _duration && _thumb) 
		{
			if(! isNaN( value/_duration * _range ) )
			{
				// prevent thumb x exceeding track range
				// any position values greater than duration will
				// be position thumb at maximum range of track
				var p:Number = value/_duration;
				p = Math.max( 0, Math.min(p,1) );
				_thumb.x = p * width;
				_progressIndicator.width = _thumb.x + _thumb.width/2;
			}
			else if(value == 0)
			{
				_thumb.x  = _progressIndicator.width = 0;
			}
		}
	}	
	
	public function getPosition():Number
	{
		return( _thumb.x/_range * _duration );
	}
	
	/**
	 * @public
	 *
	 * @param value duration of media in seconds
	 */
	public function set duration( value:Number ):void
	{
//		trace( this + " DURATION = " + value );
		_duration = ( value>=0 ? value : 0 );
	}
			
	public function get duration():Number
	{
		return( _duration );
	}
	
	/**
	 * @public
	 * 
	 * @param progress percentage 0 -> 1
	 */		
	public function setLoadProgress( progress:Number ):void
	{
		_loadProgress = progress = Math.min( 1, Math.max( progress, 0 ));
		if(_loadIndicator)
		{
			_loadIndicator.width = progress*width;	
			if( _seekToLoaded ) _clickStrip.width = _loadIndicator.width;
		}	
	}
	
	/**
	 * @public
	 * 
	 * @param value
	 */
	public function set seekToLoaded( value:Boolean ):void
	{
		_seekToLoaded = value;
		
		if( _seekToLoaded )
			_clickStrip.width = _loadIndicator.width;
		else
			_clickStrip.width = width;
	}
	
	public function get seekToLoaded():Boolean
	{
		return( _seekToLoaded );
	}		
	
	public function set liveScrubbing( value:Boolean ):void
	{
		_liveScrubbing = value;
	}	
	
	public function get liveScrubbing():Boolean
	{
		return( _liveScrubbing );
	}
	
    //--------------------------------------
    //  Protected Methods
    //--------------------------------------
	
	/**
	 * @private (protected)
	 *
	 * @param event MouseEvent
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	protected function clickStripHandler(event:MouseEvent):void
	{
		//move the _scrubButton to the area that was pressed
		//move the _progress indicator to the area that was pressed
		//pass event to the scrubButtonMouseHandler			
		scrubButtonMouseDownHandler(event);
	}		
	
	/**
	 * @private (protected)
	 *
	 * @param event MouseEvent
	 */		 
	protected function scrubButtonMouseDownHandler(event:MouseEvent):void
	{
	 	//check if this is a track click or a button click
	 	//if(event.target is BaseButton)
	 		_isDragging = true;
			var evtDragStart:Event = new Event( KScrubber.EVENT_DRAG, true, true );
			this.dispatchEvent( evtDragStart );	
		var evt:Event = new Event( KScrubber.EVENT_SEEK_START, true, true );
		this.dispatchEvent( evt );

		_thumb.x = Math.max(0, Math.min(_range, mouseX - (_thumb.width/2)));
		_progressIndicator.width = _thumb.x + _thumb.width/2;

	 	//set _scrubbing to true
	 	//set the value of _mouseDownX and _mouseDownRightPadding
	 	//pause the media through the controller
	 	//add MOUSE_UP and MOUSE_MOVE listeners	
	 	
		
		_scrubbing = true;
		_mouseDownX = _thumb.mouseX;
		_mouseDownRightPadding = _thumb.width - _mouseDownX;

		evt = new Event( KScrubber.EVENT_SEEK, true, true );
		this.dispatchEvent( evt );
		
		this.stage.addEventListener(MouseEvent.MOUSE_UP, scrubButtonMouseUpHandler, false, 0, true);
		this.stage.addEventListener(MouseEvent.MOUSE_MOVE, scrubButtonMouseMoveHandler, false, 0, true);
		
	}

	/**
	 * @private (protected)
	 *
	 * @param event MouseEvent
	 */	
	protected function scrubButtonMouseUpHandler(event:MouseEvent):void
	{
		//send the stopDrag notification only if this was a drag 
		//action - not in track click
		if (_isDragging)
		{
			_isDragging = false;
			var evtStopDrag:Event = new Event( KScrubber.EVENT_DRAG_END, true, true );
			this.dispatchEvent( evtStopDrag );
		}
		//set _scrubbing to false
		//remove the MOUSE_UP and MOUSE_DOWN listeners 
		//seek the media through the controller			
		_scrubbing = false;
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, scrubButtonMouseUpHandler);
		this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrubButtonMouseMoveHandler);
		
		if( !liveScrubbing )
		{
			var evt:Event = new Event( KScrubber.EVENT_SEEK, true, true );
			this.dispatchEvent( evt );
		}
		evt = new Event( KScrubber.EVENT_SEEK_END, true, true );
		this.dispatchEvent( evt );
	}
	
	/**
	 * @private (protected)
	 *
	 * @param event MouseEvent
	 */	
	protected function scrubButtonMouseMoveHandler(event:MouseEvent):void
	{
	 	//attached to the MOUSE_MOVE event of the _scrubButton
	 	//moves the _scrubButton and adjusts the _progressIndicator with the position of the mouse

		if( _seekToLoaded )			
			_thumb.x = Math.max(0, Math.min((_loadIndicator.width - _thumb.width), (mouseX - _mouseDownX)));
		else
			_thumb.x = Math.max(0, Math.min((width - _thumb.width), (mouseX - _mouseDownX)));
			
		_progressIndicator.width = _thumb.x + _thumb.width/2;
		event.updateAfterEvent();
		
		if( liveScrubbing )
		{
			var evt:Event = new Event( KScrubber.EVENT_SEEK, true, true );
			this.dispatchEvent( evt );
		}
	}
	
	
	public function get allowMouseClicks():String
	{
		return _allowMouseClicks.toString();
	}
	[Bindable]
	public function set allowMouseClicks(value:String):void
	{
		_allowMouseClicks = (value == "true") ? true : false;
		
		if (_allowMouseClicks)
		{
			_thumb.useHandCursor = true;
			_thumb.addEventListener(MouseEvent.MOUSE_DOWN, scrubButtonMouseDownHandler);
			
		}
		else
		{
			_thumb.useHandCursor = false;
			if (_thumb.hasEventListener(MouseEvent.MOUSE_DOWN) )
				_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, scrubButtonMouseDownHandler);
		}
		
		
	}
	/**
	 * Override of the scrubber's width setter - overridden so the scrubber will be resized on fullscreen
	 * even if the player is paused. 
	 * @param value - new width.
	 * 
	 */	
	override public function set width(value:Number):void
	{
		
		if (value && value != super.width)
		{
			if (this._clickStrip)
			{
				this._clickStrip.width = this._clickStrip.width*(value/super.width);	
			}
			
			if (this._loadIndicator)
			{
				this._loadIndicator.width = this._loadIndicator.width*(value/super.width);
			}
			
			if (this._progressIndicator)
			{
				this._progressIndicator.width = this._progressIndicator.width*(value/super.width);
			}
			super.width = value;
		}
	}
	
	

}	
}