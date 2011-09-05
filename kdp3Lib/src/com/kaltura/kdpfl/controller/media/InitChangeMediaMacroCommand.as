package com.kaltura.kdpfl.controller.media
{
	import org.puremvc.as3.patterns.command.AsyncMacroCommand;

	/**
	 * This is the command triggered by the CHANGE_MEDIA notification. It is constructed of more goal-specific sub-commands.
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
			
			//get all the metadata of the current entry (we don't wait for it to finish the macro command)
			addSubCommand( GetMediaCommand );	
		
			// load configuration (don't wait on it!!)
			addSubCommand( LoadMediaCommand ); 
		}
		
	}
}