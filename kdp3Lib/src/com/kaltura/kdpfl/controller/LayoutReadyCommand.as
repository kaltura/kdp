package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.MainViewMediator;
	
	import mx.messaging.config.ConfigMap;
	
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
			var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			var configProxy : ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			if (!sequenceProxy.vo.isInSequence	)
			{
				sequenceProxy.populatePrePostArr();
				sequenceProxy.initPreIndex();
			}
			(facade.retrieveMediator(MainViewMediator.NAME) as MainViewMediator).createContextMenu();
			var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;	
			var flashvars : Object = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
			sendNotification( NotificationType.CHANGE_MEDIA, {entryId: mediaProxy.vo.entry.id, flavorId: flashvars.flavorId });
		}
		
	}
}