package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.puremvc.as3.patterns.mediator.MultiMediator;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * mediator for the visibilator plugin  
	 * @author Atar
	 */	
	public class VisibilatorMediator extends MultiMediator implements IMediator{
		
		/**
		 * Constructor
		 * @param mediatorName name of this mediator
		 * @param viewComponent	view component
		 * 
		 */		
		public function VisibilatorMediator(viewComponent:Object=null) {
			super(viewComponent);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function listNotificationInterests():Array {
			return [NotificationType.MEDIA_READY];
		}

		/**
		 * @inheritDoc
		 */		
		override public function handleNotification(note:INotification):void {
			var data:Object = note.getBody();
			switch (note.getName()) {
				case NotificationType.MEDIA_READY:
					(viewComponent as visibilatorPluginCode).setVisibility();
			}
		}
	}
}