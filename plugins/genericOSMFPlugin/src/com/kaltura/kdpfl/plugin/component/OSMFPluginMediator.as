package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import org.osmf.media.MediaFactoryItem;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class OSMFPluginMediator extends Mediator
	{
		public static const NAME : String = "osmfPluginMediator";
		
		protected var toggleMediaFactoryItems : Array = new Array();
		
		public function OSMFPluginMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			var array : Array = [
								NotificationType.MEDIA_READY
								];
			
			return array;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case NotificationType.MEDIA_READY:
					
					if ( (viewComponent as genericOSMFPluginCode).streamerType && (viewComponent as genericOSMFPluginCode).streamerType != "") 
					{
						var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
						if (mediaProxy.vo.deliveryType != (viewComponent as genericOSMFPluginCode).streamerType)
						{
							if ( (viewComponent as genericOSMFPluginCode).mediaFactoryIds && (viewComponent as genericOSMFPluginCode).mediaFactoryIds != "")
							{
								var idsToRemove : Array = (viewComponent as genericOSMFPluginCode).mediaFactoryIds.split(",");
								
								for each (var id : String in idsToRemove)
								{
									var itemToRemove : MediaFactoryItem = (viewComponent as genericOSMFPluginCode).localMediaFactory.getItemById( id );
									
									if (itemToRemove)
									{
										toggleMediaFactoryItems.push( (viewComponent as genericOSMFPluginCode).localMediaFactory.getItemById( id ) );
										(viewComponent as genericOSMFPluginCode).localMediaFactory.removeItem( (viewComponent as genericOSMFPluginCode).localMediaFactory.getItemById( id ) );
									}
								}
							}
							
						}
						else
						{
							if (toggleMediaFactoryItems && toggleMediaFactoryItems.length)
							{
								for each (var item : MediaFactoryItem in toggleMediaFactoryItems )
								{
									(viewComponent as genericOSMFPluginCode).localMediaFactory.addItem(item);
								}
								//Empty the array
								toggleMediaFactoryItems = new Array();
							}
						}
					}
					
					break;
			}
		}
	}
}