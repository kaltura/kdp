package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.PlayerStatusProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.MainViewMediator;
	
	import flash.display.Loader;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * This class defines the actions that are taken once KDP layout is ready. 
	 */
	public class LayoutReadyCommand extends SimpleCommand
	{

		public function LayoutReadyCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var playerStatus : PlayerStatusProxy = facade.retrieveProxy(PlayerStatusProxy.NAME) as PlayerStatusProxy;
			playerStatus.vo.kdpStatus = "ready";
			// remove the preloader
			var configProxy : ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var rm:Object = facade.retrieveMediator("stageMediator");
			if(rm.root.hasOwnProperty("preloader"))
				var ldr:Loader = rm.root["preloader"] as Loader; 
			if (ldr && !configProxy.vo.flashvars.usePreloaderBufferAnimation) {
				ldr.unloadAndStop(false);
				if (ldr.parent != null) {
					rm.root.removeChild(ldr);
				}
			}
			
			var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			if (!sequenceProxy.vo.isInSequence	)
			{
				sequenceProxy.populatePrePostArr();
				sequenceProxy.initPreIndex();
			}
			(facade.retrieveMediator(MainViewMediator.NAME) as MainViewMediator).createContextMenu();
			var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;	
			var flashvars : Object = configProxy.vo.flashvars;
			if (mediaProxy.vo.entry.id) {
				sendNotification( NotificationType.CHANGE_MEDIA, {entryId: mediaProxy.vo.entry.id, flavorId: flashvars.flavorId });
			}
			else if (flashvars.referenceId) {
				sendNotification( NotificationType.CHANGE_MEDIA, {referenceId: flashvars.referenceId, flavorId: flashvars.flavorId });
			}
			else {
				sendNotification( NotificationType.CHANGE_MEDIA, {entryId: null, flavorId: flashvars.flavorId });
			}
		}
		
	}
}