package com.kaltura.kdpfl.controller
{
	import org.puremvc.as3.patterns.command.AsyncMacroCommand;

	/**
	 * This class defines the sequence of KDP initialization.  
	 */	
	public class InitMacroCommand extends AsyncMacroCommand
	{
			
		override protected function initializeAsyncMacroCommand():void
		{
			// save all flash vars
			addSubCommand( SaveFVCommand ); 	
			
			// load all the data needed to load and display the entry form kaltura
			addSubCommand( LoadConfigCommand );		
			
			//load skin before building the layout because some elements has default skin to use [async command]
			addSubCommand( LoadSkinCommand ); 
			
			//build layout 
			addSubCommand( ParseLayoutCommand );  
			
			//attach special commands to components after they all loaded 
			addSubCommand( AssignBehaviorCommand );
		}
	}
}