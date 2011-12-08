package com.kaltura.kdpfl.plugin
{
	import org.osmf.media.MediaElement;

	public interface IMidrollSequencePlugin extends ISequencePlugin
	{
		/**
		 * Function which is accessed to check whether the SequencePlugin has a midroll ad.
		 * @return <code>true</code> if has midrolls, <code>false</code> otherwise.
		 * 
		 */		
		function hasMidroll () : Boolean;
		/**
		 * Function to check whether the midroll ad of the SequencePlugin plays as an OSMF MediaElement
		 * @return the MediaElement of the midroll ad.
		 * 
		 */		
		function get midrollMediaElement () : MediaElement;
	}
}