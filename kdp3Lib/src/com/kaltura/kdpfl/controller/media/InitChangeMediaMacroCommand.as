package com.kaltura.kdpfl.controller.media
{
	import org.puremvc.as3.patterns.command.AsyncMacroCommand;

	/**
	 * This class is responsible for coordinating the different parts of changing media command
	 */	
	public class InitChangeMediaMacroCommand extends AsyncMacroCommand
	{

		/**
		 * list the parts of InitChangeMediaMacroCommand
		 */		
		override protected function initializeAsyncMacroCommand():void
		{
			//set the new entryId to the data
			addSubCommand( InitMediaChangeProcessCommand ); 
			
			//TODO: if this is playlist we don't need to get the media entry we can pass it from the playlist
			//get all the metadata of the current entry (we don't wait for it to finish the macro command)
			addSubCommand( GetMediaCommand );	
			
			// load configuration (don't wait on it!!)
			addSubCommand( LoadMediaCommand ); 
		}
		
	}
}