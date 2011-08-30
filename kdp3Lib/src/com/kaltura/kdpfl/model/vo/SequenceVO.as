package com.kaltura.kdpfl.model.vo
{
	import com.kaltura.kdpfl.plugin.IMidrollSequencePlugin;

	[Bindable]
	/**
	 * Class SequenceVO holds parameters related to the KDP sequence mechanism. 
	 * @author Hila
	 * 
	 */	
	public class SequenceVO
	{
		/**
		 *Flag signifying whether we are currently playing in a sequence (pre or post) 
		 */		
		public var isInSequence : Boolean;
		/**
		 * Array containing refereces to the PluginCode-s of the sequence plugins in the post sequence 
		 */		
		public var postSequenceArr : Array;
		/**
		 * Array containing references to the PluginCode files of the sequence plugins in the pre-sequence 
		 */		
		public var preSequenceArr : Array;
		
		/**
		 * Index of the current position in the pre sequence array, initially set to -1. 
		 */		
		public var preCurrentIndex : int = -1;
		/**
		 *Index of the current position in the post sequence array, initially set to -1. 
		 */		
		public var postCurrentIndex : int = -1;
		/**
		 * The original MediaVO for the main entry . Saved once in the bginning of the pre-sequence (or post-sequence)
		 */		
		public var mainMediaVO : MediaVO;
		/**
		 *The time remaining to the ad playing in the MediaPlayer 
		 */		
		public var timeRemaining : Number;
		/**
		 *Property signifying whether the sequencePlugin lined up to play can be skipped; 
		 */		
		public var isAdSkip : Boolean = false;
		/**
		 * Property signifying whether the sequencePlugin lined up to play has loaded. 
		 */		
		public var isAdLoaded : Boolean = false;
		/**
		 * Flag indicating whether the post sequence is complete
		 */		
		public var postSequenceComplete : Boolean = false;
		/**
		 * Flag indicating whether the pre-sequence is complete
		 */		
		public var preSequenceComplete : Boolean = false;
		/**
		 * Number of pre-sequence ads.
		 */		
		public var preSequenceCount : Number = 0;
		/**
		 * Number of post-sequence ads.
		 */		
		public var postSequenceCount : Number = 0;
		
		//New Midroll-related properties - 12.22.2010
		
		/**
		 * Array containing references to the PluginCode files of the sequence plugins that can play midrolls 
		 */	
		public var midrollArr : Array;
		/**
		 * Property containing the current midroll plugin playing in the player. The running assumptions are:
		 * a. There is only 1 midroll plugin playing at a given time
		 * b. The only way that this midroll is of interest to us is if it's playing in the KDP MediaPlayer.
		 */		
		public var activeMidrollPlugin : IMidrollSequencePlugin;
		
	}
}