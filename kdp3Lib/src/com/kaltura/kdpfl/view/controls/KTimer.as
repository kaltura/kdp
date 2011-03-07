/**
 * KTimer
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @author Dan Bacon / www.baconoppenheim.com
 */
package com.kaltura.kdpfl.view.controls
{

import com.kaltura.kdpfl.util.DateTimeUtils;

import flash.events.MouseEvent;
	

public dynamic class KTimer extends KLabel
{
	
	public var format:String = "mm:ss";
	
	private var _timerType:String = "both";
	private var currentTimerType:String = "";
	
	private var _time:Number;
	private var _duration:Number = 0;
	
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
	 * 
	 * @param time in seconds (decimal point)
	 * 
	 */		
	public function setTime( time:Number ):void
	{
		_time = time;
		updateText();
	}
		
	public function setDuration( duration:Number ):void
	{
		if(duration > 1){//if the changeDuration osmf event is bigger than 0 (due to Intelliseek side effects) , then update the duration
			_duration = duration;
			updateText();
		}
	}
	
	public function get timerType():String { return _timerType; }
	
	public function set timerType( timerType:String ):void
	{
		currentTimerType = _timerType = timerType;
		updateText();
	}
	
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