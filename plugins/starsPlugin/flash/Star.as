package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Star extends MovieClip
	{
		//(in fla) 
		public var leftHalf : MovieClip; //left half of the star MC
		//(in fla) 
		public var rightHalf : MovieClip; //right half of the star MC
		
		public function Star() : void
		{
			buttonMode = true;
			addListeners();
		}
		
		//let you color the half stars in gray
		public function showGray( showLeft : Boolean , showRight : Boolean) : void
		{
			if(showLeft) leftHalf.gotoAndStop(1);
			if(showRight) rightHalf.gotoAndStop(1);
		}
		
		//let you color the half stars in gold
		public function showGold( showLeft : Boolean , showRight : Boolean) : void
		{
			if(showLeft) leftHalf.gotoAndStop(2);
			if(showRight) rightHalf.gotoAndStop(2);
		}
		
		//let you color the half stars in red
		public function showRed( showLeft : Boolean , showRight : Boolean) : void
		{
			if(showLeft) leftHalf.gotoAndStop(3);
			if(showRight) rightHalf.gotoAndStop(3);
		}
		
		//listen to left and right half's roll over
		private function addListeners() : void
		{
			if(leftHalf)
			{
				leftHalf.addEventListener(MouseEvent.ROLL_OVER , onLeftRollOver);
				leftHalf.addEventListener(MouseEvent.CLICK , onLeftClick);
			}
				
			if(rightHalf)
			{
				rightHalf.addEventListener(MouseEvent.ROLL_OVER , onRightRollOver);
				rightHalf.addEventListener(MouseEvent.CLICK , onRightClick);
			}
		}
		
		//on roll over the left side of the star 
		private function onLeftRollOver( event : MouseEvent ) :void
		{
			dispatchEvent( new Event( "leftRollOver" ) );
		}
		
		//on roll over the right side of the star 
		private function onRightRollOver( event : MouseEvent ) :void
		{
			dispatchEvent( new Event( "rightRollOver" ) );
		}
		
		private function onLeftClick( event : MouseEvent  ) : void
		{
			dispatchEvent( new Event( "leftClick" ) );
		}
		
		private function onRightClick( event : MouseEvent ) : void
		{
			dispatchEvent( new Event( "rightClick" ) );
		}
	}
}