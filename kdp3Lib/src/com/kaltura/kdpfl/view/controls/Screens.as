package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.component.IComponent;
	import com.kaltura.kdpfl.view.containers.KCanvas;
	
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.events.ResizeEvent;

	public dynamic class Screens extends KCanvas implements IComponent
	{
		//strings of screens names (id)
		public var startScreenId:String="";
		public var startScreenOverId:String="";
		public var playScreenId:String="";
		public var playScreenOverId:String="";
		public var pauseScreenId:String="";
		public var pauseScreenOverId:String="";
		public var endScreenId:String="";
		public var endScreenOverId:String="";

		//instances
		private var _start_screen:UIComponent;
		private var _start_screen_over:UIComponent;
		private var _play_screen:UIComponent;
		private var _play_screen_over:UIComponent;
		private var _pause_screen:UIComponent;
		private var _pause_screen_over:UIComponent;
		private var _end_screen:UIComponent;
		private var _end_screen_over:UIComponent;

		private var screensObject:Object;
		private var screensArray:Array = new Array();
		private var _isOver:Boolean;
		private var _currentStateName:String;
		private var _currentScreen:UIComponent;

		private var _emptyUiComponent:UIComponent = new UIComponent();

		//duration to go back to non hover stats
		private var _timer:Timer;
		public var hoverTimeout:Number = 1200;

		public var mouseOverTarget:UIComponent;

		public function Screens()
		{
			super();
		}

		public function initScreens(o:Object):void
		{
			screensObject = o;
			setSkin("clickThrough",true); //make this module transparent and click trough
			mouseEnabled = false;
			// the array holds array trios: [0] will hold the name of the displayObject that
			// will hold the given UIconf, and [1] will hold the variable that has the name
			// value of the screen. [2] will be the state change to listen to
			//this array is saving a VO type
			screensArray.push(['_start_screen',startScreenId,ScreensMediator.KDP_STARTED]);
			screensArray.push(['_start_screen_over',startScreenOverId,ScreensMediator.KDP_STARTED+"_over"]);
			screensArray.push(['_play_screen',playScreenId,ScreensMediator.KDP_PLAYED]);
			screensArray.push(['_play_screen_over',playScreenOverId,ScreensMediator.KDP_PLAYED+"_over"]);
			screensArray.push(['_pause_screen',pauseScreenId,ScreensMediator.KDP_PAUSED]);
			screensArray.push(['_pause_screen_over',pauseScreenOverId,ScreensMediator.KDP_PAUSED+"_over"]);
			screensArray.push(['_end_screen',endScreenId,ScreensMediator.KDP_ENDED]);
			screensArray.push(['_end_screen_over',endScreenOverId,ScreensMediator.KDP_ENDED+"_over"]);
			// set all screens to empty graphics
			initScreensEmptyGraphics();
			//set screens that have a match screen id the matching uiComponent
			var config:Array = new Array();
			for each(var ui:Object in screensArray)
			{
				var tmp:UIComponent = buildScreen(ui[1] as String)
				if(tmp)
				{
					config.push({target:tmp,percentWidth:100,percentHeight:100});

				}
			}
			configuration = config;
			// hide all states. the mediator will set the visibility of states in changeState function
			hideAllStates();
			mouseOverTarget.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			_timer = new Timer(hoverTimeout,1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
			//re set height and width so the view will be refreshed
 			width = width;
 			height = height;
 			//init the player with the start screen
			changeState(ScreensMediator.KDP_STARTED);
			addEventListener(ResizeEvent.RESIZE,onResize);
		}
		private function onResize(evt:Event):void
		{
 			width = width;
 			height = height;
		}

		/**
		 * This function recieves the screen name and searches the
		 * matching variable that holds the same string. if it finds
		 * a match it will take the Uicomponent and adds it
		 */
		private function buildScreen(screenName:String):UIComponent
		{
			var index:Number = screensArray.length
			while(index--)
			{
				if(screenName == screensArray[index][1])
				{
					if(this[screensArray[index][0]] == _emptyUiComponent)
					{
						this[screensArray[index][0]] = screensObject[screenName];
						return screensObject[screenName];
					}
				}
			}
			return null;
		}
		/**
		 * Init all screens to have an empty graphic
		 * if a specific screen has a definition for a screen it will be
		 * defined later.
		 */
		private function initScreensEmptyGraphics ():void
		{
			var index:Number = screensArray.length;
			while(index--)
			{
				this[screensArray[index][0]] = _emptyUiComponent;
			}
		}
		/**
		 * Detected motion - go to hover state and start countdown to
		 * go back to non hover state
		 */
		private function onMouseMove(evt:MouseEvent=null):void
		{
			_timer.stop();
			_timer.start();
			if(!_isOver)
			{
				changeState(_currentStateName+"_over");
			}
			_isOver = true;

		}
		/**
		 * Timer is done - turn back to non-hover state
		 */
		private function onTimerComplete(evt:TimerEvent=null):void
		{
			_isOver = false;
			changeState(_currentStateName.split("_over")[0]);
		}
		/**
		 * hide all states displayObjects
		 */
		private function hideAllStates():void
		{
			var index:Number = screensArray.length;
			while(index--)
			{
				if(this[screensArray[index][0]])
					(this[screensArray[index][0]] as UIComponent).visible = false;
			}
		}
		/**
		 * Gets the current state to display (out of basic 4 states).
		 * if the mouse is over the screen - it will add '_over' to the state it wants
		 * to show
		 */
		public function changeState(stateName:String):void
		{
			_currentStateName = stateName;
			var index:Number = screensArray.length;
			hideAllStates();
			var isOver:String  = _isOver ? "" : "_over";
			if(_currentScreen)
				_currentScreen.visible = false;
			var config:Array = new Array();
			while(index--)
			{
				if (screensArray[index][2]== _currentStateName)
				{
					if(this[screensArray[index][0]])
					{
						(this[screensArray[index][0]] as UIComponent).visible = true;
						_currentScreen = this[screensArray[index][0]] as UIComponent;
						addChild(_currentScreen)
						return;
					}else
					{
						addChild(_emptyUiComponent);
					}
				}
			}
		}
	}
}