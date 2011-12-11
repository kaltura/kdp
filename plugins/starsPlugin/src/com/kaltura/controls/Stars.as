package com.kaltura.controls
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * Class Stars represents the group of 5 stars on the screen. It manages the logic of the selection of the rating. 
	 * @author Hila
	 * 
	 */	
	public class Stars extends MovieClip
	{
		/**
		 * Constant representing the number of stars to display. 
		 */		
		public static const DEFAULT_STAR_NUMBER : int = 5; //default stars number
		/**
		 * Constant representing the gap between the stars (in pixels). 
		 */		
		public static const STARS_HGAP : Number = 4;
		
		
		
		private var color1:Number = 0xFF00FF;
		private var starScale:Number;
		
		
		
		//The stars number 
		/////////////////////////
		/**
		 * Flag indicating whether the rating the stars are showing is editable or static (can the user vote or not).
		 */		
		private var _editable : Boolean = false;
		/**
		 * Parameter that holds the gap between the stars (in pixels).
		 */		
		private var _gap:Number = 3;
		/**
		 * Boolean indicating whether the user can select a full star when rolling over it, or half. 
		 */		
		private var _selectFullStars:Boolean = true;
		public function get editable() : Boolean { return _editable; }
		public function set editable( value : Boolean ) : void 
		{ 
			_editable = value; 
			if(!_editable){
				removeStarsListeners();
			}
			for( var i:int=0; i<_starsArr.length; i++ )
			{
				_starsArr[i].buttonMode = value;
			}
		}
		/////////////////////////
		/**
		 * Array of the stars, each array cell is an object of class "Star".
		 */		
		private var _starsArr : Array = new Array();
		
		//The stars number 
		/////////////////////////
		/**
		 * Parameter representing the number of stars to present to the user. 
		 */		
		private var _starNum : int = DEFAULT_STAR_NUMBER;
		public function get starNum() : int { return _starNum; }
		public function set starNum( value : int ) : void { if(_starNum != value){ _starNum = value; rebuildStars(); } }
		/////////////////////////
		
		//The rating number 
		/////////////////////////
		/**
		 * Parameter representing the rating that the stars are showing. 
		 */		
		private var _rating : Number = DEFAULT_STAR_NUMBER;
		public function get rating() : Number { return _rating; }
		public function set rating( value : Number ) : void {  _rating=value; rating2Stars( value ); }
		/////////////////////////
		/**
		 * Constructor 
		 * @param editable Boolean signifying whether the Stars are editable or static.
		 * @param rating the default rating that the stars should show on becoming visible for the first time.
		 * @param starNumber the number of stars to display.
		 * 
		 */		
		//public function Stars( editable : Boolean = true , rating : Number = 0, starNumber : int = DEFAULT_STAR_NUMBER ) : void
		public function Stars(starScale:Number=1) : void
		{
/* 			this.editable = editable;
			starNum = starNumber;
			_rating = rating;     */
		
			this.starScale = starScale;
			buildStars();
		}
		/**
		 *Function reconstructs the stars and adds the event listeners for mouse roll-over from the right and left.
		 * 
		 */		
		public function rebuildStars() : void
		{
			removeStarsListeners();
			rating = 0;
			editable = true;
			for( var i:int=0; i<_starsArr.length; i++ )
			{
					if (_selectFullStars)
					{
						_starsArr[i].addEventListener( "leftRollOver" , onRightRollOver);
						_starsArr[i].addEventListener( "leftClick" , onRightClick);
					}else
					{
						_starsArr[i].addEventListener( "leftRollOver" , onLeftRollOver);
						_starsArr[i].addEventListener( "leftClick" , onLeftClick);
					}
					_starsArr[i].addEventListener( "rightRollOver" , onRightRollOver);
					_starsArr[i].addEventListener( "rightClick" , onRightClick);
					_starsArr[i].buttonMode = true;
			}
			
		}
				
		private function buildStars() : void
		{
			for( var i:int=0; i<_starNum; i++ )
			{
				var star : Star = new Star();
				//add scaling 
				star.scaleX = starScale;
				star.scaleY = starScale;
				
				//move the stars according to the current i and add the const gap
				if(i>0) star.x= i*star.width+(_gap*i);
					
				_starsArr.push( star );
				
				if( editable )
				{
					if (_selectFullStars)
					{
						star.addEventListener( "leftRollOver" , onRightRollOver);
						star.addEventListener( "leftClick" , onRightClick);
					}else
					{
						star.addEventListener( "leftRollOver" , onLeftRollOver);
						star.addEventListener( "leftClick" , onLeftClick);
					}
					star.addEventListener( "rightRollOver" , onRightRollOver);
					star.addEventListener( "rightClick" , onRightClick);
				}
				else
				{
					star.buttonMode = false;
				}
				addChild(star);
			}
			if(!editable)
			{
				rating2Stars(_rating);
			}
		}
		
		private function removeStarsListeners() : void
		{
			for( var i:int=0; i<_starsArr.length; i++ )
			{
					if (_selectFullStars)
					{
						_starsArr[i].removeEventListener( "leftRollOver" , onRightRollOver);
						_starsArr[i].removeEventListener( "leftClick" , onRightRollOver);
					}else
					{
						_starsArr[i].removeEventListener( "leftRollOver" , onLeftRollOver);
						_starsArr[i].removeEventListener( "leftClick" , onLeftClick);
					}
				
				_starsArr[i].removeEventListener( "rightRollOver" , onRightRollOver);
				_starsArr[i].removeEventListener( "rightClick" , onRightClick);
			}
		}

		//convert rating number to stars, if the number has any float value it will add half insted ( ex. 4.3 is 4.5 stars );
		private function rating2Stars( value : Number ) : void
		{
			//if one pass a rating number that it's bigger then the number of stars it will show full rating insted
			if(value>_starNum)
			{
				value = _starNum;
			} 
				
			var floorValue : int = Math.floor( value );
			var i:int = 0;
			
			if(_editable)
			{
				for(i=0; i<_starNum; i++)
				{
					if(	i < floorValue	){
						_starsArr[i].showGold( true , true);
					}
					else{
						(_starsArr[i] as Star).showGray(true, true);
					}
				}
				
				if(value > floorValue)
				{
					_starsArr[floorValue].showGold( true , false);
				}
			}
			else
			{
				for(i=0; i<_starNum; i++)
				{
					if( i< floorValue )
						_starsArr[i].showRed( true , true);
					else if( i == floorValue )
					{
						if(value > floorValue && (value-floorValue) > 0.25 && (value-floorValue) < 0.75)
						{
							_starsArr[i].showRed( true , false );
							_starsArr[i].showGray( false, true );
						}
						else if( value > floorValue && (value-floorValue) > 0.75)
						{
							_starsArr[i].showRed( true , true );
						}
						else
							_starsArr[i].showGray( true, true );
					}
					else
						_starsArr[i].showGray( true , true);
				}
			}
		}

		private function onLeftRollOver( event : Event ) : void
		{
			if(_editable)
			{
				var currentStar : Star = event.target as Star;
				var tillHere : Boolean = false; // flag that indicate that we fond the current
				for( var i:int=0; i<_starsArr.length; i++ )
				{
					if( currentStar != _starsArr[i] )
					{
						if(!tillHere)
							_starsArr[i].showRed( true, true );
						else
							_starsArr[i].showGray( true , true );
					}
					else
					{
						tillHere = true;
						_starsArr[i].showRed( true, false );
						_starsArr[i].showGray( false, true );
					}
				}
			}
		}
		
		private function onRightRollOver( event : Event ) : void
		{
			if(_editable)
			{
				var currentStar : Star = event.target as Star;
				var tillHere : Boolean = false; // flag that indicate that we fond the current
				
				for( var i:int=0; i<_starsArr.length; i++ )
				{
					if( currentStar != _starsArr[i] )
					{
						if(!tillHere)
							_starsArr[i].showRed( true, true );
						else
							_starsArr[i].showGray( true , true );
					}
					else
					{
						tillHere = true;
						_starsArr[i].showRed( true, true );
					}
				}
			}
		}

		private function onRightClick( event : Event ) : void
		{
			if(_editable)
			{
				editable = false;
				
				for(var i:int=0; i< _starsArr.length; i++)
				{
					_starsArr[i].showRed( true, true );
					if(_starsArr[i] == event.target)
						break;
				}
				
				_rating = i+1;
				
				dispatchEvent( new Event("rated") );
			}
		}
		
		private function onLeftClick( event : Event ) : void
		{
			if(_editable)
			{
				editable = false;
				
				for(var i:int=0; i< _starsArr.length; i++)
				{
					if(_starsArr[i] == event.target)
					{
						_starsArr[i].showRed( true, false );
						break;
					}
						
					_starsArr[i].showRed( true, true );
				}
				
				_rating = i+0.5;
				dispatchEvent( new Event("rated") );
			}
		}
		
	
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set gap(value:Number):void
		{
			_gap = value;
			for( var i:int=1; i<_starsArr.length; i++ )
			{
				var star:Star = _starsArr[i] as Star;
				if(star!=null)
				{
					star.x = i * (star.width+_gap);
				}
			}
		}
	}
}