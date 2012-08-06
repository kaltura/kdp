package com.kaltura.kdpfl.view.controls
{

import com.kaltura.kdpfl.util.DateTimeUtils;

import flash.events.MouseEvent;
	
/**
 * Class representing the timers used by the KDP
 * @author Hila
 * 
 */
public dynamic class KTimer extends KLabel
{
	
	public var format:String = "mm:ss";
	
	private var _timerType:String = "both";
	private var currentTimerType:String = "";
	
	private var _time:Number;
	private var _duration:Number = 0;
	/**
	 * C-tor 
	 * 
	 */	
	public function KTimer()
	{
		super();
	}
	
	override public function initialize():void
	{
		addEventListener(MouseEvent.CLICK, onClick);
		//this.mouseChildren = false;
		this.mouseEnabled = false;

		setTime( 0 );
	}
	/**
	 *  Handler for mouse click on the timer. If timer is of type "both" (can show both ascending and descending time),
	 * the timer will switch to the opposite mode on mouse click.
	 * @param e - MouseEvent of type CLICK
	 * 
	 */	
	private function onClick(e:MouseEvent):void
	{
		if (_timerType == "both")
		{
			currentTimerType = currentTimerType == "" ? "backwards" : "";
			updateText();			
		}
	}

	/**
	 * Prevent direct access to KLabel.text
	 */		
	override public function set text( value:String ):void {}
	
	/**
	 * Updates the time shown by the Timer.
	 * @param time in seconds (decimal point)
	 * 
	 */		
	public function setTime( time:Number ):void
	{
		_time = time;
		updateText();
	}
	/**
	 * Updates the duration the Timer can count up to (or down from).
	 * @param duration
	 * 
	 */		
	public function setDuration( duration:Number ):void
	{
		if(duration > 1){//if the changeDuration osmf event is bigger than 0 (due to Intelliseek side effects) , then update the duration
			_duration = duration;
			updateText();
		}
	}
	/**
	 * reset duration to 0 
	 * 
	 */	
	public function resetDuration () : void
	{
		_duration = 0;
		updateText();
	}
	/**
	 * controls the type of the timer. There are 2 possible types: "both" for a timer that can show both ascending and descending time, and 
	 * "backwards", which can only show descending time. 
	 * @return 
	 * 
	 */	
	public function get timerType():String { return _timerType; }
	
	public function set timerType( timerType:String ):void
	{
		currentTimerType = _timerType = timerType;
		updateText();
	}
	/**
	 * This function updates the time text shown by the timer. 
	 * 
	 */	
	private function updateText():void
	{
		var formattedTime:String = "";
		
		switch(currentTimerType)
		{
			case "total":
				formattedTime = DateTimeUtils.formatTime( _duration, format );
			break;
			
			case "backwards":
				var diff:Number =_duration - _time;
				var pre:String = "-";
				if (diff <= 0)
				{
					diff = 0;
					pre = "";
				}
				formattedTime =  DateTimeUtils.formatTime( diff, format );
			break;
			
			default:
				formattedTime = DateTimeUtils.formatTime( _time, format );
		}
		
		super.text = formattedTime; 
	}
}
}