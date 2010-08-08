package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * mediator for the visibilator plugin  
	 * @author Atar
	 */	
	public class VisibilatorMediator extends Mediator implements IMediator{
		
		/**
		 * mediator name 
		 */		
		public static const NAME:String = "visibilatorMediator";
		
		/**
		 * Constructor
		 * @param mediatorName name of this mediator
		 * @param viewComponent	view component
		 * 
		 */		
		public function VisibilatorMediator(mediatorName:String=null, viewComponent:Object=null) {
			super(mediatorName, viewComponent);
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