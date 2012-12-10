package com.kaltura.kdpfl.plugin.controller {
	import com.kaltura.kdpfl.plugin.model.SoundProxy;
	
	import flash.media.Sound;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class PlayRandomSoundCommand extends SimpleCommand implements ICommand {

		

		/**
		 * Constructor 
		 */		
		public function PlayRandomSoundCommand() {
			super();
			
		}


		/**
		 * Fulfill the use-case initiated by the given <code>INotification</code>.
		 * <P>
		 * In the Command Pattern, an application use-case typically
		 * begins with some user action, which results in an <code>INotification</code> being broadcast, 
		 * which is handled by business logic in the <code>execute</code> method of an
		 * <code>ICommand</code>.</P>
		 * 
		 * In our case - play a random sound.
		 *
		 * @param notification the <code>INotification</code> to handle.
		 */
		override public function execute(notification:INotification):void {
			(facade.retrieveProxy(SoundProxy.NAME) as SoundProxy).playRandomSound();
		}
		
		
		
	}
}