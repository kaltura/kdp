package com.kaltura.kdpfl.plugin
{
	import flash.display.MovieClip;
	
	import fl.core.UIComponent;

	public class MovieClipUIContainer extends UIComponent
	{
		/**
		 * The slide as movie clip
		 **/
		private var _slideMovieClip:MovieClip;
		
		/**
		 * The current slide frame
		 **/
		private var _currentFrame:uint = 1;
		
		/**
		 * Number of slides in the SWF
		 **/
		private var _numberOfSlides:uint;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor 
	    //
	    //--------------------------------------------------------------------------
		    
		public function MovieClipUIContainer()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Getters/Setters 
	    //
	    //--------------------------------------------------------------------------
		    
		public function set currentFrame(value:uint):void {
			_currentFrame = value;
		}
		
		public function get currentFrame():uint {
			return _currentFrame;
		}
		
		public function get numberOfSlides():uint {
			return _numberOfSlides;
		}
		
		public function set loaderContent(content:MovieClip):void {
			_slideMovieClip = content as MovieClip;
			
			_numberOfSlides = _slideMovieClip.totalFrames;
			
			addChild(_slideMovieClip);
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Methods 
	    //
	    //--------------------------------------------------------------------------
	    
		public function gotoSlide(slideIndex:int):void {
			if ((slideIndex > 0) && (slideIndex <= _numberOfSlides)) {
				_slideMovieClip.gotoAndStop(1);
				
				// Beacuse we are using SWF from open-office, we multiple in 2
				_slideMovieClip.gotoAndStop(slideIndex);
				
				currentFrame = slideIndex;
			} 
		}
	}
}