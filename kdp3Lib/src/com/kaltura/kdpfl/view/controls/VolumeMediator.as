/**
 * VolumeMediator
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @author Dan Bacon / www.baconoppenheim.com
 */
 package com.kaltura.kdpfl.view.controls
{
	
import com.kaltura.kdpfl.model.ConfigProxy;
import com.kaltura.kdpfl.model.LayoutProxy;
import com.kaltura.kdpfl.model.type.NotificationType;

import flash.display.Sprite;
import flash.events.Event;
import flash.net.SharedObject;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.facade.Facade;
import org.puremvc.as3.patterns.mediator.Mediator;


public class VolumeMediator extends Mediator
{

	public static const NAME:String = "VolumeMediator";
	protected var _layoutProxy:LayoutProxy;

		 
	public function VolumeMediator( viewComponent:Object=null )
	{
		super( NAME, viewComponent );
		
		_layoutProxy= Facade.getInstance().retrieveProxy( LayoutProxy.NAME ) as LayoutProxy;
		var foreground:Sprite = _layoutProxy.vo.foreground;
		
		foreground.scaleX = foreground.scaleY = 1;
		volumeBar.sliderContainer = _layoutProxy.vo.foreground;
		volumeBar.init();
		var flashvars : Object = (facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy).vo.flashvars;
		
		volumeBar.addEventListener( KVolumeBar.EVENT_CHANGE, onVolumeChange, false, 0, true );
		
		
		//Checks whether a shared object exists with the user's last used volume. If exists, use that.
		var volumeCookie : SharedObject = SharedObject.getLocal("KalturaVolume");
		if(volumeCookie.data.volume){
			volumeBar.changeVolume(Number(volumeCookie.data.volume));
		}
	}

	protected function onVolumeChange( evt:Event ):void
	{
		//trace( "VOLUME CHANGE " + volumeBar.getVolume() );
		sendNotification( NotificationType.CHANGE_VOLUME, volumeBar.getVolume() );
	}

	override public function handleNotification( note:INotification ):void
	{
		switch( note.getName() )
		{
			case NotificationType.VOLUME_CHANGED:
				var volume:Number = Number( note.getBody().newVolume );
				volumeBar.changeVolume( volume );
				
			break;
		}
	}
	
	override public function listNotificationInterests():Array
	{
		return [
				NotificationType.VOLUME_CHANGED
			   ];
	}
			
	public function get volumeBar():KVolumeBar
	{
		return( viewComponent as KVolumeBar );
	}		
}
}