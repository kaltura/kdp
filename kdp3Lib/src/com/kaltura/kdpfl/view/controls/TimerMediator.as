/**
 * TimerMediator
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @author Dan Bacon / www.baconoppenheim.com
 */
 package com.kaltura.kdpfl.view.controls
{
	
import com.kaltura.kdpfl.model.type.NotificationType;
import com.kaltura.puremvc.as3.patterns.mediator.MultiMediator;
import com.kaltura.vo.KalturaPlayableEntry;

import org.puremvc.as3.interfaces.INotification;


public class TimerMediator extends MultiMediator
{

	public static var NAME:String = "TimerMediator";
	private static var nameIndex:int = 0;
	 
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
			
//				trace( timer + " PLAYER_UPDATE_PLAYHEAD " + note.getBody() );
				value = note.getBody() as Number;
				timer.setTime( value );
				break;
				
			case NotificationType.DURATION_CHANGE:
				value = note.getBody().newValue;
				timer.setDuration( value );
				break;

			case NotificationType.ENTRY_READY:
				var entry:object = note.getBody();
				value = entry is KalturaPlayableEntry ? KalturaPlayableEntry(entry).duration : 0;  
				timer.setDuration( value );
				break;
		}
	}
	
	override public function listNotificationInterests():Array
	{
		return [
				NotificationType.PLAYER_UPDATE_PLAYHEAD,
				NotificationType.DURATION_CHANGE,
				NotificationType.ENTRY_READY,
			   ];
	}
			
	public function get timer():KTimer
	{
		return( viewComponent as KTimer );
	}		
}
}