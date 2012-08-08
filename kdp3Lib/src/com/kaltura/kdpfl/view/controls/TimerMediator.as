/**
 * TimerMediator
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @author Dan Bacon / www.baconoppenheim.com
 */
 package com.kaltura.kdpfl.view.controls
{
	
import com.kaltura.kdpfl.model.SequenceProxy;
import com.kaltura.kdpfl.model.type.NotificationType;
import com.kaltura.puremvc.as3.patterns.mediator.MultiMediator;
import com.kaltura.vo.KalturaPlayableEntry;

import org.puremvc.as3.interfaces.INotification;


public class TimerMediator extends MultiMediator
{

	public static var NAME:String = "TimerMediator";
	private static var nameIndex:int = 0;
	/**
	 * saves the last loaded entry duration 
	 */	
	private var _entryDuration:Number;
	 
	public function TimerMediator( viewComponent:Object=null )
	{
		super(viewComponent);
	}

	override public function handleNotification( note:INotification ):void
	{
		var value:Number;
		
		switch( note.getName() )
		{
			case NotificationType.PLAYER_UPDATE_PLAYHEAD:
				value = note.getBody() as Number;
				timer.setTime( value );
				break;
				
			case NotificationType.DURATION_CHANGE:
				value = note.getBody().newValue;
				timer.setDuration( value );
				if (!(facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy).vo.isInSequence)
					_entryDuration = value;
				break;

			case NotificationType.ENTRY_READY:
				var entry:object = note.getBody();
				value = entry is KalturaPlayableEntry ? KalturaPlayableEntry(entry).duration : 0;  
				_entryDuration = value;
				timer.setDuration( value );
				timer.setTime( 0 );
				break;
			
			case NotificationType.CLEAN_MEDIA:
				timer.resetDuration();
				timer.setTime(0);
				break;
			
			case NotificationType.PRE_SEQUENCE_COMPLETE:
				timer.setTime(0);
				timer.setDuration(_entryDuration);
				break;
			
			case NotificationType.POST_SEQUENCE_COMPLETE:
				timer.setTime(_entryDuration);
				timer.setDuration(_entryDuration);
		}
	}
	
	override public function listNotificationInterests():Array
	{
		return [
				NotificationType.PLAYER_UPDATE_PLAYHEAD,
				NotificationType.DURATION_CHANGE,
				NotificationType.ENTRY_READY,
				NotificationType.CLEAN_MEDIA,
				NotificationType.PRE_SEQUENCE_COMPLETE,
				NotificationType.POST_SEQUENCE_COMPLETE
			   ];
	}
			
	public function get timer():KTimer
	{
		return( viewComponent as KTimer );
	}		
}
}