package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.osmf.proxy.KSwitchingProxyElement;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class MidSequenceEndCommand extends SimpleCommand
	{
		public function MidSequenceEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
			var sequenceProxy : SequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			(mediaProxy.vo.media as KSwitchingProxyElement).switchElements();
			sequenceProxy.vo.midrollArr = new Array();
			sequenceProxy.vo.midCurrentIndex = -1;
			sendNotification( NotificationType.DO_PLAY );
		}
	}
}