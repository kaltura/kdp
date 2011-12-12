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
	
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	
	public class VolumeMediator extends Mediator
	{
		
		public static const NAME:String = "VolumeMediator";
		protected var _layoutProxy:LayoutProxy;
		
		protected var _muted : Boolean = false;
		
		
		public function VolumeMediator( viewComponent:Object=null )
		{
			super( NAME, viewComponent );
			
			_layoutProxy= Facade.getInstance().retrieveProxy( LayoutProxy.NAME ) as LayoutProxy;
			var foreground:UIComponent = _layoutProxy.vo.foreground;
			
			foreground.scaleX = foreground.scaleY = 1;
			volumeBar.sliderContainer = _layoutProxy.vo.foreground;
			volumeBar.init();
			var flashvars : Object = (facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy).vo.flashvars;
			
			volumeBar.addEventListener( KVolumeBar.EVENT_CHANGE, onVolumeChange, false, 0, true );
			
			var initialValue:Number;
			initialValue = volumeBar.initialValue;
			//Checks whether a shared object exists with the user's last used volume. If exists, use that.
			var volumeCookie : SharedObject;
			try
			{
				volumeCookie= SharedObject.getLocal("KalturaVolume");
			}
			catch (e : Error)
			{
				KTrace.getInstance().log("No access to user's file system");
				//trace ("No access to user's file system");
			}
			if(volumeCookie && volumeCookie.data.volume != null){
				initialValue = Number(volumeCookie.data.volume);
			}
			
			if(volumeBar.forceInitialValue && volumeBar.initialValue)
				initialValue = volumeBar.initialValue;
			//only if there is an initial value - assign it to the player. 
			if(!isNaN(initialValue))
				volumeBar.changeVolume(initialValue);
		}
		
		protected function onVolumeChange( evt:Event ):void
		{
			updateMuteVal();
			//trace ('change vol to ', volumeBar.getVolume());
			sendNotification( NotificationType.CHANGE_VOLUME, volumeBar.getVolume() );
		}
		
		/**
		 * update the _muted val according to current value on volumeBar
		 * */
		private function updateMuteVal():void {
			if (volumeBar.getVolume() != 0)
			{
				if (_muted)
				{
					_muted = false;
				}
			}
			else if (!_muted)
			{
				_muted = true;
			}
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch( note.getName() )
			{
				case NotificationType.VOLUME_CHANGED:
					var volume:Number = Number( note.getBody().newVolume );
					volumeBar.changeVolume( volume , false );
					updateMuteVal();
					
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