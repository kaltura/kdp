package com.kaltura.kdpfl.plugin
{
	import org.osmf.media.MediaElement;
	
	public interface ISequencePlugin
	{
		/**
		 * Function to start playing the plugin content - each plugin implements this differently
		 * 
		 */		
		function start () : void
		
		/**
		 *Function returns whether the plugin in question has a sub-sequence 
		 * @return The function returns true if the plugin has a sub-sequence, false otherwise.
		 * 
		 */		
		function hasSubSequence() : Boolean
		
		/**
		 * Function returns the length of the sub-sequence length of the plugin 
		 * @return The function returns an integer signifying the length of the sub-sequence;
		 * 			If the plugin has no sub-sequence, the return value is 0.
		 */		
		function subSequenceLength () : int
		
		/**
		 * Returns whether the Sequence Plugin plays within the KDP or loads its own media over it. 
		 * @return The function returns <code>true</code> if the plugin media plays within the KDP
		 *  and <code>false</code> otherwise.
		 * 
		 */		
		function hasMediaElement () : Boolean
		
		/**
		 * Function for retrieving the entry id of the plugin media
		 * @return The function returns the entry id of the plugin media. If the plugin does not play
		 * 			a kaltura-based entry, the return value is the URL of the media of the plugin.
		 */		
		function get entryId () : String
		
		/**
		 * Function for retrieving the source type of the plugin media (url or entryId) 
		 * @return If the plugin plays a Kaltura-Based entry the function returns <code>entryId</script>.
		 * Otherwise the return value is <code>url</script>
		 * 
		 */		
		function get sourceType () : String
		/**
		 * Function to retrieve the MediaElement the plugin will play in the KDP. 
		 * @return returns the MediaElement that the plugin will play in the KDP. 
		 * 
		 */		
		function get mediaElement () : Object
		
		/**
		 * Function for determining where to place the ad in the pre sequence; 
		 * @return The function returns the index of the plugin in the pre sequence; 
		 * 			if the plugin should not appear in the pre-sequence, return value is -1.
		 */		
		function get preIndex () : Number;
		
		/**
		 *Function for determining where to place the plugin in the post-sequence. 
		 * @return The function returns the index of the plugin in the post-sequence;
		 * 			if the plugin should not appear in the post-sequence, return value is -1.
		 */		
		function get postIndex () : Number;
		
		
		
		
		
	}
}