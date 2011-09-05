package com.kaltura.kdpfl.controller.media
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.vo.KalturaLiveStreamEntry;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * PostSequenceEndCommand is called when the post-sequence of the player is complete.
	 * In case of a live-streaming entry, the player immediately attempts to restore connection to the stream.
	 * In case of a normal entry the notification "PLAYER_PLAY_END" is fired. 
	 * All variables which have to do with the post-sequence are nullified and the sequence is registered as COMPLETE.
	 */
	public class PostSequenceEndCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var sequenceProxy : SequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			sequenceProxy.vo.isInSequence = false;
			sequenceProxy.vo.postCurrentIndex = -1;
			sequenceProxy.vo.postSequenceComplete = true;
			var mediaProxy : MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			//sequenceProxy.vo.replacedMedia = true;
			mediaProxy.loadWithoutMediaReady();
			if(mediaProxy.vo.entry is KalturaLiveStreamEntry || mediaProxy.vo.deliveryType == StreamerType.LIVE)
			{
				mediaProxy.vo.singleAutoPlay = true;
				sendNotification(NotificationType.CHANGE_MEDIA, {entryId:mediaProxy.vo.entry.id});
			}
			else
			{
				sendNotification( NotificationType.PLAYER_PLAY_END );
			}
		}
	}
}